
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

	extensions		= 0
	horiz_gap_crossings	= 0
	vert_chasm_crossings	= 0

	def __iadd__(self, other):

		self.num_10m += other.num_10m
		self.num_30m += other.num_30m
		self.num_50m += other.num_50m

		self.extensions			+= other.extensions
		self.horiz_gap_crossings	+= other.horiz_gap_crossings
		self.vert_chasm_crossings	+= other.vert_chasm_crossings

		return self

	def to_string(self):

		if(self.num_10m >= _INF):
			return "XXXXX"
		
