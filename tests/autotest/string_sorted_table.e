note
	description: "Sorted tables with string keys (for testing purposes)."

class
	STRING_SORTED_TABLE

inherit
	V_SORTED_TABLE [STRING, ANY]

feature -- Testing
	fix_agents
			-- Fix agents corrupted by serialization
		do
			key_order := agent comparable_less_equal
		end

end
