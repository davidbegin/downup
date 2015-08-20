require "bundler/gem_tasks"

task :test do
  Dir.glob("test/test*").map do |file|
    require_relative file
  end
end
