import Quick
import Nimble

@testable import PokemonList

class PokeListViewControllerSpec: QuickSpec {
    var mockClient: MockPokeClient!
    var mockViewModel: MockPokeListViewModel!
    var sut: PokeListViewController!
    
    override func spec() {
        beforeEach { [self] in
            mockClient = MockPokeClient()
            mockViewModel = MockPokeListViewModel(client: mockClient)
            sut = PokeListViewController(viewModel: mockViewModel)
        }

        afterEach { [self] in
            mockClient = nil
            mockViewModel = nil
            sut = nil
        }
        
        context("Testing requests when view did load") { [self] in
            it("Should request pokemons and when success update view model") {
                sut.viewDidLoad()
                sut.viewDidAppear(true)
                
                expect(sut.pokeListViewModel.pokeListLiveData.value).toNot(beNil())
            }
            
            it("Should request pokemons and when fails not update view model") {
                mockClient.shouldRequestFails = true
                
                sut.viewDidLoad()
                sut.viewDidAppear(true)
                
                expect(sut.pokeListViewModel.pokeListLiveData.value).to(beNil())
            }
        }
        
        context("Testing paginating when scroll to the end of the list") { [self] in
            it("when scrolled down should update") {
                sut.viewDidLoad()
                sut.viewDidAppear(true)
                                
                sut.paginate(1, true)
                
                expect(sut.pokeListViewModel.pokeListLiveData.value?.results.count).to(equal(2))
            }
        }
        
        context("Testing click in a row") { [self] in
            it("should call didChoosePokemon method from ViewModel when clicked in a row") {
                sut.viewDidLoad()
                sut.viewDidAppear(true)
                
                sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

                expect(mockViewModel.didChoosePokemon).to(beTrue())
            }
        }
    }
}
