note
	description: "Streams where values can be output one by one."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: off--sequence, index

deferred class
	V_OUTPUT_STREAM [G]

feature -- Status report
	off: BOOLEAN
			-- Is current position off scope?
		deferred
		end

feature -- Replacement
	output (v: G)
			-- Put `v' into the stream and move to the next position
		require
			not_off: not off
		deferred
--		ensure
--			sequence_effect: sequence |=| old (sequence.replaced_at (index, v))
--			index_effect: index = old index + 1
		end

	pipe (input: V_INPUT_STREAM [G])
			-- Copy values from `input' until one either `Current' or `other' is `off'
		require
			input_exists: input /= Void
		do
			from
			until
				off or input.off
			loop
				output (input.item)
				input.forth
			end
		ensure
--			sequence_effect: sequence |=| ((old (sequence.front (index - 1)) + input.sequence.interval (old input.index, input.index))
--				|+| old sequence.tail (index))
--			index_effect: not input.sequence.domain [input.index] or not sequence.domain [index]
--			index_offset_effect: input.index - old input.index = index - old index
		end

	pipe_n (input: V_INPUT_STREAM [G]; n: INTEGER)
			-- Copy `n' elements from `input'; stop if either `Current' or `other' is `off'
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > n or off or input.off
			loop
				output (input.item)
				input.forth
				i := i + 1
			end
--		ensure
--			sequence_effect: sequence |=| ((old (sequence.front (index - 1)) + input.sequence.interval (old input.index, input.index))
--				|+| old (sequence.tail (index)))
--			index_effect: index = old index + n or not input.sequence.domain [input.index] or not sequence.domain [index]
--			index_offset_effect: input.index - old input.index = index - old index
		end

--feature -- Model
--	sequence: MML_SEQUENCE [G]
--			-- Sequence of elements
--		note
--			status: model
--		deferred
--		end

--	index: INTEGER
--			-- Current position
--		note
--			status: model
--		deferred
--		end
end
