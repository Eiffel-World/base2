note
	description: "[
		Lists implemented as arrays.
		The size of list might be smaller than the size of underlying array.
		Random access is constant time. Inserting or removing elements at front or back is amortized constant time.
		Inserting or removing elements in the middle is linear time.
		]"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: sequence, capacity

class
	V_ARRAYED_LIST [G]

inherit
	V_LIST [G]
		redefine
			default_create,
			copy
		end

create
	default_create,
	make_with_capacity

feature {NONE} -- Initizalization
	default_create
			-- Create an empty list with default `capacity'
		do
			create array.make (1, default_capacity)
			first_index := 1
		ensure then
			sequence_effect: sequence.is_empty
			capacity_effect: capacity > 0
		end

	make_with_capacity (n: INTEGER)
			-- Create an empty list with capacity `n'
		do
			create array.make (1, n)
			first_index := 1
		ensure
			sequence_effect: sequence.is_empty
			capacity_effect: capacity = n
		end

feature -- Initialization
	copy (other: like Current)
			-- Reinitialize by copying all the items of `other'.
		do
			if other /= Current then
				array := other.array.twin
				first_index := other.first_index
				count := other.count
			end
		ensure then
			capacity_effect: capacity = other.capacity
			other_capacity_effect: other.capacity = old other.capacity
		end

feature -- Access
	item alias "[]" (i: INTEGER): G
			-- Value associated with `i'
		do
			Result := array [array_index (i)]
		end

feature -- Measurement		
	count: INTEGER
			-- Number of elements

	capacity: INTEGER
			-- Size of the underlying array
		do
			Result := array.count
		end

feature -- Iteration
	at_start: V_LIST_ITERATOR [G]
			-- New iterator pointing to the first position
		do
			create {V_ARRAYED_LIST_ITERATOR [G]} Result.make (Current, 1)
		end

	at_finish: like at_start
			-- New iterator pointing to the last position
		do
			create {V_ARRAYED_LIST_ITERATOR [G]} Result.make (Current, count)
		end

	at (i: INTEGER): like at_start
			-- New iterator poiting at `i'-th position
		do
			create {V_ARRAYED_LIST_ITERATOR [G]} Result.make (Current, i)
		end

feature -- Replacement
	put (i: INTEGER; v: G)
			-- Associate `v' with index `i'
		do
			array.put (array_index (i), v)
		end

feature -- Extension
	extend_front (v: G)
			-- Insert `v' at the front
		do
			reserve (count + 1)
			if is_empty then
				array.put (1, v)
				first_index := 1
			else
				first_index := mod_capacity (first_index - 1)
				array.put (first_index, v)
			end
			count := count + 1
		ensure then
			capacity_effect: capacity >= old capacity
		end

	extend_back (v: G)
			-- Insert `v' at the back
		do
			reserve (count + 1)
			array.put (array_index (count + 1), v)
			count := count + 1
		ensure then
			capacity_effect: capacity >= old capacity
		end

	extend_at (i: INTEGER; v: G)
			-- Insert `v' at position `i'
		do
			if i = 1 then
				extend_front (v)
			elseif i = count + 1 then
				extend_back (v)
			else
				reserve (count + 1)
				circular_copy (i, i + 1, count - i + 1)
				array.put (array_index (i), v)
				count := count + 1
			end
		ensure then
			capacity_effect: capacity >= old capacity
		end

	insert_at (i: INTEGER; input: V_INPUT_ITERATOR [G])
			-- Insert sequence of values, over which `input' iterates, starting at position `i'
		local
			ic: INTEGER
		do
			if i = 1 then
				prepend (input)
			elseif i = count + 1 then
				append (input)
			else
				ic := input.count
				reserve (count + ic)
				circular_copy (i, i + ic, count - i + 1)
				count := count + ic
				at (i).pipe (input)
			end
		ensure then
			capacity_effect: capacity >= old capacity
		end

feature -- Removal
	remove_front
			-- Remove first element
		do
			first_index := mod_capacity (first_index + 1)
			count := count - 1
		end

	remove_back
			-- Remove last element
		do
			count := count - 1
		end

	remove_at  (i: INTEGER)
			-- Remove element at position `i'
		do
			circular_copy (i + 1, i, count - i)
			count := count - 1
		end

	wipe_out
			-- Remove all elements
		do
			count := 0
		end

feature -- Resizing		
	reserve (n: INTEGER)
			-- Make sure `array' can accomodate `n' elements;
			-- Do not resize by less than `growth percentage'.
		local
			old_size, new_size: INTEGER
		do
			if capacity < n then
				old_size := capacity
				new_size := n.max (capacity * growth_percentage // 100)
				array.resize (1, new_size)
				if first_index > 1 then
					array.subcopy (array, first_index, old_size, new_size - old_size + first_index)
					array.clear (first_index, old_size.min (new_size - old_size + first_index - 1))
					first_index := new_size - old_size + first_index
				end
			end
		ensure
			capacity_effect: capacity >= n.max (old capacity)
		end

feature {V_ARRAYED_LIST} -- Implementation
	default_capacity: INTEGER = 10
			-- Default value for `capacity'

	growth_percentage: INTEGER = 150
			-- Minimum percentage by which `array' grows when resized

	array: V_ARRAY [G]
			-- Element storage

	first_index: INTEGER
			-- Index of the first list element in `array'

	mod_capacity (i: INTEGER): INTEGER
			-- `i' modulo `capacity' in range [`1', `capacity']
		do
			Result := (i - 1) \\ capacity + 1
			if i <= 0 then
				Result := Result + capacity
			end
		ensure
			in_bounds: 1 <= Result and Result <= capacity
		end

	array_index (i: INTEGER): INTEGER
			-- Position in `array' of `i'th list element
		do
			Result := mod_capacity (i + first_index - 1)
		ensure
			in_bounds: 1 <= Result and Result <= capacity
		end

	circular_copy (src, dest, n: INTEGER)
			-- Copy `n' elements from position `src' to position `dest'
		local
			i: INTEGER
			a: V_ARRAY [G]
		do
			a := array.twin
			from
				i := 1
			until
				i > n
			loop
				array.put (array_index (dest + i - 1), a [array_index (src + i - 1)])
				i := i + 1
			end
		end

invariant
	array_exists: array /= Void
	array_starts_from_one: array.lower = 1
	growth_percentage_valid: growth_percentage > 100
	first_index_in_bounds: 1 <= first_index and first_index <= capacity
end
