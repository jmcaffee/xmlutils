#
#	File: gdlTemplate.rb
#
#	This class is used to create the final GDL document
#	
#

require 'xmlutils/gdlcontext'
require 'xmlutils/gdlcontextobjs'


#################################################
#
# class GdlTemplate
#
#################################################
class GdlTemplate
	
	attr_accessor :maxWidth

	def initialize()
		@maxWidth = 75
	end
	



#-------------------------------------------------------------------------------------------------------------#
# fileHeader - generate file header
#
# fname		- file name to place on header
# curDate	- a date string
#
# returns - File header text
#
#------------------------------------------------------------------------------------------------------------#
	def fileHeader(fname, curDate, misc="")
		fname = File.basename(fname, ".gdl")
		header = <<EOF
/* **************************************************************************
 * File: #{fname}.gdl
 *
 * Guideline source generated #{curDate}
 * #{misc}
 *
 * *************************************************************************/

	
EOF

		return header
	end # fileHeader
	


#-------------------------------------------------------------------------------------------------------------#
# sectionComment - generate definition header
#
# headerType	- Header type (ex: DSM)
#
# returns - definition header text
#
#------------------------------------------------------------------------------------------------------------#
	def sectionComment(sectionName)
		txt = sectionName.strip
		bar = ""
																		# 6: 5 misc chars (// ) plus 1
		width = (@maxWidth - 6 - txt.length) / 2
		width.times do
			bar += "+"
		end
		
		header = <<EOF




// #{bar} #{txt} #{bar}
		
EOF

		header

	end # def sectionComment




#-------------------------------------------------------------------------------------------------------------#
# multiLineComment - generate a multi line comment block
#
# comment	- comment text
#
# returns - multi line comment block
#
#------------------------------------------------------------------------------------------------------------#
	def multiLineComment(comment, header = "")
		bar 		= ""
		hdrBar	= ""
		
																		# 3: 3 misc chars (/* )
		width = (@maxWidth - 3)

		width.times do
			bar += "*"
		end
		
		if (header.length > 0)					# Generate a formatted header if it exists.
			hdrWidth = (@maxWidth - 6 - header.length) / 2
		
			hdrWidth.times do
				hdrBar += " "
			end # times
		end # if header
		
		output = <<EOF




/* #{bar}
#{hdrBar}-- #{header} --#{hdrBar}

#{comment}

#{bar} */



		
EOF

		output

	end # def multiLineComment




#-------------------------------------------------------------------------------------------------------------#
# ppm - generate a PPM definition 
#
# var	- XML element to generate output for
#
# @returns	GDL output for PPM definition
#
#------------------------------------------------------------------------------------------------------------#
	def ppm(dataType, ppmType, varName, varAlias)
    dt = dataType.ljust(12)
    pt = ppmType.ljust(12)
    vn = varName.ljust(48)
    va = varAlias
    out = <<EOF
ppm #{dt}#{pt}#{vn}"#{va}";
EOF
		
		out																								# Return generated output
	end # ppm
	
	
#-------------------------------------------------------------------------------------------------------------#
# dsm - generate a GDL version of a DSM definition based on DSM XML element
#
# var	- XML element to generate output for
#
# @returns	GDL output for DSM definition
#
#------------------------------------------------------------------------------------------------------------#
	def dsm(dataType, varName, varAlias)
    dsn = "decision".ljust(16)
	dpm = "dpm".ljust(4)
	dt = dataType.ljust(12)
    vn = varName.ljust(48)
	
		out = <<EOF
#{dsn}#{dpm}#{dt}#{vn}"#{varAlias}";
EOF
		
		out																								# Return generated output
	end # dsm
	
	
#-------------------------------------------------------------------------------------------------------------#
# dpm - generate a GDL version of a DPM definition based on DPM XML element
#
# var	- XML element to generate output for
#
# @returns	GDL output for DPM definition
#
#------------------------------------------------------------------------------------------------------------#
	def dpm(dataType, varName, varAlias)
    lead = " ".ljust(16)
	dpm = "dpm".ljust(4)
	dt = dataType.ljust(12)
    vn = varName.ljust(48)
	
		out = <<EOF
#{lead}#{dpm}#{dt}#{vn}"#{varAlias}";
EOF
		
		out																								# Return generated output
	end # dpm




#-------------------------------------------------------------------------------------------------------------#
# rule - output a rule
#
# ofile	- output file handle
#
#------------------------------------------------------------------------------------------------------------#
	def rule(rule)

		# Rule output is generated in GdlDoc.visitRule()
		return rule.src
		
	end # def rule




#-------------------------------------------------------------------------------------------------------------#
# ruleset - output collected variables to file
#
# ofile	- output file handle
#
#------------------------------------------------------------------------------------------------------------#
	def ruleset(ruleset, ctx)
		rulelist = rulelist(ruleset, ctx)

		cmtSuffix = ""
		ruleParams = "#{ruleset.execType}"			# Build the ruleset parameter list.
		
		if (ruleset.type == "PL")
			ruleParams += ", PL"
			cmtSuffix += "(PowerLookup)"
		end # if ruleset.type
		
		aliasStmt = ""													# Don't create an alias statement if it is not needed.
		
		if (ruleset.name != ruleset.alias)
			aliasStmt = <<EOF
