XmlToGdl README
===============

XlmToGdl consists of the following files:

bin/xmlToGdl.rb	- Main()

lib/xmlToGdl.rb - project lib include file

lib/xmlToGdl/gdlDocBuilder.rb
lib/xmlToGdl/contextListener.rb
lib/xmlToGdl/contextParser.rb

	ContextParser 
		parses the raw XML file into the CtxListener (context object).
		parses the context using:
			GdlListener
			RuleListener

	
