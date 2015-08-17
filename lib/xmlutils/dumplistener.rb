#
# File: dumpListener.rb
#
# This class is used to convert XML to GDL
#
#

require 'rexml/streamlistener'

include REXML

#################################################
#
# class DumpListener
#
#################################################
class DumpListener
  include StreamListener

  attr_writer :verbose

  def verbose?
    @verbose
  end


  def initialize()
    @verbose = false
  end


  def tag_start(tag, attributes)
    puts "Start #{tag}" unless (false == @verbose)

#   puts "Arry: " + attributes.inspect
    if(!attributes.empty?)
      puts "      Attr:" unless (false == @verbose)
      attributes.each do |attr|
        puts "            #{attr[0]}: #{attr[1]}" if verbose?
      end
    end
  end

  def tag_end(tag)
    puts "End #{tag}" if verbose?
    puts "" if verbose?
  end

  def entity(content)
    puts "entity: #{content}" if verbose?
  end

  def text(txt)
    puts "text: #{txt}" if verbose?
  end
end # class DumpListener

