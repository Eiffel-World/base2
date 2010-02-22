note
	description: "Order based on comparison defined inside COMPARABLE classes."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: order_relation

class
	V_INTERNAL_ORDER [G -> COMPARABLE]

inherit
	V_TOTAL_ORDER [G]

feature -- Basic operations
	greater_equal (x, y: G): BOOLEAN
			-- Is `x' >= `y'?
		do
			Result := x >= y
		end

feature -- Specification
	executable: BOOLEAN = False
			-- Are model-based contracts for this class executable?	
end
