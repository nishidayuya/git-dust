source 'https://rubygems.org'

# Specify your gem's dependencies in git-dust.gemspec
gemspec

group :development, :test do
  gem "coveralls", require: false
  # test needs restoring environments feature.
  gem "git", require: false, github: "nishidayuya/ruby-git", ref: "ae7aa9b2e9a97781583d14b92ee36892e0b35985"
end
