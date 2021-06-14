//
//  MenuViewController.swift
//  PoseNetDetection
//
//  Created by curry敏 on 2021/5/20.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    

        /// The list of actions, sorted by descending time.
    private var sortedActions = [String]()

    /// The times of each action, keyed by the action's name.
    var actionFrameCounts: [String: Int]? {
        didSet {
            guard let frameCounts = actionFrameCounts else { return }

            // Clear out the previous list of actions.
            sortedActions.removeAll()

            // Create a list of the actions sorted by descending time.
            let sortedElements = frameCounts.sorted { $0.value > $1.value }
            sortedElements.forEach { entry in sortedActions.append(entry.key) }
        }
    }

    /// A closure the summary view controller calls after it disappears.
    var dismissalClosure: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view?.overrideUserInterfaceStyle = .dark

        tableView.dataSource = self
        tableView.reloadData()
        tableView.delegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        // Call the dismissal closure, if there is one.
        dismissalClosure?()

        // Call the super class last.
        super.viewDidDisappear(animated)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        let vc = storyboard?.instantiateViewController(withIdentifier: "WikiAPIViewController") as? WikiAPIViewController
////        vc?.actionName = self.sortedActions[indexPath.row]
//        let nextVC = WikiAPIViewController()
//          nextVC.actionName = sortedActions[indexPath.row]
//          self.navigationController?.pushViewController(nextVC,animated: true)
//        print("menu sends \(String(describing: nextVC.actionName))")
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "WikiAPIViewController") as! WikiAPIViewController
                nextVC.actionName = sortedActions[indexPath.row]
                show(nextVC, sender: nil)
        }
    
    
}

// MARK: - Table View Data Source
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return sortedActions.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let customCellName = "SummaryCellPrototype"
        let cell = tableView.dequeueReusableCell(withIdentifier: customCellName,for: indexPath)

        guard let summaryCell = cell as? SummaryTableViewCell else {
            fatalError("Not an instance of `SummaryTableViewCell`.")
        }
        
        if let frameCounts = actionFrameCounts {
            let frameRate = yogaActionClassifier.frameRate

            let action = sortedActions[indexPath.row]
            let totalFrames = frameCounts[action] ?? 0
            let totalDuration = Double(totalFrames) / frameRate

            summaryCell.totalDuration = totalDuration
            summaryCell.actionLabel.text = action
        }

        return summaryCell
    }
    
}

//MARK: - Table Cell
class SummaryTableViewCell: UITableViewCell {
    
    @IBOutlet var actionLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    
    var totalDuration: Double = 0 {
        didSet { timerLabel.text = String(format: "%0.1fs", totalDuration) }
    }
}



