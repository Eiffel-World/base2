note
	description: "Tables implemented as sets of key-value pairs."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, relation

deferred class
	V_SET_TABLE [K, V]

inherit
	V_TABLE [K, V]

feature -- Measurement
	count: INTEGER
			-- Number of elements.
		do
			Result := set.count
		end

	has_key (k: K): BOOLEAN
			-- Is any value associated with `k'?
		do
			Result := set.has ([k, default_item])
		end

feature -- Iteration
	new_iterator: V_SET_TABLE_ITERATOR [K, V]
			-- New iterator pointing to a position in the container, from which it can traverse all elements by going `forth'.
		do
			create Result.make_at_start (Current)
		end

	at_key (k: K): V_SET_TABLE_ITERATOR [K, V]
			-- New iterator pointing to a position with key `k'
		do
			create Result.make_at_key (Current, k)
		end

feature -- Extension
	extend (v: V; k: K)
			-- Extend table with key-value pair <`k', `v'>.
		do
			set.extend ([k, v])
		end

feature -- Removal
	remove (k: K)
			-- Remove key `k' and its associated value.
		do
			set.remove ([k, default_item])
		end

	wipe_out
			-- Remove all elements.
		do
			set.wipe_out
		end

feature {V_SET_TABLE, V_SET_TABLE_ITERATOR} -- Implementation
	set: V_SET [TUPLE [key: K; value: V]]
			-- Underlying set of key-value pairs.
			-- Should not be reassigned after creation.
		deferred
		end

invariant
	set_exists: set /= Void
end
