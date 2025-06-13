Pod::Spec.new do |spec|
  spec.name         = "Down"
  spec.version      = "0.11.0"
  spec.summary      = "Blazing fast Markdown rendering in Swift, built upon cmark."
  spec.homepage     = "https://github.com/yourname/Down"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.authors      = { "You" => "your@email.com" }
  spec.source       = { :git => "https://github.com/yourname/Down.git", :tag => "v" + spec.version.to_s }

  # Swift + cmark 源文件
  spec.source_files = "Sources/Down/**/*.{swift}", "Sources/cmark/*.c", "Sources/cmark/*.h"
  spec.public_header_files = "Sources/cmark/*.h"

  # DownView 资源文件
  spec.ios.source_files = "Sources/Down/Views/**"
  spec.ios.resource = 'Sources/Down/Resources/DownView.bundle'

  # modulemap 指向 include 下的定义
  spec.module_map = 'Sources/cmark/include/module.modulemap'
  spec.header_mappings_dir = 'Sources/cmark'

  # 为 Clang & Swift 提供头文件查找路径
  spec.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '$(SRCROOT)/Sources/cmark'
  }

  spec.requires_arc = true
  spec.swift_versions = ['5.0', '5.1']
  spec.ios.deployment_target = '9.0'
end
