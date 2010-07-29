note
	description: "Finite sequences of bits."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_BIT_VECTOR

inherit
	MML_FINITE_SEQUENCE [BOOLEAN]

create
	empty,
	singleton

convert
	singleton ({BOOLEAN})
	
end
