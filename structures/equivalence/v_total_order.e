note
	description: "Total order relations."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: order_relation

deferred class
	V_TOTAL_ORDER [G]

inherit
	V_EQUIVALENCE [G]
		rename
			relation as equivalence_relation
		end

feature -- Basic operations
	less_than (x, y: G): BOOLEAN
			-- Is `x' < `y'?
		deferred
		ensure
			definition: Result = order_relation [x, y]
		end

	greater_than (x, y: G): BOOLEAN
			-- Is `x' > `y'?
		do
			Result := less_than (y, x)
		ensure
			definition: Result = order_relation [y, x]
		end

	less_equal (x, y: G): BOOLEAN
			-- Is `x' <= `y'?
		do
			Result := not greater_than (x, y)
		ensure
			definition: Result = not order_relation [y, x]
		end

	greater_equal (x, y: G): BOOLEAN
			-- Is `x' >= `y'?
		do
			Result := not less_than (x, y)
		ensure
			definition: Result = not order_relation [x, y]
		end

	equivalent (x, y: G): BOOLEAN
			-- Is `x' equivalent to `y'?
		do
			Result := less_equal (x, y) and greater_equal (x, y)
		end

feature -- Specification
	order_relation: MML_RELATION [G, G]
			-- Mathematical relation that corresponds to `less_than'
		note
			status: specification
		do
			create {MML_AGENT_RELATION [G, G]} Result.such_that (agent less_than)
		end

	is_order (x, y, z: G): BOOLEAN
			-- Does `order_relation' satisfy order relation properties for arguments `x', `y', `z'?
		note
			status: specification
		do
			Result := not order_relation [x, x] and
				order_relation [x, y] = not order_relation [y, x] and
				(order_relation [x, y] and order_relation [y, z] implies order_relation [x, z])
		ensure
			definition: Result = (not order_relation [x, x] and
				order_relation [x, y] = not order_relation [y, x] and
				(order_relation [x, y] and order_relation [y, z] implies order_relation [x, z]))
			always: Result
		end

invariant
	equivalence_relation_definition: equivalence_relation |=| (order_relation.complement * order_relation.inverse.complement)
end
