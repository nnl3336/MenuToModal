//
//  CViewController.swift (TransferModal).swift
//  MenuToModal
//
//  Created by Yuki Sasaki on 2025/09/03.
//

import SwiftUI

import UIKit

import UIKit

class CViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint

        let label = UILabel()
        label.text = "This is TransferModal (C)"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            closeButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func closeModal() {
        dismiss(animated: true, completion: nil)
    }
}
