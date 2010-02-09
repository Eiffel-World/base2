note
	description: "Total order relations."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: order

deferred class
	V_TOTAL_ORDER [G]

inherit
	V_EQUIVALENCE [G]
		rename
			relation as equivalence
		end

feature -- Basic operations
	less_than (x, y: G): BOOLEAN
			-- Is `x' < `y'?
		deferred
		ensure
			definition: Result = order [x, y]
		end

	greater_than (x, y: G): BOOLEAN
			-- Is `x' > `y'?
		do
			Result := less_than (y, x)
		ensure
			definition: Result = order [y, x]
		end

	less_equal (x, y: G): BOOLEAN
			-- Is `x' <= `y'?
		do
			Result := not greater_than (x, y)
		ensure
			definition: Result = not order [y, x]
		end

	greater_equal (x, y: G): BOOLEAN
			-- Is `x' >= `y'?
		do
			Result := not less_than (x, y)
		ensure
			definition: Result = not order [x, y]
		end

	equivalent (x, y: G): BOOLEAN
			-- Is `x' equivalent to `y'?
		do
			Result := less_equal (x, y) and greater_equal (x, y)
		end

feature -- Model
	order: MML_RELATION [G, G]
			-- Mathematical relation that corresponds to `less_than'
		note
			status: model
		do
			create {MML_AGENT_RELATION [G, G]} Result.such_that (agent less_than)
		end

	is_order (x, y, z: G): BOOLEAN
			-- Does `order' satisfy order relation properties for arguments `x', `y', `z'?
		note
			status: model_helper
		do
			Result := not order [x, x] and
				order [x, y] = not order [y, x] and
				(order [x, y] and order [y, z] implies order [x, z])
		ensure
			definition: Result = (not order [x, x] and
				order [x, y] = not order [y, x] and
				(order [x, y] and order [y, z] implies order [x, z]))
			always: Result
		end

invariant
	equivalence_definition: equivalence |=| (order.complement * order.inverse.complement)
end
