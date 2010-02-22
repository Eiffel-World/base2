note
	description: "Equivalence based on object equality."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: relation

class
	V_OBJECT_EQUALITY [G]

inherit
	V_EQUIVALENCE [G]

feature -- Basic operations
	equivalent (x, y: G): BOOLEAN
			-- Is `x' equivalent to `y'?
		do
			Result := x ~ y
		end

feature -- Specification		
	executable: BOOLEAN = False
			-- Are model-based contracts for this class executable?		
end
