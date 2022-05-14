//
//  CustomTabBar.swift
//  MoveApp
//
//  Created by Shevshelev Lev on 12.05.2022.
//

import UIKit

protocol TabBarDelegate: AnyObject {
    func tabBar(_sender: CustomTabBar, didSelectItemAt index: Int)
}

class CustomTabBar: UIView {
    
    private let containerView = UIView()
    private let containerStackView = UIStackView()
    private let indicatorView = UIView()
    
    var preferredTabBarHeight: CGFloat = 70
    var preferredBottomBackground: UIColor = .clear
    var selectedIndex = 0
    var buttons: [TabBarButton] = []
    
    var indicatorCenterX: NSLayoutConstraint?
    var indicatorWidth: NSLayoutConstraint?
    
    weak var delegate: TabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        addSubviews([containerView])
        containerView.addSubviews([containerStackView, indicatorView])
        containerStackView.distribution = .fill
        containerStackView.axis = .horizontal
        containerStackView.alignment = .fill
        
        indicatorView.backgroundColor = .systemRed
        indicatorView.layer.cornerRadius = 17.5
        indicatorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        indicatorView.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -20).isActive = true
        
        containerView.setConstraintsToSuperView(top: 7.5, left: 20, right: -20, bottom: -7.5)
        containerStackView.setConstraintsToSuperView(top: 0, left: 10, right: -10, bottom: 0)
        containerView.bringSubviewToFront(containerStackView)
        updateStyle()
        select(at: 0, animated: false, notifyDelegate: false)
    }
    
    private func updateStyle() {
        containerView.backgroundColor = .systemPurple
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = (preferredTabBarHeight - 15) / 2
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.1
        
        indicatorView.layer.shadowColor = UIColor.black.cgColor
        indicatorView.layer.shadowOffset = CGSize(width: 0, height: 2)
        indicatorView.layer.shadowOpacity = 0.3
    }
    
    func select(at index: Int, animated: Bool, notifyDelegate: Bool) {
        guard !buttons.isEmpty else { return }
        let selectedButton = buttons[index]
        selectedIndex = index
        
        indicatorCenterX?.isActive = false
        indicatorWidth?.isActive = false
        
        indicatorCenterX = indicatorView.centerXAnchor.constraint(equalTo: selectedButton.centerXAnchor)
        indicatorCenterX?.isActive = true
        
        indicatorWidth = indicatorView.widthAnchor.constraint(equalTo: selectedButton.widthAnchor)
        indicatorWidth?.isActive = true
        
        let blok = {
            self.buttons.forEach { $0._isSelected = false }
            selectedButton._isSelected = true
            selectedButton.layoutSubviews()
            self.containerStackView.layoutSubviews()
        }
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: blok)
        } else {
            blok()
        }
        
        if notifyDelegate {
            self.delegate?.tabBar(_sender: self, didSelectItemAt: index)
        }
    }
    
    func set(items: [UITabBarItem]) {
        let buttons: [TabBarButton] = items.enumerated().map {
            let button = TabBarButton(image: $0.element.image, selectedImage: $0.element.selectedImage, title: $0.element.title)
            button.tag = $0.offset
            return button
        }
        buttons.forEach {
            $0.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        }
        
        self.buttons = buttons
        self.containerStackView.addArrangedSubviews(buttons)
    }
    
    @objc func buttonTapped(sender: TabBarButton) {
        select(at: sender.tag, animated: true, notifyDelegate: true)
    }
}
