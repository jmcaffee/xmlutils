#
#	File: gdlDoc.rb
#
#	This class is used to create the final GDL document
#	
#

require 'xmlUtils/gdlContextObjs'
require 'xmlUtils/gdlTemplate'
require 'date'





#################################################
#
# class GdlDoc
#
#################################################
class GdlDoc
	
  attr_reader :context
  attr_reader :srcFile
  attr_reader :rootDir

  


	def initialize(srcFile, rootDir, ctx)
		super()
		@srcFile			= srcFile
		@rootDir 			= rootDir
		@context 			= ctx
	end
	



#------------------------------------------------------------------------------------------------------------#
# setOptions - Set configuration option flags
#
# flg	- Array of options or single string option. Currently, only -v: verbose is available
#
#------------------------------------------------------------------------------------------------------------#
	def setOptions(flgs)
		if (flgs.class == Array)
			flgs.each do |f|
				case f
					when '-v'
						@verbose = true
				end
			end # flgs.each
			
			return
		end # if flgs
		
		case flgs
			when '-v'
				@verbose = true
		end
		
	end

	


#-------------------------------------------------------------------------------------------------------------#
# currentDate - Generate today's date string
#
#
#------------------------------------------------------------------------------------------------------------#
	def currentDate()
		now = DateTime::now()
		return now.strftime("%m/%d/%Y %H:%M:%S")
	end	# currentDate




#-------------------------------------------------------------------------------------------------------------#
# generate - Generate a GDL document
#
# returns string - generated file name
#
#------------------------------------------------------------------------------------------------------------#
	def generate()
		if ($DEBUG)
			puts "generate:"
			puts "       source: #{@srcFile}"
			puts "      rootDir: #{@rootDir}"
			puts "      context: #{@context}"
		end # if $DEBUG
		
		tpl = GdlTemplate.new
		
		genFile = "#{@rootDir}/#{@srcFile}.gdl"
		
		createOutdir(@rootDir)

		File.open("#{genFile}", "w") do |ofile|
		
			ofile << tpl.fileHeader(@srcFile, currentDate() )


			ofile << tpl.sectionComment("DPM Definitions")
			
			vars = @context.dpms.sort {|a, b| a[1].name.downcase <=> b[1].name.downcase}
			vars.each do |rDpm|
				dpm = rDpm[1]
				if (dpm.varType == "DPM")
					ofile << tpl.dpm(dpm.prodType, dpm.name, dpm.alias)
				end # if dpm
			end # do
				
#			@context.dpms.each do |key, dpm|
#				if (dpm.varType == "DPM")
#					ofile << tpl.dpm(dpm.prodType, dpm.name, dpm.alias)
#				end # if dpm
#			end # dpms.each
			

			ofile << tpl.sectionComment("DSM Definitions")

			
			vars = @context.dpms.sort {|a, b| a[1].name.downcase <=> b[1].name.downcase}
			vars.each do |rDpm|
				dpm = rDpm[1]
				if (dpm.varType == "DSM")
					ofile << tpl.dsm(dpm.prodType, dpm.name, dpm.alias)
				end # if dpm
			end # do
				
#			@context.dpms.each do |key, dpm|
#				if (dpm.varType == "DSM")
#					ofile << tpl.dsm(dpm.prodType, dpm.name, dpm.alias)
#				end # if dsm
#			end # dsms.each
			

			ofile << tpl.sectionComment("PPM Definitions")

			vars = @context.ppms.sort {|a, b| a[1].name.downcase <=> b[1].name.downcase}
			vars.each do |rPpm|
				ppm = rPpm[1]
				ofile << tpl.ppm(ppm.dataType, ppm.varType, ppm.name, ppm.alias)
			end # do
				
#			@context.ppms.each do |key, ppm|
#				ofile << tpl.ppm(ppm.dataType, ppm.varType, ppm.name, ppm.alias)
#			end # ppms.each
			

			ofile << tpl.multiLineComment(buildLookupList(), "Lookups that need to be imported")
			
			
			ofile << tpl.sectionComment("Rule Definitions")

			rules = @context.rules.sort {|a, b| a[1].name.downcase <=> b[1].name.downcase}
			rules.each do |rrule|
				rule = rrule[1]
				ofile << tpl.rule(rule)
			end # do
				
