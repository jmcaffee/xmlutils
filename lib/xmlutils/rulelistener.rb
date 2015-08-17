#
# File: ruleListener.rb
#
# This class is an rule listener base class
#
#

require 'rexml/streamlistener'

include REXML




#################################################
#
# class RuleListener
#
#################################################
class RuleListener
  include StreamListener

  attr_writer   :verbose

  attr_writer   :inRule
  attr_writer   :inIfMsgs
  attr_writer   :inElseMsgs
  attr_writer   :inMsg

  attr_accessor :curRuleName
  attr_accessor :curRuleSrc
  attr_accessor :curIfMsgs
  attr_accessor :curElseMsgs
  attr_accessor :context



  def inRule?
    @inRule
  end




  def inIfMsgs?
    @inIfMsgs
  end




  def inElseMsgs?
    @inElseMsgs
  end




  def inMsg?
    @inMsg
  end




  def verbose?
    @verbose
  end




#-------------------------------------------------------------------------------------------------------------#
# initialize - Ctor
#
#
#------------------------------------------------------------------------------------------------------------#
  def initialize(ctx)
    super()

    @inRule       = false
    @inIfMsgs     = false
    @inElseMsgs   = false
    @inMsg        = false

    @curRuleSrc   = ""
    @curRuleName  = nil
    @curIfMsgs    = Array.new
    @curElseMsgs  = Array.new

    @context      = ctx
  end



#-------------------------------------------------------------------------------------------------------------#
# tag_start - A start tag has been parsed
#
# tag       - name of tag (element name)
# attributes  - element tag attributes
#------------------------------------------------------------------------------------------------------------#
  def tag_start(tag, attributes)
    case tag
      when 'Rule'
        openRule(attributes)

      when 'IfMessages'
        @inIfMsgs   = true
        openUnknown(tag, attributes)

      when 'ElseMessages'
        @inElseMsgs = true
        openUnknown(tag, attributes)

      when 'Message'
        openMessage(attributes)

      else
        openUnknown(tag, attributes)
    end # case

  end




#-------------------------------------------------------------------------------------------------------------#
# tag_end - An ending tag has been parsed
#
# tag - name of tag (element name)
#------------------------------------------------------------------------------------------------------------#
  def tag_end(tag)

    case tag
      when 'Rule'
        closeRule()

      when 'IfMessages'
        @inIfMsgs   = false
        closeUnknown(tag)

      when 'ElseMessages'
        @inElseMsgs = false
        closeUnknown(tag)


      when 'Message'
        closeMessage()

      else
        closeUnknown(tag)
    end # case

  end




#-------------------------------------------------------------------------------------------------------------#
# addMsg - Add a message to the proper message list
#
# msg - msg to add
#------------------------------------------------------------------------------------------------------------#
  def addMsg(msg)
    puts "addMsg: #{msg}" if $DEBUG

    if (inIfMsgs?)
      @curIfMsgs << msg
    elsif (inElseMsgs?)
      @curElseMsgs << msg
    end
  end




#-------------------------------------------------------------------------------------------------------------#
# entity - An entity has been parsed
#
# content - entity content
#------------------------------------------------------------------------------------------------------------#
  def entity(content)
    puts "entity: #{content}" if $DEBUG

    if (inRule?)
      @curRuleSrc += content
    end
  end




#-------------------------------------------------------------------------------------------------------------#
# text - A text node has been parsed
#
# txt - node text
#------------------------------------------------------------------------------------------------------------#
  def text(txt)
    puts "text: #{txt}" if $DEBUG

    if (inRule?)
      txt = cleanText(txt)
      @curRuleSrc += txt
    end
  end




#-------------------------------------------------------------------------------------------------------------#
# cdata - A cdata node has been parsed
#  Called when <![CDATA[ … ]]> is encountered in a document. @p content "…"
# txt - node text
#------------------------------------------------------------------------------------------------------------#
  def cdata(txt)
    if (inMsg?)
      puts "cdata: #{txt}" unless !$DEBUG
      @curRuleSrc += "<![CDATA[#{txt}]]>"
      addMsg(txt)
    end # if inMsg
  end




