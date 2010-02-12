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
	but_first: MML_BIT_VECTOR is
			-- The elements of `Current' except for the first one.
		require
			non_empty: not is_empty
		do
			create Result.make_with_count (code |>> 1, count - 1)
		end

	but_last: MML_BIT_VECTOR is
			-- The elements of `Current' except for the last one.
		require
			non_empty: not is_empty
		do
			create Result.make_with_count (code.set_bit (False, count - 1), count - 1)
		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is this vector mathematically equal to `other'?
		do
			if attached {MML_BIT_VECTOR} other as vector then
				Result := count = vector.count and code = vector.code
			end
		end

feature -- Element change
	extended (b: BOOLEAN): MML_BIT_VECTOR
			-- Current vector extended with `b' at the end
		do
			create Result.make_with_count (code + (b.to_integer |<< (count)), count + 1)
		end

	prepended (b: BOOLEAN): MML_BIT_VECTOR
			-- Current vector prepended with `b' at the beginning
		do
			create Result.make_with_count ((code |<< 1) + b.to_integer, count + 1)
		end

	replaced_at (i: INTEGER; b: BOOLEAN): MML_BIT_VECTOR
			-- Current vector with `b' at position `i'
		do
			create Result.make_with_count (code.set_bit (b, i - 1), count)
		end

feature {MML_BIT_VECTOR} -- Implementation
	code: INTEGER

invariant
	count_non_negative: count >= 0
	code_non_negative: code >= 0
	code_not_too_large: code < 1 |<< count
end
