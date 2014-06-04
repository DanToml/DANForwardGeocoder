Pod::Spec.new do |s|

  s.name         = "DANForwardGeocoder"
  s.version      = "0.0.1"
  s.summary      = "A simple library for forward geocoding."

  s.homepage     = "https://github.com/DanielTomlinson/DANForwardGeocoder"
  s.license      = "MIT"

  s.author             = { "Daniel Tomlinson" => "Dan@Tomlinson.io" }
  s.social_media_url   = "http://twitter.com/DanToml"

  s.ios.deployment_target = "6.0"
  s.osx.deployment_target = "10.8"

  s.source       = { :git => "https://github.com/DanielTomlinson/DANForwardGeocoder.git", :tag => "0.0.1" }

  s.source_files  = "DANForwardGeocoder", "DANForwardGeocoder/**/*.{h,m}"

  s.framework  = "MapKit"
  s.requires_arc = true
end
