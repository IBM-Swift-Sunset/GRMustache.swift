import PackageDescription

let package = Package(
  name: "Mustache",
  testDependencies: [
    .Package(url: "git@github.com:IBM-Swift/Kitura-TestFramework.git", versions: Version(0,2,0)..<Version(0,3,0))
  ]
) 
