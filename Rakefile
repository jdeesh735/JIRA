#!/usr/bin/env rake

require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rake/dsl_definition'

# temp fix for NoMethodError: undefined method `last_comment'
# remove when fixed in Rake 11.x
module TempFixForRakeLastComment
  def last_comment
    last_description
  end
end
Rake::Application.send :include, TempFixForRakeLastComment
### end of temfix

# Style tests. Rubocop and Foodcritic
namespace :style do
  begin
    desc 'Run Ruby style checks'
    RuboCop::RakeTask.new(:rubocop)
  rescue LoadError
    puts '>>>>> Rubocop gem not loaded, omitting tasks' unless ENV['CI']
  end

  begin
    desc 'Run Chef style checks'
    FoodCritic::Rake::LintTask.new(:foodcritic)
  rescue LoadError
    puts '>>>>> foodcritic gem not loaded, omitting tasks' unless ENV['CI']
  end
end

# Integration tests. Kitchen.ci
# namespace :integration do
#   require 'kitchen/rake_tasks'
#
#   begin
#     desc 'Run kitchen integration tests'
#     Kitchen::RakeTasks.new
#   rescue LoadError
#     puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
#   end
# end

# Unit tests with rspec/chefspec
namespace :unit do
  begin
    desc 'Run unit tests with RSpec/ChefSpec'
    RSpec::Core::RakeTask.new(:rspec) do |t|
      t.rspec_opts = [].tap do |a|
        a.push('--color')
        a.push('--format progress')
      end.join(' ')
    end
  rescue LoadError
    puts '>>>>> rspec gem not loaded, omitting tasks' unless ENV['CI']
  end
end

task style: ['style:foodcritic', 'style:rubocop']
task unit: ['unit:rspec']
task travis: %w(style unit)
# task full: ['style', 'unit', 'integration:kitchen:all']
task full: %w(style unit)
task default: %w(style unit)
