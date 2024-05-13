//
//  CustomSegmentedControl.swift
//  Restaurant
//
//  Created by Василий Тихонов on 05.03.2024.
//

import UIKit

final class CustomSegmentedControl: UIView {
    
    private let stackView = UIStackView()
    private let selectedView = UIView()
    private var widthConstraint = NSLayoutConstraint()
    private var leadingConstraint = NSLayoutConstraint()
    
    var valueChangedHandler: ((CustomSegmentedControl) -> Void)?

    var selectedIndex: Int = 0 {
        didSet {
            updateSelectedIndex()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        configureStackView()
        configureSelectedView()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ buttonText: String...) {
        self.init()
        buttonText.enumerated().forEach {
            let button: UIButton = .createSegmentedButton(title: $0.element)
            button.tag = $0.offset
            button.addTarget(self, action: #selector(segmentedButtonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        stackView.layoutIfNeeded()
    }
    
    @objc private func segmentedButtonTapped(sender: UIButton) {
        selectedIndex = sender.tag
        valueChangedHandler?(self)
    }
    
    private func updateSelectedIndex() {
            widthConstraint.constant = stackView.arrangedSubviews[selectedIndex].frame.width
            leadingConstraint.constant = stackView.arrangedSubviews[selectedIndex].frame.origin.x
            UIView.animate(withDuration: 0.3) {
                self.stackView.layoutIfNeeded()
                self.widthConstraint.constant = self.stackView.arrangedSubviews[self.selectedIndex].frame.width
            }
        }
}

private extension CustomSegmentedControl {
    
    func configure() {
        layer.cornerRadius = 20
        backgroundColor = #colorLiteral(red: 0.949019134, green: 0.9490200877, blue: 0.9705253243, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
    }
    func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
    }
    func configureSelectedView() {
        selectedView.backgroundColor = #colorLiteral(red: 0.7810060978, green: 0.7880803943, blue: 0.8063045144, alpha: 1)

        selectedView.layer.cornerRadius = 16
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(selectedView)
    }
    
    func setConstrains() {
        widthConstraint = selectedView.widthAnchor.constraint(equalToConstant: 0)
        leadingConstraint = selectedView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        widthConstraint.isActive = true
        leadingConstraint.isActive = true
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            selectedView.topAnchor.constraint(equalTo: stackView.topAnchor),
            selectedView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        
        ])
    }
}
