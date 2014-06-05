#
#	File: contextListener.rb
#
#	This class is used to convert XML to GDL
#	
#

require 'rexml/streamlistener'
require 'xmlutils/gdlcontext'
require 'xmlutils/gdlcontextobjs'
require 'xmlutils/listener'

include REXML




#################################################
#
# class ContextListener
#
#################################################
class ContextListener < Listener
	
  attr_reader :context
  attr_writer :curRuleset
  attr_writer :curLookup

  attr_writer :curParam
  
  attr_writer :inMsg





	def initialize(ctx)
		super()
		@context 		= ctx
		@curRuleset	= nil
		@curLookup 	= nil
		@curParam 	= nil
		@curMsg			= nil
		
		@inMsg			= false
		
	end
	



  def inMsg?
    return @inMsg
  end
	



  def processingRuleset?
    return true unless (nil == @curRuleset)
    return false
  end
	



  def processingLookup?
    return true unless (nil == @curLookup)
    return false
  end
	



  def isXParam?
    return true unless ('X' != @curParam)
    return false
  end
	



  def isYParam?
    return true unless ('Y' != @curParam)
    return false
  end



	
#-------------------------------------------------------------------------------------------------------------#
# cdata - A cdata node has been parsed
#  Called when <![CDATA[ … ]]> is encountered in a document. @p content "…"
# txt	- node text
#------------------------------------------------------------------------------------------------------------#
	def cdata(txt)
		if (inMsg?)
			raise "Message object has not yet been created." if (nil == @curMsg)
			@curMsg.msg = txt
			
		end # if inMsg
	end




#-------------------------------------------------------------------------------------------------------------#
# openDPM - Add a DPM variable to the context object
#
# attributes	- DPM element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openDPM(attributes)
		dpmAlias 	= attributes["Name"]
		confName 	= @context.createValidName(dpmAlias)
#		varType  	= attributes["Type"]
#		dataType	= attributes["DataType"] if attributes.has_key?("DataType")
#		prodType	= attributes["ProductType"]
#
#		dataType = prodType if nil == dataType
#		
#		dpm = Dpm.new(confName, dpmAlias, varType, dataType, prodType)
		dpm = Dpm.new(confName, attributes)
		
		@context.dpms[dpmAlias] = dpm
		
		if (processingLookup?)
			addLookupParam(dpm)
		end
		
	end	# openDPM
	



#-------------------------------------------------------------------------------------------------------------#
# openPPM - Add a PPM variable to the context object
#
# attributes	- PPM element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openPPM(attributes)
		ppmAlias 	= attributes["Name"]
		confName 	= "p" + @context.createValidName(ppmAlias)
#		varType  	= attributes["Type"]
#		dataType	= attributes["DataType"] if attributes.has_key?("DataType")

#		dataType = "Text" if nil == dataType
		
#		ppm = Ppm.new(confName, ppmAlias, varType, dataType)
		ppm = Ppm.new(confName, attributes)
		
		@context.ppms[ppmAlias] = ppm

		if (processingLookup?)
			addLookupParam(ppm)
		end
		
	end	# openPPM




#-------------------------------------------------------------------------------------------------------------#
# openRule - Add a rule to the context object
#
# attributes	- rule element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openRule(attributes)
		ruleAlias = attributes["Name"]
		confName = @context.createValidName(ruleAlias)
		
		rule = Rule.new(confName, ruleAlias)
		
		@context.rules[ruleAlias] = rule
		
		@curRuleset.addRule(ruleAlias) if (processingRuleset?)
		
	end	# openRule
	


#-------------------------------------------------------------------------------------------------------------#
# openRuleset - Open a ruleset object
#
# attributes	- ruleset element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openRuleset(attributes)
		if (processingRuleset?)
			closeRuleset
		end	# if
		
		rs = Ruleset.new(attributes)
		rs.name = @context.createValidName(rs.alias)
		
		@curRuleset = rs
		
	end	# openRuleset
	


