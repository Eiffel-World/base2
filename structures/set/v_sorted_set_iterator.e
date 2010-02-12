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
		redefine
			copy,
			search_forward
		end

create {V_SORTED_SET}
	make_start

feature {NONE} -- Initialization
	make_start (s: V_SORTED_SET [G])
			-- Create an iterator at the start of `s'
		do
			target := s
			tree_iterator := target.tree.at_inorder_start
		ensure
			target_effect: target = s
			index_effect: index = 1
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize with the same `target' and position as in `other'
		do
			if other /= Current then
				target := other.target
				tree_iterator := other.tree_iterator.twin
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

	item: G
			-- Value at current position
		do
			Result := tree_iterator.item
		end

feature -- Measurement		
	index: INTEGER
			-- Current position.
		do
			Result := tree_iterator.index
		end

feature -- Status report
	before: BOOLEAN
			-- Is current position before any position in `target'?
		do
			Result := tree_iterator.before
		end

	after: BOOLEAN
			-- Is current position after any position in `target'?
		do
			Result := tree_iterator.after
		end

	is_first: BOOLEAN
			-- Is cursor at the first position?
		do
			Result := tree_iterator.is_first
		end

	is_last: BOOLEAN
			-- Is cursor at the last position?
		do
			Result := tree_iterator.is_last
		end

feature -- Cursor movement
	start
			-- Go to the first position
		do
			tree_iterator.start
		end

	finish
			-- Go to the last position
		do
			tree_iterator.finish
		end

	forth
			-- Move one position forward
		do
			tree_iterator.forth
		end

	back
			-- Go one position backwards
		do
			tree_iterator.back
		end

	go_before
			-- Go before any position of `target'
		do
			tree_iterator.go_before
		end

	go_after
			-- Go after any position of `target'
		do
			tree_iterator.go_after
		end

	search (v: G)
			-- Move to an element equivalent to `v'
			-- (Use `target.equivalence')
		do
			from
				tree_iterator.go_root
			until
				off or else target.order.equivalent (v, item)
			loop
				if target.order.less_than (v, item) then
					tree_iterator.left
				else
					tree_iterator.right
				end
			end
		end

	search_forward (v: G)
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

feature {V_SORTED_SET, V_SORTED_SET_ITERATOR} -- Implementation
	tree_iterator: V_INORDER_ITERATOR [G]
			-- Iterator over the underlying tree

feature -- Specification
	sequence: MML_FINITE_SEQUENCE [G]
			-- Sequence of values
		note
			status: specification
		do
			Result := tree_iterator.sequence
		end
end
