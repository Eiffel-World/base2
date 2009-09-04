note
	description: "Data structures that can be extended with new elements."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_EXTENDIBLE [E]

inherit
	M_CONTAINER [E]

feature -- Status report
	has_space_for (i: INTEGER): BOOLEAN
			-- Can `i' new elements be added?
		deferred
		end

	full: BOOLEAN
			-- Can new elements not be added?
		do
			Result := not has_space_for (1)
		end

invariant
	full_does_not_have_space: full = not has_space_for (1)
end
