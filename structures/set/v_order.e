note
	description: "[
		Internal < order of a COMPARABLE as a two-argument function.
		Void is taken to be the minimal value.
		]"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

class
	V_ORDER [G -> COMPARABLE]

feature -- Basic operations
	less (x, y: G): BOOLEAN
			-- Is `x' < `y'?.
		do
			if x /= Void and y /= Void then
				Result := x < y
			else
				Result := x = Void and y /= Void
			end
		ensure
			definition_non_void: x /= Void and y /= Void implies Result = (x < y)
			definition_x_void: x = Void or y = Void implies Result = (x = Void and y /= Void)
		end

end
