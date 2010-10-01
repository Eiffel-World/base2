note
	description: "Hash functions based on functions defined inside HASHABLE classes."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map

class
	V_INTERNAL_HASH [G -> HASHABLE]

inherit
	V_HASH [G]

feature -- Basic operations
	item (v: G): INTEGER
			-- Hash value of `v'.
		do
			if v /= Void then
				Result := v.hash_code
			end
		end

feature -- Specification
	map: MML_MAP [G, INTEGER]
			-- Mathematical map from values to hash codes.
		note
			status: specification
		do
			create {MML_AGENT_MAP [G, INTEGER]} Result.from_function (agent (x: G): INTEGER
				do
					if x /= Void then
						Result := x.hash_code
					end
				end)
		end
end
