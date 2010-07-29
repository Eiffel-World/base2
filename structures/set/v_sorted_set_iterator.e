note
	description: "Iterators over sorted sets."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, index

class
	V_SORTED_SET_ITERATOR [G]

inherit
	V_SET_ITERATOR [G]
		undefine
			off
		redefine
			copy,
			search_forth,
			search_back
		end

inherit {NONE}
	V_INORDER_ITERATOR [G]
		rename
			target as tree,
			make as make_with_tree,
			remove as tree_remove
		export {V_SORTED_SET, V_SORTED_SET_ITERATOR}
			all
		redefine
			copy,
			search_forth,
			search_back
		end

create {V_SORTED_SET}
	make

feature {NONE} -- Initialization
	make (s: V_SORTED_SET [G]; t: V_BINARY_TREE [G])
			-- Create an iterator over `s'.
			-- (Passing `t' is needed to avoid violating invariant `iterator /= Void' when calling `s.tree')
		require
			s_exists: s /= Void
			valid_tree: t = s.tree
		do
			target := s
			make_with_tree (t)
		ensure
			target_effect: target = s
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize with the same `target' and position as in `other'.
		do
			if other /= Current then
				target := other.target
				tree := other.tree
				active := other.active
				after := other.after
			end
		ensure then
			target_effect: target = other.target
			index_effect: index = other.index
			other_target_effect: other.target = old other.target
			other_index_effect: other.index = old other.index
		end

feature -- Access
	target: V_SORTED_SET [G]
			-- Set to iterate over.

feature -- Cursor movement
	search (v: G)
			-- Move to an element equivalent to `v'.
			-- (Use `target.equivalence'.)
		do
			from
				go_root
			until
				active = Void or else target.order.equivalent (v, item)
			loop
				if target.order.less_than (v, item) then
					left
				else
					right
				end
			end
			if active = Void then
				after := True
			end
		end

	search_forth (v: G)
			-- Move to the first occurrence of `v' starting from current position.
			-- If `v' does not occur, move `off'.
			-- (Use reference equality.)
		do
			if before or (active /= Void and then target.order.greater_than (v, item)) then
				search (v)
			end
			if active /= Void and then v /= item then
				go_after
			end
		end

	search_back (v: G)
			-- Move to the last occurrence of `v' at or before current position.
			-- If `v' does not occur, move `before'.
			-- (Use reference equality.)
		do
			if after or (not off and then target.order.less_than (v, item)) then
				search (v)
			end
			if not off and then v /= item then
				go_before
			end
		end

feature -- Removal
	remove
			-- Remove element at current position. Move cursor to the next position.
		local
			found: V_BINARY_TREE_CELL [G]
		do
			if has_left and has_right then
				found := active
				forth
				found.put (item)
				tree.remove (active)
				active := found
			else
				found := active
				forth
				tree.remove (found)
			end
		end
end
