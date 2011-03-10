note
	description: "Closed integer intervals."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_INTERVAL

inherit
	MML_SET [INTEGER]

create
	empty,
	singleton,
	from_range,
	from_tuple

create {MML_MODEL}
	make_from_array

convert
	singleton ({INTEGER}),
	from_tuple ({TUPLE [min: INTEGER; max: INTEGER]})

feature {NONE} -- Initialization
	from_range (l, u: INTEGER)
			-- Create interval [l, u].
		local
			i: INTEGER
		do
			if l <= u then
				create array.make (l, u)
				from
					i := l
				until
					i > u
				loop
					array [i] := i
					i := i + 1
				end
			else
				create array.make (1, 0)
			end
		end

	from_tuple (t: TUPLE [l: INTEGER; u: INTEGER])
			-- Create interval [l, u].
		require
			t_exists: t /= Void
		do
			from_range (t.l, t.u)
		end

feature -- Access
	lower: INTEGER
			-- Lower bound.
		require
			not_empty: not is_empty
		do
			Result := array.first
		end

	upper: INTEGER
			-- Upper bound.
		require
			not_empty: not is_empty
		do
			Result := array.last
		end
end