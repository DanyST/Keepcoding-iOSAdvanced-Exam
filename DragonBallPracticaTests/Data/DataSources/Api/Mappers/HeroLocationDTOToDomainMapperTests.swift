import XCTest
@testable import DragonBallPractica

final class HeroLocationDTOToDomainMapperTests: XCTestCase {
    var sut: HeroLocationDTOToDomainMapper!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = HeroLocationDTOToDomainMapper()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testMapper_mapDataWithAllValues_getSuccess() throws {
        let hero = Hero(
            id: "123456",
            name: "Goku", 
            isFavorite: true,
            photo: "https://www.google.com",
            description: "description"
        )
        
        let heroLocationDTO = HeroLocationDTO(
            id: "123456",
            latidude: "35.71867899343361",
            longitude: "139.8202084625344",
            dateShow: "2022-02-20T00:00:00Z",
            heroId: hero.id
        )
        
        let heroLocation = try XCTUnwrap(sut.map(heroLocationDTO, with: hero))
        
        XCTAssertEqual(heroLocation.id, heroLocationDTO.id)
        XCTAssertEqual(heroLocation.latitude, heroLocationDTO.latidude)
        XCTAssertEqual(heroLocation.longitude, heroLocationDTO.longitude)
        XCTAssertEqual(heroLocation.dateShow, heroLocationDTO.dateShow)
        XCTAssertEqual(heroLocation.hero.id, hero.id)
        XCTAssertEqual(heroLocation.hero.name, hero.name)
        XCTAssertEqual(heroLocation.hero.photo, hero.photo)
        XCTAssertEqual(heroLocation.hero.description, hero.description)
        XCTAssertEqual(heroLocation.hero.isFavorite, hero.isFavorite)
    }
    
    func testMapper_mapDataWithAllNilValues_getHeroLocationNil() {
        let hero = Hero(
            id: "123456",
            name: "Goku",
            isFavorite: true,
            photo: "https://www.google.com",
            description: "description"
        )
        
        let heroLocationDTO = HeroLocationDTO(
            id: nil,
            latidude: nil,
            longitude: nil,
            dateShow: nil,
            heroId: nil
        )
        
        let heroLocation = sut.map(heroLocationDTO, with: hero)
        XCTAssertNil(heroLocation)
    }
}
