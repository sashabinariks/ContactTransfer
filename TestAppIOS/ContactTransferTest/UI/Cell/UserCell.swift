//
//  UserCell.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import UIKit

protocol UserCellDelegate: class {
    func shouldStartPairWithUser(_ user: User)
}

class UserCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            userNameLabel.text = user?.displayName
        }
    }
    
    weak var delegate: UserCellDelegate?
    
    // MARK: - Views
    
    private lazy var container: UIStackView = .makeStack(
        axis: .horizontal,
        arrangedSubviews: [userNameLabel, pairButton])
    
    private let userNameLabel: UILabel = .makeSubheader()
    private let pairButton: UIButton = .make(title: "Pair")
    
    // MARK: - Constructor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        user = nil
    }
    
    @objc private func didTapOnPair(_ sender: UIButton) {
        guard let user = user else { return }
        delegate?.shouldStartPairWithUser(user)
    }
}


// MARK: - Configuration
extension UserCell {
    func configure() {
        setupLayout()
        pairButton.addTarget(self, action: #selector(didTapOnPair(_:)), for: .touchUpInside)
    }
    
    func setupLayout() {
        contentView.addSubview(container)
        container.layout {
            $0.constraint(to: contentView)
        }
        
        userNameLabel.text = "Teset wests t"
        pairButton.widthAnchor.constraint(equalToConstant: 80).activate()
    }
}
