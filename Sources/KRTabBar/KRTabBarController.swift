//
//  KRTabBar.swift
//  KRTabBarController
//
//  Created by Kerolles Roshdi on 2/14/20.
//  Copyright © 2020 Kerolles Roshdi. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class KRTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var selectedTab: Int = 0
    
    private var buttons = [UIButton]()
    private var buttonsColors = [UIColor]()
    
    private let customTabBarView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let indexView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .orange
        view.layer.shadowColor = UIColor.orange.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override var viewControllers: [UIViewController]? {
        didSet {
            createButtonsStack(viewControllers!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        addcoustmeTabBarView()
        tabBar.tintColor = .black
        createButtonsStack(viewControllers!)
        autolayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customTabBarView.layer.cornerRadius = customTabBarView.frame.size.height / 2
        indexView.layer.cornerRadius = indexView.frame.size.height / 2.5
        indexView.backgroundColor = buttonsColors[selectedTab]
        indexView.layer.shadowColor = buttonsColors[selectedTab].cgColor
    }
    
    private func createButtonsStack(_ viewControllers: [UIViewController]) {
        
        // clean :
        buttons.removeAll()
        buttonsColors.removeAll()
        
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        for (index, viewController) in viewControllers.enumerated() {
            if let tabBarItem = viewController.tabBarItem as? KRTabBarItem {
                if let color = tabBarItem.color {
                    buttonsColors.append(color)
                }
            } else {
                fatalError("set tabBarItem Class as KRTabBarItem and set its color")
                
            }
            let button = UIButton()
            button.tag = index
            button.addTarget(self, action: #selector(didSelectIndex(sender:)), for: .touchUpInside)
            let image = viewController.tabBarItem.image?.withRenderingMode(.alwaysTemplate)
            button.imageView?.tintColor = .black
            button.setImage(image, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        
        view.setNeedsLayout()
    }
    
    private func autolayout() {
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            customTabBarView.widthAnchor.constraint(equalTo: tabBar.widthAnchor, constant: -20),
            customTabBarView.heightAnchor.constraint(equalToConstant: 70),
            customTabBarView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10),
            customTabBarView.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: customTabBarView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: customTabBarView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: customTabBarView.heightAnchor),
            indexView.widthAnchor.constraint(equalToConstant: customTabBarView.bounds.height),
            indexView.heightAnchor.constraint(equalToConstant: customTabBarView.bounds.height),
            indexView.centerYAnchor.constraint(equalTo: customTabBarView.centerYAnchor),
            indexView.centerXAnchor.constraint(equalTo: buttons.first?.centerXAnchor ?? customTabBarView.centerXAnchor)
        ])
    }
    
    private func addcoustmeTabBarView() {
        customTabBarView.frame = tabBar.frame
        indexView.frame = tabBar.frame
        view.addSubview(customTabBarView)
        
        view.bringSubviewToFront(self.tabBar)
        
        customTabBarView.addSubview(indexView)
        customTabBarView.addSubview(stackView)
        
    }
    
    
    @objc private func didSelectIndex(sender: UIButton) {
        let index = sender.tag
        self.selectedIndex = index
        self.selectedTab = index
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.indexView.center.x = self.buttons[index].center.x
            self.indexView.backgroundColor = self.buttonsColors[index]
            self.indexView.layer.shadowColor = self.buttonsColors[index].cgColor
        }, completion: nil)
    }
    
    
    // Delegate:
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard
            let items = tabBar.items,
            let index = items.firstIndex(of: item)
            else {
                print("not found")
                return
        }
        didSelectIndex(sender: self.buttons[index])
    }
    
}
