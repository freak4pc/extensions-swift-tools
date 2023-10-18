// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "raycast-extension-macro",
  platforms: [.macOS(.v10_15)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "RaycastExtensionMacro",
      targets: ["RaycastExtensionMacro"]
    ),
  ],
  dependencies: [
    // Depend on the latest Swift 5.9 of SwiftSyntax
    .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
  ],
  targets: [
    // Macro implementation that performs the source transformation of a macro.
    .macro(
      name: "MacroImplementation",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ]
    ),

    // Library that exposes a macro as part of its API, which is used in client programs.
    .target(
      name: "RaycastExtensionMacro",
      dependencies: ["MacroImplementation"]
    ),

    // A client of the library, which is able to use the macro in its own code.
    .executableTarget(
      name: "ClientExample",
      dependencies: ["RaycastExtensionMacro"]
    ),

    // A test target used to develop the macro implementation.
    .testTarget(
      name: "MacroTests",
      dependencies: [
        "MacroImplementation",
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),
  ]
)
