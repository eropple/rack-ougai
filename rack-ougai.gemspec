lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "rack/ougai/version"

Gem::Specification.new do |spec|
  spec.name          = "rack-ougai"
  spec.version       = Rack::Ougai::VERSION
  spec.authors       = ["Toshimitsu Takahashi", "Ed Ropple", "Pablo Crivella"]
  spec.email         = ["toshi@tilfin.com", "ed@edropple.com", "pablocrivella@gmail.com"]

  spec.summary       = "Rack integration for the Ougai logger."
  spec.homepage      = "https://github.com/eropple/rack-ougai"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"

  spec.add_runtime_dependency "rack", "~> 2.0"
  spec.add_runtime_dependency "ougai", "~> 2.0"
end
