import Foundation

enum Storage {
    private enum Error: Swift.Error {
        case noDocumentDirectory
    }

    static let documentDirectory = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first

    static let fileName = "milestones.plist"

    static func persist(dates: [Milestone]) throws {
        guard let documentDirectory = self.documentDirectory else {
            throw Error.noDocumentDirectory
        }

        let fileURL = documentDirectory.appendingPathComponent(fileName)
        let data = try PropertyListEncoder().encode(dates)
        try data.write(to: fileURL)
    }

    static func loadFromDisk() throws -> [Milestone] {
        guard let documentDirectory = self.documentDirectory else {
            throw Error.noDocumentDirectory
        }

        let fileURL = documentDirectory.appendingPathComponent(fileName)
        let data = try Data(contentsOf: fileURL)
        return try PropertyListDecoder().decode([Milestone].self, from: data)
    }
}
