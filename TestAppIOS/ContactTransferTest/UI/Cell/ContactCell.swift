//
//  ContactCell.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 03.02.2021.
//

import UIKit

class ContactCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var contact: Contact? {
        didSet {
            userNameLabel.text = contact?.fullName
            phoneNumberLabel.text = contact?.phoneNumber
            emailAdressLabel.text = contact?.email
            photoImageView.image = contact?.image?.toImage
        }
    }
    
    // MARK: - Views
    
    private let photoImageView: UIImageView = .make()
    
    private lazy var textContainer: UIStackView = .makeStack(
        axis: .vertical,
        arrangedSubviews: [userNameLabel, phoneNumberLabel, emailAdressLabel])
    
    private let userNameLabel: UILabel = .makeSubheader(withSize: 18)
    private let phoneNumberLabel: UILabel = .makeSubheader(withSize: 16)
    private let emailAdressLabel: UILabel = .makeRegular(withSize: 16)
    
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
        contact = nil
    }
}

// MARK: - Configuration
extension ContactCell {
    func configure() {
        setupLayout()
    }
    
    func setupLayout() {
        setupPhotoImageView()
        setupTextContainer()
        
        userNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        phoneNumberLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        emailAdressLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    private func setupPhotoImageView() {
        photoImageView.layer.setCornerRadius(width: 32)
        contentView.addSubview(photoImageView)
        photoImageView.backgroundColor = .lightGray
        photoImageView.layout {
            $0.constraint(to: contentView, by: .leading(10))
            $0.centerY.constraint(to: contentView, by: .centerY(0))
            $0.size(.height(64), .width(64))
        }
    }
    
    private func setupTextContainer() {
        contentView.addSubview(textContainer)
        textContainer.setDistribution(.equalSpacing)
        textContainer.layout {
            $0.constraint(to: contentView, by: .trailing(-10), .bottom(-10), .top(10))
            $0.leading.constraint(to: photoImageView, by: .trailing(30))
            $0.size(.height(64))//, .width(64))
        }
    }
}



extension Data {
    var toImage: UIImage? {
        UIImage(data: self)
    }
}
