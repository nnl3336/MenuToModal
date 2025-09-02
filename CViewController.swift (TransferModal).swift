//
//  CViewController.swift (TransferModal).swift
//  MenuToModal
//
//  Created by Yuki Sasaki on 2025/09/03.
//

import SwiftUI

import UIKit

class CViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        
        let label = UILabel()
        label.text = "This is TransferModal (C)"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
