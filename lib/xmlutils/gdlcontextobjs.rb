#
# File: gdlContextObjs.rb
#
# These are guideline context objects
#
#



#################################################
#
# class Dpm
#
#################################################
class Dpm

  attr_accessor :name
  attr_accessor :alias
  attr_accessor :varType
  attr_accessor :dataType
  attr_accessor :prodType

  def initialize(name, attributes)
    @name     = name
    @alias    = attributes["Name"]
    @varType  = attributes["Type"]
    @dataType = attributes["DataType"] if attributes.has_key?("DataType")
    @prodType = attributes["ProductType"]

    @dataType = @prodType if (nil == @dataType)

    case @prodType
      when '1'
        @prodType = "boolean"

      when '2'
        @prodType = "date"

      when '3'
        @prodType = "money"

      when '4'
        @prodType = "numeric"

      when '5'
        @prodType = "percentage"

      when '6'
        @prodType = "text"

    end # prodType
  end # initialize
end # class Dpm




#################################################
#
# class Ppm
#
#################################################
class Ppm

  attr_accessor :name
  attr_accessor :alias
  attr_accessor :varType
  attr_accessor :dataType

# def initialize(name, als, varType, dataType)
#   @name     = name
#   @alias    = als
#   @varType  = varType
#   @dataType = dataType
#
# end # initialize
  def initialize(name, attributes)
    @name     = name
    @alias    = attributes["Name"]
    @varType  = attributes["Type"]
    @dataType = "UNKNOWN"
    @dataType = attributes["DataType"] if attributes.has_key?("DataType")


    case @varType
      when 'APM'
        @varType = "app"

      when 'CRP'
        @varType = "crd"

      when 'PRD'
        @varType = "prd"

    end # varType


    case @dataType
      when 'Boolean'
        @dataType = "boolean"

      when 'Date'
        @dataType = "date"

      when 'Money'
        @dataType = "money"

      when 'Numeric'
        @dataType = "numeric"

      when 'Percentage'
        @dataType = "percentage"

      when 'Text'
        @dataType = "text"
    end # dataType
  end # initialize
end # class Ppm




#################################################
#
# class Rule
#
#################################################
class Rule

  attr_accessor :name
  attr_accessor :alias
  attr_accessor :src
  attr_accessor :xml
  attr_accessor :ifMsgs
  attr_accessor :elseMsgs


  def initialize(name, als)
    @name     = name
    @alias    = als
    @src      = nil
    @xml      = nil
    @ifMsgs   = Array.new
    @elseMsgs = Array.new
  end # initialize
end # class Rule




#################################################
#
# class Lookup
#
#################################################
class Lookup

  attr_accessor :name
  attr_accessor :xParam
  attr_accessor :yParam

  def initialize(attributes)
    lkName    = attributes["Name"]

    @name     = lkName
  end # initialize
end # class Lookup




#################################################
#
# class Ruleset
#
#################################################
class Ruleset

  attr_accessor :name
  attr_accessor :alias
  attr_accessor :rules    # rule aliases
  attr_accessor :type     # This indicates the ruleset type (Normal, PL)
  attr_accessor :execType # This indicated the execute type (TRUE, FALSE, CONTINUE)


  def initialize(attributes)
    rsAlias     = attributes["Name"]

    # Parse out the exit type
    case attributes["Type"]
      when "0"
        rsType = "Normal"

      when "1"
        rsType = "PL"

      else
        rsType = "*** UNKNOWN ***"
    end

    # Parse out the execute type
    case attributes["ExecuteType"]
      when "1"
        rsExecType = "true"

      when "2"
        rsExecType = "false"

      when "3"
        rsExecType = "continue"

      else
        rsExecType = "*** UNKNOWN ***"
    end

    # Store the results
    @name     = rsAlias
    @alias    = rsAlias
    @type     = rsType
    @execType = rsExecType
    @rules    = Array.new
  end # initialize

  def addRule(als)
    @rules << als
  end # addRule
end # class Ruleset




#################################################
#
# class Guideline
#
#################################################
class Guideline

  attr_accessor :id
  attr_accessor :name
  attr_accessor :version
  attr_accessor :startDate
  attr_accessor :items


  def initialize(attributes)
    @id         = attributes["GuidelineID"]
    @name       = attributes["Name"]
    @version    = attributes["Version"]
    @startDate  = attributes["StartDate"]
    @items      = Array.new
  end # initialize

  def addItem(itemAry)
    if (itemAry[0] == "rule" || itemAry[0] == "ruleset")
      items.push(itemAry)
    else
      raise "Invalid arg: expected rule or ruleset type"
    end # if
  end # addItem
end # class Guideline



#################################################
#
# class Message
#
#################################################
class Message

  attr_accessor :type
  attr_accessor :exceptionType
  attr_accessor :category
  attr_accessor :priorTo
  attr_accessor :msg


  def initialize(attributes)
    @type           = attributes["Type"]            # Exceptions, Observation, Condition
    @exceptionType  = attributes["ExceptionType"]   # Exceptions
    @category       = attributes["Category"]        # 1 => ,
    @priorTo        = attributes["PriorTo"]         # 1 => ,
    @msg            = String.new
  end # initialize
end # class Message
