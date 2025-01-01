import Fluent
import FluentPostgresDriver
import NIOSSL
import Vapor

public func configure(_ app: Application) async throws {
    try routes(app)
}
