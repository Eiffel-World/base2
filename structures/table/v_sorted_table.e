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
		rename
			key_equivalence as key_order
		redefine
			copy
		end

create
	make

feature {NONE} -- Initialization
	make (o: V_TOTAL_ORDER [K])
			-- Create an empty table with key order `o'.
		require
			o_exists: o /= Void
		do
			key_order := o
			create set.make (create {V_KEY_VALUE_ORDER [K, V]}.make (o))
		ensure
			map_effect: map.is_empty
			--- order_relation_effect: order_relation |=| o.order_relation
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize table by copying `key_order', and key-value pair from `other'.
		do
			if other /= Current then
				key_order := other.key_order
				if set = Void then
					-- Copy used as a creation procedure
					set := other.set.twin
				else
					set.copy (other.set)
				end
			end
		ensure then
			map_effect: map |=| other.map
			--- order_relation_effect: order_relation |=| other.order_relation
			other_map_effect: other.map |=| old other.map
			--- other_order_relation_effect: other.order_relation |=| old other.order_relation
		end

feature -- Measurement
	key_order: V_TOTAL_ORDER [K]
			-- Order relation on keys.

feature {V_SET_TABLE, V_SET_TABLE_ITERATOR} -- Implementation
	set: V_SORTED_SET [TUPLE [key: K; value: V]]
			-- Underlying set of key-value pairs.
			-- Should not be reassigned after creation.

feature -- Specification
	order_relation: MML_RELATION [K, K]
			-- Element equivalence relation.
		note
			status: specification
		do
			Result := key_order.order_relation
		end

invariant
	--- relation_definition: relation |=| (order_relation * order_relation.inverse)
	--- key_order_order_definition: key_order.order_relation |=| order_relation
end
