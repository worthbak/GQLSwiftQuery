Pod::Spec.new do |s|

  s.name         = "GQLSwiftQuery"
  s.version      = "0.0.1"
  s.summary      = "GQLSwiftQuery is a GraphQL query generator for iOS, written in Swift."
  s.description  = <<-DESC
  GQLSwiftQuery is a GraphQL query generator for iOS, written in Swift. It is designed such that GraphQL queries can be composed in Swift, rather than written and hard-coded in plain text.
                   DESC

  s.homepage     = "https://github.com/worthbak/GQLSwiftQuery.git"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author    = "Worth Baker"
  s.social_media_url   = "http://twitter.com/worthbak"

  s.platform = :ios, "9.0"
  s.source       = { :git => "https://github.com/worthbak/GQLSwiftQuery.git", :tag => "v#{s.version}" }

  s.source_files = "GQLSwiftQuery/**/*.{h,swift}"
  s.requires_arc = true

end
