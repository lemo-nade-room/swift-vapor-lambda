import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { _ in
        "Swift on Server!"
    }
    
    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("environment") { req in
        Environment.get("TEXT") ?? "環境変数: 'Text'が設定されていません"
    }
}
