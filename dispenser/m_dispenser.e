note
	description: "Finite extendible data structures, where a single element can be accessed and removed at a time."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_DISPENSER [E]

inherit
	M_FINITE [E]

	M_EXTENDIBLE_BY_VALUE [E]

	M_PRUNABLE_ACTIVE [E]
end
