note
	description: "Containers that can be extended with values and make only one element accessible at a time."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: sequence

deferred class
	V_DISPENSER [G]

inherit
	V_CONTAINER [G]

feature -- Access
	item: G
			-- The accessible element.
		require
			not_empty: not is_empty
		deferred
		end

feature -- Iteration
	new_iterator: V_ITERATOR [G]
			-- New iterator pointing to the accessible element.
			-- (Traversal in the order of accessibility.)
		deferred
		ensure then
			sequence_definition: Result.sequence |=| sequence
		end

feature -- Extension
	extend (v: G)
			-- Add `v' to the dispenser.
		deferred
		ensure
			sequence_effect: bag |=| old (bag & v)
		end

feature -- Removal
	remove
			-- Remove the accessible element.
		require
			not_empty: not is_empty
		deferred
		ensure
			sequence_effect: sequence |=| old sequence.but_first
		end

	wipe_out
			-- Remove all elements.
		deferred
		ensure
			sequence_effect: sequence.is_empty
		end

feature -- Specification
	sequence: MML_SEQUENCE [G]
			-- Sequence of elements in the order of access.
		note
			status: specification
		do
			Result := new_iterator.sequence
		ensure
			exists: Result /= Void
		end

invariant
	item_definition: not sequence.is_empty implies item = sequence.first
	bag_domain_definition: bag.domain |=| sequence.range
	bag_definition: bag.domain.for_all (agent (x: G): BOOLEAN
		do
			Result := bag [x] = sequence.occurrences (x)
		end)
end
