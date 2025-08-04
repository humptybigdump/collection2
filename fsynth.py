#!/usr/bin/python3

from printer import NetworkPrinter, NetworkNode
import sys
import yaml
from typing import Dict, List
from z3 import *

# Read the specification given via stdin
spec = yaml.safe_load(sys.stdin)
inputs: Dict[str, str] = spec['inputs']
outputs: Dict[str, str] = spec['outputs']
samples: List[Dict[str, str]] = spec['samples']
layers = int(spec['depth'])
width = int(spec['width'])

output_printer = NetworkPrinter(layers, width, outputs)

s = Solver()

# TODO Encode the given specification into SMT constraints

ans = s.check()

if ans == sat:
    # There exists a model => function is realizable
    model = s.model()
    output_printer.set_realizable(True)
    # TODO synthesize the function given the SMT model

    # Set nodes like this:
    # output_printer.set_node(i, j, NetworkNode(op, in_0, in_1))
    # Set outputs like this:
    # output_printer.set_output(output_name, output_index)
    
else:
    # Function is not realizable
    output_printer.set_realizable(False)

output_printer.print()
