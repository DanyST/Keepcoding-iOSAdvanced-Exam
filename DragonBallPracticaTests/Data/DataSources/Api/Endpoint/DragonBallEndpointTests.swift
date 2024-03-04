import XCTest
@testable import DragonBallPractica

final class DragonBallEndpointTests: XCTestCase {
    var sut = DragonBallEndpoint.self

    func testDragonBallEndpoint_loginRequest_theCorrectValues() {
        let baseURL = URL(string: "https://www.google.com")!
        let request = sut.login.request(with: baseURL)
        XCTAssertEqual(request?.url?.absoluteString, "\(baseURL.absoluteString)/auth/login")
        XCTAssertEqual(request?.httpMethod, "POST")
        XCTAssertNotNil(request?.httpBody)
    }
    
    func testDragonBallEndpoint_heroesRequest_theCorrectValues() throws {
        let baseURL = URL(string: "https://www.google.com")!
        let heroName = "Goku"
        let request = sut.heroes(name: "Goku").request(with: baseURL)
        XCTAssertEqual(request?.url?.absoluteString, "\(baseURL.absoluteString)/heros/all")
        XCTAssertEqual(request?.httpMethod, "POST")
        XCTAssertNotNil(request?.httpBody)
        
        let httpBody = try XCTUnwrap(request?.httpBody)
        let httpBodyDictionary = try JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: String]
        
        XCTAssertEqual(httpBodyDictionary?["name"], heroName)
    }
    
    func testDragonBallEndpoint_heroLocationsRequest_theCorrectValues() throws {
        let baseURL = URL(string: "https://www.google.com")!
        let heroId = "123456"
        let request = sut.heroLocations(heroId: heroId).request(with: baseURL)
        XCTAssertEqual(request?.url?.absoluteString, "\(baseURL.absoluteString)/heros/locations")
        XCTAssertEqual(request?.httpMethod, "POST")
        XCTAssertNotNil(request?.httpBody)
        
        let httpBody = try XCTUnwrap(request?.httpBody)
        let httpBodyDictionary = try JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: String]
        
        XCTAssertEqual(httpBodyDictionary?["id"], heroId)
    }
}
