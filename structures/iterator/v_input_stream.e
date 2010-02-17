note
	description: "Streams that provide values one by one."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: off, item, sequence

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
			sequence_effect: executable implies
				sequence |=| old (sequence.extended (item))
		end

	search_forth (v: G)
			-- Move to the first occurrence of `v' at or after current position
			-- If `v' does not occur, move `after'
			-- (Use refernce equality)
		do
			from
			until
				off or else item = v
			loop
				forth
			end
		ensure
			off_item_effect: off or else item = v
			sequence_effect: executable implies
				(old sequence).is_prefix_of (sequence)
			sequence_constraint: executable implies
				not sequence.tail (old sequence.count + 1).has (v)
		end

	satisfy_forth (pred: PREDICATE [ANY, TUPLE [G]])
			-- Move to the first position at or after current where `p' holds
			-- If `pred' never holds, move `after'
		do
			from
			until
				off or else pred.item ([item])
			loop
				forth
			end
		ensure
			off_item_effect: off or else pred.item ([item])
			sequence_effect: executable implies
				(old sequence).is_prefix_of (sequence)
			sequence_constraint: executable implies
				not sequence.tail (old sequence.count + 1).range.exists (pred)
		end

feature -- Specification
	sequence: MML_FINITE_SEQUENCE [G]
			-- Sequence of elements that are already read
		deferred
		end

	relevant (x: ANY): BOOLEAN
			-- Always true
		do
			Result := True
		end

	executable: BOOLEAN
			-- Are model-based contracts for this class executable?
		deferred
		end
end
