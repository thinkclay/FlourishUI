Pod::Spec.new do |s|
  s.name             = "FlourishUI"
  s.version          = "3.1.3"
  s.summary          = "FlourishUI is a nice clean user interface framework"
  s.description      = "FlourishUI is a UI framework for quickly and easily making good looking iOS components."
  s.homepage         = "https://github.com/thinkclay/FlourishUI"
  s.screenshots      = [
    'https://raw.githubusercontent.com/thinkclay/FlourishUI/master/Screenshots/iphone5s-1.png',
    'https://raw.githubusercontent.com/thinkclay/FlourishUI/master/Screenshots/iphone5s-2.png',
    'https://raw.githubusercontent.com/thinkclay/FlourishUI/master/Screenshots/iphone5s-3.png',
    'https://raw.githubusercontent.com/thinkclay/FlourishUI/master/Screenshots/iphone6s-1.png',
    'https://raw.githubusercontent.com/thinkclay/FlourishUI/master/Screenshots/iphone6s-2.png',
    'https://raw.githubusercontent.com/thinkclay/FlourishUI/master/Screenshots/iphone5s-3.png',
  ]
  s.license          = 'MIT'
  s.author           = { "Clay McIlrath" => "clay.mcilrath@gmail.com" }
  s.source           = { :git => "https://github.com/thinkclay/FlourishUI.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/thinkclay'
  s.platform         = :ios, '8.0'
  s.requires_arc     = true

  s.source_files     = 'Pod/Classes/**/*'
end
