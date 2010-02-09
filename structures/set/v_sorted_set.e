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
			copy
		end

create
	make

feature {NONE} -- Initizalization
	make (o: V_TOTAL_ORDER [G])
			-- Create an empty set with elements order `o'
		require
			o_exists: o /= Void
		do
			order := o
			create tree
			cursor := tree.at_root
		ensure
			set_effect: set.is_empty
			relation_effect: relation |=| o.equivalence
		end

feature -- Initialization
	copy (other: like Current)
			-- Copy order relation and values values from `other'.
		do
			if other /= Current then
				order := other.order
				tree := other.tree.twin
				cursor := tree.at_root
			end
		ensure then
			order_effect: order_relation |=| other.order_relation
			set_effect: set |=| other.set
			other_order_effect: other.order_relation |=| old other.order_relation
			other_set_effect: other.set |=| old other.set
		end

feature -- Measurement
	order: V_TOTAL_ORDER [G]
			-- Order relation on values

	count: INTEGER
			-- Number of elements
		do
			Result := tree.count
		end

feature -- Search
	position_of (v: G): V_INORDER_ITERATOR [G]
			-- Position of `v' in the set if contained, otherwise off
		do
			create Result.make_from_cursor (cursor_at (v))
		end

feature -- Iteration
	at_start: V_INORDER_ITERATOR [G]
			-- New iterator pointing to a position in the container, from which it can traverse all elements by going `forth'
		do
			Result := tree.at_start
		end

	at_finish: like at_start
			-- New iterator pointing to a position in the container, from which it can traverse all elements by going `back'
		do
			Result := tree.at_finish
		end

	at (i: INTEGER): like at_start
			-- New iterator poiting at `i'-th position
		do
			Result := tree.at (i)
		end

feature -- Extension
	extend (v: G)
			-- Add `v' to the set
		local
			done: BOOLEAN
		do
			if tree.is_empty then
				tree.add_root (v)
			else
				from
					cursor.go_root
				until
					done
				loop
					if order.equivalent (v, cursor.item) then
						done := True
					elseif order.less_than (v, cursor.item) then
						if not cursor.has_left then
							cursor.extend_left (v)
							done := True
						else
							cursor.left
						end
					else
						if not cursor.has_right then
							cursor.extend_right (v)
							done := True
						else
							cursor.right
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
			found: V_BINARY_TREE_CELL [G]
		do
			cursor := cursor_at (v)
			if not cursor.off then
				if cursor.has_left and cursor.has_right then
					found := cursor.active
					cursor.right
					from
					until
						not cursor.has_left
					loop
						cursor.left
					end
					found.put (cursor.item)
				end
				cursor.remove
			end
		end

feature -- Removal
	wipe_out
			-- Remove all elements
		do
			tree.wipe_out
		end

feature {V_SORTED_SET} --Implementation
	tree: V_BINARY_TREE [G]
			-- Element storage

feature {NONE} -- Implementation
	cursor: V_BINARY_TREE_CURSOR [G]
			-- Internal cursor

	cursor_at (v: G): V_BINARY_TREE_CURSOR [G]
			-- Position of `v' in the set if contained, otherwise off
		do
			from
				Result := tree.at_root
			until
				Result.off or else order.equivalent (v, Result.item)
			loop
				if order.less_than (v, Result.item) then
					Result.left
				else
					Result.right
				end
			end
		end

feature -- Model
	order_relation: MML_RELATION [G, G]
			-- Element equivalence relation
		note
			status: model
		do
			Result := order.order
		end

invariant
	order_exists: order /= Void
	tree_exists: tree /= Void
	cursor_exists: cursor /= Void
	relation_definition: relation |=| (order_relation.complement * order_relation.inverse.complement)
	order_order_definition: order.order |=| order_relation
end
