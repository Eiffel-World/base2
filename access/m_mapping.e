note
	description: "Data structures where elements are accessed through keys (mathematical functions)."

deferred class
	M_MAPPING [K, E]

inherit
	M_CONTAINER [E]

feature -- Access
	item alias "[]" (key: K): E
			-- Element associated with `key'
		require
			has_key: has_key (key)
		deferred
		ensure
			has: has (Result)
		end

	has_key (key: K): BOOLEAN
			-- Is there an element associated with `key'?
		deferred
		ensure
			empty_not_has_key: is_empty implies not Result
		end
end
