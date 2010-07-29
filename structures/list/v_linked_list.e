note
	description: "[
		Singly linked lists.
		Random access takes linear time. 
		Once a position is found, inserting or removing elements to the right of it takes constant time 
		and doesn't require reallocation of other elements.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	model: sequence

class
	V_LINKED_LIST [G]

inherit
	V_LIST [G]
		redefine
			default_create,
			copy,
			prepend
		end

feature {NONE} -- Initialization
	default_create
			-- Create an empty list.
		do
			create iterator.make (Current)
		ensure then
			sequence_effect: sequence.is_empty
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize by copying all the items of `other'.
		do
			if other /= Current then
				wipe_out
				if iterator = Void then
					create iterator.make (Current)
				end
				append (other.at_start)
			end
		ensure then
			sequence_effect: sequence |=| other.sequence
			other_sequence_effect: other.sequence |=| old other.sequence
		end

feature -- Access
	item alias "[]" (i: INTEGER): G assign put
			-- Value associated with `i'.
		do
			Result := at (i).item
		end

feature -- Measurement		
	count: INTEGER
			-- Number of elements.

feature -- Iteration
	at (i: INTEGER): V_LINKED_LIST_ITERATOR [G]
			-- New iterator pointing at position `i'.
		do
			create Result.make (Current)
			Result.go_to (i)
		end

feature -- Replacement
	put (v: G; i: INTEGER)
			-- Associate `v' with index `i'.
		do
			iterator.go_to (i)
			iterator.put (v)
		end

feature -- Extension
	extend_front (v: G)
			-- Insert `v' at the front.
		local
			cell: V_LINKABLE [G]
		do
			create cell.put (v)
			if is_empty then
				last_cell := cell
			else
				cell.put_right (first_cell)
			end
			first_cell := cell
			count := count + 1
		end

	extend_back (v: G)
			-- Insert `v' at the back.
		local
			cell: V_LINKABLE [G]
		do
			create cell.put (v)
			if is_empty then
				first_cell := cell
			else
				last_cell.put_right (cell)
			end
			last_cell := cell
			count := count + 1
		end

	extend_at (v: G; i: INTEGER)
			-- Insert `v' at position `i'.
		do
			if i = 1 then
				extend_front (v)
			elseif i = count + 1 then
				extend_back (v)
			else
				iterator.go_to (i - 1)
				iterator.extend_right (v)
			end
		end

	prepend (input: V_INPUT_ITERATOR [G])
			-- Prepend sequence of values, over which `input' iterates.
		do
			if not input.after then
				extend_front (input.item)
				input.forth
				from
					iterator.start
				until
					input.after
				loop
					iterator.extend_right (input.item)
					iterator.forth
					input.forth
				end
			end
		end

	insert_at (input: V_INPUT_ITERATOR [G]; i: INTEGER)
			-- Insert sequence of values, over which `input' iterates, starting at position `i'.
		do
			if i = 1 then
				prepend (input)
			else
				from
					iterator.go_to (i - 1)
				until
					input.after
				loop
					iterator.extend_right (input.item)
					iterator.forth
					input.forth
				end
			end
		end

feature -- Removal
	remove_front
			-- Remove first element.
		do
			if count = 1 then
				last_cell := Void
			end
			first_cell := first_cell.right
			count := count - 1
		end

	remove_back
			-- Remove last element.
		do
			if count = 1 then
				first_cell := Void
				last_cell := Void
				count := 0
			else
				iterator.go_to (count - 1)
				iterator.remove_right
			end
		end

	remove_at  (i: INTEGER)
			-- Remove element at position `i'.
		do
			if i = 1 then
				remove_front
			else
				iterator.go_to (i - 1)
				iterator.remove_right
			end
		end

	wipe_out
			-- Remove all elements.
		do
			first_cell := Void
			last_cell := Void
			count := 0
		end

feature {V_LINKED_LIST, V_LINKED_LIST_ITERATOR} -- Implementation
	first_cell: V_LINKABLE [G]
			-- First cell of the list.

	last_cell: V_LINKABLE [G]
			-- Last cell of the list.

	extend_after (v: G; c: V_LINKABLE [G])
			-- Add a new cell with value `v' after `c'.
		require
			c_exists: c /= Void
		local
			new: V_LINKABLE [G]
		do
			create new.put (v)
			if c.right = Void then
				last_cell := new
			else
				new.put_right (c.right)
			end
			c.put_right (new)
			count := count + 1
		end

	remove_after (c: V_LINKABLE [G])
			-- Remove the cell to the right of `c'.
		require
			c_exists: c /= Void
			c_right_exists: c.right /= Void
		do
			c.put_right (c.right.right)
			if c.right = Void then
				last_cell := c
			end
			count := count - 1
		end

	merge_after (other: V_LINKED_LIST [G]; c: V_LINKABLE [G])
			-- Merge `other' into `Current' after cell `c'. If `c' is `Void', merge to the front.
		require
			other_exists: other /= Void
		local
			other_first, other_last: V_LINKABLE [G]
		do
			if not other.is_empty then
				other_first := other.first_cell
				other_last := other.last_cell
				count := count + other.count
				other.wipe_out
				if c = Void then
					if first_cell = Void then
						last_cell := other_last
					else
						other_last.put_right (first_cell)
					end
					first_cell := other_first
				else
					if c.right = Void then
						last_cell := other_last
					else
						other_last.put_right (c.right)
					end
					c.put_right (other_first)
				end
			end
		end

feature {NONE} --Implementation
	iterator: V_LINKED_LIST_ITERATOR [G]
			-- Internal iterator.

invariant
	first_cell_exists_in_nonempty: is_empty = (first_cell = Void)
	last_cell_exists_in_nonempty: is_empty = (last_cell = Void)
	iterator_exists: iterator /= Void
end
