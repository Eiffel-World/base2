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
	V_SORTED_TABLE [K, G]

inherit
	V_TABLE [K, G]
		rename
			key_equivalence as key_order
		redefine
			copy
		end

create
	make

feature {NONE} -- Initialization
	make (o: V_TOTAL_ORDER [K])
			-- Create an empty table with key order `o'
		require
			o_exists: o /= Void
		do
			key_order := o
			create set.make (create {V_KEY_VALUE_ORDER [K, G]}.make (o))
		ensure
			map_effect: map.is_empty
			order_relation_effect: order_relation |=| o.order_relation
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize table by copying `key_order', and key-value pair from `other'
		do
			if other /= Current then
				key_order := other.key_order
				set := other.set.twin
			end
		ensure then
			map_effect: map |=| other.map
			order_relation_effect: order_relation |=| other.order_relation
			other_map_effect: other.map |=| old other.map
			other_order_relation_effect: other.order_relation |=| old other.order_relation
		end

feature -- Access
	item alias "[]" (k: K): G
			-- Value associated with `k'
		local
			i: V_SORTED_TABLE_ITERATOR [K, G]
		do
			create i.make_start (Current)
			i.search_key (k)
			Result := i.value
		end

feature -- Measurement
	key_order: V_TOTAL_ORDER [K]
			-- Order relation on keys

	count: INTEGER
			-- Number of elements
		do
			Result := set.count
		end

	has_key (k: K): BOOLEAN
			-- Is any value associated with `k'?
		do
			Result := set.has ([k, default_item])
		end

feature -- Iteration
	at_start: V_SORTED_TABLE_ITERATOR [K, G]
			-- New iterator pointing to a position in the container, from which it can traverse all elements by going `forth'
		do
			create Result.make_start (Current)
		end

feature -- Replacement
	put (k: K; v: G)
			-- Associate `v' with key `k'
		local
			i: V_SORTED_TABLE_ITERATOR [K, G]
		do
			create i.make_start (Current)
			i.search_key (k)
			i.put (v)
		end

feature -- Extension
	extend (k: K; v: G)
			-- Extend table with key-value pair <`k', `v'>
		do
			set.extend ([k, v])
		end

feature -- Removal
	remove (k: K)
			-- Remove key `k' and its associated value
		do
			set.remove ([k, default_item])
		end

	wipe_out
			-- Remove all elements
		do
			set.wipe_out
		end

feature {V_SORTED_TABLE, V_SORTED_TABLE_ITERATOR} -- Implementation
	set: V_SORTED_SET [TUPLE [key: K; value: G]]

feature -- Specification
	order_relation: MML_RELATION [K, K]
			-- Element equivalence relation
		note
			status: specification
		do
			Result := key_order.order_relation
		end

invariant
	search_tree_exists: set /= Void
	relation_definition: relation |=| (order_relation.complement * order_relation.inverse.complement)
	key_order_order_definition: key_order.order_relation |=| order_relation
end
