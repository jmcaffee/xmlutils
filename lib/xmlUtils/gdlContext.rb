#
#	File: gdlContext.rb
#
#	This is a guideline context object
#	
#

require 'xmlUtils/gdlContextObjs'


#################################################
#
# class GdlContext
#
#################################################
class GdlContext
	
	attr_reader		:options
	
	attr_accessor :rules
	attr_accessor :ppms
	attr_accessor :dpms
	attr_accessor :lookups
	attr_accessor :rulesets
	attr_accessor	:guideline
	attr_accessor	:messages
	
	
	def initialize()
		@rules 		= Hash.new
		@ppms			= Hash.new
		@dpms			= Hash.new
		@lookups	= Hash.new
		@rulesets	= Hash.new
		@messages	= Hash.new
		@guideline = nil
		
		
	end # initialize
	
	
	def setOptions(options)
		@options = options
	end # setOptions
	
	
#-------------------------------------------------------------------------------------------------------------#
# createValidName - Generate a valid GDL name
#
# inname	- name to convert
#
#------------------------------------------------------------------------------------------------------------#
	def createValidName(inname)
		outname = inname.gsub(/[\s\/\\?*#+]/,'')				# Remove illegal chars (replace with underscore).
		outname.gsub!(/_+/,"_")													# Replace consecutive uscores with single uscore.
		outname.gsub!(/\./,"-")													# Replace period with dash.

		outname
	end


	
	def isPpmVar(var)
		isPpm = false
		
		case var.varType
			when 'app'
				isPpm = true
				
			when 'crd'
				isPpm = true
				
			when 'prd'
				isPpm = true
				
		end # case
		
		isPpm
	end # isPpmVar
	




#-------------------------------------------------------------------------------------------------------------#
# getLookupParamNames - generate a hash containing a lookup's x and y parameter names (not alias')
#
# lkName	- name of lookup to get values from.
#
# returns Hash - xparam => xParam name, yparam => yParam name
#------------------------------------------------------------------------------------------------------------#
	def getLookupParamNames(lkName)
		lkParams = Hash.new

		lkup = @lookups[lkName]
		
		#puts lkup.inspect
		
		x = nil
		y = nil
		
		if (isPpmVar(lkup.xParam))
			x = @ppms[lkup.xParam.alias]
		else
			x = @dpms[lkup.xParam.alias]
		end # if PPM

		#puts x.inspect
		
		if (isPpmVar(lkup.yParam))
			y = @ppms[lkup.yParam.alias]
		else
			y = @dpms[lkup.yParam.alias]
		end # if PPM

		#puts y.inspect
		
		if (nil == x)
			raise "Unable to find xParam (#{lkup.xParam.alias}) in lookup #{lkName}"
		end # if nil
		
		if (nil == y)
			raise "Unable to find yParam (#{lkup.yParam.alias}) in lookup #{lkName}"
		end # if nil
		
		lkParams["xparam"] = x.name
		lkParams["yparam"] = y.name
		
		return lkParams			
		
	end # getLookupParamNames


	
#-------------------------------------------------------------------------------------------------------------#
# dumpDpms - Dump all stored DPM variables
#
#
#------------------------------------------------------------------------------------------------------------#
	def dumpDpms()
		79.times {print "="}
		puts
		puts "DPM DUMP".center(80)
		79.times {print "="}
		puts
		
		if(@dpms.length > 0)
			
			dpms = @dpms.sort
			dpms.each do |key, dpm|
				puts "#{dpm.name}\t(#{dpm.alias})" unless dpm.varType == "DSM"
			end
			
		else
			puts "No DPM variables to dump."
		end

		puts ""

		79.times {print "="}
		puts
		puts "DSM DUMP".center(80)
		79.times {print "="}
		puts

		if(@dpms.length > 0)
			dpms = @dpms.sort
			dpms.each do |key, dpm|
				puts "#{dpm.name}\t(#{dpm.alias})" if dpm.varType == "DSM"
			end
			
		else
			puts "No DSM variables to dump."
		end

		puts ""

	end	# dumpDpms


	
#-------------------------------------------------------------------------------------------------------------#
# dumpPpms - Dump all PPM variables
#
#
#------------------------------------------------------------------------------------------------------------#
	def dumpPpms()
		79.times {print "="}
		puts
		puts "PPM DUMP".center(80)
		79.times {print "="}
		puts
		
		if(@ppms.length > 0)
			ppms = @ppms.sort
			ppms.each do |key, ppm|
				puts "#{ppm.name}\t(#{ppm.alias})"
			end
			
		else
			puts "No PPM variables to dump."
		end

		puts ""

	end	# dumpppms


	
#-------------------------------------------------------------------------------------------------------------#
# dumpRules - Dump all stored rules
#
#
#------------------------------------------------------------------------------------------------------------#
	def dumpRules()
		79.times {print "="}
		puts
		puts "RULE DUMP".center(80)
		79.times {print "="}
		puts

		if(@rules.length > 0)
			rules = @rules.sort
			rules.each do |key, rule|
				puts "#{rule.name}\t(#{rule.alias})"
				puts "#{rule.xml}"
				40.times {print "-"}
				puts
			end
			
		else
			puts "No rules to dump."
		end

		puts ""
	end	# dumpRules


	
#-------------------------------------------------------------------------------------------------------------#
# dumpRule - Dump one rule
#
#
#------------------------------------------------------------------------------------------------------------#
	def dumpRule(als)
		79.times {print "="}
		puts
		puts "RULE: #{als}".center(80)
		79.times {print "="}
		puts

		rule = @rules[als]
		if (nil != rule)
			puts "#{rule.name}\t(#{rule.alias})"
			puts "#{rule.xml}"
		
		else
			puts "Cannot find matching rule."
		end

		puts ""
	end	# dumpRule


	
#-------------------------------------------------------------------------------------------------------------#
# dumpRulesets - Dump all stored rulesets
#
#
#------------------------------------------------------------------------------------------------------------#
	def dumpRulesets()
		79.times {print "="}
		puts
		puts "RULESET DUMP".center(80)
		79.times {print "="}
		puts
		
		if(@rulesets.length > 0)
			rulesets = @rulesets.sort
			rulesets.each do |key, ruleset|
				
				40.times {print "-"}
				puts
				puts "#{ruleset.name}\t(#{ruleset.alias}) : #{ruleset.type} : #{ruleset.execType}"
				ruleset.rules.each do |ruleAlias|
					puts "\t#{ruleAlias}"
				end # rules.each
				puts ""
				
			end # rulesets.each
			
		else
			puts "No rulesets to dump."
		end

		puts ""
	end	# dumpRulesets


	
#-------------------------------------------------------------------------------------------------------------#
# dumpLookups - Dump all stored rulesets
#
#
#------------------------------------------------------------------------------------------------------------#
	def dumpLookups()
		79.times {print "="}
		puts
		puts "LOOKUP DUMP".center(80)
		79.times {print "="}
		puts
		
		if(@lookups.length > 0)
			lookups = @lookups.sort
			lookups.each do |key, lookup|
				
				puts lookup.toGdlRef()
				
			end # lookups.each
		else
			puts "No lookups to dump."
		end # if

		puts ""


	end	# dumpLookups


	
end # class GdlContext




