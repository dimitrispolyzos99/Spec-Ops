//
//  ViewController.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 13/5/26.
//

import UIKit
 

nonisolated enum HomeSection: Hashable {
    case hero
    case features
}
 

nonisolated enum HomeItem: Hashable {
    case hero
    case feature(icon: String, title: String)
}
 
@MainActor class HomeViewController: UIViewController {
 
    // MARK: - Properties
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!
    private let backgroundImageView = UIImageView()
 
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupBackground()
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
            switch sectionIndex {
            case 0:  return self.heroSectionLayout()
            default: return self.featuresSectionLayout()
            }
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
    
    private func featuresSectionLayout() -> NSCollectionLayoutSection {
        // Item: το 1/3 του πλάτους (3 features δίπλα-δίπλα)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 3.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        // Group: όλο το πλάτος, σταθερό ύψος, οριζόντιο
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(80)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 24, bottom: 24, trailing: 24)
        return section
    }
 
    // MARK: - Setup
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
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
        let heroRegistration = UICollectionView.CellRegistration<HeroCell, HomeItem> { cell, _, _ in
            cell.delegate = self
        }

        let featureRegistration = UICollectionView.CellRegistration<FeatureCell, HomeItem> { cell, _, item in
            if case let .feature(icon, title) = item {
                cell.configure(icon: icon, title: title)
            }
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            switch item {
            case .hero:
                return collectionView.dequeueConfiguredReusableCell(
                    using: heroRegistration, for: indexPath, item: item)
            case .feature:
                return collectionView.dequeueConfiguredReusableCell(
                    using: featureRegistration, for: indexPath, item: item)
            }
        }
    }
    private func setupBackground() {
        backgroundImageView.image = UIImage(named: "hero_bg")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)

        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlay)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlay.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)
        ])
    }
 
    // MARK: - Snapshot
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()

        snapshot.appendSections([.hero])
        snapshot.appendItems([.hero], toSection: .hero)

        snapshot.appendSections([.features])
        snapshot.appendItems([
            .feature(icon: "sparkles", title: "AI Recommendations"),
            .feature(icon: "checkmark.shield", title: "Trusted Specs"),
            .feature(icon: "tag", title: "Best Prices")
        ], toSection: .features)

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
