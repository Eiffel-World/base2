note
	description: "Containers for a finite number of values."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: bag

deferred class
	V_CONTAINER [G]

feature -- Measurement
	count: INTEGER
			-- Number of elements.
		deferred
		end

feature -- Status report
	is_empty: BOOLEAN
			-- Is container empty?
		do
			Result := count = 0
		end

feature -- Search
	has (v: G): BOOLEAN
			-- Is value `v' contained?
			-- (Uses reference equality.)
		local
			it: V_INPUT_ITERATOR [G]
		do
			it := new_iterator
			it.search_forth (v)
			Result := not it.after
		ensure
			definition: Result = bag.domain [v]
		end

	occurrences (v: G): INTEGER
			-- How many times is value `v' contained?
			-- (Uses reference equality.)
		local
			it: V_INPUT_ITERATOR [G]
		do
			from
				it := new_iterator
			until
				it.after
			loop
				if it.item = v then
					Result := Result + 1
				end
				it.forth
			end
		ensure
			definition: Result = bag [v]
		end

	count_if (p: PREDICATE [ANY, TUPLE [G]]): INTEGER
			-- How many elements satisfy `p'?
		require
			p_exists: p /= Void
			p_has_one_arg: p.open_count = 1
		local
			it: V_INPUT_ITERATOR [G]
		do
			from
				it := new_iterator
			until
				it.after
			loop
				if p.item ([it.item]) then
					Result := Result + 1
				end
				it.forth
			end
		ensure
			definition: Result = (bag.domain * {MML_AGENT_SET [G]} [p]).count
		end

	exists (p: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
			-- Is there an element that satisfies `p'?
		require
			p_exists: p /= Void
			p_has_one_arg: p.open_count = 1
		local
			it: V_INPUT_ITERATOR [G]
		do
			it := new_iterator
			it.satisfy_forth (p)
			Result := not it.after
		ensure
			definition: Result = bag.domain.exists (p)
		end

	for_all (p: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
			-- Do all elements satisfy `p'?
		require
			p_exists: p /= Void
			p_has_one_arg: p.open_count = 1
		local
			it: V_INPUT_ITERATOR [G]
		do
			from
				Result := True
				it := new_iterator
			until
				it.after or not Result
			loop
				Result := p.item ([it.item])
				it.forth
			end
		ensure
			definition: Result = bag.domain.for_all (p)
		end

feature -- Iteration
	new_iterator: V_INPUT_ITERATOR [G]
			-- New iterator pointing to a position in the container, from which it can traverse all elements by going `forth'.
		deferred
		ensure
			target_definition: Result.target = Current
			index_definition: Result.index = 1
		end

feature -- Removal
	wipe_out
			-- Remove all elements.
		deferred
		ensure
			bag_effect: bag.is_empty
		end

feature -- Specification
	bag: MML_FINITE_BAG [G]
			-- Bag of elements.
		note
			status: specification
		local
			i: V_INPUT_ITERATOR [G]
		do
			create Result.empty
			from
				i := new_iterator
			until
				i.after
			loop
				Result := Result.extended (i.item)
				i.forth
			end
		end

	default_item: G
			-- Default value of type `G'.
		note
			status: specification
		do
		end

invariant
	count_definition: count = bag.count
	is_empty_definition: is_empty = bag.is_empty
end
