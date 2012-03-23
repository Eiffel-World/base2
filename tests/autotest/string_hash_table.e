note
	description: "Hash table with string keys (for testing purposes)."

class
	STRING_HASH_TABLE

inherit
	V_HASH_TABLE [STRING, ANY]

create
	default_create,
	with_object_equality

feature -- Testing
	fix_agents
			-- Fix agents corrupted by serialization
		do
			key_hash := agent hash_code
			key_equivalence := agent reference_equal
		end

end
