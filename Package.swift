// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "ReactorMacro",
    platforms: [.macOS(.v10_15), .iOS(.v15)],
    products: [
        .library(
            name: "ReactorMacro",
            targets: ["ReactorMacro"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0"),
    ],
    targets: [
        /// 공통 타입 모듈
        .target(
            name: "ReactorMacroShared",
            dependencies: []
        ),
        
        /// 매크로 구현 타겟
        .macro(
            name: "ReactorMacroPlugin",
            dependencies: [
                "ReactorMacroShared",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        
        /// 인터페이스 타겟 (라이브러리로 노출될)
        .target(
            name: "ReactorMacro",
            dependencies: [
                "ReactorMacroShared",
                "ReactorMacroPlugin"
            ]
        ),
        
        /// 클라이언트 (매크로 동작 확인용 예제, 외부로 노출되지 않음)
        .executableTarget(name: "ReactorMacroClient", dependencies: ["ReactorMacro"]),
        
        /// 테스트
        .testTarget(
            name: "ReactorMacroTests",
            dependencies: [
                "ReactorMacroShared",
                "ReactorMacroPlugin",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
