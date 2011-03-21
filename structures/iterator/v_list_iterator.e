note
	description: "Iterators over lists."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, index

deferred class
	V_LIST_ITERATOR [G]

inherit
	V_ITERATOR [G]
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
		require
			not_off: not off
		deferred
		ensure
			target_sequence_effect: target.sequence |=| old (target.sequence.front (index - 1).extended (v) + target.sequence.tail (index))
			index_effect: index = old index + 1
		end

	extend_right (v: G)
			-- Insert `v' to the right of current position.
			-- Do not move cursor.
		require
			not_off: not off
		deferred
		ensure
			target_sequence_effect: target.sequence |=| old (target.sequence.front (index).extended (v) + target.sequence.tail (index + 1))
			index_effect: index = old index
		end

	insert_left (other: V_INPUT_ITERATOR [G])
			-- Append, to the left of current position, sequence of values produced by `other'.
			-- Do not move cursor.
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
			other_sequence_effect: other.sequence |=| old other.sequence
		end

	insert_right (other: V_INPUT_ITERATOR [G])
			-- Append, to the right of current position, sequence of values produced by `other'.
			-- Move cursor to the last element of inserted sequence.
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
			other_sequence_effect: other.sequence |=| old other.sequence
		end

feature -- Removal
	remove
			-- Remove element at current position. Move cursor to the next position.
		require
			not_off: not off
		deferred
		ensure
			target_sequence_effect: target.sequence |=| old (target.sequence.front (index - 1) + target.sequence.tail (index + 1))
			index_effect: index = old index
		end

	remove_left
			-- Remove element to the left current position. Do not move cursor.
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
		require
			not_off: not off
			not_last: not is_last
		deferred
		ensure
			target_sequence_effect: target.sequence |=| old (target.sequence.front (index) + target.sequence.tail (index + 2))
			index_effect: index = old index
		end

invariant
	sequence_definition: sequence |=| target.sequence
end
