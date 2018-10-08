lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'speq/version'

Gem::Specification.new do |spec|
  spec.name          = 'speq'
  spec.version       = Speq::VERSION
  spec.authors       = ['zaniar moradian']
  spec.email         = ['moradianzaniar@gmail.com']

  spec.summary       = 'A tiny library to build specs with fewer words.'
  spec.homepage      = 'https://github.com/znrm/speq'
  spec.license       = 'MIT'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry', '~> 0.11.3'

  spec.add_dependency 'colorize', '~> 0.8.1'
end
