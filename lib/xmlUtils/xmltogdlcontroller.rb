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
	destDir  = @destPath			# Extract the dir if it is a file path.
	destDir  = File.dirname(@destPath) unless File.directory?(@destPath)
	if(destDir.length() < 1)
		destDir = Dir.getwd()		# Use working dir if nothing there.
	end
	options[:destdir] = destDir
	
	options[:includes] = @includes
	
									# Go to work.
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
	
	@srcPath  = File.rubypath(@srcPath)
	@destPath = File.rubypath(@destPath)
  end
      
  
  def addInclude(arg)
    $LOG.debug "XmlToGdlController::addInclude( #{arg} )"
    arg = File.rubypath(arg)
	if(!File.file?(arg))
		arg = File.expand_path(arg)
		if(!File.file?(arg))
			$LOG.error "Unable to find include file: #{arg}"
			puts "Missing file: #{arg}"
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


