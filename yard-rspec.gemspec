SPEC = Gem::Specification.new do |s|
  s.name          = "yard-tests-rspec"
  s.summary       = "YARD plugin to list RSpec specifications inside documentation"
  s.version       = "0.1.1"
  s.date          = "2009-09-15"
  s.authors       = ["Loren Segal", "Jesús Burgos"]
  s.email         = ["lsegal@soen.ca", "jburmac@gmail.com"]
  s.homepage      = "http://yardoc.org"
  s.platform      = Gem::Platform::RUBY
  s.files         = Dir.glob("{example,lib,templates}/**/*") + ['LICENSE', 'README.rdoc', 'Rakefile']
  s.require_paths = ['lib']
  s.has_rdoc      = 'yard'
  s.add_dependency 'yard'
end
