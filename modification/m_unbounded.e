note
	description: "Data structures that can always be extended."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_UNBOUNDED [E]

inherit
	M_EXTENDIBLE [E]
		redefine
			full
		end

feature -- Status report
	has_space_for (i: INTEGER): BOOLEAN
			-- Can `i' new elements be added?
		do
			Result := true
		ensure then
			has_space: Result
		end

	full: BOOLEAN is False
			-- Can new elements not be added?
end
