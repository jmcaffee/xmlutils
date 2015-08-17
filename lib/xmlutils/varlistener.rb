#
# File: varListener.rb
#
# This class is used to collect XML variables
#
#

require 'rexml/streamlistener'
require 'xmlutils/gdlcontext'
require 'xmlutils/gdlcontextobjs'
require 'xmlutils/listener'

include REXML




#################################################
#
# class VarListener
#
#################################################
class VarListener < Listener

  attr_reader :context




#-------------------------------------------------------------------------------------------------------------#
# initialize - Ctor
#
# ctx - Context object to store variables in
#
#------------------------------------------------------------------------------------------------------------#
  def initialize(ctx)
    @verbose    = false
    @context    = ctx
  end




#-------------------------------------------------------------------------------------------------------------#
# openDPM - Add a DPM variable to the context object
#
# attributes  - DPM element attributes
#
#------------------------------------------------------------------------------------------------------------#
  def openDPM(attributes)
    dpmAlias  = attributes["Name"]
    confName  = @context.createValidName(dpmAlias)
    varType   = attributes["Type"]
    dataType  = attributes["DataType"] if attributes.has_key?("DataType")
    prodType  = attributes["ProductType"]

    dataType = prodType if nil == dataType

    dpm = Dpm.new(confName, dpmAlias, varType, dataType, prodType)

    @context.dpms[dpmAlias] = dpm
  end # openDPM




#-------------------------------------------------------------------------------------------------------------#
# openPPM - Add a PPM variable to the context object
#
# attributes  - PPM element attributes
#
#------------------------------------------------------------------------------------------------------------#
  def openPPM(attributes)
    ppmAlias  = attributes["Name"]
    confName  = @context.createValidName(ppmAlias)
    varType   = attributes["Type"]
    dataType  = attributes["DataType"] if attributes.has_key?("DataType")

    dataType = "Text" if nil == dataType

    ppm = Ppm.new(confName, ppmAlias, varType, dataType)

    @context.ppms[ppmAlias] = ppm
  end # openPPM
end # class VarListener

