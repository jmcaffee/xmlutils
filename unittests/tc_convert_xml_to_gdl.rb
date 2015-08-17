require 'xmlUtils'
require 'date'

#len = ARGV.length

#puts "ARG count: #{len}"
#exit

#fname = "data/DCTEST.xml"
fname = "data/DCTEST1.xml"
#fname = "data/DCTEST1wLookups.xml"
#fname = "data/Z-TEMP-Jeff.xml"
#fname = "data/Message.xml"
#fname = "data/AUGuideline.xml"
#fname = "data/Pricing2ndGuideline.xml"

curDir = Dir.getwd
puts "Working dir: #{curDir}"


docBuilder = GdlDocBuilder.new(ARGV)
docBuilder.createDocument(fname, curDir)

