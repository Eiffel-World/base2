note
	description: "Iterators over lists."
	author: "Nadia Polikarpova"
	model: target, index

deferred class
	V_LIST_ITERATOR [G]

inherit
	V_MUTABLE_SEQUENCE_ITERATOR [G]
		redefine
			target
		end

feature -- Access

	target: V_LIST [G]
			-- Container to iterate over.
		deferred
		end

feature -- Extension

	extend_left (v: G)
			-- Insert `v' to the left of current position.
			-- Do not move cursor.
		note
			modify: index --, target.sequence
		require
			not_off: not off
		deferred
		ensure
			target_sequence_effect: target.sequence |=| old (target.sequence.front (index - 1) & v + target.sequence.tail (index))
			index_effect: index = old index + 1
		end

	extend_right (v: G)
			-- Insert `v' to the right of current position.
			-- Do not move cursor.
--		note
--			modify: target.sequence
		require
			not_off: not off
		deferred
		ensure
			target_sequence_effect: target.sequence |=| old (target.sequence.front (index) & v + target.sequence.tail (index + 1))
			index_effect: index = old index
		end

	insert_left (other: V_ITERATOR [G])
			-- Append, to the left of current position, sequence of values produced by `other'.
			-- Do not move cursor.
		note
			modify: index, other__index --, target.sequence
		require
			not_off: not off
			other_exists: other /= Void
			different_target: target /= other.target
			other_not_before: not other.before
		deferred
		ensure
			target_sequence_effect: target.sequence |=| old (target.sequence.front (index - 1) + other.sequence.tail (other.index) + target.sequence.tail (index))
			index_effect: index = old (index + other.sequence.tail (other.index).count)
			other_index_effect: other.index = other.sequence.count + 1
		end

	insert_right (other: V_ITERATOR [G])
			-- Append, to the right of current position, sequence of values produced by `other'.
			-- Move cursor to the last element of inserted sequence.
		note
			modify: index, other__index --, target.sequence
		require
			not_off: not off
			other_exists: other /= Void
			different_target: target /= other.target
			other_not_before: not other.before
		deferred
		ensure
			target_sequence_effect: target.sequence |=| old (target.sequence.front (index) + other.sequence.tail (other.index) + target.sequence.tail (index + 1))
			index_effect: index = old (index + other.sequence.tail (other.index).count)
			other_index_effect: other.index = other.sequence.count + 1
		end

feature -- Removal

	remove
			-- Remove element at current position. Move cursor to the next position.
--		note
--			modify: target.sequence
		require
			not_off: not off
		deferred
		ensure
			target_sequence_effect: target.sequence |=| old (target.sequence.front (index - 1) + target.sequence.tail (index + 1))
		end

	remove_left
			-- Remove element to the left current position. Do not move cursor.
		note
			modify: index --, target.sequence
		require
			not_off: not off
			not_first: not is_first
		deferred
		ensure
			target_sequence_effect: target.sequence |=| old (target.sequence.front (index - 2) + target.sequence.tail (index))
			index_effect: index = old index - 1
		end

	remove_right
			-- Remove element to the right current position. Do not move cursor.
--		note
--			modify: target.sequence
		require
			not_off: not off
			not_last: not is_last
		deferred
		ensure
			target_sequence_effect: target.sequence |=| old (target.sequence.front (index) + target.sequence.tail (index + 2))
		end

invariant
	sequence_definition: sequence |=| target.sequence
end
