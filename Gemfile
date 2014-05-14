source "http://rubygems.org"

# Specify your gem's dependencies in shortest_path.gemspec
gemspec

gem 'coveralls', require: false

group :development do
  group :linux do
    gem 'rb-inotify', :require => RUBY_PLATFORM.include?('linux') && 'rb-inotify'
    gem 'rb-fsevent', :require => RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'        
  end
end
