$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sword/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sword"
  s.version     = Sword::VERSION
  s.authors     = ["Aaron Collier"]
  s.email       = ["acollier@calstate.edu"]
  s.homepage    = "http://www.github.com/aaron-collier/sword"
  s.summary     = "Summary of Sword."
  s.description = "Description of Sword."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.3"

  s.add_development_dependency "sqlite3"
end
