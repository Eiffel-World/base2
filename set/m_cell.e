note
	description: "Cells that contain one element."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	M_CELL [E]

inherit
	M_REPLACEABLE_ACTIVE [E]
		rename
			replace as set_item
		end

	M_FINITE_SET [E]
		redefine
			is_empty
		end

create
	default_create, set_item

feature -- Access
	item: E
			-- Content

	has (v: E): BOOLEAN
			-- Is `v' contained?
		do
			Result := item = v
		ensure then
			Result = (item = v)
		end

	is_empty: BOOLEAN is False
			-- Never empty

	count: INTEGER is 1
			-- Number of elements

feature -- Status report
	readable: BOOLEAN is True
			-- Is current element accessable?

	writable: BOOLEAN is True
			-- Can current item be replaced?

feature -- Replacement
	set_item (v: E)
			-- Set item to with `v'
		do
			item := v
		end

	replace_all (v, u: E)
			-- Replace all occurences of `v' with `u'
		do
			if item = v then
				set_item (u)
			end
		end

	fill (v: E)
			-- Replace all elements with `v'
		do
			set_item (v)
		end

feature -- Iterations
	do_if (action: PROCEDURE [ANY, TUPLE [E]]; p: PREDICATE [ANY, TUPLE [E]]) is
			-- Call `action' for elements that satisfy `p'
		do
			if p.item ([item]) then
				action.call ([item])
			end
		end
end
