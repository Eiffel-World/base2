note
	description: "[
			Hash tables with hash function provided by HASHABLE
			and with reference or object equality as equivalence relation on keys.
		]"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, key_equivalence, key_hash

class
	V_HASH_TABLE [K -> HASHABLE, V]

inherit
	V_GENERAL_HASH_TABLE [K, V]
		redefine
			default_create
		end

inherit {NONE}
	V_EQUALITY [K]
		export {NONE}
			all
		undefine
			default_create,
			out,
			copy,
			is_equal
		end

	V_HASH [K]
		export {NONE}
			all
		undefine
			default_create,
			out,
			copy,
			is_equal
		end

create
	default_create,
	with_object_equality

feature {NONE} -- Initialization
	default_create
			-- Create an empty table with reference equality as equivalence relation on keys.
		do
			make (agent reference_equal, agent hash_code)
		end

	with_object_equality
			-- Create an empty table with object equality as equivalence relation on keys.
		do
			make (agent object_equal, agent hash_code)
		end

end
