# KeyVortex

KeyVortex provides a common abstraction around storing records in various datastores. It allows for the use of different adapters depending on the environment, and provides constraints to protect programmatically against differing constraints between them.

## Installation

Add this line to your application's Gemfile:

	gem 'key-vortex'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install key-vortex

## Usage

To start using KeyVortex, you'll need to define a [record](https://rubydoc.info/gems/key-vortex/KeyVortex/Record/):

	require "key_vortex/record"

	class ExampleRecord < KeyVortex::Record
		field :a, String, length: 20
		field :b, Integer, maximum: 100
	end

Now you can use this object in various ways:

	> record = ExampleRecord.new(key: "foo", a: "bar", b: 10)
	=> #<ExampleRecord:0x000055fe0b5fe538 @values={:key=>"foo", :a=>"bar", :b=>10}>
	> record.a
	=> "bar"
	> record.a = "baz"
	=> "baz"
	> record.a
	=> "baz"
	> record.b = 1000
	Invalid value 1000 for b (KeyVortex::Error)

You may notice that a `key` field was defined as well. This can be a String up to 36 characters long, to accomodate a GUID if that's what you wish to use.

In order to save the record somewhere, you'll need to choose an [adapter](https://rubydoc.info/gems/key-vortex/KeyVortex/Adapter).

	> require "key_vortex/adapter/memory"
	> vortex = KeyVortex.vortex(:memory, ExampleRecord)
	> vortex.save(ExampleRecord.new(key: "foo", a: "a", b: 10))
	> vortex.find("foo")
	=> #<ExampleRecord:0x0000560781f480b0 @values={:key=>"foo", :a=>"a", :b=>10}>
	> vortex.remove("foo")
	> vortex.find("foo")
	=> nil

As you can see, you have the ability to `save`, `find` and `remove` records. Once a record is saved, it can be referenced by the `key`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Lambda-Null/key-vortex. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Lambda-Null/key-vortex/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the KeyVortex project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Lambda-Null/key-vortex/blob/main/CODE_OF_CONDUCT.md).
