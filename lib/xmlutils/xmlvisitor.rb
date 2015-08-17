#
# File: XmlVisitor.rb
#
# This class is used to visit XML guideline elements
#
#

require 'rexml/document'
require 'rexml/streamlistener'
require 'logger'

#################################################
#
# class XmlVisitor
#
#################################################
class XmlVisitor
  include REXML

    @@log = Logger.new(STDOUT)


#-------------------------------------------------------------------------------------------------------------#
# initialize - Constructor
#
#
#------------------------------------------------------------------------------------------------------------#
  def initialize()
    @output = ""
#   @@log.level = Logger::DEBUG
    @@log.level = Logger::WARN


  end


#-------------------------------------------------------------------------------------------------------------#
# visit - visit an element based on its name.
#
# @returns  GDL output for Element
#
#------------------------------------------------------------------------------------------------------------#
  def visit(elem, data)
    @@log.debug("XmlVisitor::visit")
    @@log.debug(elem.inspect)

    case elem.name
      when 'Compute'
        data = visitCompute(elem, data)

      when 'Operator'
        data = visitOperator(elem, data)

      when 'LeftOperand'
        data = visitLeftOperand(elem, data)

      when 'RightOperand'
        data = visitRightOperand(elem, data)

      when 'Brace'
        data = visitBrace(elem, data)

      when 'Constant'
        data = visitConstant(elem, data)

      when 'Rule'
        data = visitRule(elem, data)

      when 'Ruleset'
        data = visitRuleset(elem, data)

      when 'PPM'
        data = visitPPM(elem, data)

      when 'DPM'
        data = visitDPM(elem, data)

      when 'Condition'
        data = visitCondition(elem, data)

      when 'IfActions'
        data = visitIfActions(elem, data)

      when 'ElseActions'
        data = visitElseActions(elem, data)

      when 'Assign'
        data = visitAssign(elem, data)

      when 'AssignTo'
        data = visitAssignTo(elem, data)

      when 'AssignValue'
        data = visitAssignValue(elem, data)

      when 'Lookup'
        data = visitLookup(elem, data)

      when 'LOOKUP'
        data = visitLookupData(elem, data)

      when 'XParameter'
        data = visitXParameter(elem, data)

      when 'YParameter'
        data = visitYParameter(elem, data)

      when 'Function'
        data = visitXmlFunction(elem, data)

      when 'Args'
        data = visitArgs(elem, data)

      when 'Arg'
        data = visitArg(elem, data)

      else
        data = visitDefault(elem, data)
    end # case

    return data
  end # visit


#-------------------------------------------------------------------------------------------------------------#
# visitDefault - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitDefault(elem, data)
    @@log.debug("XmlVisitor::visitDefault")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitDefault



#-------------------------------------------------------------------------------------------------------------#
# visitCompute - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitCompute(elem, data)
    @@log.debug("XmlVisitor::visitCompute")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitCompute



#-------------------------------------------------------------------------------------------------------------#
# visitExpression - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitExpression(elem, data)
    @@log.debug("XmlVisitor::visitExpression")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitExpression



#-------------------------------------------------------------------------------------------------------------#
# visitOperator - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitOperator(elem, data)
    @@log.debug("XmlVisitor::visitOperator")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitOperator



#-------------------------------------------------------------------------------------------------------------#
# visitLeftOperand - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitLeftOperand(elem, data)
    @@log.debug("XmlVisitor::visitLeftOperand")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitLeftOperand



#-------------------------------------------------------------------------------------------------------------#
# visitRightOperand - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitRightOperand(elem, data)
    @@log.debug("XmlVisitor::visitRightOperand")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitRightOperand



#-------------------------------------------------------------------------------------------------------------#
# visitBrace - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitBrace(elem, data)
    @@log.debug("XmlVisitor::visitBrace")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitBrace



#-------------------------------------------------------------------------------------------------------------#
# visitConstant - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitConstant(elem, data)
    @@log.debug("XmlVisitor::visitConstant")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitConstant



#-------------------------------------------------------------------------------------------------------------#
# visitRule - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitRule(elem, data)
    @@log.debug("XmlVisitor::visitRule")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitRule


