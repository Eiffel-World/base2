note
	description: "Dispensers where the earliest added element is accessible."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	V_QUEUE [G]

inherit
	V_DISPENSER [G]
		redefine
			is_equal,
			extend
		end

feature -- Comparison
	is_equal (other: like Current): BOOLEAN
			-- Is queue made of the same values in the same order as `other'?
			-- (Use reference comarison)
		local
			i, j: V_INPUT_ITERATOR [G]
		do
			if other = Current then
				Result := True
			elseif count = other.count then
				from
					Result := True
					i := at_start
					j := other.at_start
				until
					i.off or not Result
				loop
					Result := i.item = j.item
					i.forth
					j.forth
				end
			end
		ensure then
			definition: Result = (sequence |=| other.sequence)
		end

feature -- Extension
	extend (v: G)
			-- Add `v' to the dispenser
		deferred
		ensure then
			sequence_effect: sequence |=| old sequence.extended (v)
		end
end
