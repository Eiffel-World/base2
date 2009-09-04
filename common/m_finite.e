note
	description: "Data structures with finite number of elements."

deferred class
	M_FINITE [E]

inherit
	M_CONTAINER [E]

feature -- Access
	count: INTEGER
			-- Number of elements
		deferred
		end

	occurrences (v: E): INTEGER
			-- Number of times `v' appears
		deferred
		ensure
			non_negative: Result >= 0
			not_too_large: Result <= count
			positive_if_has: has (v) = (Result > 0)
		end

	is_empty: BOOLEAN
			-- Is empty?
		do
			Result := count = 0
		end

feature -- Quantifiers
	hold_count (p: PREDICATE [ANY, TUPLE [E]]): INTEGER is
			-- Number of elements for which `p' holds
		local
			result_cell: INTEGER_REF
		do
			create result_cell
			do_if (agent (res_cell: INTEGER_REF; v: E) do res_cell.set_item (res_cell.item + 1) end (result_cell, ?), p)
		end

	exists (p: PREDICATE [ANY, TUPLE [E]]): BOOLEAN is
			-- Does `p' hold for any element?
		do
			Result := hold_count (p) > 0
		ensure
			hold_count_positive: Result = (hold_count (p) > 0)
		end

	for_all (p: PREDICATE [ANY, TUPLE [E]]): BOOLEAN is
			-- Does `p' hold for all elements?
		do
			Result := hold_count (p) = count
		ensure
			hold_count_is_count: Result = (hold_count (p) = count)
		end

feature -- Iteration
	do_if (action: PROCEDURE [ANY, TUPLE [E]]; p: PREDICATE [ANY, TUPLE [E]]) is
			-- Call `action' for elements that satisfy `p'
		deferred
		end

	do_all (action: PROCEDURE [ANY, TUPLE [E]]) is
			-- Call `action' for every element
		do
			do_if (action, agent (v: E): BOOLEAN do Result := True end)
		end

invariant
	zero_count_is_empty: is_empty = (count = 0)
end
