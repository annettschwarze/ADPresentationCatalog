//
//  SelectLocationViewController.swift
//  ADPresentationCatalog
//
//  Created by Schwarze on 12.06.22.
//

import UIKit

protocol SelectSlideInOriginViewControllerDelegate: NSObjectProtocol {
    func selectSlideInOriginViewControllerDidSelect(location: SelectSlideInOriginViewController.Location)
}

class SelectSlideInOriginViewController: UIViewController {
    var selectedLocationState: Location = .topMiddle
    var buttonMap: [UIButton:Location] = [:]
    var locationMap: [Location:UIButton] = [:]

    enum Location {
        case topLeft
        case middleLeft
        case bottomLeft
        case topMiddle
        case middleMiddle
        case bottomMiddle
        case topRight
        case middleRight
        case bottomRight
    }

    weak var delegate: SelectSlideInOriginViewControllerDelegate?

    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var middleLeftButton: UIButton!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var topMiddleButton: UIButton!
    @IBOutlet weak var middleMiddleButton: UIButton!
    @IBOutlet weak var bottomMiddleButton: UIButton!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var middleRightButton: UIButton!
    @IBOutlet weak var bottomRightButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonMap = [
            topLeftButton: .topLeft,
            middleLeftButton: .middleLeft,
            bottomLeftButton: .bottomLeft,
            topMiddleButton: .topMiddle,
            middleMiddleButton: .middleMiddle,
            bottomMiddleButton: .bottomMiddle,
            topRightButton: .topRight,
            middleRightButton: .middleRight,
            bottomRightButton: .bottomRight
        ]

        locationMap = Dictionary(uniqueKeysWithValues: buttonMap.map({ (key: UIButton, value: Location) in
            return (value, key)
        }))

        for button in buttonMap.keys {
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let button = locationMap[selectedLocationState]
        button?.isSelected = true
    }

    //MARK: Primary User Action

    @objc func didTapButton(_ sender: UIButton) {
        guard let location = buttonMap[sender] else { return }

        let button = locationMap[selectedLocationState]
        button?.isSelected = false

        sender.isSelected = true
        selectedLocationState = location

        delegate?.selectSlideInOriginViewControllerDidSelect(location: location)
    }
}
