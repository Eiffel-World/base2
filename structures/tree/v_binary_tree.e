note
	description: "Binary trees (doubly linked implementation)."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map

class
	V_BINARY_TREE [G]

inherit
	V_CONTAINER [G]
		rename
			new_iterator as at_inorder_start
		redefine
			copy,
			is_equal
		end

create
	default_create

feature -- Initialization
	copy (other: like Current)
			-- Copy values and structure from `other'.
		do
			if other /= Current then
				root := subtree_twin (other.root)
				count := other.count
			end
		ensure then
			map_effect: map |=| other.map
			other_map_effect: other.map |=| old other.map
		end

feature -- Measurement
	count: INTEGER
			-- Number of elements.

feature -- Iteration
	at_root: V_BINARY_TREE_CURSOR [G]
			-- New cursor pointing to the root.
		do
			create Result.make (Current)
			Result.go_root
		ensure
			target_definition: Result.target = Current
			path_definition_non_empty: not map.is_empty implies Result.path |=| {MML_BIT_VECTOR} [True]
			path_definition_empty: map.is_empty implies Result.path.is_empty
		end

	at_inorder_start: V_INORDER_ITERATOR [G]
			-- New inorder iterator pointing to the first position.
		do
			create Result.make (Current)
			Result.start
		end

	at_preorder_start: V_PREORDER_ITERATOR [G]
			-- New preorder iterator pointing to the first position.
		do
			create Result.make (Current)
			Result.start
		end

	at_postorder_start: V_POSTORDER_ITERATOR [G]
			-- New postorder iterator pointing to the first position.
		do
			create Result.make (Current)
			Result.start
		end

feature -- Comparison
	is_equal (other: like Current): BOOLEAN
			-- Does `other' has the same structure and contain the same objects?
		do
			Result := equal_subtree (root, other.root)
		ensure then
			definition: Result = (map |=| other.map)
		end

feature -- Extension
	add_root (v: G)
			-- Add a root with value `v' to an empty tree.
		require
			is_empty: is_empty
		do
			create root.put (v)
			count := 1
		ensure
			map_effect: map |=| create {like map}.singleton (True, v)
		end

feature -- Removal		
	wipe_out
			-- Remove all elements.
		do
			root := Void
			count := 0
		ensure then
			map_effect: map.is_empty
		end

feature {V_BINARY_TREE, V_BINARY_TREE_CURSOR} -- Implementation
	root: V_BINARY_TREE_CELL [G]
			-- Root node.

feature {V_BINARY_TREE_CURSOR} -- Implementation
	extend_left (v: G; cell: V_BINARY_TREE_CELL [G])
			-- Add a left child with value `v' to `cell'.
		require
			cell_exists: cell /= Void
			not_cell_has_left: cell.left = Void
		do
			cell.put_left (create {V_BINARY_TREE_CELL [G]}.put (v))
			count := count + 1
		end

	extend_right (v: G; cell: V_BINARY_TREE_CELL [G])
			-- Add a right child with value `v' to `cell'.
		require
			cell_exists: cell /= Void
			not_cell_has_left: cell.right = Void
		do
			cell.put_right (create {V_BINARY_TREE_CELL [G]}.put (v))
			count := count + 1
		end

	remove (cell: V_BINARY_TREE_CELL [G])
			-- Remove `cell' from the tree (it must have less than two child nodes).
		require
			cell_exists: cell /= Void
			not_two_children: cell.left = Void or cell.right = Void
		local
			child: V_BINARY_TREE_CELL [G]
		do
			if cell.left /= Void then
				child := cell.left
			else
				child := cell.right
			end
			if cell.is_root then
				root := child
				if child /= Void then
					child.simple_put_parent (Void)
				end
			else
				if cell.is_left then
					cell.parent.put_left (child)
				else
					cell.parent.put_right (child)
				end
			end
			count := count - 1
		end

feature {NONE} -- Implementation
	subtree_twin (cell: V_BINARY_TREE_CELL [G]): V_BINARY_TREE_CELL [G]
			-- Copy of subtree with root `cell'.
		do
			if cell /= Void then
				create Result.put (cell.item)
				Result.put_left (subtree_twin (cell.left))
				Result.put_right (subtree_twin (cell.right))
			end
		end

	equal_subtree (i, j: V_BINARY_TREE_CELL [G]): BOOLEAN
			-- Is subtree with root `i' equal to that with root `j' both in structure in values?
		do
			if i /= Void and j /= Void then
				Result := (i.item = j.item) and equal_subtree (i.left, j.left) and equal_subtree (i.right, j.right)
			else
				Result := (i = Void) and (j = Void)
			end
		end

feature -- Specification
	map: MML_FINITE_MAP [MML_BIT_VECTOR, G]
			-- Map of paths to elements.
		note
			status: specification
		do
			if is_empty then
				create Result.empty
			else
				Result := at_root.map
			end
		end

invariant
	bag_domain_definition: bag.domain |=| map.range
	bag_definition: bag.domain.for_all (agent (x: G): BOOLEAN
		do
			Result := bag [x] = map.inverse.image_of (x).count
		end)
end
