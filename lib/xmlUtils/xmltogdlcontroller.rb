##############################################################################
# File:: xmltogdlcontroller.rb
# Purpose:: Main Controller object for XmlToGdl utility
# 
# Author::    Jeff McAffee 03/07/2010
# Copyright:: Copyright (c) 2010, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require 'ktcommon/ktpath'
require 'ktcommon/ktcmdline'
#require 'dir'

class XmlToGdlController

  attr_accessor :verbose
  attr_reader   :srcPath
  attr_reader   :destPath
    
  def initialize()
    $LOG.debug "XmlToGdlController::initialize"
    @verbose = false
    @srcPath = ""
    @destPath = ""
	@includes = []
  end
  

  def doSomething()
    $LOG.debug "XmlToGdlController::doSomething"
    options = {}
    options["verbose"]  = @verbose
      
	destFile = ""
	destFile = File.basename(@destPath) unless File.directory?(@destPath)
	if(!destFile.empty?)
		options[:destfile] = destFile
	end
	destDir  = @destPath
	destDir  = File.dirname(@destPath) unless File.directory?(@destPath)
	if(destDir.length() < 1)
		destDir = Dir.getwd()
	end
	options[:destdir] = destDir
	
	options[:includes] = @includes
	
    docBuilder = GdlDocBuilder.new(options)
    docBuilder.createDocument(@srcPath)
    
  end
      
  
  def setVerbose(arg)
    $LOG.debug "XmlToGdlController::setVerbose( #{arg} )"
    @verbose = arg
  end
      
  
  def setFilenames(arg)
    $LOG.debug "XmlToGdlController::setFilenames( #{arg} )"
    @srcPath  = arg[0]
    @destPath = arg[1]
	
	@srcPath  = KtCommon.formatPath(@srcPath, :unix)
	@destPath = KtCommon.formatPath(@destPath, :unix)
  end
      
  
  def addInclude(arg)
    $LOG.debug "XmlToGdlController::addInclude( #{arg} )"
    arg = KtCommon.formatPath(arg, :unix)
	if(!File.file?(arg))
		arg = File.expand_path(arg)
		if(!File.file?(arg))
			Log.error "Unable to find include file: #{arg}"
			puts "Unable to find include file: #{arg}"
			arg = nil
		end
	end
	if(nil != arg)
		@includes << arg
		$LOG.info "Include file added: #{arg}"
	end
	
  end
      
  
  def noCmdLineArg()
    $LOG.debug "XmlToGdlController::noCmdLineArg"
    #exit "Should never reach here."
  end
      
  
end # class XmlToGdlController


