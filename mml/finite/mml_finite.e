note
	description: "Mathematical models with finite representation."
	author: "Nadia polikarpova."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MML_FINITE

inherit
	MML_MODEL

feature -- Comparison
	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
			-- Is this model mathematically equal to `other'?
		deferred
		end
end
