note
	description: "Hash function on key-value pairs derived from an hash function on keys."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: key_map

class
	V_KEY_VALUE_HASH [K, V]

inherit
	V_HASH [TUPLE [key: K; value: V]]

create
	make

feature {NONE} -- Initialization
	make (h: V_HASH [K])
			-- Create hash function on key-value pairs derived from hash function on keys `h'.
		require
			h_exists: h /= Void
		do
			key_hash := h
		ensure
			key_map_effect: key_map |=| h.map
		end

feature -- Access
	key_hash: V_HASH [K]
			-- Hash function on keys.

feature -- Basic operations
	item (v: TUPLE [key: K; value: V]): INTEGER
			-- Hash value of `v'.
		do
			Result := key_hash.item (v.key)
		end

feature -- Specification
	key_map: MML_MAP [K, INTEGER]
			-- Mathematical map from keys to hash codes.
		note
			status: specification
		do
			Result := key_hash.map
		end

	map: MML_MAP [TUPLE [key: K; value: V], INTEGER]
			-- Mathematical map from key-value pairs to hash codes.
		note
			status: specification
		do
			create {MML_AGENT_MAP [TUPLE [key: K; value: V], INTEGER]} Result.from_function (agent (x: TUPLE [key: K; value: V]): INTEGER
				do
					Result := key_map [x.key]
				end)
		end
end
