Pod::Spec.new do |s|
  s.name     = 'HPMusicBoxParse'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'MusicBox on Parse.com'
  s.author   = { 'Herve Peroteau' => 'herve.peroteau@gmail.com' }
  s.description = 'MusicBox on Parse.com'
  s.platform = :ios
  s.source = { :git => "https://github.com/herveperoteau/HPMusicBoxParse.git"}
  s.source_files = 'HPMusicBoxParse'
  s.requires_arc = true
  #s.dependency 'Parse'
  #s.ios.framework = 'Parse'
end
