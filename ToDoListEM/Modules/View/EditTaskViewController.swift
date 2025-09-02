import UIKit

class EditTaskViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleTextField = UITextField()
    private let noteTextView = UITextView()
    private let isCompletedSwitch = UISwitch()
    private let switchLabel = UILabel()
    
    var task: ToDoItem?
    var onSave: ((ToDoItem) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadTask()
    }
    
    private func setupUI() {
        title = "Редактировать"
        view.backgroundColor = .systemBackground
        
        titleTextField.placeholder = "Название задачи"
        titleTextField.font = .systemFont(ofSize: 18, weight: .semibold)
        titleTextField.borderStyle = .roundedRect
        titleTextField.backgroundColor = .systemGray6
        
        noteTextView.font = .systemFont(ofSize: 14)
        noteTextView.backgroundColor = .systemGray6
        noteTextView.layer.cornerRadius = 8
        noteTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        isCompletedSwitch.onTintColor = .systemYellow
        switchLabel.text = "Выполнена"
        switchLabel.textColor = .label
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(saveTask)
        )
        
        [scrollView, contentView, titleTextField, noteTextView, switchLabel, isCompletedSwitch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(titleTextField)
        contentView.addSubview(noteTextView)
        contentView.addSubview(switchLabel)
        contentView.addSubview(isCompletedSwitch)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            noteTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            noteTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            noteTextView.heightAnchor.constraint(equalToConstant: 120),
            
            switchLabel.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 24),
            switchLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            switchLabel.centerYAnchor.constraint(equalTo: isCompletedSwitch.centerYAnchor),
            
            isCompletedSwitch.topAnchor.constraint(equalTo: switchLabel.topAnchor),
            isCompletedSwitch.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: isCompletedSwitch.bottomAnchor, constant: 40)
        ])
    }
    
    private func loadTask() {
        guard let task = task else { return }
        titleTextField.text = task.title
        noteTextView.text = task.note
        isCompletedSwitch.isOn = task.isCompleted
    }
    
    @objc private func saveTask() {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        let updatedTask = ToDoItem(
            id: task?.id ?? 0,
            title: title,
            note: noteTextView.text,
            createdAt: task?.createdAt ?? Date(),
            isCompleted: isCompletedSwitch.isOn
        )
        onSave?(updatedTask)
        navigationController?.popViewController(animated: true)
    }
}