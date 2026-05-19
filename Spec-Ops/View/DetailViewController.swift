//
//  DetailViewController.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 17/5/26.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Properties
    private let product: Product

    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let productImageView = UIImageView()
    private let categoryLabel = UILabel()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let divider = UIView()
    private let descriptionTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Init
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        navigationController?.navigationBar.tintColor = AppColors.accent
        setupScrollView()
        setupProductImage()
        setupCategoryLabel()
        setupNameLabel()
        setupPriceLabel()
        setupDivider()
        setupDescriptionTitle()
        setupDescriptionLabel()
        configure()
        fetchImage()
    }

    // MARK: - Setup
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupProductImage() {
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.backgroundColor = AppColors.cardBackground
        productImageView.layer.cornerRadius = 16
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(productImageView)

        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            productImageView.heightAnchor.constraint(equalToConstant: 220)
        ])
        activityIndicator.color = AppColors.accent
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        productImageView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: productImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor)
        ])

        activityIndicator.startAnimating()
    }

    private func setupCategoryLabel() {
        categoryLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        categoryLabel.textColor = AppColors.accent
        categoryLabel.textAlignment = .center
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)

        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 24),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }

    private func setupNameLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 28, weight: .black)
        nameLabel.textColor = AppColors.primaryText
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }

    private func setupPriceLabel() {
        priceLabel.font = UIFont.systemFont(ofSize: 36, weight: .black)
        priceLabel.textColor = AppColors.accent
        priceLabel.textAlignment = .center
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)

        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }

    private func setupDivider() {
        divider.backgroundColor = AppColors.cardBackground
        divider.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(divider)

        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 32),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupDescriptionTitle() {
        descriptionTitleLabel.text = "WHY THIS?"
        descriptionTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        descriptionTitleLabel.textColor = AppColors.accent
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionTitleLabel)

        NSLayoutConstraint.activate([
            descriptionTitleLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 24),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24)
        ])
    }

    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        descriptionLabel.textColor = AppColors.secondaryText
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }

    // MARK: - Configure
    private func configure() {
        nameLabel.text = product.name
        categoryLabel.text = product.category.uppercased()
        priceLabel.text = product.price
        descriptionLabel.text = product.description
    }

    // MARK: - Fetch Image
    private func fetchImage() {
        Task {
            do {
                let imageURL = try await NetworkManager.shared.fetchProductImage(query: product.name)
                guard let url = URL(string: imageURL) else { return }
                let (data, _) = try await URLSession.shared.data(from: url)
                await MainActor.run {
                    productImageView.image = UIImage(data: data)
                    activityIndicator.stopAnimating()
                }
            } catch {
                await MainActor.run {
                    productImageView.isHidden = true
                    activityIndicator.stopAnimating()
                }
            }
        }
    }
}
