note
	description: "Standard (console) output."
	author: "Nadia Polikarpova"
	date: "$Date$"
	revision: "$Revision$"
	model: separator

class
	V_STANDARD_OUTPUT

inherit
	V_OUTPUT_STREAM [ANY]

create
	default_create,
	make_with_separator

feature {NONE} -- Initialization
	make_with_separator (s: STRING)
			-- Create a stream and set `separator' to `s'.
		do
			separator := s
		ensure
			separator_effect: separator = s
		end

feature -- Access
	separator: STRING
			-- String that is output after every element.

feature -- Status report
	off: BOOLEAN = False
			-- Is current position off scope?

feature -- Replacement
	output (v: ANY)
			-- Put `v' into the stream and move to the next position.
		do
			print (v)
			if separator /= Void then
				print (separator)
			end
		end

feature -- Specification
	sequence: MML_FINITE_SEQUENCE [ANY]
			-- Sequence of elements already read.
		note
			status: specification_only
		do
		end

	executable: BOOLEAN = False
			-- Are model-based contracts for this class executable?
end