#			@context.rules.each do |key, rule|
#				ofile << tpl.rule(rule)
#			end # rules.each
			
			
			ofile << tpl.sectionComment("Ruleset Definitions")

			rulesets = @context.rulesets.sort {|a, b| a[1].name.downcase <=> b[1].name.downcase}
			rulesets.each do |rruleset|
				ruleset = rruleset[1]
				ofile << tpl.ruleset(ruleset, @context)
			end # do
				
#			@context.rulesets.each do |key, ruleset|
#				ofile << tpl.ruleset(ruleset, @context)
#			end # ruleset.each
			
			
			ofile << tpl.sectionComment("Guideline Definition")
			ofile << tpl.guideline(@context)


		end
		
		return genFile
		
	end	# generate

	


#-------------------------------------------------------------------------------------------------------------#
# generateRenameList - Generate a CSV rename list
#
# returns string - generated file name
#
#------------------------------------------------------------------------------------------------------------#
	def generateRenameList()
		if ($DEBUG)
			puts "generateRenameList:"
			puts "       source: #{@srcFile}"
			puts "      rootDir: #{@rootDir}"
			puts "      context: #{@context}"
		end # if $DEBUG
		
		genFile = "#{@rootDir}/#{@srcFile}.rename.csv"
		
		createOutdir(@rootDir)

		File.open("#{genFile}", "w") do |ofile|
		
																						# Don't add to list if alias has '.'.
																						# Don't add to list if alias and name are identical.
			vars = @context.rules.sort {|a, b| a[0].downcase <=> b[0].downcase}
			vars.each do |ruleAry|
				rule = ruleAry[1]
				if (ruleAry[0] != rule.name)
					if (nil == ruleAry[0].index('.'))
						ofile << "rule,#{ruleAry[0]},#{rule.name}\n"
					end # if no period
				end # if name and alias do not match
			end # do
				
			

			
																						# Don't add to list if ruleset is powerlookup.
																						# Don't add to list if alias and name are identical.
			vars = @context.rulesets.sort {|a, b| a[0].downcase <=> b[0].downcase}
			vars.each do |rulesetAry|
				ruleset = rulesetAry[1]
				if ("PL" != ruleset.type)
					if (rulesetAry[0] != ruleset.name)
						ofile << "ruleset,#{rulesetAry[0]},#{ruleset.name}\n"
					end # if not identical
				end # if not PL ruleset
			end # do
				
			

		end
		
		return genFile
		
	end	# generateRenameList

	


#-------------------------------------------------------------------------------------------------------------#
# buildLookupList - Create a listing of lookup definitions from the context
#
#
#------------------------------------------------------------------------------------------------------------#
	def buildLookupList()
		lkups = Hash.new
		lkList = ""
		tpl = GdlTemplate.new
		
		@context.lookups.each do |lkName, lkup|
			params = @context.getLookupParamNames(lkName)
			lkups[lkName] = tpl.lookup(lkName, params["xparam"], params["yparam"])
#			lkList += tpl.lookup(lkName, params["xparam"], params["yparam"])
#			lkList += ";\n"			# Put each lookup on a seperate line
		end # do

		sorted = lkups.sort {|a, b| a[0].downcase <=> b[0].downcase}		
		sorted.each do |item|
			lkList += "#{item[1]};\n"
		end # do sorted
		
		return lkList
	end # def buildLookupList
	



#-------------------------------------------------------------------------------------------------------------#
# createOutdir - Create a directory if it does not exist
#
# outdir	- Directory name/path to create
#
#------------------------------------------------------------------------------------------------------------#
	def createOutdir(outdir)
		if( !File.directory?(outdir) )
			FileUtils.makedirs("#{outdir}")
		end
	
	end # def createOutdir
	



#-------------------------------------------------------------------------------------------------------------#
# outputFileHeader - output file header
#
# ofile		- output file to write header to
# infile	- Name of file to create header for
#
#------------------------------------------------------------------------------------------------------------#
	def outputFileHeader(ofile, infile)
		header = <<EOF
