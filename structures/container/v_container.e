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
			-- Number of elements
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
			-- Is `v' contained?
			-- (Uses reference equality)
		local
			it: V_INPUT_ITERATOR [G]
		do
			it := at_start
			it.search (v)
			Result := not it.off
		ensure
			definition: Result = bag.domain [v]
		end

	occurrences (v: G): INTEGER
			-- How many times is `v' contained?
			-- (Uses reference equality)
		local
			it: V_INPUT_ITERATOR [G]
		do
			from
				it := at_start
			until
				it.off
			loop
				if it.item = v then
					Result := Result + 1
				end
				it.forth
			end
		ensure
			definition: Result = bag [v]
		end

--	filtered (p: PREDICATE [ANY, TUPLE [G]]): V_CONTAINER [G]
--			-- Container that consists of elements of `Current' that satisfy `p'
--		deferred
--		ensure
--			definition: Result.bag |=| bag.restricted (create {MML_AGENT_SET [G]}.such_that (p))
--		end

	exists (p: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
			-- Is a value contained such that `p'(value)?
		local
			it: V_INPUT_ITERATOR [G]
		do
			it := at_start
			it.search_that (p)
			Result := not it.off
		ensure
			definition: Result = bag.domain.exists (p)
		end

	for_all (p: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
			-- Does `p' hold for all elements?
		local
			it: V_INPUT_ITERATOR [G]
		do
			from
				Result := True
				it := at_start
			until
				it.off or not Result
			loop
				Result := p.item ([it.item])
				it.forth
			end
		ensure
			definition: Result = bag.domain.for_all (p)
		end

feature -- Iteration
	at_start: V_INPUT_ITERATOR [G]
			-- New iterator pointing to a position in the container, from which it can traverse all elements by going `forth'
		deferred
		ensure
--			target_definition: Result.target = Current
			index_definition: Result.index = 1
		end

	at_finish: like at_start
			-- New iterator pointing to a position in the container, from which it can traverse all elements by going `back'
		deferred
		ensure
--			target_definition: Result.target = Current
			index_definition: Result.index = Result.sequence.count
		end

	at (i: INTEGER): like at_start
			-- New iterator poiting at `i'-th position
		require
			has_index: 1 <= i and i <= count
		deferred
		ensure
--			target_definition: Result.target = Current
			index_definition: Result.index = i
		end

feature -- Removal
	wipe_out
			-- Remove all elements
		deferred
		ensure
			bag_effect: bag.is_empty
		end

feature -- Model
	bag: MML_FINITE_BAG [G]
			-- Bag of container elements
		note
			status: model
		local
			i: V_INPUT_ITERATOR [G]
		do
			create Result.empty
			from
				i := at_start
			until
				i.off
			loop
				Result := Result.extended (i.item)
				i.forth
			end
		end

	default_item: G
			-- Default value of type `G'
		note
			status: spec_helper
		do
		end

invariant
	count_definition: count = bag.count
	is_empty_definition: is_empty = bag.is_empty
end
