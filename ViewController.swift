//
//  ViewController.swift
//  surfjam
//
//  Created by Anton Krivonozhenkov on 01.08.2023.
//

import UIKit

class ViewController: UIViewController {

    let contentView = UIView()
    let imageView = UIImageView(image: Images.placeholder)
    let labelName = UILabel()
    let labelAbout = UILabel()
    let labelLocation = UILabel()
    let imageViewLocation = UIImageView(image: UIImage(systemName: "location.fill"))
    let stackViewLocation = UIStackView()
    let headerGroup = UIStackView()

    private var items = ["Item 1", "Item 2", "Item 3"]
    private var isEditingMode = false

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width, height: 50)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "Cell")
    //    collectionView.backgroundColor = .gray
        collectionView.tintColor = .black

        return collectionView
    }()

    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditMode))
        return button
    }()

    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        configureUIElements()

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(headerGroup)
        setupCollectionView()

        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        addSubviews()

        layoutUI()
    }

    func setNavigationBar() {
        self.navigationItem.title = Texts.title
        navigationItem.rightBarButtonItem = editButton
        navigationItem.leftBarButtonItem = addButton
    }

    func configureUIElements() {
        view.backgroundColor = .white

        labelName.numberOfLines = 2
        labelName.text = Texts.name
        labelName.textAlignment = .center
        labelName.font = UIFont.boldSystemFont(ofSize: 24)
        labelName.lineBreakMode = .byTruncatingTail

        imageView.contentMode = .scaleAspectFit

        labelAbout.numberOfLines = 1
        labelAbout.text = Texts.aboutShort
        labelAbout.textAlignment = .center
        labelAbout.font = UIFont.systemFont(ofSize: 16)
        labelAbout.lineBreakMode = .byTruncatingTail

        labelLocation.numberOfLines = 1
        labelLocation.text = Texts.location
        labelLocation.textAlignment = .left
        labelLocation.font = UIFont.systemFont(ofSize: 16)
        labelLocation.lineBreakMode = .byTruncatingTail

        stackViewLocation.axis = .horizontal
        stackViewLocation.alignment = .center
        stackViewLocation.spacing = 10

        imageViewLocation.tintColor = .black
        imageViewLocation.contentMode = .scaleAspectFit

        headerGroup.axis = .vertical
        headerGroup.spacing = 20
      //  headerGroup.backgroundColor = .lightGray
        headerGroup.isLayoutMarginsRelativeArrangement = true
        headerGroup.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    func addSubviews() {
        headerGroup.addArrangedSubview(imageView)
        headerGroup.addArrangedSubview(labelName)
        headerGroup.addArrangedSubview(labelAbout)
        headerGroup.addArrangedSubview(stackViewLocation)
        stackViewLocation.addArrangedSubview(imageViewLocation)
        stackViewLocation.addArrangedSubview(labelLocation)
    }

    func layoutUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelAbout.translatesAutoresizingMaskIntoConstraints = false
        labelLocation.translatesAutoresizingMaskIntoConstraints = false
        stackViewLocation.translatesAutoresizingMaskIntoConstraints = false
        headerGroup.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerGroup.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            headerGroup.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            headerGroup.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerGroup.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            labelName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            labelName.widthAnchor.constraint(equalToConstant: 200),

            labelAbout.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelAbout.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),

            stackViewLocation.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackViewLocation.topAnchor.constraint(equalTo: labelAbout.bottomAnchor, constant: 8)
        ])
    }

    private func setupCollectionView() {
        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerGroup.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: headerGroup.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: headerGroup.trailingAnchor),
            //       collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            collectionView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }

    @objc private func toggleEditMode() {
        isEditingMode.toggle()
        navigationItem.rightBarButtonItem?.title = isEditingMode ? "Done" : "Edit"
        collectionView.reloadData()
    }

    @objc private func addItem() {
        let alert = UIAlertController(title: "Добавление навыка", message: "Введите название навыка, которым вы владеете", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Введите название"
        }

        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self, weak alert] _ in
            guard let itemName = alert?.textFields?.first?.text, !itemName.isEmpty else { return }
            self?.items.append(itemName)
            self?.collectionView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.label.text = items[indexPath.item]
        
        if isEditingMode {
            let deleteButton = UIButton(type: .system)
            deleteButton.setTitle("удалить", for: .normal)
            deleteButton.addTarget(self, action: #selector(deleteItem(_:)), for: .touchUpInside)
            deleteButton.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
            deleteButton.backgroundColor = .red
            deleteButton.layer.cornerRadius = 4
            deleteButton.tag = indexPath.item
            
            cell.contentView.addSubview(deleteButton)
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                deleteButton.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                deleteButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
        } else {
            for subview in cell.contentView.subviews {
                subview.removeFromSuperview()
            }
        }
        
        return cell
    }
    
    @objc private func deleteItem(_ sender: UIButton) {
           items.remove(at: sender.tag)
           collectionView.reloadData()
       }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
