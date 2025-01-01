import Fluent
import Testing
import VaporTesting

@testable import App

struct AppTests {
    private func withApp(_ test: (Application) async throws -> Void) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await app.autoMigrate()
            try await test(app)
            try await app.autoRevert()
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }

    @Test func index() async throws {
        try await withApp { app in
            let testing = try app.testing()
            
            let response = try await testing.sendRequest(.GET, "")
            
            #expect(response.status == .ok)
            #expect(response.body.string == "Swift on Server!")
        }
    }
    
    @Test func helloWorld() async throws {
        try await withApp { app in
            let testing = try app.testing()
            
            let response = try await testing.sendRequest(.GET, "hello")
            
            #expect(response.status == .ok)
            #expect(response.body.string == "Hello, world!")
        }
    }
    
    @Test func env() async throws {
        setenv("TEXT", "こんにちは", 1)
        try await withApp { app in
            let testing = try app.testing()
            
            let response = try await testing.sendRequest(.GET, "environment")
            
            #expect(response.status == .ok)
            #expect(response.body.string == "こんにちは")
        }
    }
}
