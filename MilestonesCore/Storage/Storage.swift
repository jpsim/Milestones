import Foundation

enum Storage {
    private enum Error: Swift.Error {
        case noAppGroupContainerDirectory
    }

    private static let documentDirectory = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first

    private static let appGroupContainerDirectory = FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: "group.com.jpsim")

    private static let fileName = "milestones.plist"

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

        // Previous versions stored the file in the document directory, so if no file exists in the app group container,
        // try loading from the document directory to migrate data.

        let fileURL = containerDirectory.appendingPathComponent(fileName)
        let documentFileURL = documentDirectory?.appendingPathComponent(fileName)

        let data: Data
        if !FileManager.default.fileExists(atPath: fileURL.path),
            let documentFileURL = documentFileURL,
            FileManager.default.fileExists(atPath: documentFileURL.path)
        {
            data = try Data(contentsOf: documentFileURL)
        } else {
            data = try Data(contentsOf: fileURL)
        }

        return try PropertyListDecoder().decode([Milestone].self, from: data)
    }
}
