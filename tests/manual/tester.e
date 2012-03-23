note
	description : "new_tester application root class"
	date        : "$Date: 2008-12-29 15:41:59 -0800 (Mon, 29 Dec 2008) $"
	revision    : "$Revision: 76432 $"

class
	TESTER

inherit
	V_ORDER [INTEGER]

	V_HASH [STRING]

create
	execute

feature {NONE} -- Initialization
	execute
			-- Run application.
		do
--			print ("%NTest MML_SET%N")
--			test_mml_set
--			io.new_line
--			print ("%NTest ARRAY%N")
--			test_array
--			io.new_line
--			print ("%NTest LINKED_LIST%N")
--			test_linked_list
--			io.new_line
--			print ("%NTest ARRAYED_LIST%N")
--			test_arrayed_list
--			io.new_line
--			print ("%NTest BINARY_TREE%N")
--			test_binary_tree
--			io.new_line
			print ("%NTest SORTED_SET%N")
			test_sorted_set
			io.new_line
			print ("%NTest SORTED_TABLE%N")
			test_sorted_table
			io.new_line
			print ("%NTest LINKED_STACK%N")
			test_linked_stack
			io.new_line
			print ("%NTest LINKED_QUEUE%N")
			test_linked_queue
			io.new_line
			print ("%NTest HASH_SET%N")
			test_hash_set
			io.new_line
			print ("%NTest HASH_TABLE%N")
			test_hash_table
			io.new_line
		end

