# ajey

ajey is a simple helper for jekyll to integrate amazon product information into jekyll.


## What the hell is that for a freakin' name?

Easy like that: a[mazon]je[k]y[ll]

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ajey'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ajey


Run test:

Copy spec/sources/_config.yml.example to config.yml and add your amazon credentials. When tests are failing, check if products are still available.

    $ rspec spec/features/dynamic_products.rb


After that you should add it as a plugin for you jekyll project in _config.yml:

```yaml
gems:
  - ajey
```

Now you should configure your settings in the _config.yml:

```yaml
ajey:
  tracking_id: %your_amazon_tracking_id%
```

## Usage

## ToDo

- generate page config for product.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ajey/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## Links for Variable-Assignment

It can be tricky, so be warned ;)

https://docs.shopify.com/themes/liquid-documentation/tags/variable-tags
http://jekyllrb.com/docs/templates/
http://stackoverflow.com/questions/21976330/passing-parameters-to-inclusion-in-liquid-templates
https://docs.shopify.com/themes/liquid-documentation/tags/iteration-tags#for