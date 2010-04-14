##############################################################################
# File:: xmltogdltask.rb
# Purpose:: Rake Task for running the application
# 
# Author::    Jeff McAffee 04/13/2010
# Copyright:: Copyright (c) 2010, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require 'xmlutils'
class XmlToGdlTask

	def execute(srcPath, destPath, verbose=false)
		filenames = [srcPath, destPath]
		
		app = XmlToGdlController.new
		app.setFilenames(filenames)
		app.setVerbose(verbose)
		app.doSomething()
	end
end # class XmlToGdlTask


