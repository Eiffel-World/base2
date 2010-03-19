note
	description: "[
			Sets implemented as binary search trees.
			Search, extension and removal are logarithmic on average.
			Iteration produces a sorted sequence.
		]"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: set, order_relation

class
	V_SORTED_SET [G]

inherit
	V_SET [G]
		rename
			equivalence as order
		redefine
			copy,
			new_iterator
		end

create
	make

feature {NONE} -- Initizalization
	make (o: V_TOTAL_ORDER [G])
			-- Create an empty set with elements order `o'.
		require
			o_exists: o /= Void
		do
			order := o
			create tree
			create iterator.make (Current, tree)
		ensure
			set_effect: set.is_empty
			order_relation_effect: order_relation |=| o.order_relation
		end

feature -- Initialization
	copy (other: like Current)
			-- Copy order relation and values values from `other'.
		do
			if other /= Current then
				order := other.order
				tree := other.tree.twin
				create iterator.make (Current, tree)
			end
		ensure then
			order_effect: order_relation |=| other.order_relation
			set_effect: set |=| other.set
			other_order_effect: other.order_relation |=| old other.order_relation
			other_set_effect: other.set |=| old other.set
		end

feature -- Measurement
	order: V_TOTAL_ORDER [G]
			-- Order relation on values.

	count: INTEGER
			-- Number of elements.
		do
			Result := tree.count
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
					if order.equivalent (v, iterator.item) then
						done := True
					elseif order.less_than (v, iterator.item) then
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
	remove (v: G)
			-- Remove `v' from the set, if contained.
			-- Otherwise do nothing.		
		local
			found: V_SORTED_SET_ITERATOR [G]
		do
			iterator.search (v)
			if not iterator.off then
				if iterator.has_left and iterator.has_right then
					found := iterator.twin
					iterator.right
					from
					until
						not iterator.has_left
					loop
						iterator.left
					end
					found.put (iterator.item)
				end
				iterator.remove
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

feature {NONE} -- Implementation
	iterator: V_SORTED_SET_ITERATOR [G]
			-- Internal cursor.

feature -- Specification
	order_relation: MML_RELATION [G, G]
			-- Element equivalence relation.
		note
			status: specification
		do
			Result := order.order_relation
		end

invariant
	order_exists: order /= Void
	tree_exists: tree /= Void
	iterator_exists: iterator /= Void
	relation_definition: relation |=| (order_relation * order_relation.inverse)
	order_order_definition: order.order_relation |=| order_relation
end
