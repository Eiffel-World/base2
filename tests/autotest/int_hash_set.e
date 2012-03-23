note
	description: "Hash set of integers (for testing)."

class
	INT_HASH_SET

inherit
	V_HASH_SET [INTEGER]

create
	default_create,
	with_object_equality

feature -- Testing
	fix_agents
			-- Fix agents corrupted by serialization
		do
			hash := agent hash_code
			equivalence := agent reference_equal
		end
end
