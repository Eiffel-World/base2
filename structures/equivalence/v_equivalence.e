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

feature -- Model
	relation: MML_RELATION [G, G]
			-- Corresponding matematical relation
		note
			status: model
		do
			Result := create {MML_AGENT_RELATION [G, G]}.such_that (agent equivalent)
		ensure
			definition: Result |=| create {MML_AGENT_RELATION [G, G]}.such_that (agent equivalent)
		end

	is_equivalence (x, y, z: G): BOOLEAN
			-- Does `relation' satisfy equivalence relation properties for arguments `x', `y', `z'?
		note
			status: model_helper
		do
			Result := relation [x, x] and
				relation [x, y] = relation [y, x] and
				(relation [x, y] and relation [y, z] implies relation [x, z])
		ensure
			definition: Result = (relation [x, x] and
				relation [x, y] = relation [y, x] and
				(relation [x, y] and relation [y, z] implies relation [x, z]))
			always: Result
		end
end
