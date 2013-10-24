######################################################################################
# File:: rakefile
# Purpose:: Build tasks for XmlUtils application
#
# Author::    Jeff McAffee 03/12/2010
# Copyright:: Copyright (c) 2010, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
######################################################################################

require 'rubygems'
require 'psych'
gem 'rdoc', '>= 3.9.4'

require 'rake'
require 'rake/clean'
require 'rdoc/task'
require 'ostruct'
require 'rakeutils'


# Set the project name
PROJNAME        = "XmlUtils"

# Bring in the library's version constant
$:.unshift File.expand_path("../lib", __FILE__)
require "xmlutils/version"

PKG_VERSION	= XmlUtils::VERSION
PKG_FILES 	= Dir["**/*"].select { |d| d =~ %r{^(README|bin/|data/|ext/|lib/|spec/|test/)} }

# Setup common clean and clobber targets ----------------------------

#CLEAN.include("#{BUILDDIR}/**/*.*")
#CLOBBER.include("#{BUILDDIR}")

# Setup common directory structure ----------------------------------

#directory BUILDDIR

#$verbose = true
	

#############################################################################
#### Imports
# Note: Rake loads imports only after the current rakefile has been completely loaded.

# Load local tasks.
imports = FileList['tasks/**/*.rake']
imports.each do |imp|
	puts "Importing local task file: #{imp}" if $verbose
	import "#{imp}"
end



#############################################################################
#task :init => [BUILDDIR] do
task :init do

end


#############################################################################
RDoc::Task.new(:rdoc) do |rdoc|
    files = ['README.rdoc', 'docs/**/*.rdoc', 'lib/**/*.rb', 'bin/**/*.rb']
    rdoc.rdoc_files.add( files )
    rdoc.main = "README.rdoc"           	# Page to start on
	#puts "PWD: #{FileUtils.pwd}"
    rdoc.title = "#{PROJNAME} Documentation"
    rdoc.rdoc_dir = 'doc'                   # rdoc output folder
    rdoc.options << '--line-numbers' << '--all'
end


#############################################################################
SPEC = Gem::Specification.new do |s|
	s.platform = Gem::Platform::RUBY
	s.summary = "XML Utility classes library"
	s.name = PROJNAME.downcase
	s.version = PKG_VERSION
	s.requirements << 'none'
	s.require_path = 'lib'
	#s.autorequire = 'rake'
	s.files = PKG_FILES
	s.executables = "xmltogdl"
	s.author = "Jeff McAffee"
	s.email = "gems@ktechdesign.com"
	s.homepage = "http://gems.ktechdesign.com"
	s.description = <<EOF
XML Utility classes library and XmlToGdl application.
EOF
end

