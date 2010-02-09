note
	description: "Binary tree cells with references to the parent and the left and right child."
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
			-- Rigth child

	left: V_BINARY_TREE_CELL [G]
			-- Left child

	parent: V_BINARY_TREE_CELL [G]
			-- Parent

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
			-- Set `right' to `r'; detach `r' from its previous parent; detach previous `right' from Current
		do
			if right /= Void then
				right.simple_put_parent (Void)
			end
			right := r
			if right /= Void then
				right.put_parent (Current)
			end
		ensure
			old_right_parent_effect: old right /= Void implies (old right).parent = Void
			right_effect: right = r
			r_parent_effect: r /= Void implies r.parent = Current
		end

	put_left (l: V_BINARY_TREE_CELL [G])
			-- Set `left' to `l'; detach `l' from its previous parent; detach previous `left' from Current
		do
			if left /= Void then
				left.simple_put_parent (Void)
			end
			left := l
			if left /= Void then
				left.put_parent (Current)
			end
		ensure
			old_left_parent_effect: old left /= Void implies (old left).parent = Void
			left_effect: left = l
			l_parent_effect: l /= Void implies l.parent = Current
		end

feature {V_BINARY_TREE_CELL} -- Implementation
	simple_put_right (r: V_BINARY_TREE_CELL [G])
			-- Set `right' to `r'
		do
			right := r
		ensure
			right_effect: right = r
		end

	simple_put_left (l: V_BINARY_TREE_CELL [G])
			-- Set `left' to `l'
		do
			left := l
		ensure
			left_effect: left = l
		end

	simple_put_parent (p: V_BINARY_TREE_CELL [G])
			-- Set `parent' to `p'
		do
			parent := p
		ensure
			parent_effect: parent = p
		end

	put_parent (p: V_BINARY_TREE_CELL [G])
			-- Set `parent' to `p', detach Current from its previous parent
		do
			if parent /= Void then
				if parent.left = Current then
					parent.simple_put_left (Void)
				else
					parent.simple_put_right (Void)
				end
			end
			parent := p
		ensure
			old_parent_children_effect: old parent /= Void implies (old parent).left /= Current and (old parent).right /= Current
			parent_effect: parent = p
		end

invariant
	is_root_definition: is_root = (parent = Void)
	is_leaf_definition: is_leaf = (left = Void and right = Void)
	is_left_definition: is_left = (parent /= Void and then parent.left = Current)
	is_right_definition: is_right = (parent /= Void and then parent.right = Current)
	left_constraint: left /= Void implies left.parent = Current
	right_constraint: right /= Void implies right.parent = Current
end
