note
	description: "[
			Sets implemented as binary search trees.
			Search, extension and removal are logarithmic on average.
			Iteration produces a sorted sequence.
		]"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: set, less_order

class
	V_SORTED_SET [G]

inherit
	V_SET [G]
		redefine
			copy,
			new_iterator
		end

create
	make

feature {NONE} -- Initialization
	make (o: PREDICATE [ANY, TUPLE [G, G]])
			-- Create an empty set with elements order `o'.
		require
			o_exists: o /= Void
		do
			less_order := o
			create tree
			create iterator.make (Current, tree)
		ensure
			set_effect: set.is_empty
			--- order_relation_effect: order_relation |=| o.order_relation
		end

feature -- Initialization
	copy (other: like Current)
			-- Copy order relation and values values from `other'.
		do
			if other /= Current then
				less_order := other.less_order
				if tree = Void then
					-- Copy used as a creation procedure
					tree := other.tree.twin
					create iterator.make (Current, tree)
				else
					tree.copy (other.tree)
				end
			end
		ensure then
			set_effect: set |=| other.set
			--- less_order_effect: less_order |=| other.less_order
			other_set_effect: other.set |=| old other.set
			--- other_less_order_effect: other.less_order |=| old other.less_order
		end

feature -- Measurement
	count: INTEGER
			-- Number of elements.
		do
			Result := tree.count
		end

feature -- Search
	less_order: PREDICATE [ANY, TUPLE [G, G]]
			-- Order relation on values.

	less_than (x, y: G): BOOLEAN
		do
			Result := less_order.item ([x, y])
		end

	equivalence: PREDICATE [ANY, TUPLE [G, G]]
			-- Equivalence relation derived from `less_order'.	
		do
			Result := agent (x, y: G): BOOLEAN
				do
					Result := not less_than (x, y) and not less_than (y, x)
				end
		ensure then
			--- definition: Result |=| agent (x, y: G): BOOLEAN -> not less_than (x, y) and not less_than (y, x) 	
		end

feature -- Iteration
	new_iterator: V_SORTED_SET_ITERATOR [G]
			-- New iterator pointing to a position in the set, from which it can traverse all elements by going `forth'.
		do
			create Result.make (Current, tree)
			Result.start
		end

	at (v: G): V_SORTED_SET_ITERATOR [G]
			-- New iterator over `Current' pointing at element `v' if it exists and `off' otherwise.
		do
			create Result.make (Current, tree)
			Result.search (v)
		end

feature -- Extension
	extend (v: G)
			-- Add `v' to the set.
		local
			done: BOOLEAN
		do
			if tree.is_empty then
				tree.add_root (v)
			else
				from
					iterator.go_root
				until
					done
				loop
					if equivalent (v, iterator.item) then
						done := True
					elseif less_than (v, iterator.item) then
						if not iterator.has_left then
							iterator.extend_left (v)
							done := True
						else
							iterator.left
						end
					else
						if not iterator.has_right then
							iterator.extend_right (v)
							done := True
						else
							iterator.right
						end
					end
				end
			end
		end

feature -- Removal
	wipe_out
			-- Remove all elements.
		do
			tree.wipe_out
		end

feature {V_SORTED_SET, V_SORTED_SET_ITERATOR} -- Implementation
	tree: V_BINARY_TREE [G]
			-- Element storage.
			-- Should not be reassigned after creation.

feature {NONE} -- Implementation
	iterator: V_SORTED_SET_ITERATOR [G]
			-- Internal cursor.

invariant
	order_exists: less_order /= Void
	tree_exists: tree /= Void
	iterator_exists: iterator /= Void
end
