//
//  HeroCell.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 7/6/26.
//

import UIKit

// Protocol για να "μιλήσει" το cell πίσω στον ViewController όταν γίνει search.
protocol HeroCellDelegate: AnyObject {
    func heroCellDidSearch(query: String)
}

final class HeroCell: UICollectionViewCell {

    weak var delegate: HeroCellDelegate?

    // MARK: - UI Elements
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let searchContainer = UIView()
    private let searchTextField = UITextView()
    private let searchButton = UIButton(type: .system)
    private let placeholderLabel = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Views
    private func setupViews() {
        // Logo
        let config = UIImage.SymbolConfiguration(pointSize: 64, weight: .medium)
        logoImageView.image = UIImage(systemName: "cpu", withConfiguration: config)
        logoImageView.tintColor = AppColors.accent
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoImageView)

        // Title
        titleLabel.text = "Spec-Ops"
        titleLabel.font = UIFont.systemFont(ofSize: 38, weight: .black)
        titleLabel.textColor = AppColors.accent
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        // Subtitle
        subtitleLabel.text = "AI-powered hardware advisor"
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)

        // Search container
        searchContainer.backgroundColor = AppColors.cardBackground
        searchContainer.layer.cornerRadius = 14
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(searchContainer)

        // Search icon
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .secondaryLabel
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(searchIcon)

        // TextView
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchTextField.backgroundColor = .clear
        searchTextField.isScrollEnabled = false
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        searchTextField.textColor = .white
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(searchTextField)

        // Placeholder
        placeholderLabel.text = "e.g. laptop for coding..."
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.textColor = AppColors.accent.withAlphaComponent(0.5)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(placeholderLabel)

        // Search button
        var config2 = UIButton.Configuration.filled()
        config2.title = "Find My Tech"
        config2.image = UIImage(systemName: "arrow.right")
        config2.imagePlacement = .trailing
        config2.imagePadding = 8
        config2.baseBackgroundColor = AppColors.accent
        config2.cornerStyle = .large
        config2.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var updated = attrs
            updated.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            return updated
        }
        searchButton.configuration = config2
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(searchButton)
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        guard let searchIcon = searchContainer.subviews.first as? UIImageView else { return }

        NSLayoutConstraint.activate([
            
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            searchContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 48),
            searchContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            searchContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            searchIcon.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 16),
            searchIcon.topAnchor.constraint(equalTo: searchContainer.topAnchor, constant: 14),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20),

            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -16),
            searchTextField.topAnchor.constraint(equalTo: searchContainer.topAnchor, constant: 8),
            searchTextField.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: -8),

            placeholderLabel.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor, constant: 5),
            placeholderLabel.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),

            searchButton.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 16),
            searchButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            searchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            searchButton.heightAnchor.constraint(equalToConstant: 54),
            searchButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Actions
    @objc private func searchButtonTapped() {
        performSearch()
    }

    private func performSearch() {
        let query = searchTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        searchTextField.resignFirstResponder()
        delegate?.heroCellDidSearch(query: query)
    }
}

extension HeroCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            performSearch()
            return false
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
