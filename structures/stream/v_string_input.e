note
	description: "Streams that parse textual representation of values from a string."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: source, index, from_string, is_separator

class
	V_STRING_INPUT [G]

inherit
	V_INPUT_STREAM [G]

create
	make,
	make_with_separators

feature {NONE} -- Initialization
	make (src: STRING; fs: FUNCTION [ANY, TUPLE [STRING], G])
			-- Create a stream that reads from `src' and uses function `fs' to convert from string to `G'.
			-- (Use function `default_is_separator' to recognize separator characters).
		require
			src_exists: src /= Void
			fs_exists: fs /= Void
			fs_one_argument: fs.open_count = 1
		do
			make_with_separators (src, fs, agent default_is_separator)
		ensure
			source_effect: source ~ src
			index_effect: index = 0
			--- from_string_effect: from_string = fs
			--- is_separator_effect: is_separator = agent default_is_separator
		end

	make_with_separators (src: STRING; fs: FUNCTION [ANY, TUPLE [STRING], G]; is_sep: PREDICATE [ANY, TUPLE [CHARACTER]])
			-- Create a stream that reads from `src', uses function `fs' to convert from string to `G'
			-- and function `is_sep' to recognize separator characters.
		require
			src_exists: src /= Void
			fs_exists: fs /= Void
			fs_one_argument: fs.open_count = 1
			is_sep_exists: is_sep /= Void
			is_sep_one_argument: is_sep.open_count = 1
			--- is_sep_is_total: is_sep.precondition |=| True
		do
			source := src.twin
			from_string := fs
			is_separator := is_sep
		ensure
			source_effect: source ~ src
			index_effect: index = 0
			--- from_string_effect: from_string = fs
			--- is_separator_effect: is_separator = is_sep			
		end

feature -- Access
	item: G
			-- Current token.

	source: STRING
			-- Source string remained to be read.

	index: INTEGER
			-- Position of the first character of current token in `source'.

	from_string: FUNCTION [ANY, TUPLE [STRING], G]
			-- Function that converts a string into a value of type `G'.			

	is_separator: PREDICATE [ANY, TUPLE [CHARACTER]]
			-- Function that recognizes separator characters
			-- (characters to be skipped in `source').

	default_is_separator (c: CHARACTER): BOOLEAN
			-- Is `c' space or punctuation character?
		do
			Result := c.is_space or c.is_punctuation
		ensure
			definition: Result = (c.is_space or c.is_punctuation)
		end

feature -- Status report
	off: BOOLEAN
			-- Is current position off scope?
		do
			Result := not source.valid_index (index)
		end

feature -- Cursor movement
	start
			-- Read the first token.
		do
			next := 1
			skip_separators
			if source.valid_index (next) then
				parse_value
				skip_separators
			else
				index := source.count + 1
			end
		ensure then
			index_effect: index = index_that_from (source, agent non_separator, 1)
			source_effect: source ~ old source.twin
		end

	forth
			-- Read the next token.
		do
			if source.valid_index (next) then
				parse_value
				skip_separators
			else
				index := source.count + 1
			end
		ensure then
			index_effect: index = index_that_from (source, agent non_separator, index_that_from (source, is_separator, old index))
			source_effect: source ~ old source.twin
		end

feature {NONE} -- Implementation
	next: INTEGER
			-- Position of the first character of next token in `source'.

	skip_separators
			-- Move to the next character not in `separators'.
		do
			from
			until
				next > source.count or else not is_separator.item ([source [next]])
			loop
				next := next + 1
			end
		end

	parse_value
			-- Parse value at current position and move to the next separator.
		require
			index_in_bounds: source.valid_index (next)
		local
			s: STRING
			i: INTEGER
		do
			from
				i := next
			until
				next > source.count or else is_separator.item ([source [next]])
			loop
				next := next + 1
			end
			s := source.substring (i, next - 1)
			if not from_string.precondition ([s]) then
				index := source.count + 1
			else
				item := from_string.item ([s])
				index := i
			end
		end

feature -- Specification
	index_that_from (s: STRING; p: PREDICATE [ANY, TUPLE [CHARACTER]]; i: INTEGER): INTEGER
			-- Index of the first character of `s' that satisfies `p' starting from position `i';
			-- out of range, if `p' is never satisfied.	
		do
			from
				Result := i
			until
				Result > s.count or else p.item (([s [Result]]))
			loop
				Result := Result + 1
			end
		end

	non_separator (c: CHARACTER): BOOLEAN
			-- Is `c' not a separator?
		do
			Result := not is_separator.item ([c])
		ensure
			Result = not is_separator.item ([c])
		end

invariant
	item_definition: not off implies (item ~ from_string.item ([source.substring (index, index_that_from (source, is_separator, index))]))
	off_definition: off = not source.valid_index (index)
	--- is_separator_is_total: is_separator.precondition |=| True
end
