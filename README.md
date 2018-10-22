# Rack::Ougai #
`Rack::Ougai` replaces the Rack logging system with an [Ougai](https://github.com/tilfin/ougai) logger
that supports Bunyan-styled structured logging in JSON. It includes a few options for building those logs,
as well as integration with (`Rack::RequestID`)[https://github.com/dancavallaro/rack-requestid].

## Installation ##
Add this line to your application's Gemfile:

```ruby
gem 'rack-ougai'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-ougai

## Usage ##
Your `config.ru` should include directives similar to these. Obviously, `Rack::RequestID` is
optional, but `Rack::Ougai::Logger` (or another logger provider) should be high in your middleware
stack so as to push a logger down into the subsequent middleware.

```
require 'rack/ougai'
require 'rack/requestid'

use Rack::RequestID # makes sure `env` has an X-Request-Id header

use Rack::Ougai::Logger, Logger::INFO # see Log Providers below
use Rack::Ougai::AttachRequestID # Replaces logger with a child logger that's tagged with the request ID

use Rack::Ougai::LogRequests # logs every request with timing data, request result, etc.
```

## Log Providers ##

### `Rack::Ougai::Logger` ###
Simple, no-configuration Ougai logger that accepts a `Logger` severity level.

### `Rack::Ougai::ConstantLogger` ###
Specify a preconfigured logger to be used for all requests. For example, in one project I
build a global logger, separate from Rack, which is configured via a YAML file; I add it as the
top level logger in Rack, too.

```
require 'myproject/log'

use Rack::Ougai::ConstantLogger, MyProject::Log # an instance of Ougai::Logging
```

## Contributing ##
Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rack-ougai. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License ##
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct ##
Everyone interacting in the Rack::Ougai project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/eropple/rack-ougai/blob/master/CODE_OF_CONDUCT.md).
