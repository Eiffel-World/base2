note
	description: "Sorted set of integers (for testing purposes)."

class
	INT_SORTED_SET

inherit
	V_SORTED_SET [INTEGER]

feature -- Testing
	fix_agents
			-- Fix agents corrupted by serialization
		do
			order := agent comparable_less_equal
		end

end
