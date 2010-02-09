note
	description: "Iterators to traverse binary trees in order left subtree - root - right subtree."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, sequence, index

class
	V_INORDER_ITERATOR [G]

inherit
	V_ITERATOR [G]
		undefine
			off
		end

inherit {NONE}
	V_BINARY_TREE_CURSOR [G]
		export {NONE}
			all
		undefine
			is_equal
		end

create {V_CONTAINER}
	make,
	make_from_cursor

feature {NONE} -- Initialization
	make_from_cursor (c: V_BINARY_TREE_CURSOR [G])
			-- Create iterator pointing to the same node as `cursor'
		require
			c_exists: c /= Void
		do
			target := c.target
			active := c.active
			count_cell := target.count_cell
		ensure
			target_effect: target = c.target
			active_effect: active = c.active
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
	start is
			-- Go to the root
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
			-- Go to root
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
			if active = Void then
				after := True
			end
		end

	back
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

	go_before
			-- Go before any position of `target'
		do
			active := Void
			after := False
		end

	go_after
			-- Go after any position of `target'
		do
			active := Void
			after := True
		end

feature -- Model
	sequence: MML_FINITE_SEQUENCE [G]
		note
			status: model
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
end
