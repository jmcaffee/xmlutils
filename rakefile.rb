######################################################################################
# File:: rakefile
# Purpose:: Build tasks for XmlUtils application
#
# Author::    Jeff McAffee 03/12/2010
# Copyright:: Copyright (c) 2010, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
######################################################################################

require 'bundler/gem_tasks'

require 'rake'
require 'rake/clean'
require 'rspec/core/rake_task'


# Set the project name
PROJNAME        = "XmlUtils"

# Setup common clean and clobber targets ----------------------------

CLEAN.include("pkg/**/*.*")
CLEAN.include("tmp/**/*.*")

CLOBBER.include("pkg")
CLOBBER.include("tmp")


#############################################################################
desc "run all specs"
RSpec::Core::RakeTask.new do |t|
  #t.rcov = true
end

