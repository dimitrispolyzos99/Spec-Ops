//
//  ResultsViewController.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 14/5/26.
//

import UIKit

// Sections του CollectionView — enum για type safety (top-level to avoid actor isolation)
nonisolated enum ResultsSection: Hashable {
    case main
}

@MainActor class ResultsViewController: UIViewController {

    // MARK: - Properties
    private let query: String
    private let viewModel = ResultsViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<ResultsSection, Product>!


    // MARK: - Init
    init(query: String) {
        self.query = query
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = AppColors.accent
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: AppColors.primaryText
        ]
        navigationController?.navigationBar.barTintColor = AppColors.background
        view.backgroundColor = AppColors.background
        title = "Results"
        setupCollectionView()
        setupDataSource()
        setupActivityIndicator()      // ← Μετά το collectionView
        activityIndicator.startAnimating()
        bindViewModel()
        viewModel.fetchProducts(query: query)
    }

    // MARK: - Layout
    private func createLayout() -> UICollectionViewLayout {
        // Item: 50% του πλάτους του group
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        // Group: 100% πλάτος, fixed ύψος, περιέχει 2 items
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(240)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - Setup
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = AppColors.background
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.delegate = self

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func setupActivityIndicator(){
        activityIndicator.color = AppColors.accent
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductCollectionCell, Product> { cell, indexPath, product in
            cell.configure(with: product)
        }

        // Δημιουργία DataSource
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, product in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: product
            )
        }
    }

    // MARK: - Bind
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.applySnapshot()
        }
        viewModel.onError = { [weak self] message in
            self?.activityIndicator.stopAnimating()
        }
    }

    // MARK: - Snapshot
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ResultsSection, Product>()
        snapshot.appendSections([ResultsSection.main])
        snapshot.appendItems(viewModel.products)
        dataSource.apply(snapshot, animatingDifferences: true)
        activityIndicator.stopAnimating()
    }
}
extension ResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.row]
        let detailVC = DetailViewController(product: product)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
