#
#	File: listener.rb
#
#	This class is an abstract listener base class
#	
#

require 'rexml/streamlistener'

include REXML




#################################################
#
# class Listener
#
#################################################
class Listener 
	include StreamListener
	
  attr_writer :verbose

  def verbose?
    @verbose
  end
	


#-------------------------------------------------------------------------------------------------------------#
# initialize - Ctor
#
#
#------------------------------------------------------------------------------------------------------------#
	def initialize()
		@verbose 		= false
	end
	


#-------------------------------------------------------------------------------------------------------------#
# tag_start - A start tag has been parsed
#
#	tag				- name of tag (element name)
# attributes	- element tag attributes
#------------------------------------------------------------------------------------------------------------#
	def tag_start(tag, attributes)
		if ($DEBUG)
			puts "tag_start: #{tag}"

			if(!attributes.empty?)
				puts "      Attr:"
				attributes.each do |attr|
					puts "            #{attr[0]}: #{attr[1]}"
				end
			end
		end # if $DEBUG
		
		case tag
			when 'DPM'
				openDPM(attributes)
				
			when 'PPM'
				openPPM(attributes)
				
			when 'Rule'
				openRule(attributes)
				
			when 'Ruleset'
				openRuleset(attributes)
				
			when 'Lookup'
				openLookup(attributes)
				
			when 'LOOKUPS'
				openLOOKUPS(attributes)
				
			when 'LOOKUP'
				openLOOKUP(attributes)
				
			when 'Message'
				openMessage(attributes)
				
			when 'XParameter'
				openXParameter(attributes)
				
			when 'YParameter'
				openYParameter(attributes)
				
			else
				openUnknown(tag, attributes)
		end	# case
		
	end
	
	


#-------------------------------------------------------------------------------------------------------------#
# tag_end - An ending tag has been parsed
#
# tag - name of tag (element name)
#------------------------------------------------------------------------------------------------------------#
	def tag_end(tag)
		puts "tag_end: #{tag}" unless !$DEBUG
		puts "" if $DEBUG

		case tag
			when 'Ruleset'
				closeRuleset()

			when 'Lookup'
				closeLookup()
				
			when 'LOOKUPS'
				closeLOOKUPS()
				
			when 'LOOKUP'
				closeLOOKUP()
				
			when 'Message'
				closeMessage()
				
			when 'XParameter'
				closeXParameter()
				
			when 'YParameter'
				closeYParameter()
				
			else
				closeUnknown(tag)
		end # case
		
	end
	
	


#-------------------------------------------------------------------------------------------------------------#
# entity - An entity has been parsed
#
# content	- entity content
#------------------------------------------------------------------------------------------------------------#
	def entity(content)
		puts "entity: #{content}" unless !$DEBUG
	end
	
	


#-------------------------------------------------------------------------------------------------------------#
# text - A text node has been parsed
#
# txt	- node text
#------------------------------------------------------------------------------------------------------------#
	def text(txt)
		puts "text: #{txt}" unless !$DEBUG
	end




#-------------------------------------------------------------------------------------------------------------#
# cdata - A cdata node has been parsed
#  Called when <![CDATA[ … ]]> is encountered in a document. @p content "…"
# txt	- node text
#------------------------------------------------------------------------------------------------------------#
	def cdata(txt)
		puts "cdata: #{txt}" unless !$DEBUG
	end




#-------------------------------------------------------------------------------------------------------------#
# openMessage - A Message element has been started
#
# attributes	- Message element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openMessage(attributes)
	end	# openMessage




#-------------------------------------------------------------------------------------------------------------#
# closeMessage - A Message element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeMessage()
	end	# closeMessage




#-------------------------------------------------------------------------------------------------------------#
# openDPM - A DPM element has been started
#
# attributes	- DPM element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openDPM(attributes)
	end	# openDpm




#-------------------------------------------------------------------------------------------------------------#
# closeDPM - A DPM element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeDPM()
	end	# closeDPM




#-------------------------------------------------------------------------------------------------------------#
# openPPM - A PPM element has been started
#
# attributes	- PPM element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openPPM(attributes)
	end	# openPPM




#-------------------------------------------------------------------------------------------------------------#
# closePPM - A PPM element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closePPM()
	end	# closePPM




#-------------------------------------------------------------------------------------------------------------#
# openRule - A Rule element has been started
#
# attributes	- rule element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openRule(attributes)
	end	# openRule




#-------------------------------------------------------------------------------------------------------------#
# closeRule - A Rule element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeRule()
	end	# closeRule




#-------------------------------------------------------------------------------------------------------------#
# openRuleset - A Ruleset element has been started
#
# attributes	- ruleset element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openRuleset(attributes)
	end	# openRuleset




#-------------------------------------------------------------------------------------------------------------#
# closeRuleset - A Ruleset element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeRuleset()
	end	# closeRuleset




#-------------------------------------------------------------------------------------------------------------#
# openLookup - A Lookup element has been started
#
# attributes	- Lookup element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openLookup(attributes)
	end	# openLookup




#-------------------------------------------------------------------------------------------------------------#
# closeLookup - A Lookup element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeLookup()
	end	# closeLookup




#-------------------------------------------------------------------------------------------------------------#
# openLOOKUPS - A LOOKUPS element has been started
#
# attributes	- LOOKUPS element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openLOOKUPS(attributes)
	end	# openLOOKUPS




#-------------------------------------------------------------------------------------------------------------#
# closeLOOKUPS - A LOOKUPS element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeLOOKUPS()
	end	# closeUnknown




#-------------------------------------------------------------------------------------------------------------#
# openLOOKUP - A LOOKUP element has been started
#
# attributes	- LOOKUP element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openLOOKUP(attributes)
	end	# openLOOKUP




#-------------------------------------------------------------------------------------------------------------#
# closeLOOKUP - A LOOKUP element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeLOOKUP()
	end	# closeUnknown




#-------------------------------------------------------------------------------------------------------------#
# openXParameter - A XParameter element has been started
#
# attributes	- XParameter element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openXParameter(attributes)
	end	# openXParameter




#-------------------------------------------------------------------------------------------------------------#
# closeXParameter - A XParameter element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeXParameter()
	end	# closeUnknown




#-------------------------------------------------------------------------------------------------------------#
# openYParameter - A YParameter element has been started
#
# attributes	- YParameter element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openYParameter(attributes)
	end	# openYParameter




#-------------------------------------------------------------------------------------------------------------#
# closeYParameter - A YParameter element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeYParameter()
	end	# closeUnknown




#-------------------------------------------------------------------------------------------------------------#
# openUnknown - A Unknown element has been started
#
# tag				- Tag name of unknown element
# attributes	- Unknown element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openUnknown(tag, attributes)
		puts "opening unknown tag: #{tag}" unless !$DEBUG
	end	# openUnknown




#-------------------------------------------------------------------------------------------------------------#
# closeUnknown - A Unknown element has been ended
#
# tag				- Tag name of unknown element
#
#------------------------------------------------------------------------------------------------------------#
	def closeUnknown(tag)
		puts "closing unknown tag: #{tag}" unless !$DEBUG
	end	# closeUnknown




end	# class Listener



