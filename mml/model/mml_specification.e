note
	description: "Objects that use model-based specifications."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_SPECIFICATION

feature -- Comparison
	frozen model_equals (v1, v2: ANY): BOOLEAN
			-- Are `v1' and `v2' mathematically equal?
			-- If they are models use model equality, otherwise reference equality.
			-- For infinite models always true.
		do
			if attached {MML_FINITE} v1 as m1 and attached {MML_FINITE} v2 as m2 then
				Result := m1 |=| m2
			elseif attached {MML_MODEL} v1 as m1 and attached {MML_MODEL} v2 as m2 then
				Result := True
			else
				Result := v1 = v2
			end
		end
	
feature -- Framing
	relevant (x: ANY): BOOLEAN
			-- Always true.
		do
			Result := True
		end
end
