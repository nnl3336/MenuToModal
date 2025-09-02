//
//  BViewController.swift (SlideMenu).swift
//  MenuToModal
//
//  Created by Yuki Sasaki on 2025/09/03.
//

import SwiftUI

import UIKit

protocol SlideMenuDelegate: AnyObject {
    func didToggleBool(_ value: Bool)
}

class BViewController: UIViewController {
    weak var delegate: SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        let toggleSwitch = UISwitch()
        toggleSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleSwitch)
        
        NSLayoutConstraint.activate([
            toggleSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleSwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        delegate?.didToggleBool(sender.isOn)
        dismiss(animated: true) // ✅ メニューは閉じる
    }
}
