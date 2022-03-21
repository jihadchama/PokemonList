import Quick
import Nimble

@testable import PokemonList

class PokeListViewModelSpec: QuickSpec {
    
    var mockClient: MockPokeClient!
    var sut: PokeListViewModel!
    
    override func spec() {
        beforeEach {
            self.mockClient = MockPokeClient()
            self.sut = PokeListViewModelImpl(client: self.mockClient)
        }
        
        afterEach {
            self.mockClient = nil
            self.sut = nil
        }
        
        context("Should update pokemon list after requested") {
            it("successfully requested") {
                self.sut.requestPokemons()
                
                expect(self.sut.pokeListLiveData.value).toNot(beNil())
            }
            it("failed request") {
                self.mockClient.shouldRequestFails = true
                
                self.sut.requestPokemons()
                
                expect(self.sut.pokeListLiveData.value).to(beNil())
            }
        }
        
        context("Testing update method when receive pokemon list") {
            it("successfully update pokemon list when receive a pokemon list") {
                self.sut.update(with: PokemonListModel(next: "xpto",
                                                       results: [PokemonModel(name: "xpto", url: "xpto")]))
                
                expect(self.sut.pokeListLiveData.value).toNot(beNil())
                expect(self.sut.pokeListLiveData.value?.next).to(equal("xpto"))
                expect(self.sut.pokeListLiveData.value?.results.count).to(equal(1))
                expect(self.sut.pokeListLiveData.value?.results.first?.name).to(equal("xpto"))
            }
            
            it("should append pokemons in pokemon list when paginate") {
                self.sut.requestPokemons()
                self.sut.requestPokemons()
                
                expect(self.sut.pokeListLiveData.value).toNot(beNil())
                expect(self.sut.pokeListLiveData.value?.results.count).to(equal(2))
            }
            
            it ("should update nextPageURL when paginate") {
                self.sut.requestPokemons()
                self.sut.update(with: PokemonListModel(next: "page2",
                                                       results: [PokemonModel(name: "xpto", url: "xpto")]))
                
                expect(self.sut.pokeListLiveData.value).toNot(beNil())
                expect(self.sut.pokeListLiveData.value?.results.count).to(equal(2))
                expect(self.sut.pokeListLiveData.value?.next).to(equal("page2"))
            }
        }
    }
}