#-------------------------------------------------------------------------------------------------------------#
# openRule - A Rule element has been started
#
# attributes  - Rule element attributes
#
#------------------------------------------------------------------------------------------------------------#
  def openRule(attributes)
    if (inRule?)
      closeRule()
    end # if inRule

    if ($DEBUG)
      puts "openRule:"

      if(!attributes.empty?)
        puts "      Attr:"
        attributes.each do |attr|
          puts "            #{attr[0]}: #{attr[1]}"
        end
      end
    end # if verbose

    @inRule = true

    @curRuleName = attributes['Name']

    @curRuleSrc = String.new("<Rule")
    @curRuleSrc += buildAttrString(attributes)
    @curRuleSrc += ">"

    puts "Collecting rule XML: #{@curRuleName}" if verbose?

  end # openRule




#-------------------------------------------------------------------------------------------------------------#
# closeRule - A Rule element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
  def closeRule()
    puts "closeRule" if $DEBUG

    if (inRule?)
      @curRuleSrc += "</Rule>"
      @context.rules[@curRuleName].xml = @curRuleSrc
      @context.rules[@curRuleName].ifMsgs   = @curIfMsgs
      @context.rules[@curRuleName].elseMsgs = @curElseMsgs
      @curRuleSrc   = ""
      @curRuleName  = ""
      @curIfMsgs    = Array.new
      @curElseMsgs  = Array.new

      @inRule       = false
    else
      raise "Rule end tag encountered without preceeding start tag."
    end # if inRule
  end # closeRule




#-------------------------------------------------------------------------------------------------------------#
# openMessage - A Message element has been started
#
# attributes  - Message element attributes
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

    @inMsg = true

    @curRuleSrc += "<Message"
    @curRuleSrc += buildAttrString(attributes)
    @curRuleSrc += ">"

  end # openMessage




#-------------------------------------------------------------------------------------------------------------#
# closeMessage - A Message element has been ended
#
#
#------------------------------------------------------------------------------------------------------------#
  def closeMessage()
    puts "closeMessage" if $DEBUG
    if (inMsg?)
      @curRuleSrc += "</Message>"
    end # if inMsg
  end # closeMessage




#-------------------------------------------------------------------------------------------------------------#
# openUnknown - A Unknown element has been started
#
# tag       - Tag name of unknown element
# attributes  - Unknown element attributes
#
#------------------------------------------------------------------------------------------------------------#
  def openUnknown(tag, attributes)
    if ($DEBUG)
      puts "openUnknown: #{tag}"

      if(!attributes.empty?)
        puts "      Attr:"
        attributes.each do |attr|
          puts "            #{attr[0]}: #{attr[1]}"
        end
      end
    end # if $DEBUG

    if (inRule?)
      @curRuleSrc += "<#{tag}"
      @curRuleSrc += buildAttrString(attributes)
      @curRuleSrc += ">"
    end # if inRule
  end # openUnknown




#-------------------------------------------------------------------------------------------------------------#
# closeUnknown - A Unknown element has been ended
#
# tag       - Tag name of unknown element
#
#------------------------------------------------------------------------------------------------------------#
  def closeUnknown(tag)
    puts "closeUnknown: #{tag}" if $DEBUG
    if (inRule?)
      @curRuleSrc += "</#{tag}>"
    end # if inRule
  end # closeUnknown




#-------------------------------------------------------------------------------------------------------------#
# buildAttrString - Build an XML attribute string.
#
# attributes        - Hash of attributes
#
#------------------------------------------------------------------------------------------------------------#
  def buildAttrString(attributes)
    str = ""

    attributes.each do |key, val|
      str += " #{key}='#{val}'"
    end # attributes.each

    puts "attrib str: #{str}" if $DEBUG
    str
  end # buildAttrString




#-------------------------------------------------------------------------------------------------------------#
# cleanText - Convert text into entities
#
# txt       - text to convert
#
#------------------------------------------------------------------------------------------------------------#
  def cleanText(txt)
    clean = txt.gsub("<", "&lt;")
    clean.gsub!(">", "&gt;")

    puts "cleaned text: #{txt} -> #{clean}" if $DEBUG
    clean

  end # buildAttrString
end # class Listener

