note
	description: "Mathematical models of any kind."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MML_MODEL

inherit
	MML_SPECIFICATION

feature -- Comparison
---	is_model_equal alias "|=|" (other: MML_MODEL): BOOLEAN
---			-- Is this model mathematically equal to `other'?
---		deferred
---		end	
end
