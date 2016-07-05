Pod::Spec.new do |s|
  s.name         = "RxAutoUpdater"
  s.version      = "0.1.2"
  s.summary      = "Auto update to data for UITableView/UICollectionView"
  s.homepage     = "https://github.com/kciter/RxAutoUpdater"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "kciter" => "kciter@naver.com" }
  s.source       = { :git => "https://github.com/kciter/RxAutoUpdater.git", :tag => "#{s.version}" }
  s.platform     = :ios, '8.0'
  s.source_files = 'Sources/*.{swift}'
  s.frameworks   = 'UIKit', 'Foundation'
  s.dependency 'RxCocoa', '~> 2.5'
  s.requires_arc = true
end
