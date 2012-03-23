note
	description: "Sorted tables with integer keys."

class
	INT_SORTED_TABLE

inherit
	V_SORTED_TABLE [INTEGER, ANY]

feature -- Testing
	fix_agents
			-- Fix agents corrupted by serialization
		do
			key_order := agent comparable_less_equal
		end


end
