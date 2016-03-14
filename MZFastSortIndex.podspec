Pod::Spec.new do |s|
  s.name             = "MZFastSortIndex"
  s.version          = "0.1.0"
  s.summary          = "Performant and powerful sort index building for Cocoa collections"

  s.description      = <<-DESC
                       MZFastSortIndex provides performant and powerful sort index building for Cocoa collections.
                       DESC

  s.homepage         = "https://github.com/moshozen/MZFastSortIndex"
  s.license          = 'MIT'
  s.author           = { "Mat Trudel" => "mat@geeky.net" }
  s.source           = { :git => "https://github.com/moshozen/MZFastSortIndex.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MZFastSortIndex' => ['Pod/Assets/*.png']
  }
end
