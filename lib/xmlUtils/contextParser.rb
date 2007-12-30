#
#	File: contextParser.rb
#
#	This class will convert XML guideline files to GDL (Guideline Definition Language).
#	
#

require 'rexml/document'
require 'rexml/streamlistener'
require 'xmlUtils/xmlRuleVisitor'
require 'xmlUtils/dumpListener'
require 'xmlUtils/contextListener'
require 'xmlUtils/ruleListener'
require 'xmlUtils/gdlListener'



#################################################
#
# class ContextParser
#
#################################################
class ContextParser

	attr_accessor :context
	
	def initialize(ctx)
		@context			= ctx
		@verbose 			= false
		
	end



	def verbose?()
		return @verbose
	end # verbose?
	
	
	
	
#-------------------------------------------------------------------------------------------------------------#
# setFlag - Set configuration flags
#
# flg	- Array of options or single string option. Currently, only -v: verbose is available
#
#------------------------------------------------------------------------------------------------------------#
	def setFlag(flg)
		if (flg.class == Array)
			flg.each do |f|
				case f
					when '-v'
						@verbose = true
				end
			end # flg.each
			
			return
		end # if flg
		
		case flg
			when '-v'
				@verbose = true
		end
		
	end

	
#-------------------------------------------------------------------------------------------------------------#
# parse - Parse guideline XML
#
# fname	- Filename of XML file to parse
#
#------------------------------------------------------------------------------------------------------------#
	def parse(fname, dummy)
		puts "Parsing file." unless (!verbose?)
		ctxListener 				= ContextListener.new(@context)
		ctxListener.verbose	= @verbose
		parser = Parsers::StreamParser.new(File.new(fname), ctxListener)
		parser.parse


		puts "Parsing guideline." unless (!verbose?)
		gdlListener 				= GdlListener.new(@context)
		gdlListener.verbose	= @verbose
		parser = Parsers::StreamParser.new(File.new(fname), gdlListener)
		parser.parse


		puts "Parsing rule XML." unless (!verbose?)
		ruleListener 					= RuleListener.new(@context)
		ruleListener.verbose	= @verbose
		parser = Parsers::StreamParser.new(File.new(fname), ruleListener)
		parser.parse
	end # parse

	
#-------------------------------------------------------------------------------------------------------------#
# dumpResults - Dump collected context info to STDOUT
#
#
#------------------------------------------------------------------------------------------------------------#
	def dumpResults()
		@listener.context.dumpDpms()
		@listener.context.dumpPpms()
		@listener.context.dumpLookups()
		@listener.context.dumpRules()
		@listener.context.dumpRulesets()
	end	# dumpResults
	
end	# class ContextParser



