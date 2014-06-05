#
#	File: gdlListener.rb
#
#	Adds rule and ruleset names and aliases to a list (figuratively).
#	
#

require 'rexml/streamlistener'
require 'xmlutils/gdlcontext'
require 'xmlutils/gdlcontextobjs'
require 'xmlutils/listener'

include REXML




#################################################
#
# class GdlListener
#
#################################################
class GdlListener < Listener
	
  attr_reader :context
  attr_writer :gdl
  
  attr_writer :inGuideline
  attr_writer :inRule
  attr_writer :inRuleset
  





	def initialize(ctx)
		super()
		@context 			= ctx
		@gdl					= nil
		@inGuideline	= false
		@inRule 			= false
		@inRuleset 		= false
	end
	



  def inGuideline?
    return @inGuideline
  end
	



  def inRule?
    return @inRule
  end
	



  def inRuleset?
    return @inRuleset
  end
	



#-------------------------------------------------------------------------------------------------------------#
# tag_start - A start tag has been parsed
#
#	tag				- name of tag (element name)
# attributes	- element tag attributes
#------------------------------------------------------------------------------------------------------------#
	def tag_start(tag, attributes)

		case tag
			when 'Guideline'
				openGuideline(attributes)
				
			when 'Rule'
				openRule(attributes)
				
			when 'Ruleset'
				openRuleset(attributes)
				
			else
				openUnknown(tag, attributes)				# Don't care
		end	# case
		
	end
	
	


#-------------------------------------------------------------------------------------------------------------#
# tag_end - An ending tag has been parsed
#
# tag - name of tag (element name)
#------------------------------------------------------------------------------------------------------------#
	def tag_end(tag)

		case tag
			when 'Guideline'
				closeGuideline()
				
			when 'Rule'
				closeRule()
				
			when 'Ruleset'
				closeRuleset()

			else
				closeUnknown(tag)									# Don't care
		end # case
		
	end
	
	


#-------------------------------------------------------------------------------------------------------------#
# openGuideline - Add a Guideline to the context object
#
# attributes	- Guideline element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openGuideline(attributes)
		return unless (!inGuideline?)
		
		if ($DEBUG)
			puts "openGuideline:"

			if(!attributes.empty?)
				puts "      Attr:"
				attributes.each do |attr|
					puts "            #{attr[0]}: #{attr[1]}"
				end
			end
		end # if $DEBUG
		
		@gdl = Guideline.new(attributes)
		
		@inGuideline = true
		
	end	# openGuideline
	


#-------------------------------------------------------------------------------------------------------------#
# closeGuideline - Close a Guideline object
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeGuideline()
		if (inGuideline?)
			@GuidelineOpen = false
			@context.guideline = @gdl

			puts "closeGuideline" unless (!$DEBUG)
			puts "" unless (!$DEBUG)
		end	# if

	end	# closeGuideline
	


#-------------------------------------------------------------------------------------------------------------#
# openRule - Add a rule to the context object
#
# attributes	- rule element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openRule(attributes)
		return unless (inGuideline? && (!inRuleset?))
		
		if ($DEBUG)
			puts "openRule:"

			if(!attributes.empty?)
				puts "      Attr:"
				attributes.each do |attr|
					puts "            #{attr[0]}: #{attr[1]}"
				end
			end
		end # if $DEBUG
		
		ruleAlias = attributes["Name"]
		item 			= ["rule", "#{ruleAlias}"]
		
		@gdl.addItem(item)
		@inRule = true
		
		puts "Guideline item: [#{item[0]}] #{item[1]}" if verbose?

	end	# openRule
	


#-------------------------------------------------------------------------------------------------------------#
# closeRule - Close a rule object
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeRule()
		if (inRule?)
			@inRule = false

			puts "closeRule" unless (!$DEBUG)
			puts "" unless (!$DEBUG)
		end	# if

	end	# closeRule
	


#-------------------------------------------------------------------------------------------------------------#
# openRuleset - Open a ruleset object
#
# attributes	- ruleset element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openRuleset(attributes)
		return unless (inGuideline? && (!inRuleset?))
				
		if ($DEBUG)
			puts "openRuleset:"

			if(!attributes.empty?)
				puts "      Attr:"
				attributes.each do |attr|
					puts "            #{attr[0]}: #{attr[1]}"
				end
			end
		end # if $DEBUG
		
		rsAlias 	= attributes["Name"]
		item 			= ["ruleset", "#{rsAlias}"]
		
		@gdl.addItem(item)
		@inRuleset	= true
		
		puts "Guideline item: [#{item[0]}] #{item[1]}" if verbose?

	end	# openRuleset
	


#-------------------------------------------------------------------------------------------------------------#
# closeRuleset - Close a ruleset object
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeRuleset()
		if (inRuleset?)
			@inRuleset = false

			puts "closeRuleset" unless (!$DEBUG)
			puts "" unless (!$DEBUG)
		end	# if

	end	# closeRuleset
	



end	# class GdlListener



