note
	description: "Iterators to read from a container in linear order."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, sequence, index

deferred class
	V_INPUT_ITERATOR [G]

inherit
	V_INPUT_STREAM [G]
		rename
			search as search_forth,
			satisfy as satisfy_forth,
			sequence as front
		redefine
			is_equal,
			search_forth,
			satisfy_forth
		end

feature -- Access
	target: V_CONTAINER [G]
			-- Container to iterate over.
		deferred
		end

feature -- Measurement		
	index: INTEGER
			-- Current position.
		deferred
		end

	count: INTEGER
			-- Number of elements left to iterate.
		do
			Result := target.count - index + 1
		end

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i' a valid position for a cursor?
		do
			Result := 0 <= i and i <= target.count + 1
		ensure
			definition: Result = (0 <= i and i <= sequence.count + 1)
		end

feature -- Status report
	before: BOOLEAN
			-- Is current position before any position in `target'?
		deferred
		end

	after: BOOLEAN
			-- Is current position after any position in `target'?
		deferred
		end

	off: BOOLEAN
			-- Is current position off scope?
		do
			Result := before or after
		end

	is_first: BOOLEAN
			-- Is cursor at the first position?
		deferred
		end

	is_last: BOOLEAN
			-- Is cursor at the last position?
		deferred
		end

feature -- Comparison
	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to the same container at the same position?
			-- (Use reference comarison)
		do
			if other = Current then
				Result := True
			else
				Result := target = other.target and index = other.index
			end
		ensure then
			definition: Result = (target = other.target and sequence |=| other.sequence and index = other.index)
		end

feature -- Cursor movement
	start
			-- Go to the first position.
		deferred
		ensure
			index_effect: index = 1
		end

	finish
			-- Go to the last position.
		deferred
		ensure
			index_effect: index = sequence.count
		end

	forth
			-- Move one position forward.
		deferred
		ensure then
			index_effect: index = old index + 1
		end

	back
			-- Go one position backwards.
		require
			not_off: not off
		deferred
		ensure
			index_effect: index = old index - 1
		end

	go_to (i: INTEGER)
			-- Go to position `i'.
		require
			has_index: valid_index (i)
		local
			j: INTEGER
		do
			if i = 0 then
				go_before
			elseif i = target.count + 1 then
				go_after
			elseif i = target.count then
				finish
			else
				from
					start
					j := 1
				until
					j = i
				loop
					forth
					j := j + 1
				end
			end
		ensure
			index_effect: index = i
		end

	go_before
			-- Go before any position of `target'.
		deferred
		ensure
			index_effect: index = 0
		end

	go_after
			-- Go after any position of `target'.
		deferred
		ensure
			index_effect: index = sequence.count + 1
		end

	search_forth (v: G)
			-- Move to the first occurrence of `v' at or after current position.
			-- If `v' does not occur, move `after'.
			-- (Use refernce equality.)
		do
			if before then
				start
			end
			from
			until
				off or else item = v
			loop
				forth
			end
		ensure then
			index_effect_not_found: not sequence.tail (old index).has (v) implies index = target.count + 1
			index_effect_found: sequence.tail (old index).has (v) implies
				(sequence [index] = v and not sequence.interval (old index, index - 1).has (v))
			sequence_effect: sequence |=| old sequence
		end

	satisfy_forth (pred: PREDICATE [ANY, TUPLE [G]])
			-- Move to the first position at or after current where `p' holds.
			-- If `pred' never holds, move `after'.
		do
			if before then
				start
			end
			from
			until
				off or else pred.item ([item])
			loop
				forth
			end
		ensure then
			index_effect_not_found: not sequence.tail (old index).range.exists (pred) implies index = target.count + 1
			index_effect_found: sequence.tail (old index).range.exists (pred) implies
				(pred.item ([sequence [index]]) and not sequence.interval (old index, index - 1).range.exists (pred))
			sequence_effect: sequence |=| old sequence
		end

	search_back (v: G)
			-- Move to the last occurrence of `v' at or before current position.
			-- If `v' does not occur, move `before'.
			-- (Use refernce equality.)
		do
			if after then
				finish
			end
			from
			until
				off or else item = v
			loop
				back
			end
		ensure
			index_effect_not_found: not sequence.front (old index).has (v) implies index = 0
			index_effect_found: sequence.front (old index).has (v) implies
				(sequence [index] = v and not sequence.interval (index + 1, old index).has (v))
			sequence_effect: sequence |=| old sequence
		end

	satisfy_back (pred: PREDICATE [ANY, TUPLE [G]])
			-- Move to the first position at or before current where `p' holds.
			-- If `pred' never holds, move `after'.
		require
			pred_exists: pred /= Void
		do
			if after then
				finish
			end
			from
			until
				off or else pred.item ([item])
			loop
				back
			end
		ensure
			index_effect_not_found: not sequence.front (old index).range.exists (pred) implies index = 0
			index_effect_found: sequence.front (old index).range.exists (pred) implies
				(pred.item ([sequence [index]]) and not sequence.interval (index + 1, old index).range.exists (pred))
			sequence_effect: sequence |=| old sequence
		end

feature -- Specification
	sequence: MML_FINITE_SEQUENCE [G]
			-- Sequence of elements	in `target'.
		note
			status: specification
		deferred
		end

	front: MML_FINITE_SEQUENCE [G]
			-- Sequence of elements that are already read.
		note
			status: specification
		do
			Result := sequence.front (index - 1)
		end

	executable: BOOLEAN = True
			-- Are model-based contracts for this class executable?

invariant
	target_exists: target /= Void
	item_definition: sequence.domain [index] implies item = sequence [index]
	off_definition: off = not sequence.domain [index]
	front_definition: front |=| sequence.front (index - 1)
	target_bag_domain_constraint: target.bag.domain |=| sequence.range
	target_bag_constraint: target.bag.domain.for_all (agent (x: G): BOOLEAN
		do
			Result := target.bag [x] = sequence.occurrences (x)
		end)
	target_bag_count_constraint: target.bag.count = sequence.count
	before_definition: before = (index = 0)
	after_definition: after = (index = sequence.count + 1)
	is_first_definition: is_first = (not sequence.is_empty and index = 1)
	is_last_definition: is_last = (not sequence.is_empty and index = sequence.count)
	index_constraint: 0 <= index and index <= sequence.count + 1
end
