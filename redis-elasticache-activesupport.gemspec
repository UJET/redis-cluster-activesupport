lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'redis-elasticache-activesupport'
  spec.version       = '0.1.0'
  spec.authors       = ['Nate Faerber']
  spec.email         = ['nate@ujet.com']

  spec.summary       = 'Extension to redis-activesupport for working with ' \
                       'redis elasticache'
  spec.description   = 'Extension to redis-activesupport for working with ' \
                       'redis elasticache'
  spec.homepage      = 'https://github.com/UJET/redis-elasticache-activesupport'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split('\x0').reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'redis-activesupport'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'fakeredis'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end