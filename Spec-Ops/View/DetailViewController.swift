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
    private let ratingLabel = UILabel()
    private let matchLabel = PaddedLabel()
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
        setupViews()
        setupConstraints()
        configure()
        fetchImage()
    }
 
    // MARK: - Setup Views
    private func setupViews() {
        // ScrollView + ContentView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
 
        // Product image
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.backgroundColor = AppColors.cardBackground
        productImageView.layer.cornerRadius = 16
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(productImageView)
 
        // Activity indicator (πάνω στην εικόνα)
        activityIndicator.color = AppColors.accent
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        productImageView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
 
        // Category
        categoryLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        categoryLabel.textColor = AppColors.accent
        categoryLabel.textAlignment = .center
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)
 
        // Name
        nameLabel.font = UIFont.systemFont(ofSize: 28, weight: .black)
        nameLabel.textColor = AppColors.primaryText
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
 
        // Price
        priceLabel.font = UIFont.systemFont(ofSize: 36, weight: .black)
        priceLabel.textColor = AppColors.accent
        priceLabel.textAlignment = .center
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
 
        // Rating
        ratingLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        ratingLabel.textColor = AppColors.secondaryText
        ratingLabel.textAlignment = .center
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingLabel)
 
        // Match score pill
        matchLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        matchLabel.textColor = .white
        matchLabel.backgroundColor = AppColors.accent
        matchLabel.layer.cornerRadius = 8
        matchLabel.clipsToBounds = true
        matchLabel.textAlignment = .center
        matchLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(matchLabel)
 
        // Divider
        divider.backgroundColor = AppColors.cardBackground
        divider.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(divider)
 
        // Description title
        descriptionTitleLabel.text = "WHY THIS?"
        descriptionTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        descriptionTitleLabel.textColor = AppColors.accent
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionTitleLabel)
 
        // Description
        descriptionLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        descriptionLabel.textColor = AppColors.secondaryText
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
    }
 
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
 
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
 
            // Product image
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            productImageView.heightAnchor.constraint(equalToConstant: 220),
 
            // Activity indicator
            activityIndicator.centerXAnchor.constraint(equalTo: productImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
 
            // Category
            categoryLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 24),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
 
            // Name
            nameLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
 
            // Price
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
 
            // Rating
            ratingLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
 
            // Match pill
            matchLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 16),
            matchLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
 
            // Divider
            divider.topAnchor.constraint(equalTo: matchLabel.bottomAnchor, constant: 32),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            divider.heightAnchor.constraint(equalToConstant: 1),
 
            // Description title
            descriptionTitleLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 24),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
 
            // Description
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
 
        // Rating + reviews
        if let rating = product.rating {
            if let reviews = product.reviewCount {
                ratingLabel.text = "★ \(rating) · \(reviews) reviews"
            } else {
                ratingLabel.text = "★ \(rating)"
            }
        } else {
            ratingLabel.text = ""
        }
 
        // Match score
        if let score = product.matchScore {
            matchLabel.text = "✦ \(score)% Match"
            matchLabel.isHidden = false
        } else {
            matchLabel.isHidden = true
        }
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
