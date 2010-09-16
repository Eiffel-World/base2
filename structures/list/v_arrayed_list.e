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
	model: sequence

class
	V_ARRAYED_LIST [G]

inherit
	V_LIST [G]
		redefine
			default_create,
			copy,
			append,
			prepend
		end

feature {NONE} -- Initialization
	default_create
			-- Create an empty list with default `capacity' and `growth_rate'.
		do
			create array.make (1, default_capacity)
			first_index := 1
		ensure then
			sequence_effect: sequence.is_empty
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize by copying all the items of `other'.
		do
			if other /= Current then
				array := other.array.twin
				first_index := other.first_index
				count := other.count
			end
		ensure then
			sequence_effect: sequence |=| other.sequence
			other_sequence_effect: other.sequence |=| old other.sequence
		end

feature -- Access
	item alias "[]" (i: INTEGER): G assign put
			-- Value associated with `i'.
		do
			Result := array [array_index (i)]
		end

feature -- Measurement		
	count: INTEGER
			-- Number of elements.

feature -- Iteration
	at (i: INTEGER): V_ARRAYED_LIST_ITERATOR [G]
			-- New iterator pointing at position `i'.
		do
			create {V_ARRAYED_LIST_ITERATOR [G]} Result.make (Current, i)
		end

feature -- Replacement
	put (v: G; i: INTEGER)
			-- Associate `v' with index `i'.
		do
			array.put (v, array_index (i))
		end

feature -- Extension
	extend_front (v: G)
			-- Insert `v' at the front.
		do
			reserve (count + 1)
			if is_empty then
				array [1] := v
				first_index := 1
			else
				first_index := mod_capacity (first_index - 1)
				array [first_index] := v
			end
			count := count + 1
		end

	extend_back (v: G)
			-- Insert `v' at the back.
		do
			reserve (count + 1)
			array [array_index (count + 1)] := v
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
				reserve (count + 1)
				circular_copy (i, i + 1, count - i + 1)
				array [array_index (i)] := v
				count := count + 1
			end
		end

	append (input: V_INPUT_ITERATOR [G])
			-- Append sequence of values, over which `input' iterates.
		do
			Precursor (input)
		end

	prepend (input: V_INPUT_ITERATOR [G])
			-- Prepend sequence of values, over which `input' iterates.
		do
			insert_at (input, 1)
		end

	insert_at (input: V_INPUT_ITERATOR [G]; i: INTEGER)
			-- Insert sequence of values, over which `input' iterates, starting at position `i'.
		local
			ic: INTEGER
		do
			if i = count + 1 then
				append (input)
			else
				ic := input.count
				reserve (count + ic)
				circular_copy (i, i + ic, count - i + 1)
				count := count + ic
				at (i).pipe (input)
			end
		end

feature -- Removal
	remove_front
			-- Remove first element.
		do
			first_index := mod_capacity (first_index + 1)
			count := count - 1
		end

	remove_back
			-- Remove last element.
		do
			count := count - 1
		end

	remove_at (i: INTEGER)
			-- Remove element at position `i'.
		do
			circular_copy (i + 1, i, count - i)
			count := count - 1
		end

	wipe_out
			-- Remove all elements.
		do
			count := 0
		end

feature {V_ARRAYED_LIST} -- Implementation
	array: V_ARRAY [G]
			-- Element storage.

	first_index: INTEGER
			-- Index of the first list element in `array'.

feature {NONE} -- Implementation
	capacity: INTEGER
			-- Size of the underlying array.
		do
			Result := array.count
		end

	default_capacity: INTEGER = 10
			-- Default value for `capacity'.

	growth_rate: INTEGER = 150
			-- Minimum percentage by which underlying array grows when resized.
			-- Higher values improve runtime efficiency at the cost of higher memory consumption.
			-- Minimum value is 100%: only resize the array so that all list elements fit.						

	mod_capacity (i: INTEGER): INTEGER
			-- `i' modulo `capacity' in range [`1', `capacity'].
		do
			Result := (i - 1) \\ capacity + 1
			if i <= 0 then
				Result := Result + capacity
			end
		ensure
			in_bounds: 1 <= Result and Result <= capacity
		end

	array_index (i: INTEGER): INTEGER
			-- Position in `array' of `i'th list element.
		do
			Result := mod_capacity (i + first_index - 1)
		ensure
			in_bounds: 1 <= Result and Result <= capacity
		end

	circular_copy (src, dest, n: INTEGER)
			-- Copy `n' elements from position `src' to position `dest'.
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
				array [array_index (dest + i - 1)] := a [array_index (src + i - 1)]
				i := i + 1
			end
		end

	reserve (n: INTEGER)
			-- Make sure `array' can accommodate `n' elements;
			-- Do not resize by less than `growth_rate'.
		local
			old_size, new_size: INTEGER
		do
			if capacity < n then
				old_size := capacity
				new_size := n.max (capacity * growth_rate // 100)
				array.resize (1, new_size)
				if first_index > 1 then
					array.subcopy (array, first_index, old_size, new_size - old_size + first_index)
					array.clear (first_index, old_size.min (new_size - old_size + first_index - 1))
					first_index := new_size - old_size + first_index
				end
			end
		ensure
			capacity_effect_unchanged: n <= old capacity implies capacity = old capacity
			capacity_effect_changed: n > old capacity implies capacity = n.max (old capacity * growth_rate // 100)
		end

invariant
	array_exists: array /= Void
	array_starts_from_one: array.lower = 1
	first_index_in_bounds: capacity > 0 implies 1 <= first_index and first_index <= capacity
	first_index_one_in_empty: capacity = 0 implies first_index = 1
end
