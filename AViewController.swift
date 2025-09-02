//
//  AViewController.swift
//  MenuToModal
//
//  Created by Yuki Sasaki on 2025/09/03.
//

import SwiftUI

import UIKit

import UIKit

import UIKit

class AViewController: UIViewController, SlideMenuDelegate {

    // MARK: - Menu layout
    //private let menuWidth: CGFloat = 280
    private var menuWidth: CGFloat {
        min(UIScreen.main.bounds.width * 0.8, 400) // 最大 400pt
    }

    private var menuLeadingConstraint: NSLayoutConstraint!
    private var isMenuOpen = false

    private let menuContainer = UIView()
    private let overlayView = UIView()

    private let menuVC = BViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupContentUI()
        setupMenu()
        setupGestures()
    }

    private func setupContentUI() {
        let title = UILabel()
        title.text = "AViewController"
        title.font = .systemFont(ofSize: 28, weight: .bold)

        let hint = UILabel()
        hint.text = "左端からスワイプでメニュー / または下のボタン"
        hint.font = .systemFont(ofSize: 14)

        let button = UIButton(type: .system)
        button.setTitle("Open Slide Menu", for: .normal)
        button.addTarget(self, action: #selector(openMenuButtonTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [title, hint, button])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // overlay（メニュー開時に暗くする）
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlayView.alpha = 0
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        overlayView.isUserInteractionEnabled = true
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeMenu)))
    }

    private func setupMenu() {
        // メニューコンテナ
        menuContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuContainer)

        menuLeadingConstraint = menuContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -menuWidth)
        NSLayoutConstraint.activate([
            menuContainer.topAnchor.constraint(equalTo: view.topAnchor),
            menuContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuContainer.widthAnchor.constraint(equalToConstant: menuWidth),
            menuLeadingConstraint
        ])

        // B を子 VC として組み込み
        addChild(menuVC)
        menuVC.view.translatesAutoresizingMaskIntoConstraints = false
        menuContainer.addSubview(menuVC.view)
        NSLayoutConstraint.activate([
            menuVC.view.topAnchor.constraint(equalTo: menuContainer.topAnchor),
            menuVC.view.bottomAnchor.constraint(equalTo: menuContainer.bottomAnchor),
            menuVC.view.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),
            menuVC.view.trailingAnchor.constraint(equalTo: menuContainer.trailingAnchor)
        ])
        menuVC.didMove(toParent: self)
        menuVC.delegate = self

        // 影
        menuContainer.layer.shadowColor = UIColor.black.cgColor
        menuContainer.layer.shadowOpacity = 0.2
        menuContainer.layer.shadowRadius = 8
        menuContainer.layer.shadowOffset = .zero
    }

    private func setupGestures() {
        // 画面左端からのスワイプで開く
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)

        // 開いている最中のドラッグ操作にも対応（任意）
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        menuContainer.addGestureRecognizer(pan)
    }

    // MARK: - Actions

    @objc private func openMenuButtonTapped() {
        openMenu(animated: true)
    }

    @objc private func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let translation = gesture.translation(in: view).x
        switch gesture.state {
        case .changed:
            let progress = max(0, min(1, translation / menuWidth))
            updateMenu(progress: progress)
        case .ended, .cancelled:
            let velocity = gesture.velocity(in: view).x
            let translationEnough = translation > menuWidth * 0.5
            if velocity > 200 || translationEnough {
                openMenu(animated: true)
            } else {
                closeMenu(animated: true)
            }
        default:
            break
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view).x
        // 現在の leading を基準に動かす（開いているときは 0、閉じているときは -menuWidth）
        let current = menuLeadingConstraint.constant
        let proposed = current + translation
        menuLeadingConstraint.constant = min(0, max(-menuWidth, proposed))
        gesture.setTranslation(.zero, in: view)

        let shown = 1 - abs(menuLeadingConstraint.constant / menuWidth) // 0〜1
        overlayView.alpha = shown

        if gesture.state == .ended || gesture.state == .cancelled {
            let velocity = gesture.velocity(in: view).x
            let shouldOpen = (shown > 0.5) || velocity > 200
            animateMenu(open: shouldOpen)
        }
    }

    private func updateMenu(progress: CGFloat) {
        // progress: 0(閉)〜1(全開)
        menuLeadingConstraint.constant = -menuWidth * (1 - progress)
        overlayView.alpha = progress
        view.layoutIfNeeded()
    }

    private func animateMenu(open: Bool) {
        isMenuOpen = open
        menuLeadingConstraint.constant = open ? 0 : -menuWidth
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
            self.overlayView.alpha = open ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }

    private func openMenu(animated: Bool) {
        if animated {
            animateMenu(open: true)
        } else {
            isMenuOpen = true
            menuLeadingConstraint.constant = 0
            overlayView.alpha = 1
            view.layoutIfNeeded()
        }
    }

    @objc private func closeMenu(animated: Bool = true) {
        if animated {
            animateMenu(open: false)
        } else {
            isMenuOpen = false
            menuLeadingConstraint.constant = -menuWidth
            overlayView.alpha = 0
            view.layoutIfNeeded()
        }
    }

    // MARK: - SlideMenuDelegate
    func didToggleBool(_ value: Bool) {
        guard value else { return }
        // いったんメニューを閉じてから C を出す
        animateMenu(open: false)
        let cVC = CViewController()
        cVC.modalPresentationStyle = .pageSheet
        if let sheet = cVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(cVC, animated: true)
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
