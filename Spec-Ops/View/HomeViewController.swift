//
//  ViewController.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 13/5/26.
//

import UIKit
 

nonisolated enum HomeSection: Hashable {
    case hero
}
 

nonisolated enum HomeItem: Hashable {
    case hero
}
 
@MainActor class HomeViewController: UIViewController {
 
    // MARK: - Properties
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!
 
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupCollectionView()
        setupDataSource()
        applySnapshot()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
 
    // MARK: - Layout
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            // Προς το παρόν έχουμε μόνο μία section (hero).
            // Όταν προσθέσουμε features/categories, εδώ θα μπει switch.
            return self.heroSectionLayout()
        }
    }
 
    private func heroSectionLayout() -> NSCollectionLayoutSection {
        // Item: γεμίζει όλο το group
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(500)   // εκτίμηση — το cell θα πει το πραγματικό
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
 
        // Group: ίδιο μέγεθος με το item (μία στήλη)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(500)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
 
        return NSCollectionLayoutSection(group: group)
    }
 
    // MARK: - Setup
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = AppColors.background
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
 
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
 
    private func setupDataSource() {
        // Registration για το HeroCell
        let heroRegistration = UICollectionView.CellRegistration<HeroCell, HomeItem> { cell, _, _ in
            cell.delegate = self
        }
 
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: heroRegistration,
                for: indexPath,
                item: item
            )
        }
    }
 
    // MARK: - Snapshot
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        snapshot.appendSections([.hero])
        snapshot.appendItems([.hero], toSection: .hero)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
 
// MARK: - HeroCellDelegate
extension HomeViewController: HeroCellDelegate {
    func heroCellDidSearch(query: String) {
        let resultsVC = ResultsViewController(query: query)
        navigationController?.pushViewController(resultsVC, animated: true)
    }
}