alias(ruleset, #{ruleset.name}, "#{ruleset.alias}");
EOF
		end # if ruleset.name...
		
		
		out = <<EOF
#{aliasStmt}
/* ==========================================================================
 * #{ruleset.name} #{cmtSuffix}
 *
 *
 */
ruleset #{ruleset.name}(#{ruleParams})
#{rulelist}
end // ruleset #{ruleset.name}(#{ruleParams})




EOF

		return out
		
	end # def ruleset




#-------------------------------------------------------------------------------------------------------------#
# rulelist - output ruleset's rule ref list
#
# returns ruleset rule list source
#
#------------------------------------------------------------------------------------------------------------#
	def rulelist(ruleset, ctx)

		outlist = ""
		
		ruleset.rules.each do |ralias|
			rname = ctx.rules[ralias].name
			outlist += reference("rule", rname)
			
		end # rules.each

		return outlist
		
	end # def rulelist




#-------------------------------------------------------------------------------------------------------------#
# reference - output rule/set reference
#
# returns rule/set reference source
#
#------------------------------------------------------------------------------------------------------------#
	def reference(refType, refName)

		refout = <<EOF
    #{refType}  #{refName}();
EOF

		return refout
		
	end # def reference




#-------------------------------------------------------------------------------------------------------------#
# cleanMsgText - msg text to clean. Converts double quotes to single quotes.
#
# returns cleaned text
#
#------------------------------------------------------------------------------------------------------------#
	def cleanMsgText(txt)
		clean = txt.gsub(/["]/,"'")
		
		clean
	end # cleanMsgText
	
	
	
	
#-------------------------------------------------------------------------------------------------------------#
# msg - output a message
#
# returns message source
#
#------------------------------------------------------------------------------------------------------------#
	def msg(msgObj)

		raise "Bad argument" if (nil == msgObj)
		
		isCondition = false
		isException = false
		
		msgTxt	= cleanMsgText(msgObj.msg)
		msgTag	= "message"
		msgType = ""
																							# Determine message type
		case msgObj.type
			when 'Condition'
				isCondition = true
				msgTag	= "condition"

			when 'Exceptions'
				msgType += "exception"
				isException = true

			when 'Observation'
				msgType += "observation"

			when 'Findings'
				msgType += "findings"

			when 'Credit'
				msgType += "credit"

		end # case msgObj.type
		
																							
		if (isCondition)													# Handle condition messages
		
			case msgObj.category										# Handle condition message category type
				when '1'
					msgType += "asset"
					
				when '2'
					msgType += "credit"
					
				when '3'
					msgType += "income"
					
				when '4'
					msgType += "property"
					
				when '5'
					msgType += "purchase"
					
				when '6'
					msgType += "title"
					
				else
					msgType += " asset"
				
			end # case category
			


			case msgObj.priorTo											# Handle condition message priorTo type
				when '1'
					msgType += ", docs"
					
				when '2'
					msgType += ", funding"
					
				when '3'
					msgType += ", approval"
					
				else
					msgType += ", docs"
				
			end # case priorTo
			
		end # if isCondition
		
		
		
		
		msgout = <<EOF
        #{msgTag}(#{msgType}, "#{msgTxt}");
EOF

		return msgout
		
	end # def msg




#-------------------------------------------------------------------------------------------------------------#
# guideline - output collected variables to file
#
# ofile	- output file handle
#
#------------------------------------------------------------------------------------------------------------#
	def guideline(ctx)
		gdlout 	= ""
		reflist	= ""
		return gdlout if( ctx.guideline.nil? )
		
		if( ! ctx.guideline.items.nil? )
			ctx.guideline.items.each do |item|
				rname = "UNKNOWN"
				if (item[0] == 'rule')
					rname = ctx.rules[item[1]].name
				elsif (item[0] == 'ruleset')
					rname = ctx.rulesets[item[1]].name
				end # if item
				
				reflist += reference(item[0], rname)
				
			end # items.each
		end

gdlout = <<EOF
/* ==========================================================================
 * #{ctx.guideline.name}
 *
 * ID:         #{ctx.guideline.id}
 * Version:    #{ctx.guideline.version}
 * Start Date: #{ctx.guideline.startDate}
 *
 */
guideline("#{ctx.guideline.name}")

#{reflist}

end // guideline #{ctx.guideline.name}
EOF

		return gdlout

	end # def guideline



#-------------------------------------------------------------------------------------------------------------#
# lookup - output lookup reference
#
# returns lookup reference source
#
#------------------------------------------------------------------------------------------------------------#
	def lookup(lkupName, xParamName, yParamName)

		
		refout = 'lookup("' + "#{lkupName}" + '", ' + "#{xParamName}, #{yParamName})"

		return refout
		
	end # def lookup




	
	



end	# class GdlTemplate



