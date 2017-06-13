# Sword
Short description and motivation.

## Usage

From the path with the `sword_package.zip` file:

```bash
curl -i --data-binary "@./sword_package.zip" -H "Content-Disposition: filename=sword_package.zip" -H "Content-Type:application/zip" -H "X-Packaging:http://purl.org/net/sword-types/METSDSpaceSIP" -H "X-No-Op:false" -H "X-Verbose:true" http://localhost:3000/sword/deposit
```

## TODO

1. Add authentication to /deposit
2. Document configuration
3. Add handle mapping (for legacy repository interoperability)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'sword'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install sword
```

Install configs
```bash
$ rails generate sword:config
```

Add routes to config/routes.rb
```ruby
mount Sword::Engine => "/sword"
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
