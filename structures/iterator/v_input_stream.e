note
	description: "Streams that provide values one by one."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: off, item--sequence

deferred class
	V_INPUT_STREAM [G]

feature -- Access
	item: G
			-- Item at current position
		require
			not_off: not off
		deferred
		end

feature -- Status report
	off: BOOLEAN
			-- Is current position off scope?
		deferred
		end

feature -- Cursor movement
	forth
			-- Move one position forward
		require
			not_off: not off
		deferred
		ensure
			item_effect: not off implies relevant (item)
			off_effect: relevant (off)
--			sequence_effect: sequence |=| old sequence.but_first
		end

feature -- Specification
	relevant (x: ANY): BOOLEAN
			-- Always true
		do
			Result := True
		end

--	sequence: MML_SEQUENCE [G]
--			-- Sequence of elements starting from current position
--		deferred
--		end

--invariant
--	off_definition: off = sequence.is_empty
--	item_definition: not sequence.is_empty implies item = sequence.first
end
