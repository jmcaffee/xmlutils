#
#	File: XmlRuleVisitor.rb
#
#	This class is used to visit XML guideline elements
#	
#

require 'rexml/document'
require 'rexml/streamlistener'
require 'logger'
require 'xmlUtils/xmlVisitor'
require 'xmlUtils/gdlTemplate'

#################################################
#
# class XmlRuleVisitor
#
#################################################
class XmlRuleVisitor < XmlVisitor
	include REXML
	
	attr_accessor :lookupData
	attr_accessor :context
	attr_accessor :template
	
	
	
#-------------------------------------------------------------------------------------------------------------#
# initialize - Constructor
#
#
#------------------------------------------------------------------------------------------------------------#
	def initialize(ctx)
		super()
		@output = ""
		@lookupData = Hash.new
		@context	= ctx
		@template	= GdlTemplate.new

		#@log	= Logger.new(STDOUT)
		#@log.level = Logger::DEBUG
		
		
	end
	
	
	
	
#-------------------------------------------------------------------------------------------------------------#
# generateMsg - Generate a message
#
# msgTxt	- Text of message. Used to lookup message details from context
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def generateMsg(msgTxt)
		msgOut = ""
		msgData = @context.messages[msgTxt]
		
		if (nil != msgData)
			msgOut = @template.msg(msgData)
		end
		
		msgOut
	end # generateMsg
	
	
	
	
#-------------------------------------------------------------------------------------------------------------#
# visitRule - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitRule(elem, data)
		@@log.debug("XmlRuleVisitor::visitRule")
		@@log.debug(elem.inspect)
		
		
		ruleAlias	= elem.attributes['Name']
		ruleData	= @context.rules[ruleAlias]
		raise "Rule data not found: #{ruleAlias}" unless (ruleData.kind_of? Rule)
		
		ruleName = ruleData.name

		ruleCond = ""
		elem.each_element do |child|
			if ("Condition" == child.name)
				ruleCond = visit(child, ruleCond)
				break
			end
		end
		
		ifActions = ""
		elem.each_element do |child|
			if ("IfActions" == child.name)
				ifActions = visit(child, ifActions)
				break
			end
		end
		
		elseActions = ""
		elem.each_element do |child|
			if ("ElseActions" == child.name)
				elseActions = visit(child, elseActions)
				break
			end
		end
		

		ifMsgs = ""																# Generate 'If' messages
		ruleData.ifMsgs.each do |msgTxt|
			ifMsgs += generateMsg(msgTxt)
		end	# ifMsgs.each

		elseMsgs = ""															# Generate 'Else' messages
		ruleData.elseMsgs.each do |msgTxt|
			elseMsgs += generateMsg(msgTxt)
		end	# ifMsgs.each



		aliasStmt = ""													# Don't create an alias statement if it is not needed.
		if (ruleName != ruleAlias)
			aliasStmt = <<EOF
