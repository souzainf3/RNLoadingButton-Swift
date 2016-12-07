Pod::Spec.new do |s|
  s.name         = "RNLoadingButton-Swift"
  s.version      = "4.0.1"

  s.summary      = "An easy-to-use UIButton subclass with an activity indicator."

  s.description  = <<-DESC
                   The activity state is configurable and can hide the image or text while the activity indicator is displaying . You can Also choose the position of easily activity indicator or Set It up with a spacing..
                   DESC

  s.homepage     = "https://github.com/souzainf3/RNLoadingButton-Swift"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Romilson Nunes" => "souzainf3@yahoo.com.br" }
  s.social_media_url   = "http://twitter.com/souzainf3"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/souzainf3/RNLoadingButton-Swift.git", :tag => s.version.to_s }

  s.source_files  = "RNLoadingButton/*"
  s.frameworks = "UIKit"
  s.requires_arc = true
end
