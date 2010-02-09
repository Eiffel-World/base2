note
	description: "[
		Singly linked lists.
		Random access takes linear time. 
		Once a position is found, inserting or removing elements to the right of it takes constant time and desn't require reallocation of other element.
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

feature {NONE} -- Initization
	default_create
			-- Create an empty list
		do
			create count_cell.put (0)
			create iterator.make (Current)
		ensure then
			sequence_effect: sequence.is_empty
		end

feature -- Initization		
	copy (other: like Current)
			-- Reinitialize by copying all the items of `other'.
		do
			if other /= Current then
				first_cell := Void
				if count_cell = Void then
					create count_cell.put (0)
				end
				if iterator = Void then
					create iterator.make (Current)
				end
				append (other.at_start)
			end
		ensure then
			sequence_effect: sequence |=| other.sequence
			other_map_effect: other.sequence |=| old other.sequence
		end

feature -- Access
	item alias "[]" (i: INTEGER): G
			-- Value associated with `i'
		do
			Result := at (i).item
		end

feature -- Measurement		
	count: INTEGER
			-- Number of elements
		do
			Result := count_cell.item
		end

feature -- Iteration
	at_start: V_LIST_ITERATOR [G]
			-- New iterator pointing to the first position
		do
			create {V_LINKED_LIST_ITERATOR [G]} Result.make (Current)
			Result.start
		end

	at_finish: like at_start
			-- New iterator pointing to the last position
		do
			create {V_LINKED_LIST_ITERATOR [G]} Result.make (Current)
			Result.finish
		end

	at (i: INTEGER): like at_start
			-- New iterator poiting at `i'-th position
		do
			create {V_LINKED_LIST_ITERATOR [G]} Result.make (Current)
			Result.go_to (i)
		end

feature -- Replacement
	put (i: INTEGER; v: G)
			-- Associate `v' with index `i'
		do
			iterator.go_to (i)
			iterator.put (v)
		end

feature -- Extension
	extend_front (v: G)
			-- Insert `v' at the front
		local
			cell: V_LINKABLE [G]
		do
			create cell.put (v)
			cell.put_right (first_cell)
			first_cell := cell
			count_cell.put (count + 1)
		end

	extend_back (v: G)
			-- Insert `v' at the back
		do
			if is_empty then
				create first_cell.put (v)
				count_cell.put (1)
			else
				iterator.finish
				iterator.extend_right (v)
			end
		end

	extend_at (i: INTEGER; v: G)
			-- Insert `v' at position `i'
		do
			if i = 1 then
				extend_front (v)
			else
				iterator.go_to (i - 1)
				iterator.extend_right (v)
			end
		end

	prepend (input: V_INPUT_ITERATOR [G])
			-- Prepend sequence of values, through which `input' iterates
		do
			if not input.off then
				extend_front (input.item)
				input.forth
				from
					iterator.start
				until
					input.off
				loop
					iterator.extend_right (input.item)
					iterator.forth
					input.forth
				end
			end
		end

	insert_at (i: INTEGER; input: V_INPUT_ITERATOR [G])
			-- Insert sequence of values, through which `input' iterates, starting at position `i'
		do
			from
				iterator.go_to (i - 1)
			until
				input.off
			loop
				iterator.extend_right (input.item)
				iterator.forth
				input.forth
			end
		end

feature -- Removal
	remove_front
			-- Remove first element
		do
			first_cell := first_cell.right
			count_cell.put (count - 1)
		end

	remove_back
			-- Remove last element
		do
			if count = 1 then
				first_cell := Void
				count_cell.put (0)
			else
				iterator.go_to (count - 1)
				iterator.remove_right
			end
		end

	remove_at  (i: INTEGER)
			-- Remove element at position `i'
		do
			if i = 1 then
				remove_front
			else
				iterator.go_to (i - 1)
				iterator.remove_right
			end
		end

	wipe_out
			-- Remove all elements
		do
			first_cell := Void
			count_cell.put (0)
		end

feature {V_LINKED_LIST_ITERATOR} -- Implementation
	first_cell: V_LINKABLE [G]
			-- First cell of the list

	last_cell: V_LINKABLE [G]
			-- Last cell of the list
		do
			if attached {V_LINKED_LIST_ITERATOR [G]} at_finish as i then
				Result := i.active
			end
		end

	count_cell: V_CELL [INTEGER]
			-- Cell to store count, where it can be updated by iterators

feature {NONE} --Implementation
	iterator: V_LINKED_LIST_ITERATOR [G]
			-- Internal iterator

invariant
	first_cell_exists_in_nonempty: is_empty = (first_cell = Void)
	iterator_exists: iterator /= Void
end
