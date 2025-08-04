import torch
import torch.nn as nn
import torch.nn.functional as F

lst  = [12,3,4,1,3]
a = torch.tensor(lst)
print(a)

n_data_train = torch.ones(10, 2)
x0 = torch.normal(n_data_train+torch.tensor([4,2]), 1)

print(x0)