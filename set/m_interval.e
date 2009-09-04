note
	description: "Continuous resizable intervals."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M_INTERVAL [E -> COMPARABLE]

inherit
	M_COMPARABLE_CONTAINER [E]
		rename
			min as lower,
			max as upper,
			has_min as has_lower,
			has_max as has_upper
		end

	M_EXTENDIBLE [E]

	M_PRUNABLE [E]

create
	set_bounds, wipe_out

feature -- Access
	lower: E
			-- Lower bound

	upper: E
			-- Upper bound

	has (v: E): BOOLEAN
			-- Is `v' contained?
		do
			Result := not is_empty and then v >= lower and v <= upper
		ensure then
			Result = (not is_empty and then v >= lower and v <= upper)
		end

feature -- Status report
	is_empty: BOOLEAN
			-- Is empty?

	has_space_for (i: INTEGER): BOOLEAN
			-- Can `i' new elements be added?
		once
			Result := True
		ensure then
			never_full: Result
		end

	has_lower: BOOLEAN
			-- Is there a lower bound?
		do
			Result := not is_empty
		end

	has_upper: BOOLEAN
			-- Is there an upper bound?
		do
			Result := not is_empty
		end

feature -- Element change
	include (v: E)
			-- Extend in a minimal way so that `v' is contained
		do
			if is_empty then
				upper := v
				lower := v
				is_empty := False
			else
				if v > upper then
					upper := v
				elseif v < lower then
					lower := v
				end
			end
		ensure
			not_empty: not is_empty
			lower_extended: not old is_empty implies lower = v.min (old lower)
			upper_extended: not old is_empty implies upper = v.max (old upper)
			lower_set: old is_empty implies lower = v
			upper_set: old is_empty implies upper = v
		end

	set_bounds (l, u: E)
			-- Make `l' and `u' new bounds
		require
			valid_bounds: l <= u
		do
			is_empty := False
			lower := l
			upper := u
		ensure
			not_empty: not is_empty
			lower_set: lower = l
			upper_set: upper = u
		end

	wipe_out
			-- Make empty
		do
			is_empty := True
		end

invariant
	non_empty_has_lower: has_lower = not is_empty
	non_empty_has_upper: has_upper = not is_empty
end
