import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, destinations: Destinations, versionNumber: String, platform: Platform, packages: [Package], dependencies: [TargetDependency], additionalTargets: [Target], additionalFiles: [FileElement]) -> Project {
        var targets = makeAppTargets(name: name,
                                     destinations: destinations,
                                     versionNumber: versionNumber,
                                     platform: platform,
                                     dependencies: dependencies + additionalTargets.compactMap { $0.name.hasSuffix("Tests") ? nil : TargetDependency.target(name: $0.name) })
        targets += additionalTargets
        
        let baseSettings = SettingsDictionary()
            .automaticCodeSigning(devTeam: "EHV7XZLAHA")
            .marketingVersion(versionNumber)
            .currentProjectVersion("Auto generated")
        let settings = Settings.settings(base: baseSettings, defaultSettings: .recommended)

        return Project(name: name,
                       organizationName: "Stream.io Inc.",
                       packages: packages,
                       settings: settings,
                       targets: targets,
                       additionalFiles: additionalFiles,
                       resourceSynthesizers: .default)
    }

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    public static func makeFrameworkTargets(name: String, destinations: Destinations, platform: Platform, dependencies: [TargetDependency], noResources: Bool = true) -> [Target] {
        let sources = Target.target(name: name,
                destinations: destinations,
                product: .framework,
                bundleId: "io.getstream.\(name)",
                infoPlist: InfoPlist.default,
                sources: ["Targets/\(name)/Sources/**"],
                resources: noResources ? [] : ["Targets/\(name)/Resources/**"],
                dependencies: dependencies)
        let tests = Target.target(name: "\(name)Tests",
                destinations: destinations,
                product: .unitTests,
                bundleId: "io.getstream.twitterclone.\(name)Tests",
                infoPlist: InfoPlist.default,
                sources: ["Targets/\(name)/Tests/**"],
                resources: [],
                dependencies: [TargetDependency.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, destinations: Destinations, versionNumber: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let infoPlist: [String: Plist.Value] = [
            "CFBundleShortVersionString": Plist.Value(stringLiteral: versionNumber),
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
            "NSAppleMusicUsageDescription": "Please allow access to media.",
            "NSCameraUsageDescription": "Please allow access to the Camera to add photo&apos;s to posts.",
            "NSPhotoLibraryUsageDescription": "Please allow access to the Photo library to add photo&apos;s to posts.",
            "NSMicrophoneUsageDescription": "Please allow access to the Mic to talk in audio spaces",
            "NSLocalNetworkUsageDescription": "Please allow access to local network to enable audio calling",
            "UIApplicationSceneManifest": ["UISceneConfigurations":[:]]
            ]
        
        let swiftlintTargetAction = TargetScript.pre(path: .relativeToRoot("bin/swiftlint.sh"), name: "Swiftlint.", basedOnDependencyAnalysis: false)
        let buildNumberTargetAction = TargetScript.post(path: .relativeToRoot("bin/set_build_number.sh"), name: "Set build number", basedOnDependencyAnalysis: false)

        let mainTarget = Target.target(
            name: name,
            destinations: destinations,
            product: .app,
            bundleId: "io.getstream.\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            entitlements: "TwitterClone.entitlements",
            scripts: [swiftlintTargetAction, buildNumberTargetAction],
            dependencies: dependencies,
            launchArguments: [.launchArgument(name: "NETWORK_PAYLOAD_LOGGING_ENABLED", isEnabled: false)]
        )

        let testTarget = Target.target(
            name: "\(name)Tests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "io.getstream.twitterclone.\(name)Tests",
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        return [mainTarget, testTarget]
    }
}
