Pod::Spec.new do |s|
  s.name             = 'RoktContracts'
  s.version          = '0.1.3'
  s.summary          = 'Shared protocols and types for the Rokt SDK ecosystem.'
  s.swift_version    = '5.9'

  s.description      = <<-DESC
  Lightweight contract library containing only protocols and value types
  shared across the Rokt SDK, mParticle Apple SDK, mParticle-Rokt Kit,
  and payment extensions such as Stripe. Zero external dependencies.
                       DESC

  s.homepage         = 'https://github.com/ROKT/rokt-contracts-apple'
  s.license          = { :type => 'Rokt SDK Terms of Use 2.0', :file => 'LICENSE.md' }
  s.author           = { 'ROKT DEV' => 'nativeappsdev@rokt.com' }
  s.source           = { :git => 'https://github.com/ROKT/rokt-contracts-apple.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'

  s.source_files = 'Sources/RoktContracts/**/*.swift'
  s.frameworks = 'Foundation'
  s.ios.frameworks = 'UIKit'
end
