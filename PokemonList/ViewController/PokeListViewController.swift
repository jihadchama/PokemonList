import UIKit

class PokeListViewController: UIViewController {
    let pokeListViewModel: PokeListViewModel
    
    private var pokeListKvo: NSKeyValueObservation?
    private var paginating: Bool = false
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .darkGray
        tableView.register(PokeTableViewCell.self, forCellReuseIdentifier: PokeTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    
    init(viewModel: PokeListViewModel) {
        self.pokeListViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        observePokemonListLiveData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pokeListViewModel.requestPokemons()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func observePokemonListLiveData() {
        pokeListKvo = pokeListViewModel.pokeListLiveData.observe { _ in
            self.tableView.reloadData()
            self.paginating = false
        }
    }
}

extension PokeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokeListViewModel.pokeListLiveData.value?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokeTableViewCell.identifier, for: indexPath) as! PokeTableViewCell
        cell.selectionStyle = .none
        cell.render(with: pokeListViewModel.pokeListLiveData.value?.results[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pokeListViewModel.didChoosePokemon(with: pokeListViewModel.pokeListLiveData.value?.results[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let cellHeight = 20.0
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        let isContentMarginLessThanCellHeight = (contentHeight - offset - screenHeight) < cellHeight

        paginate(offset, isContentMarginLessThanCellHeight)
    }
    
    func paginate(_ offset: CGFloat, _ isContentMarginLessThanCellHeight: Bool) {
        if offset > 0, isContentMarginLessThanCellHeight, !paginating {
            pokeListViewModel.requestPokemons()
            paginating = true
        }
    }
}
