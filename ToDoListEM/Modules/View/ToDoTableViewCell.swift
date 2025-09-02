import UIKit

class ToDoTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ToDoCell"
    
    private let titleLabel = UILabel()
    private let noteLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusButton = UIButton()
    private let avatarStackView = UIStackView()
    private let separatorView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        statusButton.tintColor = .systemYellow
        statusButton.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
        
        avatarStackView.axis = .horizontal
        avatarStackView.spacing = 4
        avatarStackView.alignment = .center
        
        separatorView.backgroundColor = .separator
        
        [titleLabel, noteLabel, dateLabel, statusButton, avatarStackView, separatorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        addAvatars()
    }
    
    private func addAvatars() {
        ["M", "I", "D"].forEach { letter in
            let button = UIButton(type: .system)
            button.setTitle(letter, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 10, weight: .bold)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.randomColor()
            button.layer.cornerRadius = 16
            button.clipsToBounds = true
            button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            avatarStackView.addArrangedSubview(button)
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
            noteLabel.trailingAnchor.constraint(lessThanOrEqualTo: avatarStackView.leadingAnchor, constant: -8),
            
            dateLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -4),
            
            avatarStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            avatarStackView.heightAnchor.constraint(equalToConstant: 32),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with task: ToDoItem) {
        titleLabel.text = task.title
        noteLabel.text = task.note.isEmpty ? nil : task.note
        dateLabel.text = task.createdAt.formatted(date: .abbreviated, time: .omitted)
        statusButton.isSelected = task.isCompleted
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}