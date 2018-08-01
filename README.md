# Mina Puma

[Mina](https://github.com/nadarei/mina) tasks for handle with
[Puma](https://github.com/puma/puma).

This gem provides several mina tasks:

    mina puma:phased_restart  # Restart puma (using phased restart)
    mina puma:hard_restart    # Restart puma (using stop, then start)
    mina puma:restart         # Restart puma (using pumactl)
    mina puma:start           # Start puma
    mina puma:stop            # Stop puma
    mina puma:status          # Get status

## Installation

Add this line to your application's Gemfile:

    gem 'mina-puma', require: false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mina-puma

Note: by just including this gem, does not mean your development server will be Puma, for that, you need explicitly add `gem 'puma'` to your Gemfile.

## Usage

Run:
```
mina init
```
to generate `config/deploy.rb` file if you have not configured it yet.

Add this to your `config/deploy.rb` file:

    require 'mina/puma'

Make sure the following settings are set in your `config/deploy.rb`:

* `deploy_to`   - deployment path

Make sure the following directories exists on your server:

* `shared/tmp/sockets` - directory for socket files.
* `shared/tmp/pids` - directory for pid files.

OR you can set other directories by setting follow variables:

* `puma_socket` - puma socket file, default is `shared/tmp/sockets/puma.sock`
* `puma_pid` - puma pid file, default `shared/tmp/pids/puma.pid`
* `puma_state` - puma state file, default `shared/tmp/sockets/puma.state`
* `puma_stdout` - puma redirect path for stdout, default `shared/log/puma.log`
* `puma_stderr` - puma redirect path for stderr, default `shared/log/puma.log`
* `pumactl_socket` - pumactl socket file, default `shared/tmp/sockets/pumactl.sock`
* `puma_root_path` - puma command execute root path, default `current`

Then:

```
$ mina puma:start
```

## Example
```ruby
require 'mina/puma'

# Add pids and sockets directories to shared dirs
set :shared_dirs, fetch(:shared_dirs, []).push('log', 'tmp/pids', 'tmp/sockets')

task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    ...

    on :launch do
      ...
      invoke :'puma:phased_restart'
    end
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
