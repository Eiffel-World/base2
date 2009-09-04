note
	description: "Traversable integer intervals."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M_TRAVERSABLE_INTEGER_INTERVAL

inherit
	M_INTEGER_INTERVAL
		undefine
			hold_count,
			exists,
			do_if
		end

	M_FINITE_SORTED [INTEGER]
		rename
			min as lower,
			max as upper,
			has_min as has_lower,
			has_max as has_upper
		undefine
			is_empty,
			occurrences,
			has_lower,
			has_upper,
			has,
			lower,
			upper,
			back,
			go_i_th
		redefine
			i_th
		end

	M_FINITE_INDEXED_LINEAR [INTEGER]
		undefine
			is_empty,
			occurrences,
			has
		redefine
			i_th
		end

create
	set_bounds, wipe_out

feature -- Access
	i_th alias "[]" (i: INTEGER): INTEGER
			-- Element associated with `i'
		do
			Result := i + lower - 1
		end
end
