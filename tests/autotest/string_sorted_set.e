note
	description: "Sorted sets of strings (for testing purposes)."

class
	STRING_SORTED_SET

inherit
	V_SORTED_SET [STRING]

feature -- Testing
	fix_agents
			-- Fix agents corrupted by serialization
		do
			order := agent comparable_less_equal
		end
end
