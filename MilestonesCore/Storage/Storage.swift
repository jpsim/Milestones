import Foundation

enum Storage {
    private enum Error: Swift.Error {
        case noAppGroupContainerDirectory
    }

    static let appGroupContainerDirectory = FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: "group.com.jpsim")

    static let fileName = "milestones.plist"

    static func persist(dates: [Milestone]) throws {
        guard let containerDirectory = self.appGroupContainerDirectory else {
            throw Error.noAppGroupContainerDirectory
        }

        let fileURL = containerDirectory.appendingPathComponent(fileName)
        let data = try PropertyListEncoder().encode(dates)
        try data.write(to: fileURL)
    }

    static func loadFromDisk() throws -> [Milestone] {
        guard let containerDirectory = self.appGroupContainerDirectory else {
            throw Error.noAppGroupContainerDirectory
        }

        let fileURL = containerDirectory.appendingPathComponent(fileName)
        let data = try Data(contentsOf: fileURL)
        return try PropertyListDecoder().decode([Milestone].self, from: data)
    }
}
