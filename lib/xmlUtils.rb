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
      file = File.open('xmltogdl.log', File::WRONLY | File::APPEND | File::CREAT | File::TRUNC)
      $LOG = Logger.new(file)
      #$LOG = Logger.new('xledit.log', 2)
      $LOG.level = Logger::DEBUG
      #$LOG.level = Logger::INFO
    else
      $LOG = Logger.new(STDERR)
      $LOG.level = Logger::ERROR
    end
    $LOG.info "**********************************************************************"
    $LOG.info "Logging started for XmlToGdl library."
    $LOG.info "**********************************************************************"
end



require 'xmlUtils/xmltogdlcontroller'
require 'xmlUtils/xmltogdltask'
require 'xmlUtils/xmlVisitor'
require 'xmlUtils/ruleParser'
require 'xmlUtils/contextParser'
require 'xmlUtils/xmlRuleVisitor'
require 'xmlUtils/gdlDocBuilder'

