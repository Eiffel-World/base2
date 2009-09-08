note
	description: "Data structures in which elements can be replaced by other elements."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_REPLACEABLE [E]

inherit
	M_CONTAINER [E]

feature -- Replacement
	replace_all (v, u: E)
			-- Replace all occurences of `v' with `u'
		deferred
		ensure
			no_more_v: not has (v)
			has_u: old has (v) implies has (u)
		end

	fill (v: E)
			-- Replace all elements with `v'
		deferred
		ensure
			has_v: not is_empty implies has (v)
		end

	clear_all
			-- Replace all elements with default values
		local
			default_value: E
		do
			fill (default_value)
		end
end
