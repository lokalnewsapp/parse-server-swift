import Vapor
import ParseSwift

// swiftlint:disable:next cyclomatic_complexity function_body_length
func routes(_ app: Application) throws {
    
    let env = try Environment.detect()
    let port = Environment.get("PARSE_SERVER_SWIFT_PORT")
    print("ENVIRONMENT: \(env.name)")
    print("PORT: \(port.logable)")
    
    do {
        try app.register(collection: BusogCollection())
        //try app.register(collection: LocationCollection())
        try app.register(collection: UserCollection())
        try app.register(collection: LokalityCollection())
    } catch {
        print(error)
    }
    
}
