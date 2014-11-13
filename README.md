# FastlyVclUpload

Install VLC files from a given folder into Fastly.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fastly_vcl_upload'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fastly_vcl_upload

## Usage

If you are wanting to use this with rails. Then add the following to your assets:precompile rake task

```
FastlyVclUpload.install "#{Rails.root}/config",
  service_name: Rails.configuration.base_domain,
  api_key: ENV['FASTLY_API_KEY']
```

Example:
```
namespace :assets do
  desc "Precompile assets, including install fastly's VCL"
  task :precompile do
    if %w(production).include? Rails.env
      FastlyVclUpload.install "#{Rails.root}/config",
        service_name: "service_name",
        api_key: ENV['FASTLY_API_KEY']
    end
  end
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/fastly_vcl_upload/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
