note
	description: "Reference and object equality as functions."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	V_EQUALITY [G]

feature -- Basic operations
	reference_equal (x, y: G): BOOLEAN
			-- `='.
		do
			Result := x = y
		ensure
			definition: Result = (x = y)
		end

	object_equal (x, y: G): BOOLEAN
			-- `~'.
		do
			Result := x ~ y
		ensure
			definition: Result = (x ~ y)
		end
end
