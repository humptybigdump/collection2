#!/usr/bin/env python3
import numpy as np
import argparse
from torchvision import transforms

#MedMNIST
import medmnist
from medmnist import INFO, Evaluator

parser = argparse.ArgumentParser(description="Saves given dataset as npy")
parser.add_argument("dataset", type=str, nargs='?', help="Dataset name")
args = parser.parse_args()

#Chosen medmnist data
data_flag = args.dataset
download = True

info = INFO[data_flag]
task = info['task']
n_channels = info['n_channels']
n_classes = len(info['label'])

DataClass = getattr(medmnist, info['python_class'])

# no preprocessing, do this directly on the device
data_transform = transforms.Compose([
])

train_dataset   = DataClass(split='train',  transform=data_transform, download=download)
test_dataset    = DataClass(split='test',   transform=data_transform, download=download)
val_dataset     = DataClass(split='val',    transform=data_transform, download=download)

data    = [train_dataset, test_dataset, val_dataset]
types   = ["train", "test", "val"]

# Saving everything into seperate npz
for i,_ in enumerate(data):
    set    = {
        types[i]+"_imgs":   data[i].imgs.astype(np.uint8),
        types[i]+"_labels": data[i].labels}
    np.savez("dataset/"+args.dataset+"_"+types[i]+".npz", **set)
    # Verify: Load and print data shape
    set = np.load("dataset/"+args.dataset+"_"+types[i]+".npz")
    print(types[i]+" images data shape: {}".format(set[types[i]+"_imgs"].shape))
    print(types[i]+" labels data shape: {}".format(set[types[i]+"_labels"].shape))

