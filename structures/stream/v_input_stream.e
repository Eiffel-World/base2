note
	description: "Streams that provide values one by one."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: off, item

deferred class
	V_INPUT_STREAM [G]

feature -- Access
	item: G
			-- Item at current position.
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
			-- Move one position forward.
		require
			not_off: not off
		deferred
		ensure
			item_effect: not off implies relevant (item)
			off_effect: relevant (off)
		end

	search (v: G)
			-- Move to the first occurrence of `v' at or after current position.
			-- If `v' does not occur, move `after'.
			-- (Use reference equality.)
		do
			from
			until
				off or else item = v
			loop
				forth
			end
		ensure
			off_item_effect: off or else item = v
		end

	satisfy (pred: PREDICATE [ANY, TUPLE [G]])
			-- Move to the first position at or after current where `p' holds.
			-- If `pred' never holds, move `after'.
		require
			pred_exists: pred /= Void
			pred_has_one_arg: pred.open_count = 1
		do
			from
			until
				off or else pred.item ([item])
			loop
				forth
			end
		ensure
			off_item_effect: off or else pred.item ([item])
		end

feature -- Specification
	relevant (x: ANY): BOOLEAN
			-- Always true.
		note
			status: specification
		do
			Result := True
		ensure
			definition: Result
		end
end
