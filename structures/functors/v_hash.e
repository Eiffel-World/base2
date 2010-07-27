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
			non_negative: Result >= 0
		end

feature -- Specification
	map: MML_MAP [G, INTEGER]
			-- Mathematical map from values to hash codes.
		note
			status: specification
		deferred
		end
end
