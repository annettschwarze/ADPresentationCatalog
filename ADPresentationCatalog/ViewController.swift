//
//  ViewController.swift
//  ADPresentationCatalog
//
//  Created by Schwarze on 06.06.22.
//

import UIKit
import ADPresentationKit

class ViewController: UIViewController, SelectionLocationViewControllerDelegate, SelectSlideInOriginViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    var pmRef: SlidePresentationManager?
    var pm = SlidePresentationManager()
    var selectedLocationState: SelectLocationViewController.Location = .middleMiddle
    var selectedLocationStateSlideInOrigin: SelectSlideInOriginViewController.Location = .topMiddle

    @IBOutlet weak var compressedButton: UIButton!
    @IBOutlet weak var interactiveDismissButton: UIButton!
    @IBOutlet weak var panningButton: UIButton!

    var compressedButtonIsSelected: Bool = false
    var interactiveDismissButtonIsSelected: Bool = false
    var panningButtonIsSelected: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        selectSlideInOriginViewControllerDidSelect(location: selectedLocationStateSlideInOrigin)
        selectLocationViewControllerDidSelect(location: selectedLocationState)
        pm.config.panShiftSingleEnabled = panningButtonIsSelected
        pm.config.interactiveDismissEnabled = interactiveDismissButtonIsSelected
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Show touches:
        // ShowTime.enabled = .always
    }

    @IBAction func didTapPresent(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") else { return }

        // Reset the cursor position when presenting. When panning is enabled,
        // the last position of the view is remembered. Reset it, because this
        // is not wanted here.
        pm.config.resetRelativePosition()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = pm
        pmRef = pm
        pm.config.backdropBackgroundColor = .black.withAlphaComponent(0.2)
        pm.config.layoutVerticalGap = 105.0
        present(vc, animated: true, completion: nil)
    }

    @IBAction func didTapCompressedButton(_ sender: Any) {
        if compressedButtonIsSelected == true {
            pm.config.layoutCompressed = false
            compressedButtonIsSelected = false
            updateCompressedButtonState()
        } else {
            pm.config.layoutCompressed = true
            compressedButtonIsSelected = true
            updateCompressedButtonState()
        }
    }
    
    @IBAction func didTapInteractiveDismissButton(_ sender: Any) {
        if interactiveDismissButtonIsSelected == true {
            pm.config.interactiveDismissEnabled = false
            interactiveDismissButtonIsSelected = false
            updateInteractiveDismissButton()
        } else {
            pm.config.interactiveDismissEnabled = true
            interactiveDismissButtonIsSelected = true
            updateInteractiveDismissButton()
        }
    }

    @IBAction func didTapPanningButton(_ sender: Any) {
        if panningButtonIsSelected == true {
            pm.config.panShiftSingleEnabled = false
            panningButtonIsSelected = false
            updatePanningButton()
        } else {
            pm.config.panShiftSingleEnabled = true
            panningButtonIsSelected = true
            updatePanningButton()
        }
    }

    //MARK: Seque

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "origin" {
            if let vc = segue.destination as? SelectSlideInOriginViewController {
                vc.delegate = self
                vc.selectedLocationState = self.selectedLocationStateSlideInOrigin
            }
        }
        if segue.identifier == "location" {
            if let vc = segue.destination as? SelectLocationViewController {
                vc.delegate = self
                vc.selectedLocationState = self.selectedLocationState
            }
        }
    }

    //MARK: SelectLocation Delegate

    func selectLocationViewControllerDidSelect(location: SelectLocationViewController.Location) {

        selectedLocationState = location

        let locationMap: [SelectLocationViewController.Location : (SlidePresentationVerticalAnchor,SlidePresentationHorizontalAnchor)] = [
            .topLeft : (.top, .leading),
            .topMiddle : (.top, .middle),
            .topRight : (.top, .trailing),
            .middleLeft : (.middle, .leading),
            .middleMiddle : (.middle, .middle),
            .middleRight : (.middle, .trailing),
            .bottomLeft : (.bottom, .leading),
            .bottomMiddle : (.bottom, .middle),
            .bottomRight : (.bottom, .trailing)
        ]
        let tuple: (SlidePresentationVerticalAnchor,SlidePresentationHorizontalAnchor) = locationMap [location] ?? (.middle,.middle)

        pm.config.anchorVertical = tuple.0
        pm.config.anchorHorizontal = tuple.1
    }

    //MARK: SelectionSlideInOrigin Delegate

    func selectSlideInOriginViewControllerDidSelect(location: SelectSlideInOriginViewController.Location) {
        selectedLocationStateSlideInOrigin = location
        let locationMap: [SelectSlideInOriginViewController.Location : SlidePresentationOrigin] = [
            .topMiddle : .top,
            .middleLeft : .leading,
            .middleRight : .trailing,
            .bottomMiddle : .bottom,
        ]
        let origin: SlidePresentationOrigin = locationMap [location] ?? .top
        pm.config.slideInOrigin = origin
    }

    //MARK: - Popup Style Delegates

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

    //MARK: Helper Function

    func updateCompressedButtonState() {
        if compressedButtonIsSelected == true {
            compressedButton.backgroundColor = UIColor(named: "ButtonSelectedColor")
        } else {
            compressedButton.backgroundColor = UIColor(named: "ButtonColor")
        }
    }

    func updateInteractiveDismissButton() {
        if interactiveDismissButtonIsSelected == true {
            interactiveDismissButton.backgroundColor = UIColor(named: "ButtonSelectedColor")
        } else {
            interactiveDismissButton.backgroundColor = UIColor(named: "ButtonColor")
        }
    }

    func updatePanningButton() {
        if panningButtonIsSelected == true {
            panningButton.backgroundColor = UIColor(named: "ButtonSelectedColor")
        } else {
            panningButton.backgroundColor = UIColor(named: "ButtonColor")
        }
    }
}