#-------------------------------------------------------------------------------------------------------------#
# visitRuleset - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitRuleset(elem, data)
    @@log.debug("XmlVisitor::visitRuleset")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitRuleset


#-------------------------------------------------------------------------------------------------------------#
# visitPPM - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitPPM(elem, data)
    @@log.debug("XmlVisitor::visitPPM")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitPPM


#-------------------------------------------------------------------------------------------------------------#
# visitDPM - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitDPM(elem, data)
    @@log.debug("XmlVisitor::visitDPM")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitDPM


#-------------------------------------------------------------------------------------------------------------#
# visitCondition - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitCondition(elem, data)
    @@log.debug("XmlVisitor::visitCondition")
    @@log.debug(elem.inspect)

    if (elem.elements.size < 1)
      @@log.error("*** Condition element has no children.")
    end

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitCondition



#-------------------------------------------------------------------------------------------------------------#
# visitIfActions - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitIfActions(elem, data)
    @@log.debug("XmlVisitor::visitIfActions")
    @@log.debug(elem.inspect)

    if (elem.elements.size < 1)
      @@log.error("*** IfActions element has no children.")
    end

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitIfActions



#-------------------------------------------------------------------------------------------------------------#
# visitElseActions - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitElseActions(elem, data)
    @@log.debug("XmlVisitor::visitElseActions")
    @@log.debug(elem.inspect)

    if (elem.elements.size < 1)
      @@log.error("*** ElseActions element has no children.")
    end

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitElseActions


#-------------------------------------------------------------------------------------------------------------#
# visitAssign - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitAssign(elem, data)
    @@log.debug("XmlVisitor::visitAssign")
    @@log.debug(elem.inspect)

    if (elem.elements.size < 1)
      @@log.error("*** Assign element has no children.")
    end

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitAssign



#-------------------------------------------------------------------------------------------------------------#
# visitAssignTo - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitAssignTo(elem, data)
    @@log.debug("XmlVisitor::visitAssignTo")
    @@log.debug(elem.inspect)

    if (elem.elements.size < 1)
      @@log.error("*** AssignTo element has no children.")
    end

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitAssignTo



#-------------------------------------------------------------------------------------------------------------#
# visitAssignValue - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitAssignValue(elem, data)
    @@log.debug("XmlVisitor::visitAssignValue")
    @@log.debug(elem.inspect)

    if (elem.elements.size < 1)
      @@log.error("*** AssignValue element has no children.")
    end

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitAssignValue



#-------------------------------------------------------------------------------------------------------------#
# visitLookup - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitLookup(elem, data)
    @@log.debug("XmlVisitor::visitLookup")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitLookup



#-------------------------------------------------------------------------------------------------------------#
# visitLookupData - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitLookupData(elem, data)
    @@log.debug("XmlVisitor::visitLookupData")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitLookupData



#-------------------------------------------------------------------------------------------------------------#
# visitXParameter - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitXParameter(elem, data)
    @@log.debug("XmlVisitor::visitXParameter")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitXParameter



#-------------------------------------------------------------------------------------------------------------#
# visitYParameter - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitYParameter(elem, data)
    @@log.debug("XmlVisitor::visitYParameter")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitYParameter



#-------------------------------------------------------------------------------------------------------------#
# visitXmlFunction - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitXmlFunction(elem, data)
    @@log.debug("XmlVisitor::visitXmlFunction")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitXmlFunction


#-------------------------------------------------------------------------------------------------------------#
# visitArgs - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitArgs(elem, data)
    @@log.debug("XmlVisitor::visitArgs")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitArgs


#-------------------------------------------------------------------------------------------------------------#
# visitArg - Handle default parsing
#
# elem  - Element to visit
# data  - output object to append GDL text to
#
# @returns  GDL output
#
#------------------------------------------------------------------------------------------------------------#
  def visitArg(elem, data)
    @@log.debug("XmlVisitor::visitArg")
    @@log.debug(elem.inspect)

    elem.each_element do |child|
      data = visit(child, data)
    end

    return data
  end # visitArg
end # class XmlVisitor

