source 'https://rubygems.org'

# Specify your gem's dependencies in git-dust.gemspec
gemspec

group :development, :test do
  gem "coveralls", require: false
  # test needs restoring environments feature.
  gem "git", require: false, github: "nishidayuya/ruby-git", ref: "e803dd65b7a851431835f72052e09e445a80e532"
end
