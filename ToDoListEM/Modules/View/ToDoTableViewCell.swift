//
//  ToDoTableViewCell.swift
//  ToDoListEM
//
//  Created by Илья Востров on 28.08.2025.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ToDoCell"
    
    private let titleLabel = UILabel()
    private let noteLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        selectionStyle = .default
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        
        noteLabel.font = .systemFont(ofSize: 14)
        noteLabel.textColor = .secondaryLabel
        noteLabel.numberOfLines = 1
        
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel
        
        statusButton.setImage(UIImage(systemName: "circle"), for: .normal)
        statusButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        statusButton.tintColor = UIColor(red: 0xFF/255.0, green: 0xD7/255.0, blue: 0x02/255.0, alpha: 1.0)
        statusButton.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
        
        [titleLabel, noteLabel, dateLabel, statusButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            statusButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            statusButton.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            statusButton.widthAnchor.constraint(equalToConstant: 30),
            statusButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -60),
            
            noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            noteLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            noteLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -60),
            
            dateLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -4)
        ])
    }
    
    func configure(with task: ToDoItem) {
        titleLabel.text = task.title
        noteLabel.text = task.note.isEmpty ? nil : task.note
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = formatter.string(from: task.createdAt)
        
        statusButton.isSelected = task.isCompleted
    }
}
