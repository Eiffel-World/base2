note
	description: "Binary tree cells with references to the parent and the left and right child."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M_BINARY_TREE_CELL [E]

inherit
	M_CELL [E]

create
	set_item

feature -- Access
	right: M_BINARY_TREE_CELL [E]
			-- Rigth child

	left: M_BINARY_TREE_CELL [E]
			-- Left child

	parent: M_BINARY_TREE_CELL [E]
			-- Parent

feature -- Measurement
	subtree_count (node: like Current): INTEGER
			-- Number of nodes in a subtree starting from `node'
		do
			if node = Void then
				Result := 0
			else
				Result := 1 + subtree_count (node.left) + subtree_count (node.right)
			end
		end

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
	set_right (r: M_BINARY_TREE_CELL [E])
			-- Set `right' to `r'; detach `r' from its previous parent; detach previous `right' from Current
		do
			if right /= Void then
				right.simple_set_parent (Void)
			end
			right := r
			if right /= Void then
				right.set_parent (Current)
			end
		ensure
			right_set: right = r
		end

	set_left (l: M_BINARY_TREE_CELL [E])
			-- Set `left' to `l'; detach `l' from its previous parent; detach previous `left' from Current
		do
			if left /= Void then
				left.simple_set_parent (Void)
			end
			left := l
			if left /= Void then
				left.set_parent (Current)
			end
		ensure
			left_set: left = l
		end

feature {M_BINARY_TREE_CELL} -- Implementation
	simple_set_right (r: M_BINARY_TREE_CELL [E])
			-- Set `right' to `r'
		do
			right := r
		ensure
			right_set: right = r
		end

	simple_set_left (l: M_BINARY_TREE_CELL [E])
			-- Set `left' to `l'
		do
			left := l
		ensure
			left_set: left = l
		end

	simple_set_parent (p: M_BINARY_TREE_CELL [E])
			-- Set `parent' to `p'
		do
			parent := p
		ensure
			parent_set: parent = p
		end

	set_parent (p: M_BINARY_TREE_CELL [E])
			-- Set `parent' to `p', detach Current from its previous parent
		do
			if parent /= Void then
				if parent.left = Current then
					parent.simple_set_left (Void)
				else
					parent.simple_set_right (Void)
				end
			end
			parent := p
		ensure
			parent_set: parent = p
		end

invariant
	correct_parent_left: left /= Void implies left.parent = Current
	correct_parent_right: right /= Void implies right.parent = Current
end
