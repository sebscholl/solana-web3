require_relative 'lib/solana/version'

Gem::Specification.new do |spec|
  spec.name          = "solana-web3"
  spec.version       = Solana::VERSION
  spec.authors       = ["Sebastian Scholl"]
  spec.email         = ["sebscholl@gmail.com"]

  spec.summary       = "Ruby implementation of Solana web3.js"
  spec.homepage      = "https://github.com/sebscholl/solana-web3"
  spec.description   = "A framework-agnostic Ruby library for interacting with Solana blockchain"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.glob("{lib}/**/*") + %w[README.md LICENSE.txt]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 13.0"

  # Add any runtime dependencies you'll need
  spec.add_dependency "securerandom"
  spec.add_dependency "ed25519"
  spec.add_dependency "base58"
  spec.add_dependency "json"
  spec.add_dependency "http"
end