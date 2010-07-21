note
	description: "[
		Binary tree cells with references to the parent and the left and right child.
		Cells provide a low-level interface and do not ensure neither the consistency of parent and child links, nor the acyclicity property.
		]"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: item, left, right, parent

class
	V_BINARY_TREE_CELL [G]

inherit
	V_CELL [G]

create
	put

feature -- Access
	right: V_BINARY_TREE_CELL [G]
			-- Right child.

	left: V_BINARY_TREE_CELL [G]
			-- Left child.

	parent: V_BINARY_TREE_CELL [G]
			-- Parent.

feature -- Status report
	is_root: BOOLEAN
			-- Does not have parent?
		do
			Result := (parent = Void)
		end

	is_leaf: BOOLEAN
			-- Does not have children?
		do
			Result := (left = Void and right = Void)
		end

	is_left: BOOLEAN
			-- Is the left child of its parent?
		do
			Result := (not is_root and then parent.left = Current)
		end

	is_right: BOOLEAN
			-- Is the right child of its parent?
		do
			Result := (not is_root and then parent.right = Current)
		end

feature -- Replacement
	put_right (r: V_BINARY_TREE_CELL [G])
			-- Set `right' to `r' and `r.parent' to `Current'.
		do
			right := r
			if r /= Void then
				r.simple_put_parent (Current)
			end
		ensure
			right_effect: right = r
			r_parent_effect: r /= Void implies r.parent = Current
		end

	put_left (l: V_BINARY_TREE_CELL [G])
			-- Set `left' to `l' and `l.parent' to `Current'.
		do
			left := l
			if l /= Void then
				l.simple_put_parent (Current)
			end
		ensure
			left_effect: left = l
			l_parent_effect: l /= Void implies l.parent = Current
		end

	simple_put_right (r: V_BINARY_TREE_CELL [G])
			-- Set `right' to `r'.
		do
			right := r
		ensure
			right_effect: right = r
		end

	simple_put_left (l: V_BINARY_TREE_CELL [G])
			-- Set `left' to `l'.
		do
			left := l
		ensure
			left_effect: left = l
		end

	simple_put_parent (p: V_BINARY_TREE_CELL [G])
			-- Set `parent' to `p'.
		do
			parent := p
		ensure
			parent_effect: parent = p
		end

invariant
	is_root_definition: is_root = (parent = Void)
	is_leaf_definition: is_leaf = (left = Void and right = Void)
	is_left_definition: is_left = (parent /= Void and then parent.left = Current)
	is_right_definition: is_right = (parent /= Void and then parent.right = Current)
end
