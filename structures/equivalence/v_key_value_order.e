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
			-- Create key-value order derived from key order `o'
		require
			o_exists: o /= Void
		do
			key_order := o
		end

feature -- Access
	key_order: V_TOTAL_ORDER [K]

feature -- Basic operations
	less_than (x, y: TUPLE [key: K; value: G]): BOOLEAN
			-- Is `x' < `y'?
		do
			Result := key_order.less_than (x.key, y.key)
		end

feature -- Specification
	key_order_relation: MML_RELATION [K, K]
			-- Order relation on keys
		note
			status: specification
		do
			Result := key_order.order_relation
		end

	order_relation_definition (x, y: TUPLE [key: K; value: G]): BOOLEAN
			-- Does `relation' satisfy equivalence relation properties for arguments `x', `y', `z'?
		note
			status: specification
		do
			Result := (order_relation [x, y] = key_order_relation [x.key, y.key])
		ensure
			definition: Result = (order_relation [x, y] = key_order_relation [x.key, y.key])
			always: Result
		end

invariant
	key_order_exists: key_order /= Void
	key_order_order_relation_definition: key_order.order_relation |=| key_order_relation
end
