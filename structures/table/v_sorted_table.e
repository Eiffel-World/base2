note
	description: "[
			Tables implemented as binary search trees.
			Search, extension and removal are logarithmic on average.
		]"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, order_relation

class
	V_SORTED_TABLE [K, V]

inherit
	V_SET_TABLE [K, V]
		redefine
			copy
		end

create
	make

feature {NONE} -- Initialization
	make (o: PREDICATE [ANY, TUPLE [K, K]])
			-- Create an empty table with key order `o'.
		require
			o_exists: o /= Void
		do
			key_less_order := o
			create set.make (agent (kv1, kv2: TUPLE [key: K; value: V]; key_o: PREDICATE [ANY, TUPLE [K, K]]): BOOLEAN
					do
						Result := key_o.item ([kv1.key, kv2.key])
					end (?, ?, o))
		ensure
			map_effect: map.is_empty
			--- key_less_order_effect: key_less_order |=| o
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize table by copying `key_order', and key-value pair from `other'.
		do
			if other /= Current then
				key_less_order := other.key_less_order
				if set = Void then
					-- Copy used as a creation procedure
					set := other.set.twin
				else
					set.copy (other.set)
				end
			end
		ensure then
			map_effect: map |=| other.map
			--- key_less_order_effect: key_less_order |=| other.key_less_order
			other_map_effect: other.map |=| old other.map
			--- other_key_less_order_effect: other.key_less_order |=| old other.key_less_order
		end

feature -- Search
	key_less_order: PREDICATE [ANY, TUPLE [K, K]]
			-- `<' order relation on keys.

	less_than (k1, k2: K): BOOLEAN
			-- Is `k1 < k2' according to `key_less_order'?
		note
			status: specification
		do
			Result := key_less_order.item ([k1, k2])
		ensure
			definition: Result = key_less_order.item ([k1, k2])
		end

	key_equivalence: PREDICATE [ANY, TUPLE [K, K]]
			-- Key equivalence relation derived from `key_less_order'.	
		do
			Result := agent (x, y: K): BOOLEAN
				do
					Result := not less_than (x, y) and not less_than (y, x)
				end
		ensure then
			--- definition: Result |=| agent (x, y: K): BOOLEAN -> not less_than (x, y) and not less_than (y, x) 	
		end

feature {V_SET_TABLE, V_SET_TABLE_ITERATOR} -- Implementation
	set: V_SORTED_SET [TUPLE [key: K; value: V]]
			-- Underlying set of key-value pairs.
			-- Should not be reassigned after creation.

invariant
	key_less_order_exists: key_less_order /= Void
end
