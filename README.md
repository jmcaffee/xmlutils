# XmlUtils

## Summary

The XmlUtils library provides XML related helper objects.

An application (`xmltogdl`) is also provided to convert AMS XML guidelines
to the GDL language. See [GDLC](https://github.com/jmcaffee/gdlc) for more
information about GDL.

## Installation

Add this line to your gemfile:

    gem 'xmlutils'

And then execute:

    $ bundle install

or install it yourself as:

    $ gem install xmlutils

## Usage

### Command Line Application

Usage info can be retrieved from the application by calling it with the `-h` or `--help`
options:

    $ xmltogdl --help

### Rake Task Usage

The rake task can be included in a rakefile by requiring `xmlutils/xmltogdltask`:

    require `xmlutils/xmltogdltask`

and called as:

    XmlToGdlTask.new.execute(src_path, dest_path, verbose_true_or_false);

## Testing

XmlUtils will use RSpec for testing, but it currently only has simple
hand-rolled tests in the `unittests` directory.

To run all existing specs (none at this time):

    $ rake spec

or directly:

    $ bundle exec rspec

## TODO

Update the naming convention of methods to the ruby standard.

## Contributing

1. Fork it ( https://github.com/jmcaffee/xmlutils/fork )
1. Clone it (`git clone git@github.com:[my-github-username]/xmlutils.git`)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Create tests for your feature branch
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## LICENSE

XmlUtils is licensed under the MIT license.

See [LICENSE](https://github.com/jmcaffee/xmlutils/blob/master/LICENSE) for
details.

