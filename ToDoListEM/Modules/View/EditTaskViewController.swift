//
//  EditTaskViewController.swift
//  ToDoListEM
//
//  Created by Илья Востров on 28.08.2025.
//

import UIKit

class EditTaskViewController: UIViewController {
    
    private let titleLabel = UITextField()
    private let noteTextView = UITextView()
    private let dateLabel = UILabel()
    
    private let datePicker = UIDatePicker()
    private let datePickerContainer = UIView()
    private let datePickerDoneButton = UIButton(type: .system)
    
    private var datePickerVisible = false
    private var noteTextViewHeightConstraint: NSLayoutConstraint!
    
    var task: ToDoItem?
    var onSave: ((ToDoItem) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        setupUI()
        setupDatePicker()
        loadTask()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent || isBeingDismissed {
            saveAndClose()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = nil
        
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left
        titleLabel.placeholder = "Введите название"
        
        noteTextView.font = .systemFont(ofSize: 16)
        noteTextView.textColor = .label
        noteTextView.backgroundColor = .clear
        noteTextView.textContainerInset = .zero
        noteTextView.textContainer.lineFragmentPadding = 0
        noteTextView.isScrollEnabled = false
        noteTextView.delegate = self
        
        dateLabel.font = .systemFont(ofSize: 15, weight: .regular)
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .left
        dateLabel.isUserInteractionEnabled = true
        dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped)))
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.backgroundColor = .systemBackground
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        [titleLabel, noteTextView, dateLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(noteTextView)
        
        noteTextViewHeightConstraint = noteTextView.heightAnchor.constraint(equalToConstant: 60)
        noteTextViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateLabel.heightAnchor.constraint(equalToConstant: 30),
            
            noteTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            noteTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            noteTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: noteTextView.bottomAnchor, constant: 40)
        ])
        
        setupDatePickerContainer()
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.maximumDate = Date()
    }
    
    private func setupDatePickerContainer() {
        datePickerContainer.backgroundColor = .systemGray6
        datePickerContainer.layer.cornerRadius = 12
        datePickerContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePickerContainer)
        
        datePickerDoneButton.setTitle("ОК", for: .normal)
        datePickerDoneButton.setTitleColor(.systemYellow, for: .normal)
        datePickerDoneButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        datePickerDoneButton.addTarget(self, action: #selector(hideDatePicker), for: .touchUpInside)
        
        [datePicker, datePickerDoneButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        datePickerContainer.addSubview(datePicker)
        datePickerContainer.addSubview(datePickerDoneButton)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerContainer.topAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 160),
            
            datePickerDoneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 8),
            datePickerDoneButton.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor, constant: -16),
            datePickerDoneButton.bottomAnchor.constraint(equalTo: datePickerContainer.bottomAnchor, constant: -8),
            datePickerDoneButton.heightAnchor.constraint(equalToConstant: 30),
            
            datePickerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePickerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            datePickerContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            datePickerContainer.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        datePickerContainer.alpha = 0
    }
    
    @objc private func dateLabelTapped() {
        if datePickerVisible {
            hideDatePicker()
        } else {
            showDatePicker()
        }
    }
    
    private func showDatePicker() {
        datePickerVisible = true
        UIView.animate(withDuration: 0.3) {
            self.datePickerContainer.alpha = 1
        }
    }
    
    @objc private func hideDatePicker() {
        datePickerVisible = false
        UIView.animate(withDuration: 0.3) {
            self.datePickerContainer.alpha = 0
        }
    }
    
    @objc private func dateChanged() {
        updateDateLabel()
    }
    
    private func updateDateLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = "Дата: \(formatter.string(from: datePicker.date))"
    }
    
    private func loadTask() {
        if let task = task {
            titleLabel.text = task.title
            if !task.note.isEmpty {
                noteTextView.text = task.note
            }
            datePicker.date = task.createdAt
        } else {
            titleLabel.text = ""
            noteTextView.text = ""
            datePicker.date = Date()
        }
        updateDateLabel()
    }
    
    private func saveAndClose() {
        let title = titleLabel.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if title.isEmpty {
            showAlert(title: "Ошибка", message: "Название задачи не может быть пустым")
            return
        }
        
        let taskId = task?.id ?? 0
        let updatedTask = ToDoItem(
            id: taskId,
            title: title,
            note: noteTextView.text,
            createdAt: datePicker.date,
            isCompleted: task?.isCompleted ?? false
        )
        onSave?(updatedTask)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension EditTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
        let newHeight = max(60, size.height)
        UIView.animate(withDuration: 0.1) {
            self.noteTextViewHeightConstraint.constant = newHeight
            self.view.layoutIfNeeded()
        }
    }
}
