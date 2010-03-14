note
	description: "Total order relation on key-value pairs derived from a total relation on keys."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: key_order_relation

class
	V_KEY_VALUE_ORDER [K, G]

inherit
	V_TOTAL_ORDER [TUPLE [key: K; value: G]]

create
	make

feature {NONE} -- Initialization
	make (o: V_TOTAL_ORDER [K])
			-- Create key-value order derived from key order `o'.
		require
			o_exists: o /= Void
		do
			key_order := o
		ensure
			key_order_relation_effect: executable implies
				key_order_relation |=| o.order_relation
		end

feature -- Access
	key_order: V_TOTAL_ORDER [K]

feature -- Basic operations
	greater_equal (x, y: TUPLE [key: K; value: G]): BOOLEAN
			-- Is `x' >= `y'?
		do
			Result := key_order.greater_equal (x.key, y.key)
		end

feature -- Specification
	key_order_relation: MML_RELATION [K, K]
			-- Order relation on keys.
		note
			status: specification
		do
			Result := key_order.order_relation
		end

	executable: BOOLEAN = False
			-- Are model-based contracts for this class executable?		

invariant
	key_order_exists: key_order /= Void
	key_order_order_relation_definition: executable implies key_order.order_relation |=| key_order_relation
	order_relation_definition: executable implies order_relation |=|
		create {MML_AGENT_ENDORELATION [TUPLE [key: K; value: G]]}.such_that (agent (x, y: TUPLE [key: K; value: G]): BOOLEAN
		do
			Result := key_order_relation [x.key, y.key]
		end)
end
