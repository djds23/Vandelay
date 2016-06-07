# vandelay

[![Build Status](https://travis-ci.org/djds23/Vandelay.svg?branch=master)](https://travis-ci.org/djds23/Vandelay)

This is one implementation of the [Builder Pattern](https://en.wikipedia.org/wiki/Builder_pattern) in the Ruby programming language. This is primarily used for composing objects to transport a set of data to a receiver with a specific payload. The advantage of using a builder over a plain Hash is using explicit methods to set required fields, and getting a common way to present your data to the receiver. By default, `.build` will transform your data into a hash, but you can override this method to create your preferred format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vandelay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vandelay

## Usage

### Basic Pointers
* `made_of` creates setters for that field, and optionally accepts a default value with the `default` optional parameters.
* use/override the `build` method to create a hash with all `made_of` arguments.
* [See full documentation here.](http://www.rubydoc.info/github/djds23/vandelay/master)

```ruby
require 'vandelay'

class ToDoBuilder
  include Vandelay::Buildable

  made_of :text,
          :title,
          :completed_at

  made_of :due_at, default: (Time.now + 1.week.from_now).iso8601

  def build
    params = super
    ToDo.new(params)
  end
end

todo_builder = ToDoBuilder.new

todo_builder.set_title('Write a ruby package')
todo_builder.set_text('Ruby is fun to write, so why not write a gem?')
todo_builder.set_completed_at(Time.now.iso8601)

new_todo = todo_builder.build
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/djds23/vandelay.

