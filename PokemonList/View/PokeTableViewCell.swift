import SnapKit
import UIKit

class PokeTableViewCell: UITableViewCell {
    static let identifier = "PokeTableViewCellIdentifier"
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        contentView.addSubview(nameLabel)
        contentView.backgroundColor = .darkGray

        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func render(with name: String?) {
        nameLabel.text = name
    }
}
