//
//  CompareViewController.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 12/6/26.
//

import UIKit

@MainActor class CompareViewController: UIViewController {

    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let mainStack = UIStackView()
    private let compareProducts: [Product]


    init(products: [Product]) {
            self.compareProducts = products
            super.init(nibName: nil, bundle: nil) // ΠΡΟΣΟΧΗ: Αυτό έλειπε!
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        title = "Compare"
        setupViews()
        setupConstraints()
        buildComparison()
    }

    // MARK: - Setup
    private func setupViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(mainStack)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            mainStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            mainStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }

    // MARK: - Build
    private func buildComparison() {
        let products = compareProducts
        guard !products.isEmpty else { return }

        mainStack.addArrangedSubview(makeHeaderRow(products))
        mainStack.addArrangedSubview(makeRow(title: "Price", values: products.map { "\($0.price)" }))
        mainStack.addArrangedSubview(makeRow(title: "Category", values: products.map { $0.category.uppercased() }))
        mainStack.addArrangedSubview(makeRow(title: "Rating", values: products.map {
            $0.rating.map { "★ \($0)" } ?? "—"
        }))
        mainStack.addArrangedSubview(makeRow(title: "Match", values: products.map {
            $0.matchScore.map { "\($0)%" } ?? "—"
        }))
        mainStack.addArrangedSubview(makeRow(title: "Badge", values: products.map {
            $0.badge?.displayTitle ?? "—"
        }))
    }

    // MARK: - Row builders
    private func makeHeaderRow(_ products: [Product]) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = 8

        for product in products {
            let column = UIStackView()
            column.axis = .vertical
            column.spacing = 8
            column.alignment = .fill        // ← ήταν .center, άλλαξέ το

            // Εικόνα προϊόντος
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.backgroundColor = AppColors.cardBackground
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: 90).isActive = true

            // Async φόρτωση εικόνας από Unsplash (ίδιο pattern με το Detail)
            Task {
                do {
                    let imageURL = try await NetworkManager.shared.fetchProductImage(query: product.name)
                    guard let url = URL(string: imageURL) else { return }
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data) {
                        imageView.image = image
                    }
                } catch {
                    // αν αποτύχει, μένει το cardBackground placeholder — ΟΚ
                }
            }

            let nameLabel = UILabel()
            nameLabel.text = product.name
            nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            nameLabel.textColor = AppColors.primaryText
            nameLabel.textAlignment = .center
            nameLabel.numberOfLines = 2

            column.addArrangedSubview(imageView)
            column.addArrangedSubview(nameLabel)
            row.addArrangedSubview(column)
        }
        return row
    }

    private func makeRow(title: String, values: [String]) -> UIView {
        let container = UIView()
        container.backgroundColor = AppColors.cardBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = title.uppercased()
        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        titleLabel.textColor = AppColors.secondaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)

        let valuesRow = UIStackView()
        valuesRow.axis = .horizontal
        valuesRow.distribution = .fillEqually
        valuesRow.spacing = 8
        valuesRow.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(valuesRow)

        for value in values {
            let label = UILabel()
            label.text = value
            label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            label.textColor = AppColors.primaryText
            label.textAlignment = .center
            label.numberOfLines = 2
            valuesRow.addArrangedSubview(label)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),

            valuesRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valuesRow.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            valuesRow.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            valuesRow.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])

        return container
    }

}
