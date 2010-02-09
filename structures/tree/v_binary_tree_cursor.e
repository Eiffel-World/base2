note
	description: "Cursors to traverse binary trees."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, active

class
	V_BINARY_TREE_CURSOR [G]

inherit
	V_CELL_CURSOR [G]
		redefine
			active
		end

create {V_BINARY_TREE}
	make

feature {NONE} -- Initialization
	make (tree: V_BINARY_TREE [G])
			-- Create iterator through `tree', whose count is stored in `cc'
		require
			tree_exists: tree /= Void
		do
			target := tree
			count_cell := tree.count_cell
		ensure
			target_effect: target = tree
			active_effect: active = Void
		end

feature -- Access
	target: V_BINARY_TREE [G]
			-- Tree to traverse

	active: V_BINARY_TREE_CELL [G]
			-- Cell at current position

--feature -- Measurement
--	subtree_count (node: V_BINARY_TREE_CELL [G]): INTEGER
--			-- Number of nodes in a subtree starting from `node'
--			-- ToDo: recursive definition
--		do
--			if node = Void then
--				Result := 0
--			else
--				Result := 1 + subtree_count (node.left) + subtree_count (node.right)
--			end
--		ensure
--			definition_base: node = Void implies Result = 0
--			definition_step: node /= Void implies Result = 1 + subtree_count (node.left) + subtree_count (node.right)
--		end

feature -- Status report
	is_root: BOOLEAN
			-- Is cursor at root?
		do
			Result := active /= Void and then active.is_root
		end

	is_leaf: BOOLEAN
			-- Is cursor at leaf?
		do
			Result := active /= Void and then active.is_leaf
		end

	has_left: BOOLEAN
			-- Does current node have a left child?
		do
			Result := active /= Void and then active.left /= Void
		end

	has_right: BOOLEAN
			-- Does current node have a right child?
		do
			Result := active /= Void and then active.right /= Void
		end

feature -- Cursor movement
	up is
			-- Move cursor up to the parent
		require
			not_off: not off
		do
			active := active.parent
		ensure
			active_effect: active = (old active).parent
		end

	left is
			-- Move cursor down to the left child
		require
			not_off: not off
		do
			active := active.left
		ensure
			active_effect: active = (old active).left
		end

	right is
			-- Move cursor down to the right child
		require
			not_off: not off
		do
			active := active.right
		ensure
			active_effect: active = (old active).right
		end

	go_root is
			-- Move cursor to the root
		do
			active := target.root
		ensure
			active_effect: active = target.root
		end

feature -- Extension
	extend_left (v: G)
			-- Add a left child with value `v' to the current node
		require
			not_off: not off
			not_has_left: not has_left
		do
			active.put_left (create {V_BINARY_TREE_CELL [G]}.put (v))
			count_cell.put (count_cell.item + 1)
		ensure
			active_left_item_effect: active.left.item = v
			active_left_left_effect: active.left.left = Void
			active_left_right_effect: active.left.right = Void
			target_bag_effect: target.bag |=| old target.bag.extended (v)
		end

	extend_right (v: G)
			-- Add a left child with value `v' to the current node
		require
			not_off: not off
			not_has_right: not has_right
		do
			active.put_right (create {V_BINARY_TREE_CELL [G]}.put (v))
			count_cell.put (count_cell.item + 1)
		ensure
			active_right_item_effect: active.right.item = v
			active_right_left_effect: active.right.left = Void
			active_right_right_effect: active.right.right = Void
			target_bag_effect: target.bag |=| old target.bag.extended (v)
		end
		
feature -- Removal
	remove
			-- Remove current node (it must have less than two child nodes)
			-- ToDo: contract
		require
			not_off: not off
			not_two_children: not has_left or not has_right
		local
			child: V_BINARY_TREE_CELL [G]
		do
			if has_left then
				child := active.left
			else
				child := active.right
			end
			if is_root then
				if is_leaf then
					target.wipe_out
				else
					active.put (child.item)
					active.put_left (child.left)
					active.put_right (child.right)
					count_cell.put (count_cell.item - 1)
				end
			else
				if active.is_left then
					active.parent.put_left (child)
				else
					active.parent.put_right (child)
				end
				count_cell.put (count_cell.item - 1)
			end
			active := Void
		ensure
			target_bag_effect: target.bag |=| old (target.bag.removed (active.item))
			active_effect: active = Void
		end

feature {NONE} -- Implementation
	count_cell: V_CELL [INTEGER]
			-- Cell where `target's	count is stored	

invariant
	is_root_definition: is_root = (active /= Void and then active.parent = Void)
	is_leaf_definition: is_leaf = (active /= Void and then active.left = Void and active.right = Void)
	has_left_definition: has_left = (active /= Void and then active.left /= Void)
	has_right_definition: has_right = (active /= Void and then active.right /= Void)
end
