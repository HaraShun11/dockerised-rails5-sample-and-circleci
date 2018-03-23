namespace :env do
  task :setup, ['file'] do |task, args|
    f = File.open(args[:file], 'w')
    Rails.application.secrets.each do |secret|
      f.puts "#{secret[0].to_s.upcase}=#{secret[1]}" unless secret[1].nil?
    end
    f.close
  end
end
