//
//  ToDoViewController.swift
//  ToDoListEM
//
//  Created by Илья Востров on 28.08.2025.
//


import UIKit

class ToDoViewController: UIViewController {
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let footerView = UIView()
    private let taskCountLabel = UILabel()
    private let addTaskButton = UIButton()
    var presenter: ToDoViewOutput?
    private var tasks: [ToDoItem] = []
    private var blurView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let router = presenter?.router, let nc = self.navigationController {
            router.navigationController = nc
        }
        
        setupUI()
        setupConstraints()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        title = "Задачи"
        view.backgroundColor = .systemBackground
        
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.setImage(UIImage(systemName: "mic"), for: .bookmark, state: .normal)
        searchBar.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.backgroundColor = .clear
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.reuseIdentifier)
        tableView.separatorColor = UIColor(white: 0.4, alpha: 0.8)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        

        footerView.backgroundColor = UIColor(
            red: 39/255.0,
            green: 39/255.0,
            blue: 41/255.0,
            alpha: 1.0
        )
        footerView.layer.cornerRadius = 8
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        taskCountLabel.font = .systemFont(ofSize: 14)
        taskCountLabel.textColor = .white
        taskCountLabel.textAlignment = .center
        
        addTaskButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        addTaskButton.tintColor = UIColor(red: 0xFF/255.0, green: 0xD7/255.0, blue: 0x02/255.0, alpha: 1.0)
        addTaskButton.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
        
        [taskCountLabel, addTaskButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        footerView.addSubview(taskCountLabel)
        footerView.addSubview(addTaskButton)
        
        NSLayoutConstraint.activate([
            taskCountLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            taskCountLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 15),
            
            addTaskButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -25),
            addTaskButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10),
        ])
        
        [searchBar, tableView, footerView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(footerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 64)
            
            
        ])
    }
    
    private func setupTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        
        let interaction = UIContextMenuInteraction(delegate: self)
        tableView.addInteraction(interaction)
    }
    

    
    @objc private func addNewTask() {
        presenter?.router?.showEditTaskForNewTask()
    }
    

}

extension ToDoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.reuseIdentifier, for: indexPath) as! ToDoTableViewCell
        cell.configure(with: tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        presenter?.toggleTaskStatus(id: task.id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            presenter?.deleteTask(id: task.id)
        }
    }
}

extension ToDoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchTasks(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        presenter?.searchTasks(query: "")
        searchBar.resignFirstResponder()
    }
}

extension ToDoViewController: ToDoViewInput {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tasks = self.presenter?.tasks ?? []
            self.taskCountLabel.text = "\(self.tasks.count) Задач"
            self.tableView.reloadData()
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

extension ToDoViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = interaction.location(in: tableView).indexPath(in: tableView),
              let _ = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell
        else { return nil }
        
        let task = tasks[indexPath.row]
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { [weak self] in
                return self?.makePreviewViewController(for: task)
            }
        ) { _ in
            return self.makeContextMenu(for: task)
        }
    }
    
    private func makePreviewViewController(for task: ToDoItem) -> UIViewController {
        let previewVC = UIViewController()
        previewVC.view.backgroundColor = .systemBackground
        
        let cardView = CardView(task: task)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        previewVC.view.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: previewVC.view.layoutMarginsGuide.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: previewVC.view.layoutMarginsGuide.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: previewVC.view.layoutMarginsGuide.trailingAnchor),
            cardView.bottomAnchor.constraint(lessThanOrEqualTo: previewVC.view.layoutMarginsGuide.bottomAnchor)
        ])
        
        return previewVC
    }
    
    private func makeContextMenu(for task: ToDoItem) -> UIMenu {
        let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { [weak self] _ in
            self?.presenter?.router?.showEditTask(task: task)
        }
        
        let share = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
            let activity = UIActivityViewController(activityItems: [task.title], applicationActivities: nil)
            self?.present(activity, animated: true)
        }
        
        let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.presenter?.deleteTask(id: task.id)
        }
        
        return UIMenu(title: "", children: [edit, share, delete])
    }
}

private class CardView: UIView {
    private let titleLabel = UILabel()
    private let noteLabel = UILabel()
    private let dateLabel = UILabel()
    
    init(task: ToDoItem) {
        super.init(frame: .zero)
        setupUI(task: task)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(task: ToDoItem) {
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 8
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        
        noteLabel.font = .systemFont(ofSize: 14)
        noteLabel.textColor = .secondaryLabel
        noteLabel.numberOfLines = 2
        
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel
        
        [titleLabel, noteLabel, dateLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        addSubview(titleLabel)
        addSubview(noteLabel)
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            noteLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            noteLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -8)
        ])
        
        titleLabel.text = task.title
        noteLabel.text = task.note.isEmpty ? nil : task.note
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = formatter.string(from: task.createdAt)
    }
}

extension CGPoint {
    func indexPath(in tableView: UITableView) -> IndexPath? {
        return tableView.indexPathForRow(at: self)
    }
}
