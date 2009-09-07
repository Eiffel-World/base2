note
	description: "Sets implemented as binary serach trees."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M_BINARY_SEARCH_TREE [E -> COMPARABLE]

inherit
	M_SPARSE_SET [E]
		undefine
			hold_count,
			exists
		end

	M_SORTED [E]
		rename
			search as linear_serach
		undefine
			item,
			readable,
			back,
			occurrences
		redefine
			has
		select
			last,
			finish,
			back,
			go_i_th,
			i_th,
			first,
			index,
			index_of,
			start,
			forth
		end

inherit {NONE}
	M_BINARY_TREE [E]
		rename
			inorder_start as start,
			inorder_finish as finish,
			inorder_forth as forth,
			inorder_back as back,
			inorder_index as index
		export {NONE}
			all
		undefine
			occurrences
		redefine
			has
		end

feature -- Access
	has (v: E): BOOLEAN
			-- Is `v' contained?
		do
			search (v)
			Result := not off
		end

feature -- Cursor movement
	search (v: E)
			-- Move cursor to `v' if it is contained, otherwise go off
		do
			from
				go_root
			until
				active = Void or else item ~ v
			loop
				if v < item then
					left
				else
					right
				end
			end
		end

feature -- Element change
	extend (v: E)
			-- Extend with `v'
		local
			is_inserted: BOOLEAN
		do
			if is_empty then
				make_root (v)
			else
				from
					go_root
				until
					is_inserted
				loop
					if v ~ item then
						is_inserted := True
					elseif v < item then
						if active.left = Void then
							extend_left (v)
							is_inserted := True
						else
							left
						end
					else
						if active.right = Void then
							extend_right (v)
							is_inserted := True
						else
							right
						end
					end
				end
			end
		end

	prune (v: E)
			-- Remove `v'
		local
			found: like active
		do
			search (v)
			if not off then
				if active.is_leaf then
					remove
				elseif active.right = Void then
					if is_root then
						root := active.left
						active.set_left (Void)
					else
						active.parent.set_right (active.left)
					end
					count := count - 1
				elseif active.left = Void then
					if is_root then
						root := active.right
						active.set_right (Void)
					else
						active.parent.set_left (active.right)
					end
					count := count - 1
				else
					found := active
					right
					from
					until
						active.left = Void
					loop
						left
					end
					found.set_item (active.item)
					if active.is_left then
						active.parent.set_left (active.right)
					else
						active.parent.set_right (active.right)
					end
					count := count - 1
				end
			end
		end
end
