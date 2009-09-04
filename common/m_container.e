indexing
	description: "Data structures of the most general kind, characterised by presence or absence of elements."

deferred class
	M_CONTAINER [E]

feature -- Access
	has (v: E): BOOLEAN
			-- Is `v' contained?
		deferred
		ensure
			not_has_if_empty: is_empty implies not Result
		end

	is_empty: BOOLEAN
			-- Is empty?
		deferred
		end

end
