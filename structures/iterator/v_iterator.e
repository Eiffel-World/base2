note
	description: "Iterators to read and write from/to a container in linear order."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, sequence, index

deferred class
	V_ITERATOR [G]

inherit
	V_INPUT_ITERATOR [G]

	V_OUTPUT_STREAM [G]
		rename
			sequence as front
		undefine
			is_equal,
			relevant
		redefine
			pipe,
			pipe_n
		end

feature -- Replacement
	put (v: G)
			-- Replace item at current position with `v'
		require
			not_off: not off
		deferred
		ensure
			sequence_effect: sequence |=| old sequence.replaced_at (index, v)
		end

	output (v: G)
			-- Replace item at current position with `v' and go to the next position
		do
			put (v)
			forth
		ensure then
			sequence_effect: sequence |=| old (sequence.replaced_at (index, v))
			index_effect: index = old index + 1
		end

	pipe (input: V_INPUT_STREAM [G])
			-- Copy values from `input' until one either `Current' or `other' is `off'
		do
			Precursor (input)
		ensure then
			index_effect: index = old index + input.sequence.count - old input.sequence.count
			sequence_effect: sequence |=| (old (sequence.front (index - 1)) + input.sequence.tail (old input.sequence.count + 1)
				+ (old sequence).tail (index))
		end

	pipe_n (input: V_INPUT_STREAM [G]; n: INTEGER)
			-- Copy `n' elements from `input'; stop if either `Current' or `other' is `off'
		do
			Precursor (input, n)
		ensure then
			index_effect: index = old index + input.sequence.count - old input.sequence.count
			sequence_effect: sequence |=| (old (sequence.front (index - 1)) + input.sequence.tail (old input.sequence.count + 1)
				+ (old sequence).tail (index))
		end
end
