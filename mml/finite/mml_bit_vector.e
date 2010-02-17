note
	description: "Finite sequences of bits."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_BIT_VECTOR

inherit
	MML_MODEL

create
	make,
	make_with_count

convert
	make ({INTEGER})

feature {NONE} -- Initialization
	make (i: INTEGER)
			-- Create a bit vector which is a binary representation of `i'.
			-- Use minimal number of bits that are enough to represent `i'.
		require
			i_non_negative: i >= 0
		local
			temp: INTEGER
		do
			code := i
			from
				temp := code
			until
				temp = 0
			loop
				temp := temp |>> 1
				count := count + 1
			end
		end

	make_with_count (i, n: INTEGER)
			-- Create a bit vector with `n' bits which is a binary representation of `i'.
		require
			i_non_negative: i >= 0
			i_not_too_large: i < 1 |<< n
			n_non_negative: n >= 0
		do
			code := i
			count := n
		end

feature -- Access
	item alias "[]" (i: INTEGER): BOOLEAN
			-- Bit at `i'th position
		require
			i_in_bounds: 1 <= i and i <= count
		do
			Result := code.bit_test (i - 1)
		end

	count: INTEGER
			-- Number of bits

feature -- Status report
	is_empty: BOOLEAN
			-- Does vector have zero length?
		do
			Result := count = 0
		end

feature -- Decomposition
	last: BOOLEAN is
			-- The last element of `current'.
		require
			non_empty: not is_empty
		do
			Result := item (count)
		end

	but_first: MML_BIT_VECTOR is
			-- The elements of `Current' except for the first one.
		require
			non_empty: not is_empty
		do
			create Result.make_with_count (code |>> 1, count - 1)
		end

	tail (lower: INTEGER): MML_BIT_VECTOR
			-- The elements of `Current' string from `lower'.
		local
			l: INTEGER
		do
			l := lower.max (1).min (count + 1)
			create Result.make_with_count (code |>> (l - 1), count - l + 1)
		end

	but_last: MML_BIT_VECTOR is
			-- The elements of `Current' except for the last one.
		require
			non_empty: not is_empty
		do
			create Result.make_with_count (code.set_bit (False, count - 1), count - 1)
		end

	front (upper: INTEGER): MML_BIT_VECTOR
			-- Prefix up to `upper'.
		local
			u: INTEGER
		do
			u := upper.min (count).max (0)
			create Result.make_with_count (code & (1 |<< u - 1), u)
		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is this vector mathematically equal to `other'?
		do
			if attached {MML_BIT_VECTOR} other as vector then
				Result := count = vector.count and code = vector.code
			end
		end

	is_prefix_of (other: MML_BIT_VECTOR): BOOLEAN
			-- Is `Current' a prefix of `other'?
		local
			i: INTEGER
		do
			Result := count <= other.count
			from
				i := 1
			until
				i > count or not Result
			loop
				Result := item (i) = other.item (i)
				i := i + 1
			end
		end

feature -- Element change
	extended (b: BOOLEAN): MML_BIT_VECTOR
			-- Current vector extended with `b' at the end
		do
			create Result.make_with_count (code + b.to_integer |<< count, count + 1)
		end

	extended_at (i: INTEGER; b: BOOLEAN): MML_BIT_VECTOR
			-- Current vector extended with `b' at position `i'
		do
			Result := front (i - 1).extended (b) + tail (i)
		end

	removed_at (i: INTEGER): MML_BIT_VECTOR
			-- Current vector with element at position `i' removed
		do
			Result := front (i - 1) + tail (i + 1)
		end

	prepended (b: BOOLEAN): MML_BIT_VECTOR
			-- Current vector prepended with `b' at the beginning
		do
			create Result.make_with_count (code |<< 1 + b.to_integer, count + 1)
		end

	replaced_at (i: INTEGER; b: BOOLEAN): MML_BIT_VECTOR
			-- Current vector with `b' at position `i'
		do
			create Result.make_with_count (code.set_bit (b, i - 1), count)
		end

	concatenation alias "+" (other : MML_BIT_VECTOR): MML_BIT_VECTOR is
			-- The concatenation of `current' and `other'.
		do
			create Result.make_with_count (code + other.code |<< count, count + other.count)
		end

feature {MML_BIT_VECTOR} -- Implementation
	code: INTEGER

invariant
	count_non_negative: count >= 0
	code_non_negative: code >= 0
	code_not_too_large: code < 1 |<< count
end
