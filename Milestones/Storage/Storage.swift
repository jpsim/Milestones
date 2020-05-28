import Foundation

enum Storage {
    private enum Error: Swift.Error {
        case noCachesDirectory
    }

    static let cachesDirectory = FileManager.default
        .urls(for: .cachesDirectory, in: .userDomainMask)
        .first

    static let fileName = "milestones.plist"

    static func persist(dates: [Milestone]) throws {
        guard let cachesDirectory = self.cachesDirectory else {
            throw Error.noCachesDirectory
        }

        let cacheFileURL = cachesDirectory.appendingPathComponent(fileName)
        let data = try PropertyListEncoder().encode(dates)
        try data.write(to: cacheFileURL)
    }

    static func loadFromDisk() throws -> [Milestone] {
        guard let cachesDirectory = self.cachesDirectory else {
            throw Error.noCachesDirectory
        }

        let cacheFileURL = cachesDirectory.appendingPathComponent(fileName)
        let cacheData = try Data(contentsOf: cacheFileURL)
        return try PropertyListDecoder().decode([Milestone].self, from: cacheData)
    }
}
