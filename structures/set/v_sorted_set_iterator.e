note
	description: "Iterators over sorted sets."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, sequence, index

class
	V_SORTED_SET_ITERATOR [G]

inherit
	V_SET_ITERATOR [G]
		undefine
			off
		redefine
			copy,
			search_forth
		end

inherit {NONE}
	V_INORDER_ITERATOR [G]
		rename
			target as tree,
			make as make_with_tree
		export {V_SORTED_SET, V_SORTED_SET_ITERATOR}
			all
		redefine
			copy,
			search_forth,
			make_with_tree
		end

create {V_SORTED_SET}
	make

feature {NONE} -- Initialization
	make (s: V_SORTED_SET [G]; t: V_BINARY_TREE [G])
			-- Create an iterator over `s'
		require
			s_exists: s /= Void
			valid_tree: t = s.tree
		do
			target := s
			make_with_tree (t, t.count_cell)
		ensure
			target_effect: target = s
		end

	make_with_tree (t: V_BINARY_TREE [G]; cc: V_CELL [INTEGER])
			-- Create iterator over `tree'
		do
			tree := t
			count_cell := cc
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize with the same `target' and position as in `other'
		do
			if other /= Current then
				target := other.target
				tree := other.tree
				active := other.active
				count_cell := tree.count_cell
				after := other.after
			end
		ensure then
			target_effect: target = other.target
			sequence_effect: sequence = other.sequence
			index_effect: index = other.index
			other_target_effect: other.target = old other.target
			other_sequence_effect: other.sequence = old other.sequence
			other_index_effect: other.index = old other.index
		end

feature -- Access
	target: V_SORTED_SET [G]
			-- Set to iterate over

	search (v: G)
			-- Move to an element equivalent to `v'
			-- (Use `target.equivalence')
		do
			from
				go_root
			until
				off or else target.order.equivalent (v, item)
			loop
				if target.order.less_than (v, item) then
					left
				else
					right
				end
			end
			if off then
				after := True
			end
		end

	search_forth (v: G)
			-- Move to the first occurrence of `v' starting from current position
			-- If `v' does not occur, move `off'
			-- (Use refernce equality)
		do
			if v /= item then
				if target.order.less_than (v, item) then
					go_after
				else
					search (v)
					if v /= item then
						go_after
					end
				end
			end
		end
end
