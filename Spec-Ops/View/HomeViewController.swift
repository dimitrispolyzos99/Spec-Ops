//
//  ViewController.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 13/5/26.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - UI Elements
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let searchContainer = UIView()
    private let searchTextField = UITextView()
    private let searchButton = UIButton(type: .system)
    private let placeholderLabel = UILabel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupLogo()
        setupTitleLabel()
        setupSubtitleLabel()
        setupSearchContainer()
        setupSearchButton()
    }

    // MARK: - Setup
    private func setupLogo() {
        let config = UIImage.SymbolConfiguration(pointSize: 64, weight: .medium)
        logoImageView.image = UIImage(systemName: "cpu", withConfiguration: config)
        logoImageView.tintColor = AppColors.accent
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func setupTitleLabel() {
        titleLabel.text = "Spec-Ops"
        titleLabel.font = UIFont.systemFont(ofSize: 38, weight: .black)
        titleLabel.textColor = AppColors.accent
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func setupSubtitleLabel() {
        subtitleLabel.text = "AI-powered hardware advisor"
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = AppColors.accent.withAlphaComponent(0.5)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func setupSearchContainer() {
        // 1. Πρώτα addSubview το container στο view
        searchContainer.backgroundColor = .secondarySystemBackground
        searchContainer.layer.cornerRadius = 14
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.backgroundColor = AppColors.cardBackground
        view.addSubview(searchContainer)


        NSLayoutConstraint.activate([
            searchContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 48),
            searchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        // 2. Search icon
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .secondaryLabel
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(searchIcon)

        // 3. TextView
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchTextField.backgroundColor = .clear
        searchTextField.isScrollEnabled = false
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        searchTextField.textColor = .white
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(searchTextField)

        // 4. Placeholder — addSubview ΠΡΙΝ τα constraints
        placeholderLabel.text = "e.g. laptop for coding..."
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.textColor = AppColors.accent.withAlphaComponent(0.5)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(placeholderLabel)

        // 5. Όλα τα constraints μαζί στο τέλος
        NSLayoutConstraint.activate([
            searchIcon.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 16),
            searchIcon.topAnchor.constraint(equalTo: searchContainer.topAnchor, constant: 14),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20),

            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -16),
            searchTextField.topAnchor.constraint(equalTo: searchContainer.topAnchor, constant: 8),
            searchTextField.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: -8),

            placeholderLabel.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor, constant: 5),
            placeholderLabel.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor)
        ])
    }

    private func setupSearchButton() {
        var config = UIButton.Configuration.filled()
        config.title = "Find My Tech"
        config.image = UIImage(systemName: "arrow.right")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseBackgroundColor = AppColors.accent
        config.cornerStyle = .large
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var updated = attrs
            updated.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            return updated
        }
        searchButton.configuration = config
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchButton)

        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 16),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            searchButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }

    // MARK: - Actions
    @objc private func searchButtonTapped() {
        performSearch()
    }

    private func performSearch() {
        guard let query = searchTextField.text?.trimmingCharacters(in: .whitespaces) else {
            shakeSearchContainer()
            return
        }
        searchTextField.resignFirstResponder()
        let resultsVC = ResultsViewController(query: query)
        navigationController?.pushViewController(resultsVC, animated: true)
    }

    private func shakeSearchContainer() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.4
        animation.values = [-10, 10, -8, 8, -5, 5, 0]
        searchContainer.layer.add(animation, forKey: "shake")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension HomeViewController: UITextViewDelegate {
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
