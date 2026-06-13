//
//  ViewController.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 13/5/26.
//

import UIKit
 
// Sections του Home — enum για type safety
nonisolated enum HomeSection: Hashable {
    case hero
    case features
    case categories
}
 
// Items μέσα στις sections
nonisolated enum HomeItem: Hashable {
    case hero
    case feature(icon: String, title: String)
    case category(icon: String, title: String)
}
 
@MainActor class HomeViewController: UIViewController {
 
    // MARK: - Properties
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!
    private let backgroundImageView = UIImageView()
    private let overlayView = UIView()
 
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupViews()
        setupConstraints()
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
 
    // MARK: - Setup Views
    private func setupViews() {
        // Background image
        backgroundImageView.image = UIImage(named: "hero_bg")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
 
        // Dark overlay για readability
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
 
        // Collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
 
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Background — γεμίζει όλη την οθόνη edge-to-edge
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
 
            // Overlay — ταιριάζει με το background
            overlayView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
 
            // Collection view
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
 
    // MARK: - Layout
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:  return self.heroSectionLayout()
            case 1:  return self.featuresSectionLayout()
            default: return self.categoriesSectionLayout()
            }
        }
    }
 
    private func heroSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(500)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
 
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(500)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
 
        return NSCollectionLayoutSection(group: group)
    }
 
    private func featuresSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 3.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
 
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(80)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
 
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 24, bottom: 24, trailing: 24)
        return section
    }
 
    private func categoriesSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 4.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
 
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(90)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
 
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 24, bottom: 24, trailing: 24)
 
        // Section header ("Top Categories")
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SectionHeaderView.elementKind,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
 
        return section
    }
 
    // MARK: - Data Source
    private func setupDataSource() {
        let heroRegistration = UICollectionView.CellRegistration<HeroCell, HomeItem> { cell, _, _ in
            cell.delegate = self
        }
 
        let featureRegistration = UICollectionView.CellRegistration<FeatureCell, HomeItem> { cell, _, item in
            if case let .feature(icon, title) = item {
                cell.configure(icon: icon, title: title)
            }
        }
 
        let categoryRegistration = UICollectionView.CellRegistration<CategoryCell, HomeItem> { cell, _, item in
            if case let .category(icon, title) = item {
                cell.configure(icon: icon, title: title)
            }
        }
 
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(
            elementKind: SectionHeaderView.elementKind
        ) { headerView, _, indexPath in
            let section = self.dataSource.sectionIdentifier(for: indexPath.section)
            if section == .categories {
                headerView.configure(title: "Top Categories")
            }
        }
 
        // 1. Φτιάχνουμε το data source
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            switch item {
            case .hero:
                return collectionView.dequeueConfiguredReusableCell(
                    using: heroRegistration, for: indexPath, item: item)
            case .feature:
                return collectionView.dequeueConfiguredReusableCell(
                    using: featureRegistration, for: indexPath, item: item)
            case .category:
                return collectionView.dequeueConfiguredReusableCell(
                    using: categoryRegistration, for: indexPath, item: item)
            }
        }
 
        // 2. Μετά του βάζουμε τον supplementary provider
        dataSource.supplementaryViewProvider = { _, _, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: indexPath)
        }
    }
 
    // MARK: - Snapshot
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
 
        snapshot.appendSections([.hero])
        snapshot.appendItems([.hero], toSection: .hero)
 
        snapshot.appendSections([.features])
        snapshot.appendItems([
            .feature(icon: "sparkles", title: "AI Picks"),
            .feature(icon: "checkmark.shield", title: "Trusted Specs"),
            .feature(icon: "tag", title: "Best Prices")
        ], toSection: .features)
 
        snapshot.appendSections([.categories])
        snapshot.appendItems([
            .category(icon: "gamecontroller", title: "Gaming"),
            .category(icon: "laptopcomputer", title: "Laptops"),
            .category(icon: "cpu", title: "GPUs"),
            .category(icon: "headphones", title: "Audio")
        ], toSection: .categories)
 
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
 
// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
 
        if case let .category(_, title) = item {
            let resultsVC = ResultsViewController(query: title)
            navigationController?.pushViewController(resultsVC, animated: true)
        }
    }
}
