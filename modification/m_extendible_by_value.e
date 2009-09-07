note
	description: "Data structures that can be extended with individual elements without specifying, where the element should be put."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_EXTENDIBLE_BY_VALUE [E]

inherit
	M_EXTENDIBLE [E]

feature -- Element change
	extend (v: E)
			-- Extend with `v'
		deferred
		ensure
			added: has (v)
		end
end
