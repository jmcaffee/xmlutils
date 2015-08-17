#
# File: ruleParser.rb
#
# This class will convert XML rule elements to GDL (Guideline Definition Language).
#
#

require 'rexml/document'
require 'rexml/streamlistener'
require 'xmlutils/xmlrulevisitor'

include REXML


#################################################
#
# class RuleParser
#
#################################################
class RuleParser
  attr_accessor :context

#-------------------------------------------------------------------------------------------------------------#
# initialize - Constructor
#
#
#------------------------------------------------------------------------------------------------------------#
  def initialize(ctx)
    @verbose    = false
    @context    = ctx

  end




  def verbose?
    @verbose
  end




#-------------------------------------------------------------------------------------------------------------#
# setFlag - Set configuration flags
#
# flg - Array of options or single string option. Currently, only -v: verbose is available
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
# parse - Build a GDL rule definition from XML source.
#
# src - String containing XML source
# gdl - GDL rule definition.
#
#------------------------------------------------------------------------------------------------------------#
  def parse(src)
    doc = nil
    doc = Document.new(src)
    root = doc.root

    return parseRuleXml(root)

  end # def parse




#-------------------------------------------------------------------------------------------------------------#
# parseRuleXml - generate a GDL version of a rule definition based on Rule XML element
#
# rule  - XML element to generate output for
#
# @returns  GDL output for Rule definition
#
#------------------------------------------------------------------------------------------------------------#
  def parseRuleXml(rule)
#   arule = root.elements['//Rule'].to_a  # returns all 1st level rule children elements
    #ruleParts = rule.elements.to_a
    puts "Parsing rule: #{rule.attributes['Name']}" if verbose?

    visitor = XmlRuleVisitor.new(@context)
    output = ""

    return visitor.visit(rule, output)


  end # parseRuleXml
end # class RuleParser

