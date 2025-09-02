//
//  BViewController.swift (SlideMenu).swift
//  MenuToModal
//
//  Created by Yuki Sasaki on 2025/09/03.
//

import SwiftUI

import UIKit

import UIKit

class BViewController: UIViewController {
    weak var delegate: SlideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground

        let titleLabel = UILabel()
        titleLabel.text = "Slide Menu"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)

        let openButton = UIButton(type: .system)
        openButton.setTitle("Open TransferModal (C)", for: .normal)
        openButton.addTarget(self, action: #selector(openTransfer), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleLabel, openButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func openTransfer() {
        delegate?.didToggleBool(true)
    }
}
