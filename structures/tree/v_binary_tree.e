note
	description: "Binary trees (doubly linked implementation)."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map

class
	V_BINARY_TREE [G]

inherit
	V_CONTAINER [G]
		rename
			at_start as at_inorder_start
		redefine
			default_create,
			copy,
			is_equal
		end

create
	default_create

feature {NONE} -- Initialization
	default_create
			-- Create an empty tree.
		do
			create count_cell.put (0)
		ensure then
			map_effect: map.is_empty
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
				else
					count_cell.put (0)
				end
				if not other.is_empty then
					i := other.at_root
					add_root (i.item)
					copy_subtree (i, at_root)
				end
			end
		ensure then
			map_effect: map |=| other.map
			other_map_effect: other.map |=| old other.map
		end

feature -- Measurement
	count: INTEGER
			-- Number of elements.
		do
			Result := count_cell.item
		end

feature -- Iteration
	at_root: V_BINARY_TREE_CURSOR [G]
			-- New cursor pointing to the root.
		do
			create Result.make (Current, count_cell)
			Result.go_root
		ensure
			target_definition: Result.target = Current
			path_definition_non_empty: not map.is_empty implies Result.path |=| {MML_BIT_VECTOR} [1]
			path_definition_empty: map.is_empty implies Result.path.is_empty
		end

	at_inorder_start: V_INORDER_ITERATOR [G]
			-- New inorder iterator pointing to the leftmost node.
		do
			create Result.make (Current, count_cell)
			Result.start
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
			definition: Result = (map |=| other.map)
		end

feature -- Extension
	add_root (v: G)
			-- Add a root with value `v' to an empty tree.
		require
			is_empty: is_empty
		do
			create root.put (v)
			count_cell.put (1)
		ensure
			map_effect: map |=| create {like map}.singleton (1, v)
		end

feature -- Removal		
	wipe_out
			-- Remove all elements.
		do
			root := Void
			count_cell.put (0)
		ensure then
			map_effect: map.is_empty
		end

feature {V_BINARY_TREE_CURSOR} -- Implementation
	root: V_BINARY_TREE_CELL [G]
			-- Root node.

	count_cell: V_CELL [INTEGER]
			-- Cell to store count, where it can be updated by iterators.

	copy_subtree (input, output: V_BINARY_TREE_CURSOR [G])
			-- Copy subtree to which `input' points as a subtree of a leaf node, to which `ouput' points.
		require
			input_not_off: not input.off
			output_not_off: not output.off
			output_if_leaf: output.is_leaf
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
			-- Is subtree starting from `i' equal to that starting from `j' both in structure in values?
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

feature -- Specification
	map: MML_FINITE_MAP [MML_BIT_VECTOR, G]
			-- Map of paths to elements.
		note
			status: specification
		do
			if is_empty then
				create Result.empty
			else
				Result := at_root.map
			end
		end

invariant
	bag_domain_definition: bag.domain |=| map.range
	bag_definition: bag.domain.for_all (agent (x: G): BOOLEAN
		do
			Result := bag [x] = map.inverse.image_of (x).count
		end)
end
