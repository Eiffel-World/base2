note
	description: "Binary trees (doubly linked implementation)."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: bag--map

class
	V_BINARY_TREE [G]

inherit
	V_CONTAINER [G]
		redefine
			default_create,
			copy,
			is_equal
		end

create
	default_create

feature {NONE} -- Initialization
	default_create
			-- Create an empty tree
		do
			create count_cell.put (0)
		ensure then
			bag_effect: bag.is_empty
--			map_effect: map.is_empty
		end

feature -- Initialization
	copy (other: like Current)
			-- Copy values and structure from `other'.
		local
			i: V_BINARY_TREE_CURSOR [G]
		do
			if other /= Current then
				root := Void
				if count_cell = Void then
					create count_cell.put (0)
				end
				if not other.is_empty then
					i := other.at_root
					add_root (i.item)
					copy_subtree (i, at_root)
				end
			end
		ensure then
			bag_effect: bag |=| other.bag
			other_bag_effect: other.bag |=| old other.bag
		end

feature -- Measurement
	count: INTEGER
			-- Number of elements
		do
			Result := count_cell.item
		end

feature -- Iteration
	at_root: V_BINARY_TREE_CURSOR [G]
			-- New cursor pointing to the root
		do
			create Result.make (Current)
			Result.go_root
		ensure
			target_definition: Result.target = Current
			active_definition: Result.active = root
		end

	at_start: V_INORDER_ITERATOR [G]
			-- New inorder iterator pointing to the leftmost node
		do
			create Result.make (Current)
			Result.start
		end

	at_finish: like at_start
			-- New inorder iterator pointing to the rightmost node
		do
			create Result.make (Current)
			Result.finish
		end

	at (i: INTEGER): like at_start
			-- New inorder iterator poiting at `i'-th position
		do
			create Result.make (Current)
			Result.go_to (i)
		end

feature -- Comparison
	is_equal (other: like Current): BOOLEAN
			-- Does `other' has the same structure and contain the same objects?
		do
			if is_empty and other.is_empty then
				Result := True
			elseif count = other.count then
				Result := equal_subtree (at_root, other.at_root)
			end
		ensure then
			definition: Result implies bag |=| other.bag -- ToDo: incomplete!
		end

feature -- Extension
	add_root (v: G)
			-- Add a route with value `v' to an empty tree
		require
			is_empty: is_empty
		do
			create root.put (v)
			count_cell.put (1)
		ensure
			bag_effect: bag |=| old bag.extended (v)
--			map_domain_count_effect: map.domain.count = 1
--			map_domain_content_effect: map.domain [create {MML_FINITE_SEQUENCE [BOOLEAN]}.empty]
--			map_effect: map [create {MML_FINITE_SEQUENCE [BOOLEAN]}.empty] = v
		end

feature -- Removal		
	wipe_out
			-- Remove all elements
		do
			root := Void
			count_cell.put (0)
--		ensure then
--			map_effect: map.is_empty
		end

feature {V_BINARY_TREE_CURSOR} -- Implementation
	root: V_BINARY_TREE_CELL [G]
			-- Root node

	count_cell: V_CELL [INTEGER]
			-- Cell to store count, where it can be updated by iterators

	copy_subtree (input, output: V_BINARY_TREE_CURSOR [G])
			--
		require
			input_not_off: not input.off
			output_not_off: not output.off
		do
			if input.has_left then
				input.left
				output.extend_left (input.item)
				output.left
				copy_subtree (input, output)
				input.up
				output.up
			end
			if input.has_right then
				input.right
				output.extend_right (input.item)
				output.right
				copy_subtree (input, output)
				input.up
				output.up
			end
		end

	equal_subtree (i, j: V_BINARY_TREE_CURSOR [G]): BOOLEAN
			--
		require
			i_not_off: not i.off
			j_not_off: not j.off
		do
			if i.item = j.item then
				if i.has_left and j.has_left then
					i.left
					j.left
					Result := equal_subtree (i, j)
					i.up
					j.up
				elseif not i.has_left and not j.has_left then
					Result := True
				else
					Result := False
				end
				if Result then
					if i.has_right and j.has_right then
						i.right
						j.right
						Result := equal_subtree (i, j)
						i.up
						j.up
					elseif not i.has_right and not j.has_right then
						Result := True
					else
						Result := False
					end
				end
			end
		end

--feature -- Model
--	map: MML_FINITE_MAP [MML_FINITE_SEQUENCE [BOOLEAN], G]
--			-- Map of tree positions to elements
--		do

--		end
end
