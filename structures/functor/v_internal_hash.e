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
end
