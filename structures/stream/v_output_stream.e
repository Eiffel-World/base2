note
	description: "Streams where values can be output one by one."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: off, sequence

deferred class
	V_OUTPUT_STREAM [G]

feature -- Status report
	off: BOOLEAN
			-- Is current position off scope?
		deferred
		end

feature -- Replacement
	output (v: G)
			-- Put `v' into the stream and move to the next position.
		require
			not_off: not off
		deferred
		ensure
			off_effect: relevant (off)
		end

	pipe (input: V_INPUT_STREAM [G])
			-- Copy values from `input' until one either `Current' or `input' is `off'.
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
			off_effect: off or input.off
			sequence_effect: executable and input.executable implies
				sequence |=| (old sequence + input.sequence.tail (old input.sequence.count + 1))
			input_sequence_effect: input.executable implies
				(old input.sequence).is_prefix_of (input.sequence)
			input_item_effect: not input.off implies relevant (input.item)
		end

	pipe_n (input: V_INPUT_STREAM [G]; n: INTEGER)
			-- Copy `n' elements from `input'; stop if either `Current' or `input' is `off'.
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
		ensure
			off_effect: input.executable implies
				off or input.off or input.sequence.count - old input.sequence.count = n
			sequence_effect: executable and input.executable implies
				sequence |=| (old sequence + input.sequence.tail (old input.sequence.count + 1))
			input_sequence_effect: input.executable implies
				(old input.sequence).is_prefix_of (input.sequence)
			input_sequnce_constraint: input.executable implies
				input.sequence.count - old input.sequence.count <= n
			input_item_effect: not input.off implies relevant (input.item)
		end

feature -- Specification
	sequence: MML_FINITE_SEQUENCE [G]
			-- Sequence of elements that are already written.
		note
			status: specification
		deferred
		end

	relevant (x: ANY): BOOLEAN
			-- Always true.
		note
			status: specification
		do
			Result := True
		end

	executable: BOOLEAN
			-- Are model-based contracts for this class executable?
		note
			status: specification
		deferred
		end
end
