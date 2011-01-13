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
	greater_equal (x, y: G): BOOLEAN
			-- Is `x' >= `y'?
		deferred
		ensure
			definition: Result = order_relation [x, y]
		end

	less_equal (x, y: G): BOOLEAN
			-- Is `x' <= `y'?
		do
			Result := greater_equal (y, x)
		ensure
			definition: Result = order_relation [y, x]
		end

	greater_than (x, y: G): BOOLEAN
			-- Is `x' > `y'?
		do
			Result := not greater_equal (y, x)
		ensure
			definition: Result = not order_relation [y, x]
		end

	less_than (x, y: G): BOOLEAN
			-- Is `x' < `y'?
		do
			Result := not greater_equal (x, y)
		ensure
			definition: Result = not order_relation [x, y]
		end

	equivalent (x, y: G): BOOLEAN
			-- Is `x' equivalent to `y'?
		do
			Result := less_equal (x, y) and greater_equal (x, y)
		end

feature -- Specification
	order_relation: MML_ENDORELATION [G]
			-- Mathematical relation that corresponds to `greater_equal'.
		note
			status: specification
		do
			create {MML_AGENT_ENDORELATION [G]} Result.such_that (agent greater_equal)
		end

invariant
	--- equivalence_relation_definition: equivalence_relation |=| (order_relation * order_relation.inverse)
	--- order_relation_reflexive: order_relation.reflexive
	--- order_relation_antisymmetric: order_relation.antisymmetric
	--- order_relation_transitive: order_relation.transitive
	--- order_relation_total: order_relation.total
end
