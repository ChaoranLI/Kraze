#Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Kraze' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
# Pods for Kraze

pod 'FacebookCore'
pod 'FacebookLogin'
pod 'FacebookShare'
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod	'Firebase'
pod 'Firebase/Analytics'
target 'KrazeTests' do
    inherit! :search_paths
    # Pods for testing
  end
pre_install do |installer|
    def installer.verify_no_static_framework_transitive_dependencies; end
end
  target 'KrazeUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
