//
//  resultViewController.swift
//  FollowTheOrder
//
//  Created by Даниил on 28.11.2022.
//

import UIKit

class resultViewController: UIViewController {
    // MARK: - Properties
    public var didWinLast: Bool!
    weak var delegate: resultDelegate!
    /// Title label with "Congratulations" / "Regard" states
    private let wishLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: "ClashDisplay-Extralight", size: 40)
        return label
    }()
    /// Label with fish from "fortune" url
    private let fortuneLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: "ClashDisplay-Extralight", size: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var startGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "ClashDisplay-Extralight", size: 40)
        button.alpha = 0
        button.addTarget(self,
                         action: #selector(continueGameHandler),
                         for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
    }

    // MARK: - Selectors
    public func configureView(){
        view.backgroundColor = .systemBackground
        /// Adding all the subViews
        view.addSubview(wishLabel)
        view.addSubview(fortuneLabel)
        view.addSubview(startGameButton)
        
        self.fortuneLabel.alpha = 0
        /// Checking if the user won the previous game or not
        if didWinLast == true{
            wishLabel.text = "Congratulations"
            FortunaService.shared.getData { quote in
                guard let quote = quote else {
                    return
                }
                DispatchQueue.main.async {
                    self.fortuneLabel.text = quote
                    self.fortuneLabel.alpha = 0
                    self.startGameButton.setTitle("Next level", for: .normal)
                    UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
                        self.fortuneLabel.alpha = 1
                    }
                    UIView.animate(withDuration: 1, delay: 0.5, options: .curveLinear) {
                        self.startGameButton.alpha = 1
                    }

                }
            }
        }
        else{
            wishLabel.text = "Regard"
            startGameButton.setTitle("Restart level", for: .normal)
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
                self.startGameButton.alpha = 1
            }
        }
    }
    /// Function for setting constraints
    private func setConstraints(){
        wishLabel.translatesAutoresizingMaskIntoConstraints = false
        wishLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        wishLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fortuneLabel.translatesAutoresizingMaskIntoConstraints = false
        fortuneLabel.topAnchor.constraint(equalTo: wishLabel.bottomAnchor, constant: 5).isActive = true
        fortuneLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        fortuneLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        startGameButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        startGameButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        startGameButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
    }
    /// Redirecting to a new level
    @objc func continueGameHandler(){
        self.navigationController!.dismiss(animated: true){
            self.startGameButton.alpha = 0
            self.delegate.restartLevel(vc: self, with: self.didWinLast)
        }
    }
}
