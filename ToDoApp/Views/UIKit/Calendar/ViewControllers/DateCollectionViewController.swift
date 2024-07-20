//
//  DateCollectionViewController.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/20/24.
//

import Foundation
import UIKit

class DateCollectionViewController: UIViewController {

    private var viewModel: TodoListViewModel

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init(viewModel: TodoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupConstraints()
    }
}

// MARK: Data source
extension DateCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Array(viewModel.todosGroupedByDate.keys).sorted().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as? DateCollectionViewCell else {
            return UICollectionViewCell()
        }
        let sortedKeys = Array(viewModel.todosGroupedByDate.keys).sorted()
        cell.makeCell(text: sortedKeys[indexPath.row])
        return cell
    }
}

// MARK: Delegate
extension DateCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

// MARK: Constraint
extension DateCollectionViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 100),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
