require 'xmlUtils'

def usage()
	puts 
	puts "Usage:"
	puts "xmltogdl FILENAME [OPTIONS]"
	puts 
	puts "Converts XML guideline file to GDL language."
	puts
	
	exit
end # usage

if ($DEBUG)
	puts "ARG count: #{ARGV.length.to_s}"

end # debug

if (ARGV.length < 1)
	usage
end # if no args


fname = ARGV.shift

puts "Converting file: #{fname}"

curDir = Dir.getwd
puts "Working dir: #{curDir}"


docBuilder = GdlDocBuilder.new(ARGV)
docBuilder.createDocument(fname, curDir)




