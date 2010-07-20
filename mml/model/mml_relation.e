note
	description: "Relations with possibly infinite domains."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MML_RELATION [G, H]

inherit
	MML_MODEL

feature -- Access
	has alias "[]" (x: G; y: H): BOOLEAN
			-- Is `x' related `y'?
		deferred
		end

	image_of (x: G): MML_SET [H]
			-- The set of values related to `x'
		deferred
		end

feature -- Status report
	is_identity: BOOLEAN
			-- Is this an identity relation?
		do
		end

feature -- Basic operations
	complement: MML_RELATION [G, H]
			-- Relation consisting of all pairs not in `Current'
		deferred
		end

	inverse: MML_RELATION [H, G]
			-- Relation consisting of inverted pairs from `Current'
		deferred
		end

	intersection alias "*" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation consisting of pair contained in both `Current' and `other'
		require
			other_exists: other /= Void
		deferred
		end
end
