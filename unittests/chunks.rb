require 'xmlUtils/lineParser'

chunks = 0

File.read(ARGV[0]).split.each do |word|
    next if word =~ /^#/
    break if ["__DATA__", "__END__"].member? word
    chunks += 1 
    
#    puts word
end

print "Found ", chunks, " chunks\n"



lp = LineParser.new

lp.parse(ARGV[0])

lp.dumpResults

#
#fh = File.new(ARGV[0])

#fh.readlines.each { |line|
#    lp.parseLine(line.chomp!)
#}



