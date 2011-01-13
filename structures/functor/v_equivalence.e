note
	description: "Equivalence relations."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: relation

deferred class
	V_EQUIVALENCE [G]

feature -- Basic operations
	equivalent (x, y: G): BOOLEAN
			-- Is `x' equivalent to `y'?
		deferred
		ensure
			definition: Result = relation [x, y]
		end

feature -- Specification
	relation: MML_ENDORELATION [G]
			-- Corresponding mathematical relation.
		note
			status: specification
		do
			Result := create {MML_AGENT_ENDORELATION [G]}.such_that (agent equivalent)
		end

invariant
	--- relation_reflexive: relation.reflexive
	--- relation_symmetric: relation.symmetric
	--- relation_transitive: relation.transitive
end
