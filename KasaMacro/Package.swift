// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "KasaMacro",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(
            name: "KasaMacro",
            targets: ["KasaMacro"]
        ),
        .executable(
            name: "KasaMacroClient",
            targets: ["KasaMacroClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.0-latest"),
    ],
    targets: [
        /// 공통 타입 모듈
        .target(
            name: "KasaMacroShared",
            dependencies: []
        ),
        
        /// 매크로 구현 타겟
        .macro(
            name: "Implementations",
            dependencies: [
                "KasaMacroShared",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        
        /// 인터페이스 타겟 (라이브러리로 노출될)
        .target(
            name: "KasaMacro",
            dependencies: [
                "KasaMacroShared",
                "Implementations"
            ]
        ),
        
        /// 클라이언트
        .executableTarget(name: "KasaMacroClient", dependencies: ["KasaMacro"]),
        
        /// 테스트
        .testTarget(
            name: "KasaMacroTests",
            dependencies: [
                "KasaMacroShared",
                "Implementations",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
