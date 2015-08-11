Pod::Spec.new do |s|
  s.name		  = "JMSRangeSlider"
  s.version		= "2.0.4"
  s.summary		= "A Custom Range Slider for OSX"
  s.homepage	= "https://github.com/johnmcneilstudio/JMSRangeSlider"
  s.license		= { :type => 'MIT', :file => 'LICENSE' }
  s.author		= {
    "Matthieu Collé" => "matthieu@johnmcneilstudio.com"
  }
  s.source		= { :git => "https://github.com/johnmcneilstudio/JMSRangeSlider.git", 
                  :tag => "v#{s.version}" }
  s.social_media_url	= 'https://twitter.com/jmcneilstudio'
  s.screenshot = 'https://github.com/johnmcneilstudio/JMSRangeSlider/raw/master/screenshot.png'
  s.documentation_url = 'https://github.com/johnmcneilstudio/JMSRangeSlider/blob/master/README.md'
  s.platform		= :osx, "10.10"
  s.frameworks		= 'QuartzCore'
  s.description  = "JMSRangeSlider is a custom Range Slider for OSX. Think of a NSSlider with two cells."
  s.source_files	= 'JMSRangeSlider/*.swift'
end
