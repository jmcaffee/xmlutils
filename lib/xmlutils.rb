#-------------------------------------------------------------------------------------------------------------#
# XmlUtils library
#                                                                              
#  XmlUtils scripts written by Jeff McAffee   11/03/07
# Purpose: XML Utility objects/classes
#
#------------------------------------------------------------------------------------------------------------#

require 'find'
require 'logger'

$LOGGING = true   # TODO: Change this flag to false when releasing production build.

if(!$LOG)
    if($LOGGING)
      # Create a new log file each time:
      file = File.open('xmlutils.log', File::WRONLY | File::APPEND | File::CREAT | File::TRUNC)
      $LOG = Logger.new(file)
      #$LOG = Logger.new('xmlutils.log', 2)
      $LOG.level = Logger::DEBUG
      #$LOG.level = Logger::INFO
    else
      $LOG = Logger.new(STDERR)
      $LOG.level = Logger::ERROR
    end
    $LOG.info "**********************************************************************"
    $LOG.info "Logging started for XmlUtils library."
    $LOG.info "**********************************************************************"
end



require 'xmlutils/xmltogdlcontroller'
require 'xmlutils/xmltogdltask'
require 'xmlutils/xmlvisitor'
require 'xmlutils/ruleparser'
require 'xmlutils/contextparser'
require 'xmlutils/xmlrulevisitor'
require 'xmlutils/gdldocbuilder'

