guard :bundler do
  watch("Gemfile")
  watch(/\A.+\.gemspec\z/)
end

guard :rspec, all_after_pass: true, all_on_start: true do
  watch(%r{\Alib/(.+)\.rb\z}) { |m|
    "spec/#{m[1]}_spec.rb"
  }
  watch("spec/spec_helper.rb") {
    "spec"
  }
  watch(%r{\Aspec/.+_spec\.rb\z})
end
