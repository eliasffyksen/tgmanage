import copy

#Constants

_INF = 9999999

#Start of switch class

class Switch:

	row = 0
	num = 0

	def __init__(self, row, num):
		self.row = row
		self.num = num

#Start of inventory class

class Inventory:

	num_10m = 0
	num_30m = 0
	num_50m	= 0

	extensions           = 0
	horiz_gap_crossings  = 0
	vert_chasm_crossings = 0

	def __iadd__(self, other):

		self.num_10m += other.num_10m
		self.num_30m += other.num_30m
		self.num_50m += other.num_50m

		self.extensions           += other.extensions
		self.horiz_gap_crossings  += other.horiz_gap_crossings
		self.vert_chasm_crossings += other.vert_chasm_crossings

		return self

	def to_string(self):

		if(self.num_10m >= _INF):
			return 'XXXXX'

		ret = ""
		invCopy = copy.copy(self)

		while(invCopy.num_50m > 0):
			invCopy.num_50m -= 1

			if(ret != ""):
				ret += '+'
			ret += '50';

		while(invCopy.num_30m > 0):
			invCopy.num_30m -= 1

			if(ret != ""):
				ret += '+'
			ret += '30';

		while(invCopy.num_10m > 0):
			invCopy.num_10m -= 1

			if(ret != ""):
				ret += '+'
			ret += '10';

		return ret

# Data structures for flow algorithm

class Node:

	edges            = []
	name             = ''
	cost_from_source = 0
	active           = False
	prev_edge        = None

class Edge:

	to       = None
	reverse  = None
	capacity = 0
	flow     = 0
	cost     = 0

class Graph:

	source_node  = 0
	distro_nodes = []
	switch_nodes = []
	edges        = []
	all_nodes    = []

def compareByCost(a, b):
	return a.cost_from_source > b.cost_from_source

class VerticalGap:
	after_row_num = 0
	extra_cost    = 0

	def __init__(self, arn, ec):
		self.after_row_num = arn
		self.extra_cost    = ec
#Config

horiz_cost = [
	216, 72, 72, 216 # First switch from the middle; 7.2m, the outer; 21.6m
]

vertical_gaps = [            # Mid-row to mid-row is 3.6m
	VerticalGap(10, 23), # After row 12: 4.6m+0.1m slack = 2.3m cost
	VerticalGap(18, 17), # After row 20: 4.0m+0.1m slack = 1.7m cost
	VerticalGap(27, 13)  # After row 29: 3.6m+0.1m slack = 1.3m cost
]

print('hello world')

