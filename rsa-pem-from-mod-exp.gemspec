Gem::Specification.new do |s|
  s.name        = 'rsa-pem-from-mod-exp'
  s.version     = '0.1.1'
  s.date        = '2017-06-28'
  s.summary     = "Creates a valid pem given a modulus and exponent"
  s.description = "A simple rsa pem tool based off tracker1/node-rsa-pem-from-mod-exp"
  s.authors     = ["Sarah Griffis", "Daniel Chang"]
  s.email       = 'daniel.chang85@gmail.com'
  s.files       = ["lib/rsa_pem.rb"]
  s.homepage    =
    'http://rubygems.org/gems/rsa-pem-from-mod-exp'
  s.license       = 'MIT'

  s.add_development_dependency 'rspec'
end
