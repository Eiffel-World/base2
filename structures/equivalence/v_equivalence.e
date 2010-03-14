note
	description: "Equivance relations."
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
			-- Corresponding matematical relation.
		note
			status: specification
		do
			Result := create {MML_AGENT_ENDORELATION [G]}.such_that (agent equivalent)
		end

	executable: BOOLEAN
			-- Are model-based contracts for this class executable?
		note
			status: specification
		deferred
		end
invariant
	relation_reflaxive: executable implies relation.reflexive
	relation_symmetric: executable implies relation.symmetric
	relation_transitive: executable implies relation.transitive
end