feature -- Tests
	test_array
			-- Test V_ARRAY
		local
			a1, a2: V_ARRAY [INTEGER]
			i: INTEGER
			b: BOOLEAN
			r: V_RANDOM
			it: V_IO_ITERATOR [INTEGER]
		do
			create a1.make (1, 10)
			create a2.make_filled (1, 10, 5)
			i := a1.count
			i := a1.count_satisfying (agent less_equal (0, ?))
			create r.set_seed (0)
			from
				i := a1.lower
			until
				i > a1.upper
			loop
				a1 [i] := r.bounded_item (1, 10)
				r.forth
				i := i + 1
			end
			from
				i := a1.lower
			until
				i > a1.upper
			loop
				print (a1 [i])
				print (" ")
				i := i + 1
			end
			io.new_line
			b := a2.is_empty
			b := a2.has_index (5)
			b := a2.has_index (100)
			b := a1.is_equal (a2)
			a2.clear (a2.lower, a2.upper)
			b := a1.is_equal (a2)
			b := a1.is_equal (a1.subarray (1, 5))
			b := a1.is_equal (a1.subarray (6, 5))
			a2.fill (6, a2.lower + 1, a2.upper - 1)
			i := a2.index_of (6)
			i := a2.index_of (5)
			i := a2.index_of_from (6, 3)
			i := a2.index_satisfying (agent (x: INTEGER): BOOLEAN do Result := x < 0 end)
			i := a2.index_satisfying_from (agent (x: INTEGER): BOOLEAN do Result := x > 0 end, 3)
			b := a2.has (6)
			b := a2.has (5)
			i := a2.occurrences (6)
			i := a2.occurrences (5)
			b := a2.exists (agent (x: INTEGER): BOOLEAN do Result := x < 0 end)
			b := a2.for_all (agent (x: INTEGER): BOOLEAN do Result := x > 0 end)
			a2.resize (1, 0)
			b := a2.is_empty
			create a2.make_filled (1, 5, 5)
			a2.resize (1, 10)
			a2.resize (1, 5)
			a2.resize (-5, 10)
			a2.resize (1, 15)
			a2.resize (-5, 10)
			a2.resize (1, 5)
			a2.resize (3, 7)
			a2.copy_range (a1, 5, 8, 4)
			a2.include (10)
			a2.force (5, 10)
			a2.force (5, 10)
			a2.copy (a1)
			a2.resize (6, 15)
			a1.copy (a2)
			across
				a1 as it1
			loop
				print (it1.item)
				print (" ")
				it1.put (5)
			end
			io.new_line
			it := a1.new_cursor
			it.search_forth (5)
			it.search_forth (6)
			it.finish
			it.search_back (5)
			it.search_back (6)
			it.start
			it.satisfy_forth (agent (x: INTEGER): BOOLEAN do Result := x > 0 end)
			it.satisfy_forth (agent (x: INTEGER): BOOLEAN do Result := x < 0 end)
			it.start
			it.satisfy_back (agent (x: INTEGER): BOOLEAN do Result := x > 0 end)
			a2.swap (10, 8)
			a2.sort (agent less_equal)
			cout.pipe (a2.new_cursor)
			a1.wipe_out
			a1.include (7)
		end

	test_linked_list
			-- Test V_LINKED_LIST
		local
			l1, l2: V_LINKED_LIST [INTEGER]
			it: V_LIST_ITERATOR [INTEGER]
			i: INTEGER
			b: BOOLEAN
		do
			create l1
			l1.extend_front (1)
			l1.extend_back (2)
			l1.extend_at (0, 1)
			l1.extend_at (2, 3)
			l1.extend_at (3, 5)
			across
				l1 as it1
			loop
				print (it1.item)
				print (" ")
			end
			io.new_line
			from
				it := l1.at_last
			until
				it.before
			loop
				print (it.item)
				print (" ")
				it.back
			end
			i := l1.count
			create l2
			i := l2.count
			l2.copy (l1)
			b := l1.is_equal (l2)
			l1.append (l2.new_cursor)
			b := l1.is_equal (l2)
			l2.prepend (l1.at (3))
			l1.insert_at (l2.at (3), 3)
			l1.put (10, 10)
			l1.remove (2)
			l1.remove_all (1)
			l1.remove_satisfying (agent (x: INTEGER): BOOLEAN do Result := x \\ 2 = 0 end)
			l1.remove_all_satisfying (agent (x: INTEGER): BOOLEAN do Result := x \\ 3 = 0 end)

			b := l1.is_empty
			b := l1.has_index (5)
			b := l1.has_index (100)
			l1.clear (2, 2)
			l1.fill (6, 1, l1.count)
			i := l1.index_of (6)
			i := l1.index_of (5)
			i := l1.index_of_from (6, 3)
			i := l1.index_satisfying (agent (x: INTEGER): BOOLEAN do Result := x < 0 end)
			i := l1.index_satisfying_from (agent (x: INTEGER): BOOLEAN do Result := x > 0 end, 3)
			b := l1.has (6)
			b := l1.has (5)
			i := l1.occurrences (6)
			i := l1.occurrences (5)
			b := l1.exists (agent (x: INTEGER): BOOLEAN do Result := x < 0 end)
			b := l1.for_all (agent (x: INTEGER): BOOLEAN do Result := x > 0 end)

			it := l2.new_cursor
			i := it.count
			b := it.is_first
			b := it.is_last
			it.output (5)
			it.extend_left (4)
			it.extend_right (6)
			it.insert_left (l1.new_cursor)
			it.insert_right (l1.at_last)
			it.remove
			it.remove_left
			it.remove_right

			l1.new_cursor.merge (l2)

			l1.remove_front
			l1.remove_back
			l1.remove_at (3)
			l1.wipe_out
		end

	test_arrayed_list
			-- Test V_ARRAYED_LIST		
		local
			l1, l2: V_ARRAYED_LIST [INTEGER]
			it: V_LIST_ITERATOR [INTEGER]
			i: INTEGER
			b: BOOLEAN
		do
			create l1
			l1.extend_front (1)
			l1.extend_back (2)
			l1.extend_at (0, 1)
			l1.extend_at (2, 3)
			l1.extend_at (3, 5)
			across
				l1 as it1
			loop
				print (it1.item)
				print (" ")
			end
			io.new_line
			from
				it := l1.at_last
			until
				it.before
			loop
				print (it.item)
				print (" ")
				it.back
			end
			i := l1.count
			create l2
			i := l2.count
			l2.copy (l1)
			b := l1.is_equal (l2)
			l1.append (l2.new_cursor)
			b := l1.is_equal (l2)
			l2.prepend (l1.at (3))
			l1.insert_at (l2.at (3), 3)
			l1.put (10, 10)
			l1.sort (agent greater_equal)
			l1.remove (2)
			l1.remove_all (1)
			l1.remove_satisfying (agent (x: INTEGER): BOOLEAN do Result := x \\ 2 = 0 end)
			l1.remove_all_satisfying (agent (x: INTEGER): BOOLEAN do Result := x \\ 3 = 0 end)

			b := l1.is_empty
			b := l1.has_index (5)
			b := l1.has_index (100)
			l1.clear (2, 2)
			l1.fill (6, 1, l1.count)
			i := l1.index_of (6)
			i := l1.index_of (5)
			i := l1.index_of_from (6, 3)
			i := l1.index_satisfying (agent (x: INTEGER): BOOLEAN do Result := x < 0 end)
			i := l1.index_satisfying_from (agent (x: INTEGER): BOOLEAN do Result := x > 0 end, 3)
			b := l1.has (6)
			b := l1.has (5)
			i := l1.occurrences (6)
			i := l1.occurrences (5)
			b := l1.exists (agent (x: INTEGER): BOOLEAN do Result := x < 0 end)
			b := l1.for_all (agent (x: INTEGER): BOOLEAN do Result := x > 0 end)

			it := l2.new_cursor
			i := it.count
			b := it.is_first
			b := it.is_last
			it.output (5)
			it.extend_left (4)
			it.extend_right (6)
			it.insert_left (l1.new_cursor)
			it.insert_right (l1.at_last)
			it.remove
			it.remove_left
			it.remove_right

			l1.remove_front
			l2.remove_back
			l1.remove_at (3)
			l1.wipe_out
		end

	test_binary_tree
			-- Test V_BINARY_TREE
		local
			t1, t2: V_BINARY_TREE [INTEGER]
			c: V_BINARY_TREE_CURSOR [INTEGER]
			it: V_BINARY_TREE_ITERATOR [INTEGER]
			b: BOOLEAN
		do
			create t1
			t1.add_root (5)
			c := t1.at_root
			it := t1.preorder
			b := c.is_equal (it)
			c.extend_left (3)
			c.extend_right (7)
			c.left
			c.extend_left (2)
			c.extend_right (4)
			print (t1)
			io.new_line
			cout.pipe (t1.inorder)
			io.new_line
			cout.pipe (t1.preorder)
			io.new_line
			cout.pipe (t1.postorder)
			io.new_line
			from
				it := t1.postorder
				it.finish
			until
				it.before
			loop
				print (it.item.out + " ")
				it.back
			end
			io.new_line
			c.left
			c.remove
			cout.pipe (t1.inorder)
			io.new_line
			cout.pipe (t1.preorder)
			io.new_line
			cout.pipe (t1.postorder)
			io.new_line
			create t2
			t2.copy (t1)
			c.go_root
			c.left
			c.remove
			c.go_root
			c.right
			c.remove
			c.go_root
			c.remove
			c.go_root
			c.remove
			t1.wipe_out
		end

	test_sorted_set
			-- Test V_SORTED_SET
		local
			s1, s2: V_SET [INTEGER]
			b: BOOLEAN
			i: INTEGER
			it: V_SET_ITERATOR [INTEGER]
		do
			create {V_SORTED_SET [INTEGER]} s1
			s1.extend (5)
			s1.extend (3)
			s1.extend (2)
			s1.extend (4)
			s1.extend (7)
			s1.extend (7)
			cout.pipe (s1.new_cursor)
			io.new_line
			s1.remove (10)
			s1.remove (7)
			s1.remove (5)
			s1.remove (3)
			b := s1.has (5)
			b := s1.has (10)
			b := s1.has_exactly (5)
			b := s1.has_exactly (10)
			i := s1.occurrences (5)
			i := s1.occurrences (10)
			it := s1.new_cursor
			it.search (4)
			it.remove
			s1.extend (4)
			it.search (10)
			create {V_SORTED_SET [INTEGER]} s2
			b := s1.is_equal (s2)
			b := s1.disjoint (s2)
			s2.extend (2)
			s2.extend (1)

			b := s2.is_subset_of (s1)
			b := s2.is_superset_of (s1)
			b := s1.disjoint (s2)
			cout.pipe (s1.new_cursor)
			print (" meet ")
			cout.pipe (s2.new_cursor)
			print (" = ")
			s1.meet (s2)
			cout.pipe (s1.new_cursor)
			io.new_line
			b := s1.is_subset_of (s2)
			b := s2.is_superset_of (s1)
			s1.extend (4)
			cout.pipe (s1.new_cursor)
			print (" join ")
			cout.pipe (s2.new_cursor)
			print (" = ")
			s2.join (s1)
			cout.pipe (s2.new_cursor)
			io.new_line
			s2.copy (s1)
			b := s2.is_equal (s1)
			s2.remove (4)
			s1.subtract (s2)
			cout.pipe (s1.new_cursor)
			io.new_line
			s1.symmetric_subtract (s2)
			cout.pipe (s1.new_cursor)
			s2.wipe_out

			create {V_SORTED_SET [INTEGER]} s1
			s1.extend (5)
			s1.extend (6)
			it := s1.new_cursor
			it.search (5)
			it.remove
			it.search (6)
			it.remove
			s1.remove (5)

			s1.extend (5)
			s1.extend (6)
			s1.subtract (s1)
			s1.extend (5)
			s1.extend (6)
			s1.symmetric_subtract (s1)
		end

	test_sorted_table
			-- Test V_SORTED_TABLE
		local
			t1, t2: V_SORTED_TABLE [INTEGER, STRING]
			it: V_TABLE_ITERATOR [INTEGER, STRING]
			s: STRING
			b: BOOLEAN
		do
			create t1
			t1.extend ("five", 5)
			t1.extend ("tree", 3)
			t1.extend ("two", 2)
			t1.extend ("four", 4)
			t1.extend ("seven", 7)
			cout.pipe (t1.new_cursor)
			io.new_line
			s := t1.item (2)
			b := t1.has_key (3)
			b := t1.has_key (10)
			b := t1.has ("five")
			b := t1.exists (agent {STRING}.is_equal ("five"))
			t1.force ("ten", 10)
			t1.put ("dieci", 10)
			t1.force ("ten", 10)
			t1.force (Void, 10)
			print (t1)
			io.new_line
			it := t1.new_cursor
			it.search_key (4)
			it.remove
			it.remove
			t1.extend ("four", 4)
			t1.extend ("five", 5)
			it.search_key (4)
			cout.pipe (it)
			io.new_line
			t2 := t1.twin
			b := t1.is_equal (t2)
			t1.remove (2)
			t1.remove (10)
			b := t1.is_equal (t2)
			t1.wipe_out
		end

	test_linked_stack
			-- Test V_LINKED_STACK
		local
			s1, s2: V_LINKED_STACK [INTEGER]
			b: BOOLEAN
		do
			create s1
			b := s1.is_empty
			s1.extend (1)
			s1.extend (2)
			s1.extend (3)
			print (s1.item)
			s1.remove
			print (s1.item)
			s1.remove
			print (s1.item)
			create s2
			b := s1.is_equal (s2)
			s2.copy (s1)
			b := s2.is_equal (s1)
		end

	test_linked_queue
			-- Test V_LINKED_QUEUE
		local
			q1, q2: V_LINKED_QUEUE [INTEGER]
			b: BOOLEAN
		do
			create q1
			b := q1.is_empty
			q1.extend (1)
			q1.extend (2)
			q1.extend (3)
			print (q1.item)
			q1.remove
			print (q1.item)
			q1.remove
			print (q1.item)
			create q2
			b := q1.is_equal (q2)
			q2.copy (q1)
			b := q2.is_equal (q1)
		end

	test_hash_set
			-- Test V_HASH_SET
		local
			s1, s2: V_SET [INTEGER]
			b: BOOLEAN
			i: INTEGER
			it: V_SET_ITERATOR [INTEGER]
		do
			create {V_HASH_SET [INTEGER]} s1
			s1.extend (5)
			s1.extend (3)
			s1.extend (2)
			s1.extend (4)
			s1.extend (7)
			s1.extend (7)
			cout.pipe (s1.new_cursor)
			io.new_line
			s1.remove (10)
			s1.remove (7)
			s1.remove (5)
			s1.remove (3)
			b := s1.has (5)
			b := s1.has (10)
			b := s1.has_exactly (5)
			b := s1.has_exactly (10)
			i := s1.occurrences (5)
			i := s1.occurrences (10)
			it := s1.new_cursor
			it.search (4)
			it.remove
			s1.extend (4)
			it.search (10)
			create {V_HASH_SET [INTEGER]} s2
			b := s1.is_equal (s2)
			b := s1.disjoint (s2)
			s2.extend (2)
			s2.extend (1)
			b := s2.is_subset_of (s1)
			b := s2.is_superset_of (s1)
			b := s1.disjoint (s2)
			cout.pipe (s1.new_cursor)
			print (" meet ")
			cout.pipe (s2.new_cursor)
			print (" = ")
			s1.meet (s2)
			cout.pipe (s1.new_cursor)
			io.new_line
			b := s1.is_subset_of (s2)
			b := s2.is_superset_of (s1)
			s1.extend (4)
			cout.pipe (s1.new_cursor)
			print (" join ")
			cout.pipe (s2.new_cursor)
			print (" = ")
			s2.join (s1)
			cout.pipe (s2.new_cursor)
			io.new_line
			s2.copy (s1)
			b := s2.is_equal (s1)
			s2.remove (4)
			s1.subtract (s2)
			cout.pipe (s1.new_cursor)
			io.new_line
			s1.symmetric_subtract (s2)
			cout.pipe (s1.new_cursor)
			s2.wipe_out

			s1.extend (5)
			s1.extend (6)
			s1.subtract (s1)
			s1.extend (5)
			s1.extend (6)
			s1.symmetric_subtract (s1)
		end

	test_hash_table
			-- Test V_HASH_TABLE
		local
			t1, t2: V_HASH_TABLE [INTEGER, STRING]
			it: V_TABLE_ITERATOR [INTEGER, STRING]
			s: STRING
			b: BOOLEAN
		do
			create t1
			t1.extend ("five", 5)
			t1.extend ("tree", 3)
			t1.extend ("two", 2)
			t1.extend ("four", 4)
			t1.extend ("seven", 7)
			cout.pipe (t1.new_cursor)
			io.new_line
			s := t1.item (2)
			b := t1.has_key (3)
			b := t1.has_key (10)
			b := t1.has ("five")
			b := t1.exists (agent {STRING}.is_equal ("five"))
			t1.force ("ten", 10)
			t1.put ("dieci", 10)
			t1.force ("ten", 10)
			t1.force (Void, 10)
			print (t1)
			io.new_line
			it := t1.new_cursor
			it.search_key (4)
			it.remove
			it.remove
			t1.extend ("four", 4)
			t1.extend ("five", 5)
			it.search_key (4)
			cout.pipe (it)
			io.new_line
			t2 := t1.twin
			b := t1.is_equal (t2)
			t1.remove (2)
			t1.remove (10)
			b := t1.is_equal (t2)
			t1.wipe_out
		end

