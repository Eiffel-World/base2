note
	description: "Iterators over linked lists."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, index

class
	V_LINKED_LIST_ITERATOR [G]

inherit
	V_LIST_ITERATOR [G]
		undefine
			off
		redefine
			copy
		end

	V_CELL_CURSOR [G]
		undefine
			is_equal
		redefine
			active,
			copy
		end

create {V_LINKED_LIST}
	make

feature {NONE} -- Initialization
	make (list: V_LINKED_LIST [G]; cc: V_CELL [INTEGER])
			-- Create iterator over `list'
		require
			list_exists: list /= Void
			valid_cc: cc = list.count_cell
		do
			target := list
			count_cell := cc
		ensure
			target_effect: target = list
			index_effect: index = 0
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize with the same `target' and position as in `other'
		do
			target := other.target
			active := other.active
			after := other.after
			count_cell := target.count_cell
		ensure then
			target_effect: target = other.target
			index_effect: index = other.index
			other_target_effect: other.target = old other.target
			other_index_effect: other.index = old other.index
		end

feature -- Access
	target: V_LINKED_LIST [G]
			-- Container to iterate over

feature -- Measurement			
	index: INTEGER
			-- Current position
		local
			c: V_LINKABLE [G]
		do
			if after then
				Result := count_cell.item + 1
			elseif active /= Void then
				from
					c := target.first_cell
					Result := 1
				until
					c = active
				loop
					Result := Result + 1
					c := c.right
				end
			end
		end

feature -- Status report		
	is_first: BOOLEAN
			-- Is cursor at the first position?
		do
			Result := not (active = Void) and active = target.first_cell
		end

	is_last: BOOLEAN
			-- Is cursor at the last position?
		do
			Result := not (active = Void) and then active.right = Void
		end

	after: BOOLEAN
			-- Is current position after the last container position?

	before: BOOLEAN
			-- Is current position before the first container position?
		do
			Result := off and not after
		end

feature -- Cursor movement
	start
			-- Go to the first position
		do
			active := target.first_cell
			if active = Void then
				after := True
			else
				after := False
			end
		end

	finish
			-- Go to the last position
		do
			if not target.is_empty then
				if off then
					start
				end
				from
				until
					active.right = Void
				loop
					forth
				end
			end
			after := False
		end

	forth
			-- Move one position forward
		do
			active := active.right
			if active = Void then
				after := True
			end
		end

	back
			-- Go one position backwards
		local
			old_active: V_LINKABLE [G]
		do
			if is_first then
				go_before
			else
				old_active := active
				from
					start
				until
					active.right = old_active
				loop
					forth
				end
			end
		end

	go_before
			-- Go before any position of `target'
		do
			active := Void
			after := False
		end

	go_after
			-- Go after any position of `target'
		do
			active := Void
			after := True
		end

feature -- Extension
	extend_left (v: G)
			-- Insert `v' to the left of current position. Do not move cursor.
		do
			if is_first then
				target.extend_front (v)
			else
				back
				extend_right (v)
				forth
				forth
			end
		end

	extend_right (v: G)
			-- Insert `v' to the right of current position. Do not move cursor.
		local
			cell: V_LINKABLE [G]
		do
			create cell.put (v)
			cell.put_right (active.right)
			active.put_right (cell)
			count_cell.put (count_cell.item + 1)
		end

	insert_left (other: V_INPUT_ITERATOR [G])
			-- Append sequence of values, over which `input' iterates to the left of current position. Do not move cursor.
		do
			if is_first then
				target.prepend (other)
			else
				back
				insert_right (other)
				forth
			end
		end

	insert_right (other: V_INPUT_ITERATOR [G])
			-- Append sequence of values, over which `input' iterates to the right of current position. Move cursor to the last element of inserted sequence.
		do
			from
			until
				other.off
			loop
				extend_right (other.item)
				forth
				other.forth
			end
		end

	merge (other: V_LINKED_LIST [G])
			-- Merge `other' into `target' after current position. Do not copy elements. Empty `other'.
		require
			other_exists: other /= Void
			not_off: not off
		local
			other_first, other_last: V_LINKABLE [G]
		do
			if not other.is_empty then
				other_first := other.first_cell
				other_last := other.at_finish.active
				count_cell.put (count_cell.item + other.count)
				other.wipe_out
				other_last.put_right (active.right)
				active.put_right (other_first)
			end
		ensure
			sequence_effect: sequence |=| old (sequence.front (index) + other.sequence + sequence.tail (index + 1))
			index_effect: index = old index
			other_sequence_effect: other.sequence.is_empty
		end

feature -- Removal
	remove
			-- Remove element at current position. Move cursor to the next position.
		do
			if is_first then
				target.remove_front
				start
			else
				back
				remove_right
				forth
			end
		end

	remove_left
			-- Remove element to the left current position. Do not move cursor.
		local
			old_active: V_LINKABLE [G]
		do
			old_active := active
			back
			remove
			active := old_active
		end

	remove_right
			-- Remove element to the right current position. Do not move cursor.
		do
			active.put_right (active.right.right)
			count_cell.put (count_cell.item - 1)
		end

feature {V_CELL_CURSOR} -- Implementation
	active: V_LINKABLE [G]
			-- Cell at current position

feature {NONE} -- Implementation
	count_cell: V_CELL [INTEGER]
			-- Cell where `target's	count is stored	

feature -- Specification
	sequence: MML_FINITE_SEQUENCE [G]
		note
			status: specification
		local
			c: V_LINKABLE [G]
		do
			create Result.empty
			from
				c := target.first_cell
			until
				c = Void
			loop
				Result := Result.extended (c.item)
				c := c.right
			end
		end
end
