note
	description: "Hash functions."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map

deferred class
	V_HASH [G]

feature -- Basic operations
	item (v: G): INTEGER
			-- Hash value of `v'.
		deferred
		ensure
			definition: Result = map [v]
		end

feature -- Specification
	map: MML_MAP [G, INTEGER]
			-- Mathematical map from values to hash codes.
		note
			status: specification
		do
			Result := create {MML_AGENT_MAP [G, INTEGER]}.from_function (agent item)
		end

invariant
---	map_constraint: map.domain.for_all (agent (x: G): BOOLEAN
---		do
---			Result := map [x] >= 0
---		end)
end
