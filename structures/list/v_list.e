note
	description: "Indexable containers, where elements can be inserted and removed at any position. Indexing starts from 1."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: sequence

deferred class
	V_LIST [G]

inherit
	V_INDEXABLE [G]
		undefine
			count
		redefine
			at_start,
			is_equal
		end

feature -- Measurement
	lower: INTEGER = 1
			-- Lower bound of index interval

	upper: INTEGER
			-- Upper bound of index interval
		do
			Result := count
		end

feature -- Iteration
	at_start: V_LIST_ITERATOR [G]
			-- New iterator pointing to the first position
		deferred
		end

feature -- Comparison
	is_equal (other: like Current): BOOLEAN
			-- Is list made of the same items as `other'?
			-- (Use reference comarison)
		local
			i, j: V_INPUT_ITERATOR [G]
		do
			if other = Current then
				Result := True
			elseif count = other.count then
				from
					Result := True
					i := at_start
					j := other.at_start
				until
					i.off or not Result
				loop
					Result := i.item = j.item
					i.forth
					j.forth
				end
			end
		ensure then
			definition: Result = (sequence |=| other.sequence)
		end

feature -- Extension
	extend_front (v: G)
			-- Insert `v' at the front
		deferred
		ensure
			sequence_effect: sequence |=| old sequence.prepended (v)
		end

	extend_back (v: G)
			-- Insert `v' at the back
		deferred
		ensure
			sequence_effect: sequence |=| old sequence.extended (v)
		end

	extend_at (i: INTEGER; v: G)
			-- Insert `v' at position `i'
		require
			valid_index: has_index (i) or i = count + 1
		deferred
		ensure
			sequence_effect: sequence |=| old (sequence.front (i - 1).extended (v) + sequence.tail (i))
		end

	append (input: V_INPUT_ITERATOR [G])
			-- Append sequence of values, through which `input' iterates
		do
			from
			until
				input.off
			loop
				extend_back (input.item)
				input.forth
			end
		ensure
			sequence_effect: sequence |=| old (sequence + input.sequence.tail (input.index))
			input_index_effect: input.index = input.sequence.count + 1
			input_sequence_effect: input.sequence |=| old input.sequence
		end

	prepend (input: V_INPUT_ITERATOR [G])
			-- Prepend sequence of values, through which `input' iterates
		local
			i: INTEGER
		do
			from
				i := input.count
				input.finish
			until
				i < 1
			loop
				extend_front (input.item)
				input.back
				i := i - 1
			end
			input.go_after
		ensure
			sequence_effect: sequence |=| old (input.sequence.tail (input.index) + sequence)
			input_index_effect: input.index = input.sequence.count + 1
			input_sequence_effect: input.sequence |=| old input.sequence
		end

	insert_at (i: INTEGER; input: V_INPUT_ITERATOR [G])
			-- Insert sequence of values, through which `input' iterates, starting at position `i'
		require
			valid_index: has_index (i) or i = count + 1
		deferred
		ensure
			sequence_effect: sequence |=| old (sequence.front (i - 1) + input.sequence.tail (input.index) + sequence.tail (i))
			input_index_effect: input.index = input.sequence.count + 1
			input_sequence_effect: input.sequence |=| old input.sequence
		end

feature -- Removal
	remove_front
			-- Remove first element
		require
			not_empty: not is_empty
		deferred
		ensure
			sequence_effect: sequence |=| old sequence.but_first
		end

	remove_back
			-- Remove last element
		require
			not_empty: not is_empty
		deferred
		ensure
			sequence_effect: sequence |=| old sequence.but_last
		end

	remove_at  (i: INTEGER)
			-- Remove element at position `i'
		require
			has_index: has_index (i)
		deferred
		ensure
			sequence_effect: sequence |=| old (sequence.front (i - 1) + sequence.tail (i + 1))
		end

	wipe_out
			-- Remove all elements
		deferred
		ensure then
			sequence_effect: sequence.is_empty
		end

feature -- Specification
	sequence: MML_FINITE_SEQUENCE [G]
			-- Sequence of list's elements
		note
			status: specification
		do
			Result := at_start.sequence
		end

invariant
	map_domain_definition: map.domain |=| sequence.domain
	map_definition: map.domain.for_all (agent (i: INTEGER): BOOLEAN
		do
			Result := map [i] = sequence [i]
		end)
end
