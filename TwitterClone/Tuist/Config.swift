import ProjectDescription

let config = Config(
swiftVersion: "5.7.2",
    plugins: [
        .local(path: .relativeToManifest("../../Plugins/TwitterClone")),
    ]
)