/* **************************************************************************
 * File: #{infile}.gdl
 * Generated guideline
 *
 * *************************************************************************/

	
EOF

		ofile << header
	end
	


#-------------------------------------------------------------------------------------------------------------#
# definitionHeader - output collected variables to file
#
# headerType	- Header type (ex: DSM)
#
#------------------------------------------------------------------------------------------------------------#
	def definitionHeader(headerType)
		header = <<EOF




// ---------------------------- #{headerType} definitions ----------------------------
		
EOF

		header

	end # def definitionHeader




#-------------------------------------------------------------------------------------------------------------#
# outputPpm - generate a GDL version of a PPM definition based on PPM XML element
#
# var	- XML element to generate output for
#
# @returns	GDL output for PPM definition
#
#------------------------------------------------------------------------------------------------------------#
	def outputPpm(var)
		xVarType = "text"
		xvarSection	= var.attribute('Type').to_s
		
		case xvarSection
			when 'APM'
				varSection = "app"
				
			when 'PRD'
				varSection = "prd"
				
			when 'CRP'
				varSection = "crd"
		end
		
		varAlias = var.attribute('Alias')
		varName = var.attribute('Name')

		
		out = <<EOF
	ppm	#{xVarType}	#{varSection}	p#{varName}		"#{varAlias}";
EOF
		
		out																								# Return generated output
	end # outputPpm
	
	
#-------------------------------------------------------------------------------------------------------------#
# outputDsm - generate a GDL version of a DSM definition based on DSM XML element
#
# var	- XML element to generate output for
#
# @returns	GDL output for DSM definition
#
#------------------------------------------------------------------------------------------------------------#
	def outputDsm(var)
		xVarType = var.attribute('ProductType').to_s
		
		case xVarType
			when '1'
				varType = "boolean"
				
			when '2'
				varType = "date"
				
			when '3'
				varType = "money"

			when '4'
				varType = "numeric"

			when '5'
				varType = "percentage"

			when '6'
				varType = "text"
		end
		
		varAlias = var.attribute('Alias')
		varName = var.attribute('Name')

		
		out = <<EOF
decision		dpm	#{varType}	#{varName}		"#{varAlias}";
EOF
		
		out																								# Return generated output
	end # outputDsm
	
	
#-------------------------------------------------------------------------------------------------------------#
# outputDpm - generate a GDL version of a DPM definition based on DPM XML element
#
# var	- XML element to generate output for
#
# @returns	GDL output for DPM definition
#
#------------------------------------------------------------------------------------------------------------#
	def outputDpm(var)
		xVarType = var.attribute('ProductType').to_s
		
		case xVarType
			when '1'
				varType = "boolean"
				
			when '2'
				varType = "date"
				
			when '3'
				varType = "money"

			when '4'
				varType = "numeric"

			when '5'
				varType = "percentage"

			when '6'
				varType = "text"
		end
		
		varAlias = var.attribute('Alias')
		varName = var.attribute('Name')

		
		out = <<EOF
	dpm	#{varType}	#{varName}		"#{varAlias}";
EOF
		
		out																								# Return generated output
	end # outputDpm




#-------------------------------------------------------------------------------------------------------------#
# outputRuleInfo - output collected variables to file
#
# ofile	- output file handle
#
#------------------------------------------------------------------------------------------------------------#
	def outputRuleInfo(ofile)

		ofile << definitionHeader("Rule")
		
		@rules.each_value do |rule|
			ofile << outputRule(rule)
		end
		
	end # def outputRuleInfo


#-------------------------------------------------------------------------------------------------------------#
# outputRule - generate a GDL version of a rule definition based on Rule XML element
#
# rule	- XML element to generate output for
#
# @returns	GDL output for Rule definition
#
#------------------------------------------------------------------------------------------------------------#
	def outputRule(rule)
#		arule = root.elements['//Rule'].to_a  # returns all 1st level rule children elements
		ruleParts = rule.elements.to_a
		puts ""
		puts "Rule Parts:"
		puts "#{ruleParts.inspect}"
		puts ""

		visitor = XmlRuleVisitor.new
		output = ""
		visitor.lookupData = @lookupData
		
		return visitor.visit(rule, output)


	end # outputRule




end	# class GdlDoc



