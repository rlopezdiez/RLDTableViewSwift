Pod::Spec.new do |s|
  s.name         = 'RLDTableViewSwift'
  s.version      = '0.2.1'
  s.homepage     = 'https://github.com/rlopezdiez/RLDTableViewSwift.git'
  s.summary      = 'Reusable table view controller, data source and delegate for all your UITableView needs in Swift'
  s.authors      = { 'Rafael Lopez Diez' => 'https://www.linkedin.com/in/rafalopezdiez' }
  s.source       = { :git => 'https://github.com/rlopezdiez/RLDTableViewSwift.git', :tag => s.version.to_s }
  s.source_files = 'Classes/*.swift'
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
end
