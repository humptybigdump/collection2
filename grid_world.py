"""
@author:    Ge Li, ge.li@kit.edu
@brief:     Define the grid_world: terrain and other utilities
"""


# DO NOT MODIFY THIS FILE
# DO NOT MODIFY THIS FILE
# DO NOT MODIFY THIS FILE

class GridWorld:
    """
    GridWorld class defining the terrain and other helper functions.
    All the members and methods in this class are static, and can be used
    without creating an instance, i.e. you can call GridWorld.X to access the
    members and GridWorld.x() to call methods.
    """

    # Static Attributes
    W = 6  # Width of the grid_world
    H = 6  # Height of the grid_world
    N = W * H  # Total number of cells
    S = 14  # cell_index of Start
    G = 28  # cell_index of Goal

    @staticmethod
    def get_neighbors(cell_index):
        """
        Return the neighbor cells' indices, which defines the terrain of the
        grid_world. If a cell has no constraints, it should have 4 neighbors:
        [east, south, west, north]
        Args:
            cell_index: index of current cell
        Returns:
            list of neighbor cells' indices
        """
        # Check if current cell is a boundary cell
        east = None if cell_index % GridWorld.W == GridWorld.W - 1 \
            else cell_index + 1
        south = None if cell_index >= GridWorld.W * (
                GridWorld.H - 1) else cell_index + GridWorld.W
        west = None if cell_index % GridWorld.W == 0 else cell_index - 1
        north = None if cell_index < GridWorld.W else cell_index - GridWorld.W

        # Check if internal constraints (walls) exist
        if cell_index == 8:
            east = None
        if cell_index == 9:
            south, west = None, None
        if cell_index == 13:
            south = None
        if cell_index == 15:
            south, north = None, None
        if cell_index == 19:
            east, north = None, None
        if cell_index == 20:
            east, west = None, None
        if cell_index == 21:
            west, north = None, None
        if cell_index == 22:
            south = None
        if cell_index == 28:
            north = None

        # Return neighbor indices
        return [index for index in [east, south, west, north] if index is not
                None]

    @staticmethod
    def compute_x_y(cell_index):
        """
        Compute x and y coordinate of a cell in grid_world, given the cell index
        Args:
            cell_index: index of the cell

        Returns:
            the x and y coordinate of the cell in grid_world
        """
        return cell_index // GridWorld.W, cell_index % GridWorld.W

    @staticmethod
    def string_coordinate(cell_index):
        """
        Helper function to parse cell index to string coordinate
        Args:
            cell_index: index of the cell

        Returns:
            String coordinate, such as: "I-1", "III-4" etc.
        """

        # From cell index to x, y coordinate
        x, y = GridWorld.compute_x_y(cell_index)

        # From x, y coordinate to String coordinate
        result_string = ""
        if x == 0:
            result_string += "   I-"
        elif x == 1:
            result_string += "  II-"
        elif x == 2:
            result_string += " III-"
        elif x == 3:
            result_string += "  IV-"
        elif x == 4:
            result_string += "   V-"
        elif x == 5:
            result_string += "  VI-"
        elif x == 6:
            result_string += " VII-"
        else:  # x == 7
            result_string += "VIII-"
        result_string += str(y + 1)

        return result_string

    @staticmethod
    def manhattan_distance(cell_index):
        """
        Compute the Manhattan distance between Goal and given cell
        Args:
            cell_index:
        Returns:
            manhattan distance
        """
        # G's coordinate
        x_G, y_G = GridWorld.compute_x_y(GridWorld.G)
        # Node's coordinate
        x, y = GridWorld.compute_x_y(cell_index)
        # manhattan distance
        return abs(x - x_G) + abs(y - y_G)

    @staticmethod
    def is_goal(cell_index):
        """
        Check if cell is goal cell
        Returns:
            Bool value, True if current cell is the goal
        """
        return cell_index == GridWorld.G
