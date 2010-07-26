note
	description: "Summary description for {MML_AGENT_MAP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MML_AGENT_MAP [K, G]

inherit
	MML_MAP [K, G]

create
	from_function

convert
	from_function ({FUNCTION [ANY, TUPLE [K], G]})

feature {NONE} -- Initialization
	from_function (f: FUNCTION [ANY, TUPLE [K], G])
			-- Create a set {x | p(x)}
		require
			f_exists: f /= Void
			f_has_one_arg: f.open_count = 1
		do
			function := f
		end

feature -- Access
	domain: MML_SET [K]
			-- Set of keys.
		do
			create {MML_AGENT_SET [K]} Result.such_that (agent (k: K): BOOLEAN do Result := True end)
		end

	item alias "[]" (k: K): G
			-- Value associated with `k'
		do
			Result := function.item ([k])
		end

feature -- Replacement
	replaced_at (k: K; x: G): MML_MAP [K, G]
			-- Current map with the value associated with `k' replaced by `x'
		do

		end

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is this model mathematically equal to `other'?
		do
			Result := True
		end

feature {MML_AGENT_MAP} -- Implementation
	function: FUNCTION [ANY, TUPLE [K], G]
			-- Agent that defines the mapping.
end
