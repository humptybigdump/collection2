from typing import List, Any, Literal, overload
from mpi4py import MPI
import numpy as np

comm = MPI.COMM_WORLD
rank = comm.Get_rank()


@overload
def alltoallv_helper(b: np.ndarray, individual: Literal[True]) -> List[np.ndarray]:
    ...


@overload
def alltoallv_helper(b: np.ndarray, individual: Literal[False]) -> np.ndarray:
    ...


def alltoallv_helper(b: np.ndarray, individual=True):
    comm.Barrier()
    size = comm.Get_size()
    # Size of b array in each rank
    sizes = np.empty(size, dtype=np.uint32)
    comm.Allgather(
        [np.array(len(b), dtype=np.uint32), MPI.UINT32_T], [sizes, MPI.UINT32_T]
    )
    # Distribute the array

    s_counts = [len(b)] * size

    s_disp = [0] * size
    r_counts = [i for i in sizes]
    r_disp = [int(np.sum(r_counts[:i])) for i, s in enumerate(sizes)]

    result = np.zeros(np.sum(r_counts), np.uint32)

    comm.Barrier()
    comm.Alltoallv(
        [b, (s_counts, s_disp), MPI.UINT32_T],
        [result, (r_counts, r_disp), MPI.UINT32_T],
    )
    if individual:
        return [result[disp : disp + size] for disp, size in zip(r_disp, r_counts)]
    return result


@overload
def gatherv_helper(b: np.ndarray, individual: Literal[True]) -> List[np.ndarray] | None:
    ...


@overload
def gatherv_helper(b: np.ndarray, individual: Literal[False]) -> np.ndarray | None:
    ...


def gatherv_helper(b: np.ndarray, individual=True):
    """Gathers the contents of b on rank 0, returns None for every other rank"""
    comm.Barrier()

    sizes = comm.gather(len(b))

    if rank == 0:
        assert isinstance(sizes, List)
        recvbuf = np.empty(sum(sizes), dtype=float)
    else:
        recvbuf = None

    comm.Gatherv(sendbuf=b, recvbuf=(recvbuf, sizes), root=0)

    if rank == 0 and individual:
        assert isinstance(sizes, List) and isinstance(recvbuf, np.ndarray)
        disps = [int(np.sum(sizes[:i])) for i, s in enumerate(sizes)]
        return [recvbuf[disp : disp + size] for disp, size in zip(disps, sizes)]
    return recvbuf


class GatherScatter:
    global_indices: np.ndarray
    """An array that relates the local node index to the global node index.
    Indices may occur multiple times, also across ranks."""

    ming: int
    """Minimum of global_indices, to save some memory during g-s"""

    gsend: List[np.ndarray]
    """For each rank, which values we need to send to that node"""

    total_send: int
    """Total number of halo nodes in this rank"""

    offsets: List[int]
    """Offsets for sending/receiving the values"""

    sizes: List[int]
    """Sizes for sending/receiving the values"""

    def __init__(self, global_indices) -> None:
        self.global_indices = global_indices
        self.ming = np.min(self.global_indices)
        all_ids = alltoallv_helper(self.global_indices, individual=True)
        self.gsend = [
            self.__communicator(all_ids, comm.rank, i) for i in range(comm.Get_size())
        ]

        self.total_send = sum(len(i) for i in self.gsend)
        self.offsets = [
            sum(len(i) for i in self.gsend[0:j]) for j, _ in enumerate(self.gsend)
        ]
        self.sizes = [len(i) for i in self.gsend]

    def __call__(self, values: np.ndarray) -> Any:
        """Perform direct stiffness summation (sum up values of shared nodes)"""
        gathered = np.bincount(self.global_indices - self.ming, values)
        scattered = np.take(gathered, self.global_indices - self.ming)

        # Distribute shared values between ranks.
        send_buf = np.zeros(self.total_send, dtype=np.double)
        for s, o, indices in zip(self.sizes, self.offsets, self.gsend):
            if len(indices) > 0:
                send_buf[o : o + s] = values[indices]
        recv_buf = np.zeros(sum(len(i) for i in self.gsend), dtype=np.double)
        comm.Barrier()
        comm.Alltoallv(
            [send_buf, (self.sizes, self.offsets), MPI.DOUBLE],
            [recv_buf, (self.sizes, self.offsets), MPI.DOUBLE],
        )

        # Add the received values at the correct positions.
        for size, offset, send in zip(self.sizes, self.offsets, self.gsend):
            if size == 0:
                continue
            current_vals = recv_buf[offset : offset + size]
            np.add.at(scattered, send, current_vals)

        return scattered

    @staticmethod
    def __communicator(all_ids, from_rank, to_rank):
        """Get which local indices we need to send from from_rank to to_rank.
        Due to the symmetric structure, the values received by from_rank from to_rank
        are added at __communicator(to_rank, from_rank)."""
        lower = min(from_rank, to_rank)
        higher = max(from_rank, to_rank)
        if from_rank == to_rank:
            return []
        else:
            target_indices = []
            send_indices = []
            for sendindex, j in enumerate(all_ids[lower]):
                current = list(np.argwhere(all_ids[higher] == j)[:, 0])
                if len(current) > 0:
                    target_indices += current
                    send_indices += [sendindex for _ in current]
            if to_rank < from_rank:
                return target_indices
            else:
                return send_indices

    def __repr__(self):
        return (
            f"GatherScatter on Rank {comm.rank}: ("
            + ", ".join(
                f"Shared with Rank {r}: {self.gsend[r]}"
                for r in range(comm.Get_size())
                if r != comm.rank
            )
            + ")"
        )
