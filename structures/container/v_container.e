note
	description: "Containers for a finite number of values."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: bag

deferred class
	V_CONTAINER [G]

inherit
	ANY
		redefine
			out
		end

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

	count_satisfying (pred: PREDICATE [ANY, TUPLE [G]]): INTEGER
			-- How many elements satisfy `pred'?
		require
			pred_exists: pred /= Void
			pred_has_one_arg: pred.open_count = 1
			precondition_satisfied: precondition_satisfied (pred)
		local
			it: V_INPUT_ITERATOR [G]
		do
			from
				it := new_iterator
			until
				it.after
			loop
				if pred.item ([it.item]) then
					Result := Result + 1
				end
				it.forth
			end
		ensure
			definition: Result = (bag.domain | pred).count
		end

	exists (pred: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
			-- Is there an element that satisfies `pred'?
		require
			pred_exists: pred /= Void
			pred_has_one_arg: pred.open_count = 1
			precondition_satisfied: precondition_satisfied (pred)
		local
			it: V_INPUT_ITERATOR [G]
		do
			it := new_iterator
			it.satisfy_forth (pred)
			Result := not it.after
		ensure
			definition: Result = bag.domain.exists (pred)
		end

	for_all (pred: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
			-- Do all elements satisfy `pred'?
		require
			pred_exists: pred /= Void
			pred_has_one_arg: pred.open_count = 1
			precondition_satisfied: precondition_satisfied (pred)
		local
			it: V_INPUT_ITERATOR [G]
		do
			from
				Result := True
				it := new_iterator
			until
				it.after or not Result
			loop
				Result := pred.item ([it.item])
				it.forth
			end
		ensure
			definition: Result = bag.domain.for_all (pred)
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

feature -- Output
	out: STRING
			-- String representation of the content.
		local
			stream: V_STRING_OUTPUT
		do
			create Result.make_empty
			create stream.make (Result)
			stream.pipe (new_iterator)
			Result.remove_tail (stream.separator.count)
		end

feature -- Specification
	bag: MML_BAG [G]
			-- Bag of elements.
		note
			status: specification
		local
			i: V_INPUT_ITERATOR [G]
		do
			create Result
			from
				i := new_iterator
			until
				i.after
			loop
				Result := Result & i.item
				i.forth
			end
		ensure
			exists: Result /= Void
		end

	precondition_satisfied (pred: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
			-- Does the precondition of `pred' hold for all elements of `Current'?
		note
			status: specification
		do
			Result := for_all (agent (x: G; p: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
				do
					Result := p.precondition ([x])
				end (?, pred))
		ensure
			definition: Result = bag.domain.for_all (agent (x: G; p: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
				do
					Result := p.precondition ([x])
				end (?, pred))
		end

invariant
	count_definition: count = bag.count
	is_empty_definition: is_empty = bag.is_empty
end
