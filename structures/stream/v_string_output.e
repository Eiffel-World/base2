note
	description: "Streams that output textual representation of values to a string."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: string, separator

class
	V_STRING_OUTPUT

inherit
	V_OUTPUT_STREAM [ANY]

create
	make,
	make_with_separator

feature {NONE} -- Initialization
	make (dest: STRING)
			-- Create a stream that outputs into `dest'.
			-- (Use `default_separator' as `separator').
		require
			dest_exists: dest /= Void
		do
			make_with_separator (dest, default_separator)
		ensure
			string_effect: destination = dest
			separator_effect: separator = default_separator
		end

	make_with_separator (dest, sep: STRING)
			-- Create a stream that outputs into `dest'
			-- and uses `sep' as `separator'.
		require
			dest_exists: dest /= Void
			sep_exists: sep /= Void
		do
			destination := dest
			separator := sep
		ensure
			string_effect: destination = dest
			separator_effect: separator = sep
		end

feature -- Access
	destination: STRING
			-- Destination string.

	separator: STRING
			-- String that is output after every element.

	default_separator: STRING = " "
			-- Default value of `separator'.			

feature -- Status report
	off: BOOLEAN = False
			-- Is current position off scope?

feature -- Replacement
	output (v: ANY)
			-- Put `v' into the stream and move to the next position.
		do
			destination.append (v.out)
			destination.append (separator)
		ensure then
			string_effect: destination ~ (old destination.twin) + v.out + separator
		end

invariant
	destination_exists: destination /= Void
	separator_exists: separator /= Void
end
