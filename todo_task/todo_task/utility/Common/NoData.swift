//
//  NoData.swift
//  todo_task
//
//  Created by Piyush on 22/04/25.
//

import UIKit

class NoDataView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "tray") 
        imageView.tintColor = PrimaryColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No Data Available"
        label.textColor = PrimaryColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(message: String = "No Data Available", image: UIImage? = UIImage(systemName: "tray")) {
        super.init(frame: .zero)
        self.messageLabel.text = message
        self.imageView.image = image
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(imageView)
        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60),

            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
}