feature -- MML tests
	test_mml_set
			-- Test MML_SET
		local
			s1, s2, s3: MML_SET [INTEGER]
			b: BOOLEAN
			i: INTEGER
		do
			create s1
			create s2.singleton (1)
			b := s1.is_empty
			b := s2.is_empty
			s1 := s1.extended (1).extended (2).extended (3)
			i := s1.any_item
			i := s1.extremum (agent greater_equal)
			b := s1.for_all (agent greater_equal (?, 0))
			b := s1.exists (agent greater_equal (?, 3))
			b := s1.has (0)
			b := s1.has (1)
			s2 := s1.filtered (agent greater_equal (?, 2))
			i := s2.count
			b := s2.is_subset_of (s1)
			b := s1.is_subset_of (s2)
			b := s1.is_superset_of (s2)
			b := s1.disjoint (s2)
			s2 := {MML_INTERVAL} [[4, 6]]
			b := s1.disjoint (s2)
			s2 := s2.extended (1)
			s2 := s2.extended (4)
			s2 := s2.removed (6)
			s2 := s2.removed (6)
			s3 := s1 + s2
			s3 := s1 * s2
			s3 := s1 - s2
			s3 := s1 ^ s2
		end

feature -- Performance tests
	test_performance
			-- Test V_LINKED_LIST against LINKED_LIST
		local
			start, finish: TIME
			i, n: INTEGER
		do
			n := 10_000
			create start.make_now
			from
				i := 1
			until
				i > n
			loop
				linked_list_performance
				i := i + 1
			end
			create finish.make_now
			io.new_line
			print (finish.relative_duration (start).fine_second)
			io.new_line
			create start.make_now
			from
				i := 1
			until
				i > n
			loop
				v_linked_list_performance
				i := i + 1
			end
			create finish.make_now
			io.new_line
			print (finish.relative_duration (start).fine_second)
