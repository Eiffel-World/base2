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
			create search_tree.make (create {V_KEY_VALUE_ORDER [K, G]}.make (o))
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
				search_tree := other.search_tree.twin
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
		do
			Result := search_tree.position_of ([k, default_item]).item.value
		end

feature -- Measurement
	key_order: V_TOTAL_ORDER [K]
			-- Order relation on keys

	count: INTEGER
			-- Number of elements
		do
			Result := search_tree.count
		end

	has_key (k: K): BOOLEAN
			-- Is any value associated with `k'?
		do
			Result := search_tree.has ([k, default_item])
		end

feature -- Search
	position_of_key (k: K): V_TABLE_ITERATOR [K, G]
			-- Position of `k' in the table if contained, otherwise off
		do
			create {V_SORTED_TABLE_ITERATOR [K, G]} Result.make_from_tree_iterator (Current, search_tree.position_of ([k, default_item]))
		end

feature -- Iteration
	at_start: V_TABLE_ITERATOR [K, G]
			-- New iterator pointing to a position in the container, from which it can traverse all elements by going `forth'
		do
			create {V_SORTED_TABLE_ITERATOR [K, G]} Result.make_start (Current)
		end

	at_finish: like at_start
			-- New iterator pointing to a position in the container, from which it can traverse all elements by going `back'
		do
			create {V_SORTED_TABLE_ITERATOR [K, G]} Result.make_start (Current)
			Result.finish
		end

	at (i: INTEGER): like at_start
			-- New iterator poiting at `i'-th position
		do
			create {V_SORTED_TABLE_ITERATOR [K, G]} Result.make_start (Current)
			Result.go_to (i)
		end

feature -- Replacement
	put (k: K; v: G)
			-- Associate `v' with key `k'
		do
			search_tree.position_of ([k, default_item]).item.value := v
		end

feature -- Extension
	extend (k: K; v: G)
			-- Extend table with key-value pair <`k', `v'>
		do
			search_tree.extend ([k, v])
		end

feature -- Removal
	remove (k: K)
			-- Remove key `k' and its associated value
		do
			search_tree.remove ([k, default_item])
		end

	wipe_out
			-- Remove all elements
		do
			search_tree.wipe_out
		end

feature {V_SORTED_TABLE_ITERATOR, V_SORTED_TABLE} -- Implementation
	search_tree: V_SORTED_SET [TUPLE [key: K; value: G]]

feature -- Specification
	order_relation: MML_RELATION [K, K]
			-- Element equivalence relation
		note
			status: specification
		do
			Result := key_order.order_relation
		end

invariant
	search_tree_exists: search_tree /= Void
	relation_definition: relation |=| (order_relation.complement * order_relation.inverse.complement)
	key_order_order_definition: key_order.order_relation |=| order_relation
end
