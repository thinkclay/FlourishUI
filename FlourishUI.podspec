Pod::Spec.new do |s|
  s.name             = "FlourishUI"
  s.version          = "2.1.0"
  s.summary          = "FlourishUI is a nice clean user interface framework"
  s.description      = "FlourishUI is a UI framework for quickly and easily making good looking iOS components."
  s.homepage         = "https://github.com/thinkclay/FlourishUI"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Clay McIlrath" => "clay.mcilrath@gmail.com" }
  s.source           = { :git => "https://github.com/thinkclay/FlourishUI.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/thinkclay'
  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'FlourishUI' => ['Pod/Assets/*.png']
  }
end