#-------------------------------------------------------------------------------------------------------------#
# closeRuleset - Close a ruleset object
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeRuleset()
		if (processingRuleset?)
			rsAlias = @curRuleset.alias
			@context.rulesets[rsAlias] = @curRuleset
		end	# if

		@curRuleset = nil		
		
	end	# closeRuleset
	


#-------------------------------------------------------------------------------------------------------------#
# openMessage - A Message element has been started
#
# name				- Tag name of unknown element
# attributes	- Message element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openMessage(attributes)
		if ($DEBUG)
			puts "openMessage"

			if(!attributes.empty?)
				puts "      Attr:"
				attributes.each do |attr|
					puts "            #{attr[0]}: #{attr[1]}"
				end
			end
		end # if $DEBUG
		
		if (inMsg?)
			closeMessage()
		end # if inMsg
		
		@inMsg = true
		
		@curMsg = Message.new(attributes)
		
	end	# openMessage




#-------------------------------------------------------------------------------------------------------------#
# closeMessage - A Message element has been ended
#
# name				- Tag name of unknown element
#
#------------------------------------------------------------------------------------------------------------#
	def closeMessage()
		puts "closeMessage" if $DEBUG
		if (inMsg?)
			msgDone(@curMsg)			# Close out the msg
			@curMsg = nil
			@inMsg = false
		end	# if inMsg
	end	# closeMessage




#-------------------------------------------------------------------------------------------------------------#
# msgDone - A message is finished. Handle it by putting it in the If que or the Else que
#
# msg		  - Complete Message object
#
#------------------------------------------------------------------------------------------------------------#
	def msgDone(msg)
		puts "msgDone" if $DEBUG

		if (msg.msg == nil || msg.msg.length < 1)
			#raise "Blank message text. Unable to store message in context."
			puts "Blank message text. Unable to store message in context."
			return
		end # if msg blank
		
		@context.messages[msg.msg] = msg
		
		puts msg.inspect if $DEBUG
	end	# msgDone




#-------------------------------------------------------------------------------------------------------------#
# openLOOKUP - A LOOKUP element has been started
#
# attributes	- LOOKUP element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openLOOKUP(attributes)
		if (processingLookup?)
			closeLOOKUP
		end	# if
		
		lk = Lookup.new(attributes)
		
		@curLookup = lk
		
	end	# openLOOKUP




#-------------------------------------------------------------------------------------------------------------#
# closeLOOKUP - A LOOKUP element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeLOOKUP()
		if (processingLookup?)
			lkName = @curLookup.name
			@context.lookups[lkName] = @curLookup
		end	# if

		@curLookup = nil		
		
	end	# closeUnknown




#-------------------------------------------------------------------------------------------------------------#
# addLookupParam - A LOOKUP parameter element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def addLookupParam(var)
		if (processingLookup?)
			if (isXParam?)
				@curLookup.xParam = var
			end
			
			if (isYParam?)
				@curLookup.yParam = var
			end
			
		end	# if

	end	# addLookupParam




#-------------------------------------------------------------------------------------------------------------#
# openXParameter - A XParameter element has been started
#
# attributes	- XParameter element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openXParameter(attributes)
		@curParam = "X"
	end	# openXParameter




#-------------------------------------------------------------------------------------------------------------#
# closeXParameter - A XParameter element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeXParameter()
		@curParam = ""
	end	# closeUnknown




#-------------------------------------------------------------------------------------------------------------#
# openYParameter - A YParameter element has been started
#
# attributes	- YParameter element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openYParameter(attributes)
		@curParam = "Y"
	end	# openYParameter




#-------------------------------------------------------------------------------------------------------------#
# closeYParameter - A YParameter element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeYParameter()
		@curParam = ""
	end	# closeYParameter




#-------------------------------------------------------------------------------------------------------------#
# openXmlFunction - A XmlFunction element has been started
#
# attributes	- XmlFunction element attributes
#
#------------------------------------------------------------------------------------------------------------#
	def openXmlFunction(attributes)
		@curParam = "Y"
	end	# openXmlFunction




#-------------------------------------------------------------------------------------------------------------#
# closeXmlFunction - A XmlFunction element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
	def closeXmlFunction()
		@curParam = ""
	end	# closeXmlFunction




end	# class ContextListener



