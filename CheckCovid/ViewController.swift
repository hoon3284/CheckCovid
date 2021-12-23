//
//  ViewController.swift
//  CovidWidget
//
//  Created by wickedRun on 2021/12/12.
//

import UIKit
import WidgetKit

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var covidInfos: [CovidInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        update()
    }
    
    func update() {
        let request = DailyInfoRequest()
        request.send { result in
            switch result {
            case .success(let items):
                self.covidInfos = items
            case .failure:
                self.covidInfos = []
            }
            
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    func updateView() {
        let total = covidInfos.first { $0.gubunEn == "Total" }!
        let data = try? JSONEncoder().encode(total)
        UserDefaults.shared.setValue(data, forKey: "DailyTotal")
        titleLabel.text! += "\n" + CovidInfo.dateFormatter.string(from: total.standardDay)
        for info in covidInfos {
            textView.text += info.description + "\n"
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "CovidWidget")
    }
}

