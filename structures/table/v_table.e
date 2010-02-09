note
	description: "Finite maps where key-value pairs can be added and removed. Keys are unique with respect to key_equivalenvce"
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: map, relation

deferred class
	V_TABLE [K, G]

inherit
	V_UPDATABLE_MAP [K, G]

	V_CONTAINER [G]

feature -- Initialization
	make (key_eq: V_EQUIVALENCE [K])
			-- Create an empty table with key equivalence relation `key_eq'
		require
			key_eq_exists: key_eq /= Void
		deferred
		ensure
			map_effect: map.is_empty
			relation_effect: relation |=| key_eq.relation
		end

	make_reference_equality
			-- Create an empty table with key equivalence based on reference equality
		deferred
		ensure
			map_effect: map.is_empty
			relation_effect: relation |=| create {MML_IDENTITY [G]}
		end

	make_object_equality
			-- Create an empty table with key equivalence based on object equality
		deferred
		ensure
			map_effect: map.is_empty
			relation_effect: relation |=| create {MML_AGENT_RELATION [G, G]}.such_that (agent (x, y: G): BOOLEAN do Result := x ~ y end)
		end

feature -- Measurement
	key_equivalence: V_EQUIVALENCE [K]
			-- Equivalence relation on keys

feature -- Iteration
	start: V_TABLE_ITERATOR [K, G]
			-- New iterator pointing to start position of the table
		deferred
		end

feature -- Extension
	extend (k: K; v: G)
			-- Extend table with key-value pair <`k', `v'>
		require
			fresh_key: not has_key (k)
		deferred
		ensure
			map_effect: map |=| old map.extended (k, v)
		end

feature -- Removal
	remove (k: K)
			-- Remove key `k' and its associated value
		require
			has_key: has_key (k)
		deferred
		ensure
			map_effect: map |=| old map.removed (map_key (k))
		end

	wipe_out
			-- Remove all elements
		deferred
		ensure then
			map_effect: map.is_empty
		end

feature -- Model
	map: MML_FINITE_MAP [K, G]
			-- Corresponding mathematical map
		note
			status: model
		deferred
		end

invariant
	bag_domain_definition: bag.domain |=| map.range
	bag_definition: bag.domain.for_all (agent (x: G): BOOLEAN
		do
			Result := bag [x] = map.inverse.image_of (x).count
		end)
	key_equivalence_relation_definition: key_equivalence.relation |=| relation
end
