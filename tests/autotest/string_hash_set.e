note
	description: "Hash set of strings (for testing)."

class
	STRING_HASH_SET

inherit
	V_HASH_SET [STRING]

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
