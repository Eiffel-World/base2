note
	description: "Iterators to traverse binary trees in order left subtree - root - right subtree."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, path, after

class
	V_INORDER_ITERATOR [G]

inherit
	V_ITERATOR [G]
		undefine
			off
		redefine
			copy
		end

	V_BINARY_TREE_CURSOR [G]
		undefine
			is_equal
		redefine
			copy,
			go_root,
			make
		end

create {V_CONTAINER}
	make

feature {NONE} -- Initialization
	make (tree: V_BINARY_TREE [G]; cc: V_CELL [INTEGER])
			-- Create iterator over `tree'
		do
			Precursor (tree, cc)
		ensure then
			after_effect: not after
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize with the same `target' and position as in `other'
		do
			Precursor {V_BINARY_TREE_CURSOR} (other)
			after := other.after
		ensure then
			sequence_effect: sequence |=| other.sequence
			path_effect: path |=| other.path
			after_effect: after = other.after
			other_sequence_effect: other.sequence |=| old other.sequence
			other_path_effect: other.path |=| old other.path
			other_after_effect: other.after = old other.after
		end

feature -- Measurement
	index: INTEGER
			-- Index of current position
		local
			old_active: V_BINARY_TREE_CELL [G]
			old_after: BOOLEAN
		do
			if after then
				Result := count_cell.item + 1
			elseif not off then
				old_active := active
				old_after := after
				from
					start
					Result := 1
				until
					active = old_active
				loop
					forth
					Result := Result + 1
				end
				active := old_active
				after := old_after
			end
		end

feature -- Status report		
	is_first: BOOLEAN
			-- Is cursor at the first position?
		local
			old_active: V_BINARY_TREE_CELL [G]
			old_after: BOOLEAN
		do
			if not off then
				old_active := active
				old_after := after
				start
				Result := active = old_active
				active := old_active
				after := old_after
			end
		end

	is_last: BOOLEAN
			-- Is cursor at the last position?
		local
			old_active: V_BINARY_TREE_CELL [G]
			old_after: BOOLEAN
		do
			if not off then
				old_active := active
				old_after := after
				finish
				Result := active = old_active
				active := old_active
				after := old_after
			end
		end

	after: BOOLEAN
			-- Is current position after the last container position?

	before: BOOLEAN
			-- Is current position before the first container position?
		do
			Result := off and not after
		end

feature -- Cursor movement
	go_root is
			-- Move cursor to the root
		do
			Precursor
			if not target.is_empty then
				after := False
			else
				after := True
			end
		ensure then
			after_effect_nonemtpy: not target.map.is_empty implies not after
			after_effect_empty: target.map.is_empty implies after
		end

	start is
			-- Move cursor to the leftmost node
		do
			if not target.is_empty then
				from
					go_root
				until
					active.left = Void
				loop
					left
				end
				after := False
			else
				after := True
			end
		end

	finish
			-- Move cursor to the rightmost node
		do
			if not target.is_empty then
				from
					go_root
				until
					active.right = Void
				loop
					right
				end
			end
			after := False
		end

	forth
			-- Move cursor to the next element in inorder
		do
			if active.right /= Void then
				right
				from
				until
					active.left = Void
				loop
					left
				end
			else
				from
				until
					active.is_root or active.is_left
				loop
					up
				end
				up
			end
			if active = Void then
				after := True
			end
		end

	back
			-- Move cursor to the previous element in inorder
		do
			if active.left /= Void then
				left
				from
				until
					active.right = Void
				loop
					right
				end
			else
				from
				until
					active.is_root or active.is_right
				loop
					up
				end
				up
			end
		end

	go_before
			-- Move cursor before any position of `target'
		do
			active := Void
			after := False
		end

	go_after
			-- Move cursor after any position of `target'
		do
			active := Void
			after := True
		end

feature -- Specification
	sequence: MML_FINITE_SEQUENCE [G]
			-- Sequence of elements
		note
			status: specification
		local
			old_active: V_BINARY_TREE_CELL [G]
			old_after: BOOLEAN
		do
			old_active := active
			old_after := after
			create Result.empty
			from
				start
			until
				off
			loop
				Result := Result.extended (item)
				forth
			end
			active := old_active
			after := old_after
		end

	subtree_sequence (m: MML_FINITE_MAP [MML_BIT_VECTOR, G]; root: MML_BIT_VECTOR): MML_FINITE_SEQUENCE [G]
			-- Inorder sequence of values in a subtree of `m' starting from `root'
		note
			status: specification
		do
			if not m.domain [root] then
				create Result.empty
			else
				Result := subtree_sequence (m, root.extended (False)).extended (m [root]) + subtree_sequence (m, root.extended (True))
			end
		ensure
			definition_base: not m.domain [root] implies Result.is_empty
			definition_step: m.domain [root] implies
				Result = subtree_sequence (m, root.extended (False)).extended (m [root]) + subtree_sequence (m, root.extended (True))
		end

	predecessor (m: MML_FINITE_MAP [MML_BIT_VECTOR, G]; node: MML_BIT_VECTOR): MML_BIT_VECTOR
			-- Predecessor of `node' in inorder
		note
			status: specification
		do
			if not m.domain [node.extended (False)] then
				if node [node.count] then
					Result := node.but_last
				else
					Result := node.front (node.last_index_of (True) - 1)
				end
			else
				from
					Result := node.extended (False)
				until
					not m.domain [Result]
				loop
					Result := Result.extended (True)
				end
				Result := Result.but_last
			end
		ensure
			definition_has_left: m.domain [node.extended (False)] implies
				node.extended (False).is_prefix_of (Result) and
				not m.domain [Result.extended (True)] and
				Result.tail (node.count + 2).is_constant (True)
			definition_not_has_left_is_right: not m.domain [node.extended (False)] and node [node.count] implies
				Result |=| node.but_last
			definition_not_has_left_is_left: not m.domain [node.extended (False)] and not node [node.count] implies
				Result |=| node.front (node.last_index_of (True) - 1)
		end

	node_index (m: MML_FINITE_MAP [MML_BIT_VECTOR, G]; node: MML_BIT_VECTOR): INTEGER
			-- Index of `node' in inorder
		do
			if m.domain [node] then
				 Result := node_index (m, predecessor (m, node)) + 1
			end
		ensure
			definition_base: not m.domain [node] implies Result = 0
			definition_step: m.domain [node] implies Result = node_index (m, predecessor (m, node)) + 1
		end

invariant
	sequence_definition: sequence |=| subtree_sequence (target.map, {MML_BIT_VECTOR} [1])
	index_definition_not_after: not after implies index = node_index (target.map, path)
	index_definition_afetr: after implies index = target.map.count + 1
end
