note
	description: "Discrete resizable intervals."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M_INTEGER_INTERVAL

inherit
	M_INTERVAL [INTEGER]

	M_FINITE_SET [INTEGER]
		undefine
			is_empty
		end

create
	set_bounds, wipe_out

feature -- Access
	count: INTEGER
			-- Number of elements
		do
			if not is_empty then
				Result := upper - lower + 1
			end
		end

feature -- Iteration
	do_if (action: PROCEDURE [ANY, TUPLE [INTEGER]]; p: PREDICATE [ANY, TUPLE [INTEGER]]) is
			-- Call `action' for elements that satisfy `p'
		local
			i: INTEGER
		do
			if not is_empty then
				from
					i := lower
				until
					i > upper
				loop
					if p.item ([i]) then
						action.call ([i])
					end
					i := i + 1
				end
			end
		end
end
