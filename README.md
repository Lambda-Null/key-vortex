# KeyVortex

KeyVortex provides a common abstraction around storing records in various datastores. It allows for the use of different adapters depending on the environment, and provides constraints to protect programmatically against differing constraints between them.

To start using KeyVortex, you'll need to define a record:

```ruby
require "key_vortex/record"

class ExampleRecord < KeyVortex::Record
	field :a, String, length: 20
	field :b, Integer, maximum: 100
end
```

Now you can use this object in various ways:

```
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
```

You may notice that a `key` field was defined as well. This can be a String up to 36 characters long, to accomodate a GUID if that's what you wish to use.



Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/key_vortex`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'key-vortex'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install key-vortex

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/key-vortex. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/key-vortex/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the KeyVortex project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/key-vortex/blob/main/CODE_OF_CONDUCT.md).
