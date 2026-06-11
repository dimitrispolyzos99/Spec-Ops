//
//  FavoriteViewController.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 11/6/26.
//

import UIKit

@MainActor class FavoritesViewController: UIViewController {

    // MARK: - Properties
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<ResultsSection, Product>!
    private let emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        title = "Favorites"
        setupViews()
        setupConstraints()
        setupDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFavorites()
    }

    // MARK: - Setup Views
    private func setupViews() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = AppColors.background
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        // Empty state — όταν δεν υπάρχουν favorites
        emptyLabel.text = "No favorites yet.\nTap the ♡ on any product to save it here."
        emptyLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emptyLabel.textColor = AppColors.secondaryText
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

    // MARK: - Layout (ίδιο grid με το Results)
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(240)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - Data Source
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductCollectionCell, Product> { cell, _, product in
            cell.configure(with: product)
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, product in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: product)
        }
    }

    // MARK: - Reload
    private func reloadFavorites() {
        let favorites = FavoritesManager.shared.allFavorites()

        emptyLabel.isHidden = !favorites.isEmpty
        collectionView.isHidden = favorites.isEmpty

        var snapshot = NSDiffableDataSourceSnapshot<ResultsSection, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(favorites)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailVC = DetailViewController(product: product)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
