note
	description: "Equivalence relation on key-value pairs derived from an equivalence relation on keys."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: key_equivalence_relation

class
	V_KEY_VALUE_EQUIVALENCE [K, V]

inherit
	V_EQUIVALENCE [TUPLE [key: K; value: V]]

create
	make

feature {NONE} -- Initialization
	make (eq: V_EQUIVALENCE [K])
			-- Create key-value equivalence derived from key equivalence `eq'.
		require
			eq_exists: eq /= Void
		do
			key_equivalence := eq
		ensure
			key_equivalence_relation_effect: executable implies
				key_equivalence_relation |=| eq.relation
		end

feature -- Access
	key_equivalence: V_EQUIVALENCE [K]
			-- Equivalence on keys.

feature -- Basic operations
	equivalent (x, y: TUPLE [key: K; value: V]): BOOLEAN
			-- Is `x' equivalent to `y'?
		do
			Result := key_equivalence.equivalent (x.key, y.key)
		end

feature -- Specification
	key_equivalence_relation: MML_ENDORELATION [K]
			-- Equivalence relation on keys.
		note
			status: specification
		do
			Result := key_equivalence.relation
		end

	executable: BOOLEAN = False
			-- Are model-based contracts for this class executable?

invariant
	key_equivalence_exists: key_equivalence /= Void
	key_equivalence_relation_definition: executable implies key_equivalence.relation |=| key_equivalence_relation
	relation_definition: executable implies relation |=|
		create {MML_AGENT_ENDORELATION [TUPLE [key: K; value: V]]}.such_that (agent (x, y: TUPLE [key: K; value: V]): BOOLEAN
		do
			Result := key_equivalence_relation [x.key, y.key]
		end)
end
