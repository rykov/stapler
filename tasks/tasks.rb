# Re-definitions are appended to existing tasks
task :environment
task :merb_env

namespace :stapler do
  PUBLIC_DIR = "#{RAILS_ROOT}/public"
  STAPLE_DIR = "#{PUBLIC_DIR}/stapler"
  
  desc "Staple all files"
  task :run => [:merb_env, :environment, :clean] do
    file_list = FileList["#{PUBLIC_DIR}/**/*.js", "#{PUBLIC_DIR}/**/*.css"]
    file_list.each do |from|
      to = from.gsub(/#{PUBLIC_DIR}/, STAPLE_DIR)
      FileUtils.mkdir_p(File.dirname(to))
      puts "[Stapler] Stapling #{from} to #{to}"
      Stapler::Compressor.new(from, to).compress!
    end
  end

  task :clean => [:merb_env, :environment] do |t, args|
    puts "[Stapler] Cleaning #{STAPLE_DIR}"
    FileUtils.rm_rf(STAPLE_DIR)
  end
end
