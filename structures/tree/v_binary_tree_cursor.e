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
	make (t: V_BINARY_TREE [G])
			-- Create iterator over `tree'.
		require
			tree_exists: t /= Void
		do
			target := t
		ensure
			target_effect: target = t
			path_effect: path.is_empty
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize with the same `target' and `path' as in `other'.
		do
			target := other.target
			active := other.active
		ensure then
			target_effect: target = other.target
			path_effect: path |=| other.path
			other_target_effect: other.target = old other.target
			other_path_effect: other.path |=| old other.path
		end

feature -- Access
	target: V_BINARY_TREE [G]
			-- Tree to traverse.

feature -- Status report
	is_root: BOOLEAN
			-- Is cursor at root?
		do
			Result := active /= Void and active = target.root
		end

	is_leaf: BOOLEAN
			-- Is cursor at leaf?
		require
			not_off: not off
		do
			Result := active.is_leaf
		end

	has_left: BOOLEAN
			-- Does current node have a left child?
		require
			not_off: not off
		do
			Result := active.left /= Void
		end

	has_right: BOOLEAN
			-- Does current node have a right child?
		require
			no_off: not off
		do
			Result := active.right /= Void
		end

feature -- Comparison
	is_equal (other: like Current): BOOLEAN
			-- Does `other' have the same `target' and `path'?
		do
			Result := target = other.target and (off and other.off or active = other.active)
		ensure then
			definition: Result = (target = other.target and path |=| other.path)
		end

feature -- Cursor movement
	up
			-- Move cursor up to the parent.
		require
			not_off: not off
		do
			active := active.parent
		ensure
			path_effect: path |=| old path.but_last
		end

	left
			-- Move cursor down to the left child.
		require
			not_off: not off
		do
			active := active.left
		ensure
			path_effect_not_off: old (map.domain.has (path.extended (False))) implies path |=| old path.extended (False)
			path_effect_off: not old (map.domain.has (path.extended (False))) implies path.is_empty
		end

	right
			-- Move cursor down to the right child.
		require
			not_off: not off
		do
			active := active.right
		ensure
			path_effect_not_off: old (map.domain.has (path.extended (True))) implies path |=| old path.extended (True)
			path_effect_off: not old (map.domain.has (path.extended (True))) implies path.is_empty
		end

	go_root
			-- Move cursor to the root.
		do
			active := target.root
		ensure
			path_effect_non_empty: not target.map.is_empty implies path |=| {MML_BIT_VECTOR} [True]
			path_effect_empty: target.map.is_empty implies path.is_empty
		end

feature -- Extension
	extend_left (v: G)
			-- Add a left child with value `v' to the current node.
		require
			not_off: not off
			not_has_left: not has_left
		do
			target.extend_left (v, active)
		ensure
			target_map_effect: target.map |=| old target.map.extended (path.extended (False), v)
			path_effect: path |=| old path
		end

	extend_right (v: G)
			-- Add a left child with value `v' to the current node.
		require
			not_off: not off
			not_has_right: not has_right
		do
			target.extend_right (v, active)
		ensure
			target_map_effect: target.map |=| old target.map.extended (path.extended (True), v)
			path_effect: path |=| old path
		end

feature -- Removal
	remove
			-- Remove current node (it must have less than two child nodes). Go off.
		require
			not_off: not off
			not_two_children: not has_left or not has_right
		do
			target.remove (active)
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
	reachable: BOOLEAN
			-- Is `active' part of the target container?
		do
			Result := reachable_from (target.root)
		end

	reachable_from (c: V_BINARY_TREE_CELL [G]): BOOLEAN
			-- Is `active' in subtree with root `c'?
		do
			if c = active then
				Result := True
			elseif c /= Void then
				Result := reachable_from (c.left) or reachable_from (c.right)
			end
		end

feature -- Specification
	path: MML_BIT_VECTOR
			-- Path from root to current node.
		note
			status: specification
		local
			cell: V_BINARY_TREE_CELL [G]
		do
			create Result.empty
			if not off then
				from
					cell := active
				until
					cell = Void
				loop
					if cell.is_left then
						Result := Result.prepended (False)
					else
						Result := Result.prepended (True)
					end
					cell := cell.parent
				end
			end
		end

	map: MML_FINITE_MAP [MML_BIT_VECTOR, G]
			-- Map of paths to values in the subtree starting from current node.
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
	is_root_definition: is_root = (path |=| {MML_BIT_VECTOR} [True])
	is_leaf_definition: target.map.domain.has (path) implies
		is_leaf = (not target.map.domain.has (path.extended (True)) and not target.map.domain.has (path.extended (False)))
	has_left_definition: target.map.domain.has (path) implies has_left = target.map.domain.has (path.extended (False))
	has_right_definition: target.map.domain.has (path) implies has_right = target.map.domain.has (path.extended (True))
end
