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
    
    // viewModel이라고는 했지만 Model에 가까우므로 추후 수정할 예정.
    var viewModel: DailyCovidInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        update()
    }
    
    func update() {
        DailyInfoRequest().send { result in
            if case let .success(items) = result {
                self.viewModel = DailyCovidInfo(dailyInfos: items)
                
                DailyCovidInfo.dailyTotalInfo = self.viewModel!.dailyInfos[CovidInfoCategory.total.rawValue]
                
                WidgetCenter.shared.reloadTimelines(ofKind: "CovidWidget")
            }
            
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    func updateView() {
        guard let viewModel = viewModel else {
            textView.text = "데이터를 불러오지 못 했습니다."
            return
        }
        // 임시 view 설정
        let total = viewModel.dailyInfos[CovidInfoCategory.total.rawValue]!
        titleLabel.text! += "\n" + DailyCovidInfo.dateFormatter.string(from: total.standardDay)
        
        for info in viewModel.dailyInfos {
            textView.text += info.value.description + "\n"
        }
    }
}