--			io.read_character
		end

	v_linked_list_performance
			-- Test V_LINKED_LIST
		local
			l1, l2: V_LINKED_LIST [INTEGER]
			it: V_LIST_ITERATOR [INTEGER]
			i: INTEGER
			b: BOOLEAN
		do
			create l1
			l1.extend_front (1)
			l1.extend_back (2)
			l1.extend_at (0, 1)
			l1.extend_at (2, 3)
			l1.extend_at (3, 5)
			from
				it := l1.new_cursor
			until
				it.after
			loop
				it.forth
			end
			from
				it := l1.at_last
			until
				it.before
			loop
				it.back
			end
			i := l1.count
			create l2
			i := l2.count
			l2.copy (l1)
			b := l1.is_equal (l2)
			l1.append (l2.new_cursor)
			b := l1.is_equal (l2)
			l1.put (10, 10)
			b := l1.is_empty
			b := l1.has_index (5)
			b := l1.has_index (100)
			i := l1.index_of (6)
			i := l1.index_of (5)
			i := l1.index_of_from (6, 3)
			b := l1.has (6)
			b := l1.has (5)
			i := l1.occurrences (6)
			i := l1.occurrences (5)

			l1.remove_front
			l1.remove_back
			l1.remove_at (3)
			l1.wipe_out
		end

	linked_list_performance
			-- Test V_LINKED_LIST
		local
			l1, l2: LINKED_LIST [INTEGER]
			i: INTEGER
			b: BOOLEAN
		do
			create l1.make
			l1.put_front (1)
			l1.extend (2)
			l1.start
			l1.put_left (0)
			l1.forth
			l1.put_left (2)
			l1.forth
			l1.put_left (3)
			from
				l1.start
			until
				l1.off
			loop
				l1.forth
			end
			from
				l1.finish
			until
				l1.off
			loop
				l1.back
			end
			i := l1.count
			create l2.make
			i := l2.count
			l2.copy (l1)
			b := l1.is_equal (l2)
			l1.append (l2)
			b := l1.is_equal (l2)
			l1.go_i_th (10)
			l1.put (10)
			b := l1.is_empty
			b := l1.valid_index (5)
			b := l1.valid_index (100)
			i := l1.index_of (6, 1)
			i := l1.index_of (5, 1)
			i := l1.index_of (6, 3)
			b := l1.has (6)
			b := l1.has (5)
			i := l1.occurrences (6)
			i := l1.occurrences (5)

			l1.start
			l1.remove
			l1.finish
			l1.remove
			l1.go_i_th (3)
			l1.remove
			l1.wipe_out
		end
feature -- Implementation
	cout: V_STANDARD_OUTPUT
			-- Standard output stream
		once
			create Result.make_with_separator (" ")
		end
end
