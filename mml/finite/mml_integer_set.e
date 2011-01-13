note
	description: "Finite sets of integers."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MML_INTEGER_SET

inherit
	MML_FINITE_SET [INTEGER]
		redefine
			is_integer_set,
			is_interval,
			lower,
			upper
		end

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
	from_range (min, max: INTEGER)
			-- Create interval [min, max]
		note
			mapped_to: "Set.from_range(min, max)"
		local
			i: INTEGER
		do
			if min <= max then
				create array.make (min, max)
				from
					i := min
				until
					i > max
				loop
					array [i] := i
					i := i + 1
				end
				interval_computed := True
				is_interval_cache := True
				lower_cache := min
				upper_cache := max
			else
				create array.make (1, 0)
				interval_computed := True
				is_interval_cache := True
				lower_cache := {INTEGER}.max_value
				upper_cache := {INTEGER}.min_value
			end
		end

	from_tuple (t: TUPLE [min: INTEGER; max: INTEGER])
			-- Create interval [min, max]
		require
			t_exists: t /= Void
		do
			from_range (t.min, t.max)
		end

feature -- Access
	lower: INTEGER
			-- Minimum
		note
			mapped_to: "Set.lower(Current)"
		do
			if not interval_computed then
				compute_interval
			end
			Result := lower_cache
		end

	upper: INTEGER
			-- Maximum
		note
			mapped_to: "Set.upper(Current)"
		do
			if not interval_computed then
				compute_interval
			end
			Result := upper_cache
		end

feature -- Status report
	is_integer_set: BOOLEAN = True

	is_interval: BOOLEAN
			-- Is Current an integer interval?
		do
			if not interval_computed then
				compute_interval
			end
			Result := is_interval_cache
		end

feature {NONE} -- Implementation		
	upper_cache, lower_cache: INTEGER
	is_interval_cache, interval_computed: BOOLEAN

	compute_interval
		local
			i: INTEGER
			int_set: MML_FINITE_SET [INTEGER]
		do
			interval_computed := True
			is_interval_cache := True
			create int_set.empty
			lower_cache := {INTEGER}.max_value
			upper_cache := {INTEGER}.min_value
			from
				i := array.lower
			until
				i > array.upper
			loop
				if attached {INTEGER} array.item (i) as n then
					if int_set [n] then
						is_interval_cache := False
					else
						int_set := int_set.extended (n)
						if n < lower_cache then
							lower_cache := n
						end
						if n > upper_cache then
							upper_cache := n
						end
					end
				else
					is_interval_cache := False
				end
				i := i + 1
			end
			is_interval_cache := array.is_empty or (upper_cache - lower_cache + 1) = array.count
		end
end
