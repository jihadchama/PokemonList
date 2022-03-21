import XCTest
@testable import PokemonList

class PokeListViewControllerTest: XCTestCase {
    
    var mockPokeClient: MockPokeClient!
    var mockPokeListViewModel: MockPokeListViewModel!
    var sut: PokeListViewController!
    
    override func setUp() {
        mockPokeClient = MockPokeClient()
        mockPokeListViewModel = MockPokeListViewModel(client: mockPokeClient)
        sut = PokeListViewController(viewModel: mockPokeListViewModel)
    }
    
    override func tearDown() {
        mockPokeClient = nil
        mockPokeListViewModel = nil
        sut = nil
    }
    
    func test_WhenViewDidLoad_ShouldRequestPokemons_AndWhenSuccess_UpdateViewModel() {
        sut.viewDidLoad()
        sut.viewDidAppear(true)
        
        XCTAssertNotNil(sut.pokeListViewModel.pokeListLiveData.value)
    }
    
    func test_WhenViewDidLoad_ShouldRequestPokemons_AndWhenFails_NotUpdateViewModel() {
        mockPokeClient.shouldRequestFails = true
        
        sut.viewDidLoad()
        sut.viewDidAppear(true)
        
        XCTAssertNil(sut.pokeListViewModel.pokeListLiveData.value)
    }
    
    func test_ShouldPaginated_WhenScrolledToTheEndOfTheList() {
        sut.viewDidLoad()
        sut.viewDidAppear(true)
        
        sut.paginate(1, true)
        
        XCTAssertEqual(sut.pokeListViewModel.pokeListLiveData.value?.results.count, 2)
    }
    
    func test_ShouldCallViewModel_WhenUserClickOnCell() {
        sut.viewDidLoad()
        
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(item: 0, section: 0))
        
        XCTAssertTrue(mockPokeListViewModel.didChoosePokemon)
    }
}
