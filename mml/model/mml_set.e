note
	description: "Possibly infinite sets."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MML_SET [G]

inherit
	MML_MODEL

feature -- Access
	has alias "[]" (x: G): BOOLEAN
			-- Does set contain `x'?
		deferred
		end

feature -- Status report
	is_finite: BOOLEAN
			-- Is the set finite?
		do
		end

	is_empty: BOOLEAN
			-- Is the set empty?
		require
			is_finite: is_finite
		do
			Result := as_finite.is_empty
		end

feature -- Conversion
	as_finite: MML_FINITE_SET [G]
			-- If `is_finite' then current set
		require
			is_finite: is_finite
		do
		end

feature -- Basic operations
	intersection alias "*" (other: MML_SET [G]): MML_SET [G]
			-- Set that consists of values contained in both `Current' and `other'
		deferred
		end
end
