//
//  BaseSplitViewController.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import UIKit

class BaseSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        delegate = self
        if let navigationController = viewControllers.last as? UINavigationController {
            navigationController.topViewController?.navigationItem.leftBarButtonItem = displayModeButtonItem
            navigationController.topViewController?.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}

extension BaseSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController,
                             willShow vc: UIViewController,
                             invalidating barButtonItem: UIBarButtonItem) {
        if let detailView = svc.viewControllers.first as? UINavigationController {
            svc.navigationItem.backBarButtonItem = nil
            detailView.topViewController?.navigationItem.leftBarButtonItem = nil
        }
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
