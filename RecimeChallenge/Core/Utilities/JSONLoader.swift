import Foundation

enum JSONLoader {
    static func load<T: Decodable>(_ filename: String, as type: T.Type) throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw APIError.fileNotFound(filename)
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw APIError.networkError(error)
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
