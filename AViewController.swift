//
//  AViewController.swift
//  MenuToModal
//
//  Created by Yuki Sasaki on 2025/09/03.
//

import SwiftUI

import UIKit

class AViewController: UIViewController, SlideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let openMenuButton = UIButton(type: .system)
        openMenuButton.setTitle("Open SlideMenu", for: .normal)
        openMenuButton.addTarget(self, action: #selector(showSlideMenu), for: .touchUpInside)
        
        openMenuButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(openMenuButton)
        
        NSLayoutConstraint.activate([
            openMenuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openMenuButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func showSlideMenu() {
        let bVC = BViewController()
        bVC.delegate = self
        bVC.modalPresentationStyle = .pageSheet
        present(bVC, animated: true)
    }
    
    // ✅ SlideMenuDelegate
    func didToggleBool(_ value: Bool) {
        if value {
            let cVC = CViewController()
            cVC.modalPresentationStyle = .pageSheet
            present(cVC, animated: true)
        }
    }
}

import SwiftUI

struct AViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AViewController {
        return AViewController()
    }
    
    func updateUIViewController(_ uiViewController: AViewController, context: Context) {
        // SwiftUI側の状態が変わった時に UIKit に反映したい場合ここに書く
    }
}
