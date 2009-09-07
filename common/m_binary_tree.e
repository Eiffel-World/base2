note
	description: "Summary description for {M_BINARY_TREE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M_BINARY_TREE [E]

inherit
	M_SEQUENCE [E]
		rename
			start as preorder_start,
			forth as preorder_forth,
			back as preorder_back,
			finish as preorder_finish,
			index as preorder_index,
			i_th as preorder_i_th,
			first as preorder_first,
			last as preorder_last,
			index_of as preorder_index_of,
			go_i_th as preorder_go_i_th,
			search as preorder_search
		undefine
			preorder_go_i_th,
			item,
			readable
		redefine
			preorder_back
--		select
--			preorder_start,
--			preorder_forth,
--			preorder_back,
--			preorder_finish,
--			preorder_index,
--			preorder_i_th,
--			preorder_first,
--			preorder_last,
--			preorder_index_of,
--			preorder_go_i_th,
--			preorder_search
		end

--	M_SEQUENCE [E]
--		rename
--			start as inorder_start,
--			forth as inorder_forth,
--			back as inorder_back,
--			finish as inorder_finish,
--			index as inorder_index,
--			i_th as inorder_i_th,
--			first as inorder_first,
--			last as inorder_last,
--			index_of as inorder_index_of,
--			go_i_th as inorder_go_i_th,
--			search as inorder_search
--		undefine
--			item,
--			readable
--		redefine
--			inorder_back
--		end

	M_REPLACEABLE_ACTIVE [E]

	M_PRUNABLE_ACTIVE [E]

	M_CELLED_SEQUENCE [E]
		rename
			start as preorder_start,
			forth as preorder_forth,
			back as preorder_back,
			finish as preorder_finish,
			index as preorder_index,
			i_th as preorder_i_th,
			first as preorder_first,
			last as preorder_last,
			index_of as preorder_index_of,
			go_i_th as preorder_go_i_th,
			search as preorder_search
		redefine
			active,
			preorder_back
--		select
--			preorder_start,
--			preorder_forth,
--			preorder_back,
--			preorder_index,
--			preorder_i_th,
--			preorder_first,
--			preorder_index_of,
--			preorder_go_i_th,
--			preorder_search
		end

--	M_CELLED_SEQUENCE [E]
--		rename
--			start as inorder_start,
--			forth as inorder_forth,
--			back as inorder_back,
--			index as inorder_index,
--			i_th as inorder_i_th,
--			first as inorder_first,
--			index_of as inorder_index_of,
--			go_i_th as inorder_go_i_th,
--			search as inorder_search
--		redefine
--			active,
--			inorder_back
--		end

create
	default_create, make_root

feature -- Access
	count: INTEGER
			-- Number of elements

	inorder_index: INTEGER
			-- Index of current position
		do
			if active = Void then
				Result := 0
			else
				save_cursor
				from
					Result := 1
					inorder_start
				until
					cursors.item = active
				loop
					Result := Result + 1
					inorder_forth
				end
				restore_cursor
			end
		end

feature -- Status report
	writable: BOOLEAN
			-- Can current item be replaced?
		do
			Result := readable
		end

	is_root: BOOLEAN
			-- Is cursor at root?
		do
			Result := active /= Void and then active.is_root
		end

	is_leaf: BOOLEAN
			-- Is cursor at leaf?
		do
			Result := active /= void and then active.is_leaf
		end

	has_left: BOOLEAN
			-- Does current node have a left child?
		do
			Result := active /= void and then active.left /= Void
		end

	has_right: BOOLEAN
			-- Does current node have a right child?
		do
			Result := active /= void and then active.right /= Void
		end

feature -- Cursor movement
	up is
			-- Move cursor up to the parent
		require
			not_off: readable
		do
			active := active.parent
		end

	left is
			-- Move cursor down to the left child
		require
			not_off: not off
		do
			active := active.left
		ensure
			not_off_if_has_left: old has_left implies not off
		end

	right is
			-- Move cursor down to the right child
		require
			not_off: not off
		do
			active := active.right
		ensure
			not_off_if_has_right: old has_right implies not off
		end

	go_root is
			-- Move cursor to the root
		do
			active := root
		ensure
			is_root
		end


	preorder_start is
			-- Go to the root
		do
			go_root
		end

	preorder_finish
			-- Move current position to the rightmost leaf
		do
			if not is_empty then
				from
					go_root
				until
					active.is_leaf
				loop
					if active.right /= Void then
						right
					else
						left
					end
				end
			end
		end

	preorder_forth
			-- Move current position to the next element in preorder
		do
			if active.is_leaf then
				from
				until
					off or else (active.is_left and active.parent.right /= Void)
				loop
					up
				end
				if not off then
					up
					right
				end
			elseif active.left /= Void then
				left
			else
				right
			end
		end

	preorder_back
			-- Move current position to the previous element in preorder
		do
			if active.is_right and then active.parent.left /= Void then
				up
				left
				from
				until
					active.is_leaf
				loop
					if active.right /= Void then
						right
					else
						left
					end
				end
			else
				up
			end
		end

	inorder_start is
			-- Go to the root
		do
			if not is_empty then
				from
					go_root
				until
					active.left = Void
				loop
					left
				end
			end
		end

	inorder_finish
			-- Go to root
		do
			if not is_empty then
				from
					go_root
				until
					active.right = Void
				loop
					right
				end
			end
		end

	inorder_forth
			-- Move current position to the next element in preorder
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
		end

	inorder_back
			-- Move current position to the previous element in preorder
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

feature -- Replacement
	replace (v: E)
			-- Replace current element with `v'
		do
			active.set_item (v)
		end

	replace_all (v, u: E)
			-- Replace all occurences of `v' with `u'
		do
			from
				preorder_start
				preorder_search (v)
			until
				off
			loop
				replace (u)
				preorder_search (v)
			end
		end

	fill (v: E)
			-- Replace all elements with `v'
		do
			from
				preorder_start
			until
				off
			loop
				replace (v)
				preorder_forth
			end
		end

feature -- Element change
	make_root (v: E)
			-- Add a route to an empty tree with value `v'
		require
			is_empty: is_empty
		do
			create root.set_item (v)
			count := 1
		ensure
			not_empty: not is_empty
		end

	extend_left (v: E)
			-- Add a left child with value `v' to the current node
		require
			not_off: not off
			not_has_left: not has_left
		do
			active.set_left (create {M_BINARY_TREE_CELL [E]}.set_item (v))
			count := count + 1
		ensure
			has_left: has_left
		end

	extend_right (v: E)
			-- Add a left child with value `v' to the current node
		require
			not_off: not off
			not_has_right: not has_right
		do
			active.set_right (create {M_BINARY_TREE_CELL [E]}.set_item (v))
			count := count + 1
		ensure
			has_right: has_right
		end

	remove
			-- Remove subtree starting from current element
		do
			count := count - active.subtree_count (active)
			if is_root then
				root := Void
			elseif active.is_left then
				active.parent.set_left (Void)
			else
				active.parent.set_right (Void)
			end
			active := Void
		end

	wipe_out
			-- Prune of all elements
		do
			root := Void
			active := Void
			count := 0
		end

feature -- Implementation
	root: M_BINARY_TREE_CELL [E]

	active: like root

invariant
	not_root_if_off: off implies not is_root
	not_leaf_if_off: off implies not is_leaf
	not_has_left_if_off: off implies not has_left
	not_has_right_if_off: off implies not has_right
	leaf_if_no_children: not off implies (is_leaf = (not has_left and not has_right))
	correct_count: count = 0 or else count = root.subtree_count (root)
end
