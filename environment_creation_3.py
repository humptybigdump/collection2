from environments.door_key import DoorKeyEnv
from environments.observation_wrappers import FullyObservableWrapper, PartiallyObservableWrapper


def create_fully_observable_door_key(**kwargs):
    return FullyObservableWrapper(DoorKeyEnv(**kwargs))


def create_partially_observable_door_key(**kwargs):
    return PartiallyObservableWrapper(DoorKeyEnv(**kwargs))
