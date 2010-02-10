note
	description: "Iterators to read from and update sorted tables."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: target, key_sequence, index

class
	V_SORTED_TABLE_ITERATOR [K, G]

inherit
	V_TABLE_ITERATOR [K, G]

create {V_SORTED_TABLE}
	make_start,
	make_from_tree_iterator

feature {NONE} -- Initialization
	make_start (t: V_SORTED_TABLE [K, G])
			-- Create an iterator at the start of `t'
		do
			target := t
			tree_iterator := target.search_tree.at_start
		ensure
			target_effect: target = t
			index_effect: index = 1
		end

	make_from_tree_iterator (t: V_SORTED_TABLE [K, G]; it: V_INORDER_ITERATOR [TUPLE [key: K; value: G]])
			-- Create iterator pointing to the same node as `cursor'
		require
			t_exists: t /= Void
			it_exists: it /= Void
--			valid_target: t.search_tree.tree = it.target
		do
			target := t
			tree_iterator := it
		ensure
			target_effect: target = t
			index_effect: index = it.index
		end

feature -- Access
	target: V_SORTED_TABLE [K, G]
			-- Container to iterate over

	key: K
			-- Key at current position
		do
			Result := tree_iterator.item.key
		end

	value: G
			-- Value at current position
		do
			Result := tree_iterator.item.value
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

--	search_key (k: K)
--			-- Go to a position where key is equivalent to `k'
--			-- If `k' does not appear, go off
--		do
--			
--		end

feature -- Replacement
	put (v: G)
			-- Replace item at current position with `v'
		do
			target.put (key, v)
		ensure then
			target_map_effect: target.map |=| old target.map.replaced_at (key_sequence [index], v)
		end

feature {NONE} -- Implementation
	tree_iterator: V_INORDER_ITERATOR [TUPLE [key: K; value: G]]

feature -- Specification
	key_sequence: MML_FINITE_SEQUENCE [K]
			-- Sequence of keys
		note
			status: specification
		local
			pair_sequence: MML_FINITE_SEQUENCE [TUPLE [key: K; value: G]]
			i: INTEGER
		do
			create Result.empty
			pair_sequence := tree_iterator.sequence
			from
				i := 1
			until
				i > pair_sequence.count
			loop
				Result := Result.extended (pair_sequence.item (i).key)
				i := i + 1
			end
		end

	value_sequence: MML_FINITE_SEQUENCE [G]
			-- Sequence of values
		note
			status: specification
		local
			pair_sequence: MML_FINITE_SEQUENCE [TUPLE [key: K; value: G]]
			i: INTEGER
		do
			create Result.empty
			pair_sequence := tree_iterator.sequence
			from
				i := 1
			until
				i > pair_sequence.count
			loop
				Result := Result.extended (pair_sequence.item (i).value)
				i := i + 1
			end
		end
end