alias(rule, #{ruleName}, "#{ruleAlias}");
EOF
		end # if rulename...
		
																						# Create rule template
		output = <<EOF
#{aliasStmt}
/* ==========================================================================
 * #{ruleName}
 *
 *
 */
rule #{ruleName}()
    if(
        #{ruleCond}
      )
    then
        #{ifActions}
#{ifMsgs}
EOF

		if (elseActions.length > 0)
			output += <<EOF
    else
        #{elseActions}
#{elseMsgs}
EOF
		end
		
		output += <<EOF
    end
end	// rule #{ruleName}




EOF
		
		data += output
		return data
	end	# visitRule




#-------------------------------------------------------------------------------------------------------------#
# visitXmlFunction - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitXmlFunction(elem, data)
		@@log.debug("XmlRuleVisitor::visitXmlFunction")
		@@log.debug(elem.inspect)
		
		funcName	= elem.attributes['Name']

		funcArgs = ''
		elem.each_element do |child|
			funcArgs = visit(child, funcArgs)
		end
		
		output = "#{funcName}#{funcArgs}"
		data += output
		return data
	end	# visitXmlFunction


#-------------------------------------------------------------------------------------------------------------#
# visitArgs - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitArgs(elem, data)
		@@log.debug("XmlRuleVisitor::visitArgs")
		@@log.debug(elem.inspect)
		
		argsData = ''
		elem.each_element do |child|
			argsData = visit(child, argsData)
		end
		
		output = "( #{argsData} )"
		data += output
		return data
	end	# visitArgs


#-------------------------------------------------------------------------------------------------------------#
# visitArg - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitArg(elem, data)
		@@log.debug("XmlRuleVisitor::visitArg")
		@@log.debug(elem.inspect)
		
		argData = ''
			
		elem.each_element do |child|
			argData += ", " if(!data.empty?)
			argData = visit(child, argData)
		end
		
		data += argData
		return data
	end	# visitArg


#-------------------------------------------------------------------------------------------------------------#
# visitCompute - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitCompute(elem, data)
		@@log.debug("XmlRuleVisitor::visitCompute")
		@@log.debug(elem.inspect)
		
		if (3 != elem.elements.size)
			@@log.error("Compute element did not have the expected number of child elements.")
			return data
		end
		
		# visit the left side
		data = visit(elem.elements[2], data)

		# visit the operator
		data = visit(elem.elements[1], data)

		# visit the right side
		data = visit(elem.elements[3], data)

		return data
	end	# visitCompute




#-------------------------------------------------------------------------------------------------------------#
# visitExpression - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitExpression(elem, data)
		@@log.debug("XmlRuleVisitor::visitExpression")
		@@log.debug(elem.inspect)
		
		elem.each_element do |child|
			data = visit(child, data)
		end
		
		return data
	end	# visitExpression




#-------------------------------------------------------------------------------------------------------------#
# visitLeftOperand - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitLeftOperand(elem, data)
		@@log.debug("XmlRuleVisitor::visitLeftOperand")
		@@log.debug(elem.inspect)
		
		elem.each_element do |child|
			data = visit(child, data)
		end
		
		return data
	end	# visitLeftOperand




#-------------------------------------------------------------------------------------------------------------#
# visitRightOperand - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitRightOperand(elem, data)
		@@log.debug("XmlRuleVisitor::visitRightOperand")
		@@log.debug(elem.inspect)
		
		elem.each_element do |child|
			data = visit(child, data)
		end
		
		return data
	end	# visitRightOperand




#-------------------------------------------------------------------------------------------------------------#
# visitOperator - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitOperator(elem, data)
		@@log.debug("XmlRuleVisitor::visitOperator")
		@@log.debug(elem.inspect)
		
		if (!elem.has_text?)
			@@log.error("An OPERATOR element does not have any text.")
			return data
		end
		
		case elem.text
			when '&lt;'
				data += ' < '
				
			when '&gt;'
				data += ' > '
				
			when '&lt;&gt;', '<>'
				data += ' != '
				
			when 'OR'
				data += " ||\n\t\t"
				
			when 'AND'
				data += " &&\n\t\t"
				
			else
				data += " #{elem.text} "
		end
		
		return data
	end	# visitOperator




#-------------------------------------------------------------------------------------------------------------#
# visitBrace - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitBrace(elem, data)
		@@log.debug("XmlRuleVisitor::visitBrace")
		@@log.debug(elem.inspect)
		
		data += "("
		
		elem.each_element do |child|
			data = visit(child, data)
		end

		data += ")"
		
		return data
	end	# visitBrace




#-------------------------------------------------------------------------------------------------------------#
# visitConstant - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitConstant(elem, data)
		@@log.debug("XmlRuleVisitor::visitConstant")
		@@log.debug(elem.inspect)
		
		if (!elem.has_text?)
			@@log.error("A CONSTANT element does not have any text.")
			return data
		end
		
		text = elem.text
		num = isNumber(text)
		if (nil != num)
			data += num.to_s													# TODO Fix the fact that numbers are also returned as text.
		else
			data += "\"#{text}\""
		end

		return data
	end	# visitConstant

		



#-------------------------------------------------------------------------------------------------------------#
# isNumber - Determine if a string is in fact a number
#
# text	- string to check
#
# @returns	boolean
#
#------------------------------------------------------------------------------------------------------------#
	def isNumber(text)
		@@log.debug("XmlRuleVisitor::isNumber")
		@@log.debug(text.inspect)
		
		if (nil != text.index('.'))
			num = text.to_f
			if (num.to_s == text)
				@@log.debug("isNumber: float: #{num.to_s}")
				return num
			end # if num
		end # if nil
		
		num = text.to_i
		if (num.to_s == text)
				@@log.debug("isNumber: int: #{num.to_s}")
			return num
		end # if num
		
		return nil
		
	end	# isNumber




#-------------------------------------------------------------------------------------------------------------#
# visitPPM - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitPPM(elem, data)
		@@log.debug("XmlRuleVisitor::visitPPM")
		@@log.debug(elem.inspect)
		
		varName = @context.ppms[elem.attributes['Name']].name

		data += varName
		
		return data
	end	# visitPPM




#-------------------------------------------------------------------------------------------------------------#
# visitDPM - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitDPM(elem, data)
		@@log.debug("XmlRuleVisitor::visitDPM")
		@@log.debug(elem.inspect)
		
		varName = @context.dpms[elem.attributes['Name']].name
		
		data += varName
		
		return data
	end	# visitDPM




#-------------------------------------------------------------------------------------------------------------#
# visitAssign - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitAssign(elem, data)
		@@log.debug("XmlRuleVisitor::visitAssign")
		@@log.debug(elem.inspect)
		
		if (elem.elements.size < 1)
			@@log.error("Assign element has no children.")
		end
		
		if (2 != elem.elements.size)
			@@log.error("Assign element did not have the expected number of child elements.")
			return data
		end
		
		# visit the left side
		data = visit(elem.elements[1], data)
		
		data += " = "														# Add the equals sign.
		
		# visit the assignment
		data = visit(elem.elements[2], data)

		data += ";\n\t\t"														# Terminate the statement.
		
		return data
	end	# visitAssign




#-------------------------------------------------------------------------------------------------------------#
# visitAssignTo - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitAssignTo(elem, data)
		@@log.debug("XmlRuleVisitor::visitAssignTo")
		@@log.debug(elem.inspect)
		
		if (elem.elements.size < 1)
			@@log.error("AssignTo element has no children.")
		end
		
		elem.each_element do |child|
			data = visit(child, data)
		end
		
		return data
	end	# visitAssignTo




#-------------------------------------------------------------------------------------------------------------#
# visitAssignValue - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitAssignValue(elem, data)
		@@log.debug("XmlRuleVisitor::visitAssignValue")
		@@log.debug(elem.inspect)
		
		if (elem.elements.size < 1)
			@@log.error("AssignValue element has no children.")
		end
		
		elem.each_element do |child|
			data = visit(child, data)
		end
		
		return data
	end	# visitAssignValue




#-------------------------------------------------------------------------------------------------------------#
# visitLookup - Handle default parsing
#
# elem	- Element to visit
#	data	- output object to append GDL text to
#
# @returns	GDL output
#
#------------------------------------------------------------------------------------------------------------#
	def visitLookup(elem, data)
		@@log.debug("XmlRuleVisitor::visitLookup")
		@@log.debug(elem.inspect)
		
		lkName = elem.attributes['Name']
		lkParams = @context.getLookupParamNames(lkName)
		
		data += @template.lookup(lkName, lkParams["xparam"], lkParams["yparam"])
			
		return data

		lkup = @context.lookups[lkName]
		
		#puts lkup.inspect
		
		x = nil
		y = nil
		
		if (isPpmVar(lkup.xParam))
			x = @context.ppms[lkup.xParam.alias]
		else
			x = @context.dpms[lkup.xParam.alias]
		end # if PPM

		#puts x.inspect
		
		if (isPpmVar(lkup.yParam))
			y = @context.ppms[lkup.yParam.alias]
		else
			y = @context.dpms[lkup.yParam.alias]
		end # if PPM

		#puts y.inspect
		
		if (nil == x)
			raise "Unable to find xParam (#{lkup.xParam.alias}) in lookup #{lkName}"
		end # if nil
		
		if (nil == y)
			raise "Unable to find yParam (#{lkup.yParam.alias}) in lookup #{lkName}"
		end # if nil
		
#		data += lkup.toGdlRef()
		data += @template.lookup(lkName, x.name, y.name)
			
		return data
	end	# visitLookup




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
	
end	# class XmlRuleVisitor
