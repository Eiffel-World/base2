note
	description: "Cursors to traverse binary trees."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, path

class
	V_BINARY_TREE_CURSOR [G]

inherit
	V_CELL_CURSOR [G]
		redefine
			active,
			copy,
			is_equal
		end

create {V_BINARY_TREE}
	make

feature {NONE} -- Initialization
	make (tree: V_BINARY_TREE [G]; cc: V_CELL [INTEGER])
			-- Create iterator over `tree'.
		require
			tree_exists: tree /= Void
			valid_cc: cc = tree.count_cell
		do
			target := tree
			count_cell := cc
		ensure
			target_effect: target = tree
			path_effect: path.is_empty
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize with the same `target' and `path' as in `other'.
		do
			target := other.target
			active := other.active
			count_cell := target.count_cell
		ensure then
			target_effect: target = other.target
			path_effect: path = other.path
			other_target_effect: other.target = old other.target
			other_path_effect: other.path = old other.path
		end

feature -- Access
	target: V_BINARY_TREE [G]
			-- Tree to traverse.

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

feature -- Comparison
	is_equal (other: like Current): BOOLEAN
			-- Does `other' have the same `target' and `path'?
		do
			Result := target = other.target and active = other.active
		ensure then
			definition: Result = (target = other.target and path |=| other.path)
		end

feature -- Cursor movement
	up is
			-- Move cursor up to the parent.
		require
			not_off: not off
		do
			active := active.parent
		ensure
			path_effect: path |=| old path.but_last
		end

	left is
			-- Move cursor down to the left child.
		require
			not_off: not off
		do
			active := active.left
		ensure
			path_effect_not_off: old (map.domain.has (path.extended (False))) implies path |=| old path.extended (False)
			path_effect_off: not old (map.domain.has (path.extended (False))) implies path.is_empty
		end

	right is
			-- Move cursor down to the right child.
		require
			not_off: not off
		do
			active := active.right
		ensure
			path_effect_not_off: old (map.domain.has (path.extended (True))) implies path |=| old path.extended (True)
			path_effect_off: not old (map.domain.has (path.extended (True))) implies path.is_empty
		end

	go_root is
			-- Move cursor to the root.
		do
			active := target.root
		ensure
			path_effect_non_empty: not target.map.is_empty implies path |=| {MML_BIT_VECTOR} [1]
			path_effect_empty: target.map.is_empty implies path.is_empty
		end

feature -- Extension
	extend_left (v: G)
			-- Add a left child with value `v' to the current node.
		require
			not_off: not off
			not_has_left: not has_left
--		local
--			new: V_BINARY_TREE_CELL [G]
		do
--			create new.put (v)
			active.put_left (create {V_BINARY_TREE_CELL [G]}.put (v))
			count_cell.put (count_cell.item + 1)
		ensure
			target_map_effect: target.map |=| old target.map.extended (path.extended (False), v)
			path_effect: path |=| old path
		end

	extend_right (v: G)
			-- Add a left child with value `v' to the current node.
		require
			not_off: not off
			not_has_right: not has_right
--		local
--			new: V_BINARY_TREE_CELL [G]
		do
--			create new.put (v)
			active.put_right (create {V_BINARY_TREE_CELL [G]}.put (v))
			count_cell.put (count_cell.item + 1)
		ensure
			target_map_effect: target.map |=| old target.map.extended (path.extended (True), v)
			path_effect: path |=| old path
		end

feature -- Removal
	remove
			-- Remove current node (it must have less than two child nodes).
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
			target_map_domain_effect: (old target.map.domain).for_all (agent (x, p: MML_BIT_VECTOR): BOOLEAN
				do
					Result := (not p.is_prefix_of (x) implies target.map.domain [x]) and
						((p.is_prefix_of (x) and not (x |=| p)) implies target.map.domain [x.removed_at (p.count + 1)])
				end (?, old path))
			target_map_domain_constraint: target.map.count = old target.map.count - 1
			target_map_effect: (old target.map.domain).for_all (agent (x, p: MML_BIT_VECTOR; m: MML_FINITE_MAP [MML_BIT_VECTOR, G]): BOOLEAN
				do
					Result := (not p.is_prefix_of (x) implies target.map [x] = m [x]) and
					((p.is_prefix_of (x) and not (x |=| p)) implies target.map [x.removed_at (p.count + 1)] = m [x])
				end (?, old path, old target.map))
			path_effect: path.is_empty
		end

feature {V_CELL_CURSOR, V_INPUT_ITERATOR} -- Implementation
	active: V_BINARY_TREE_CELL [G]
			-- Cell at current position.

feature {NONE} -- Implementation
	count_cell: V_CELL [INTEGER]
			-- Cell where `target's	count is stored.

feature -- Specification
	path: MML_BIT_VECTOR
			-- Path from root to current node.
		note
			status: specification
		local
			old_active: V_BINARY_TREE_CELL [G]
		do
			old_active := active
			from
				create Result.make_with_count (0, 0)
			until
				off
			loop
				if active.is_left then
					Result := Result.prepended (False)
				else
					Result := Result.prepended (True)
				end
				up
			end
			active := old_active
		end

	map: MML_FINITE_MAP [MML_BIT_VECTOR, G]
			-- Map of paths to values in the subtree startin from current node.
		note
			status: specification
		require
			not_off: not off
		do
			create Result.singleton (path, item)
			if has_left then
				left
				Result := Result + map
				up
			end
			if has_right then
				right
				Result := Result + map
				up
			end
		end

invariant
	item_definition: target.map.domain.has (path) implies item = target.map [path]
	off_definition: off = not target.map.domain.has (path)
	is_root_definition: is_root = (path |=| {MML_BIT_VECTOR} [1])
	is_leaf_definition: is_leaf = (target.map.domain.has (path) and
		not target.map.domain.has (path.extended (True)) and not target.map.domain.has (path.extended (False)))
	has_left_definition: has_left = (target.map.domain.has (path) and target.map.domain.has (path.extended (False)))
	has_right_definition: has_right = (target.map.domain.has (path) and target.map.domain.has (path.extended (True)))
end
