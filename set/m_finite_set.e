note
	description: "Data strures that have at most one occurrence of any value."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_FINITE_SET [E]

inherit
	M_FINITE [E]

feature -- Access
	occurrences (v: E): INTEGER
			-- Number of times `v' appears
		do
			if has (v) then
				Result := 1
			end
		ensure then
			one_if_has: has (v) implies Result = 1
		end
end
