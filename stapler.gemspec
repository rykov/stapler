Gem::Specification.new do |s|
  s.name              = "stapler"
  s.version           = "0.1.0"
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "Dynamic asset compression for Rails"
  s.homepage          = "http://github.com/rykov/stapler"
  s.email             = "mrykov@gmail"
  s.authors           = [ "Michael Rykov" ]
  s.has_rdoc          = false

  s.files             = %w( README.md Rakefile LICENSE )
  s.files            += Dir.glob("lib/**/*")

  s.add_dependency    "yuicompressor", "~> 1.2.0"

  s.description = <<DESCRIPTION
Dynamic asset compression for Rails using YUI Compressor
DESCRIPTION
end
