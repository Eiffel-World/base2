note
	description: "Equivalence based on reference equality."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: relation

class
	V_REFERENCE_EQUALITY [G]

inherit
	V_EQUIVALENCE [G]
		redefine
			relation
		end

feature -- Basic operations
	equivalent (x, y: G): BOOLEAN
			-- Is `x' equivalent to `y'?
		do
			Result := x = y
		end

feature -- Model
	relation: MML_IDENTITY [G]
			-- Corresponding matematical relation
		note
			status: model
		do
			create Result
		end
end
