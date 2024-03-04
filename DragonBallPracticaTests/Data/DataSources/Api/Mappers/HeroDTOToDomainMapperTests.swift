import XCTest
@testable import DragonBallPractica

final class HeroDTOToDomainMapperTests: XCTestCase {
    
    var sut: HeroDTOToDomainMapper!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = HeroDTOToDomainMapper()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testMapper_mapDataWithAllValues_getSuccess() throws {
        let heroDTO = HeroDTO(
            id: "123456",
            favorite: true,
            name: "Goku",
            photo: "https://www.google.com",
            description: "description"
        )
        let hero = try XCTUnwrap(sut.map(heroDTO))
        
        XCTAssertEqual(hero.id, heroDTO.id)
        XCTAssertEqual(hero.isFavorite, heroDTO.favorite)
        XCTAssertEqual(hero.name, heroDTO.name)
        XCTAssertEqual(hero.photo, heroDTO.photo)
        XCTAssertEqual(hero.description, heroDTO.description)
    }
    
    func testMapper_mapDataWithOnlyIdValue_getSuccess() throws {
        let heroDTO = HeroDTO(
            id: "123456",
            favorite: nil,
            name: nil,
            photo: nil,
            description: nil
        )
        let hero = try XCTUnwrap(sut.map(heroDTO))
        
        XCTAssertEqual(hero.id, heroDTO.id)
        XCTAssertEqual(hero.isFavorite, false)
        XCTAssertEqual(hero.name, "")
        XCTAssertEqual(hero.photo, nil)
        XCTAssertEqual(hero.description, nil)
    }
    
    func testMapper_mapDataWithAllNilValues_getHeroNil() {
        let heroDTO = HeroDTO(
            id: nil,
            favorite: nil,
            name: nil,
            photo: nil,
            description: nil
        )
        let hero = sut.map(heroDTO)
        XCTAssertNil(hero)
    }
    
    func testMapper_mapDataWithPhotoHTTPScheme_getPhotoHTTPSScheme() throws {
        let heroDTO = HeroDTO(
            id: "123456",
            favorite: true,
            name: "Goku",
            photo: "http://www.google.com",
            description: "description"
        )
        let hero = try XCTUnwrap(sut.map(heroDTO))
        
        XCTAssertEqual(hero.id, heroDTO.id)
        XCTAssertEqual(hero.isFavorite, heroDTO.favorite)
        XCTAssertEqual(hero.name, heroDTO.name)
        XCTAssertEqual(hero.photo, "https://www.google.com")
        XCTAssertEqual(hero.description, heroDTO.description)
    }
}
