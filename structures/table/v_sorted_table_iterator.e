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
		redefine
			copy
		end

create {V_SORTED_TABLE}
	make_start

feature {NONE} -- Initialization
	make_start (t: V_SORTED_TABLE [K, G])
			-- Create an iterator at the start of `t'
		do
			target := t
			set_iterator := target.set.at_start
		ensure
			target_effect: target = t
			index_effect: index = 1
		end

feature -- Initialization
	copy (other: like Current)
			-- Initialize with the same `target' and position as in `other'
		do
			if other /= Current then
				target := other.target
				set_iterator := other.set_iterator.twin
			end
		ensure then
			target_effect: target = other.target
			key_sequence_effect: key_sequence = other.key_sequence
			index_effect: index = other.index
			other_target_effect: other.target = old other.target
			other_key_sequence_effect: other.key_sequence = old other.key_sequence
			other_index_effect: other.index = old other.index
		end

feature -- Access
	target: V_SORTED_TABLE [K, G]
			-- Container to iterate over

	key: K
			-- Key at current position
		do
			Result := set_iterator.item.key
		end

	value: G
			-- Value at current position
		do
			Result := set_iterator.item.value
		end

feature -- Measurement		
	index: INTEGER
			-- Current position.
		do
			Result := set_iterator.index
		end

feature -- Status report
	before: BOOLEAN
			-- Is current position before any position in `target'?
		do
			Result := set_iterator.before
		end

	after: BOOLEAN
			-- Is current position after any position in `target'?
		do
			Result := set_iterator.after
		end

	is_first: BOOLEAN
			-- Is cursor at the first position?
		do
			Result := set_iterator.is_first
		end

	is_last: BOOLEAN
			-- Is cursor at the last position?
		do
			Result := set_iterator.is_last
		end

feature -- Cursor movement
	start
			-- Go to the first position
		do
			set_iterator.start
		end

	finish
			-- Go to the last position
		do
			set_iterator.finish
		end

	forth
			-- Move one position forward
		do
			set_iterator.forth
		end

	back
			-- Go one position backwards
		do
			set_iterator.back
		end

	go_before
			-- Go before any position of `target'
		do
			set_iterator.go_before
		end

	go_after
			-- Go after any position of `target'
		do
			set_iterator.go_after
		end

	search_key (k: K)
			-- Move to a position where key is equivalent to `k'.
			-- If `k' does not appear, go off.
			-- (Use `target.key_equivalence')
		do
			set_iterator.search ([k, default_item])
		end

feature -- Replacement
	put (v: G)
			-- Replace item at current position with `v'
		do
			set_iterator.item.value := v
		ensure then
			target_map_effect: target.map |=| old target.map.replaced_at (key_sequence [index], v)
		end

feature {V_SORTED_TABLE_ITERATOR} -- Implementation
	set_iterator: V_SORTED_SET_ITERATOR [TUPLE [key: K; value: G]]
			-- Iterator over the underlying set

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
			pair_sequence := set_iterator.sequence
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
			pair_sequence := set_iterator.sequence
			from
				i := 1
			until
				i > pair_sequence.count
			loop
				Result := Result.extended (pair_sequence.item (i).value)
				i := i + 1
			end
		end

	default_item: G
			-- Default value of type `G'
		note
			status: specification
		do
		end
end
