//
//  ProductCollectionCell.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 17/5/26.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {

    // MARK: - UI Elements
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let priceLabel = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        contentView.backgroundColor = AppColors.cardBackground
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true

        // Λεπτή orange γραμμή στην κορυφή — subtle accent
        let accentLine = UIView()
        accentLine.backgroundColor = AppColors.accent
        accentLine.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(accentLine)

        NSLayoutConstraint.activate([
            accentLine.topAnchor.constraint(equalTo: contentView.topAnchor),
            accentLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            accentLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            accentLine.heightAnchor.constraint(equalToConstant: 3)
        ])

        setupIcon()
        setupLabels()
        setupConstraints()
    }

    private func setupIcon() {
        let config = UIImage.SymbolConfiguration(pointSize: 36, weight: .light)
        iconImageView.preferredSymbolConfiguration = config
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = AppColors.accent
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
    }

    private func setupLabels() {
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 3
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Category — pill style
        categoryLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        categoryLabel.textColor = AppColors.accent
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false

        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .black)
        priceLabel.textColor = .label
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(priceLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Icon — centered στην κορυφή
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 48),
            iconImageView.heightAnchor.constraint(equalToConstant: 48),

            // Name
            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            // Category
            categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            // Price — κολλητά στο κάτω μέρος
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
    }

    // MARK: - Configure
    func configure(with product: Product) {
        nameLabel.text = product.name
        categoryLabel.text = product.category.uppercased()
        priceLabel.text = product.price
        iconImageView.image = UIImage(systemName: CategoryIcon.iconName(for: product.category))
    }
}
