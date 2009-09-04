note
	description: "Singly linked lists."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M_LINKED_LIST [E]

inherit
	M_LIST [E]
		undefine
			full,
			item,
			readable,
			go_i_th
		redefine
			remove_right,
			is_first,
			is_last
		end

	M_UNBOUNDED [E]

	M_CELLED_LINEAR [E]
		redefine
			active,
			is_first
		end

feature -- Access
	count: INTEGER
			-- Number of elements

feature -- Status report
	is_first: BOOLEAN
			-- Is cursor on the first element?
		do
			Result := not is_empty and (active = first_cell)
		end

	is_last: BOOLEAN
			-- Is cursor on the last element?
		do
			Result := (active /= Void and then active.right = Void)
		end

feature -- Cursor movement
	start
			-- Move current position to the first element
		do
			active := first_cell
		end

	forth
			-- Move current position to the next element
		do
			active := active.right
		end

	finish
			-- Move current position to the last element
		do
			if is_empty then
				active := Void
			else
				from
					start
				until
					active.right = Void
				loop
					forth
				end
			end
		end

feature -- Replacement
	replace (v: E)
			-- Replace current element with `v'
		do
			active.set_item (v)
		end

feature -- Element change
	extend_right (v: E)
			-- Add `v' to the right of cursor position.
			-- Do not move cursor.
		local
			new: M_LINKABLE [E]
		do
			create new.set_item (v)
			new.set_right (active.right)
			active.set_right (new)
			count := count + 1
		end

	extend_front (v: E)
			-- Add `v' at the front
		local
			new: M_LINKABLE [E]
		do
			create new.set_item (v)
			new.set_right (first_cell)
			first_cell := new
			count := count + 1
		end

	merge_right (other: like Current)
			-- Merge `other' into current structure after cursor
			-- position. Do not move cursor. Empty `other'.
		do
			other.last_cell.set_right (active.right)
			active.set_right (other.first_cell)
			count := count + other.count
			other.wipe_out
		end

	wipe_out
			-- Prune of all elements
		do
			first_cell := Void
			active := Void
			count := 0
		end

	remove_right
			-- Remove an element to the right from the cursor
		do
			active.set_right (active.right.right)
			count := count - 1
		end

	remove
			-- Remove current element
		do
			if is_first then
				first_cell := first_cell.right
				active := first_cell
				count := count - 1
			else
				back
				remove_right
			end
		end

feature {M_LINKED_LIST} -- Implementation
	first_cell: M_LINKABLE [E]

	last_cell: like first_cell
			-- Tail of list
		local
			p: like first_cell
		do
			from
				p := first_cell
			until
				p = Void
			loop
				Result := p
				p := p.right
			end
		end

	active: like first_cell
end
