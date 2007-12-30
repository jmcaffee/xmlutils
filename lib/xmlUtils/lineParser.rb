#
#	File: lineParser.rb
#
#	This class is used to import GDL variable definitions.
#	
#

require 'xmlUtils/gdlContextObjs'

class LineParser

	attr_accessor :ppms
	attr_accessor :dpms
	attr_accessor :dsms
	
	
	def initialize()
		@ppms = Hash.new
		@dpms = Hash.new
		@dsms = Hash.new
		
	end	# initialize
	
	
	def dumpResults()
		puts "PPMs parsed: #{ppms.size}"
		puts "DPMs parsed: #{dpms.size}"
		puts "DSMs parsed: #{dsms.size}"
		
		puts "--== PPMs ==--".center(79)
		puts
		@ppms.each do |key, val|
			puts "[#{key}] #{val.name}"
#			puts "[ #{key} ] #{val.inspect}"
			#puts "\t\t#{val.inspect}"
		end # do
		puts
		puts
		
		puts "--== DPMs ==--".center(79)
		puts
		@dpms.each do |key, val|
			puts "[#{key}] #{val.name}"
		end # do
		puts
		puts
		
		puts "--== DSMs ==--".center(79)
		puts
		@dsms.each do |key, val|
			puts "[#{key}] #{val.name}"
		end # do
		puts
		puts
		
	end # dumpResults
	
	
	def getAlias(line)
		outAry = line.scan(/"([^";]*)"/)
		#puts "Get Alias scan result: #{outAry}"
		outp = outAry[0].to_s
		outp.strip!
		#puts "Get Alias final result: #{outp}"
		return outp
	end # getAlias
	
	
	def parse(filename)
		fh = File.new(filename)

		fh.readlines.each { |line|
				parseLine(line.chomp!)
		}
		
	end	# parse
	
	
	def parseLine(line)
		line.gsub!(/;/, '')												# Remove semi-colon terminators
		parts = line.split
		return unless (parts.length > 0)
		
		case parts[0]
			when 'ppm'
				parsePpm(line)
		
			when 'dpm'
				parseDpm(line)
		
			when 'decision'
				parseDsm(line)
		
			else
				puts "Skipping line: #{line}" if $DEBUG
		end # case
	end

	def parsePpm(line)
		varAlias = getAlias(line)
		parts = line.split
		
		parts.each {|part| part.strip!}
		
		if (parts.length < 5)
			puts "*** Invalid PPM line. Less than 5 items. ***"
			return
		end # if parts
		
		attributes = Hash.new
		attributes["DataType"] 	= parts[1]
		attributes["Type"] 			= parts[2]
		varName									= parts[3]
		
		raise "Missing PPM var name: #{attributes}" unless (varName.length > 0)
		
		if (nil == varAlias || varAlias.length < 1)
			varAlias = varName
		end
		
		attributes["Name"] 			= varAlias
		
		@ppms[varAlias] = Ppm.new(varName, attributes)
		
	end
	
	def parseDpm(line)
		puts "parse DPM: #{line}" if $DEBUG
		varAlias = getAlias(line)
		parts = line.split
		
		parts.each {|part| part.strip!}
		
		if (parts.length < 3)
			puts "*** Invalid DPM line. Less than 3 items. ***"
			return
		end # if parts
		
		attributes = Hash.new
		attributes["Type"] 				= "DPM"
		attributes["ProductType"]	= parts[1]
		attributes["DataType"] 		= parts[1]
		varName										= parts[2]

		if (nil == varAlias || varAlias.length < 1)
			varAlias = varName
		end
		
		attributes["Name"] 				= varAlias

		raise "Missing DPM var name: #{attributes}" unless (varName.length > 0)
		

		#attributes["Type"] 			= parts[2]
		
		@dpms[varAlias] = Dpm.new(varName, attributes)
		
	end
	
	def parseDsm(line)
		puts "parse DSM: #{line}" if $DEBUG
		varAlias = getAlias(line)
		parts = line.split
		
		parts.each {|part| part.strip!}
		
		if (parts.length < 4)
			puts "*** Invalid DSM line. Less than 4 items. ***"
			return
		end # if parts
		
		attributes = Hash.new
		attributes["Type"] 				= "DSM"
		attributes["ProductType"]	= parts[2]
		attributes["DataType"] 		= parts[2]
		varName										= parts[3]

		if (nil == varAlias || varAlias.length < 1)
			varAlias = varName
		end
		
		attributes["Name"] 				= varAlias


		raise "Missing DSM var name: #{attributes}" unless (varName.length > 0)
		
		#attributes["Type"] 			= parts[2]
		
		@dsms[varAlias] = Dpm.new(varName, attributes)
		
	end
	
end # class LineParser



