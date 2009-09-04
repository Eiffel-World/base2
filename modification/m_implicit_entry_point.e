note
	description: "Data structures that can be extended with individual elements without specifying, where the element should be put."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	M_IMPLICIT_ENTRY_POINT [E]

inherit
	M_SPARSE_EXTENDIBLE [E]

feature -- Element change
	extend (v: E)
			-- Extend with `v'
		require
			not_full: not full
		deferred
		ensure
			added: has (v)
		end
end
