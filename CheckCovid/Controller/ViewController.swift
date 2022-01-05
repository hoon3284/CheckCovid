//
//  ViewController.swift
//  CovidWidget
//
//  Created by wickedRun on 2021/12/12.
//

import UIKit
import WidgetKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var model: DailyCovidInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        update()
    }
    
    func update() {
        DailyInfoRequest().send { result in
            switch result {
            case .success(let items):
                self.model = DailyCovidInfo(dailyInfos: items)
                DailyCovidInfo.dailyTotalInfo = self.model!.dailyInfoDict[CovidInfoCategory.total.rawValue]
                
                DispatchQueue.main.async {
                    // Widget 새로고침도 UI라서 백그라운드에서는 안되는 것 같다.
                    WidgetCenter.shared.reloadTimelines(ofKind: "com.wickedrun.CheckCovid")
                    self.updateView()
                }
                
            case .failure(let error):
                let errorCode: String
                if let apiError = error as? APIError {
                    errorCode = apiError.rawValue
                } else {
                    errorCode = error.localizedDescription
                }
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "데이터를 불러오지 못 했습니다.\n에러코드: \(errorCode)", message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "확인", style: .cancel) { result in
                        exit(0)
                    }
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func updateView() {
        guard let model = model else { return }

        // 임시 view 설정
        let total = model.dailyInfoDict[CovidInfoCategory.total.rawValue]!
        updateTotalInfoView(with: total)
        
        tableView.reloadData()
    }
    
    func updateTotalInfoView(with total: CovidInfo) {
        titleLabel.text! = DailyCovidInfo.dateFormatter.string(from: total.standardDay)
    }
    
    // MARK: DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model else { return 0 }

        return model.dailyInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model,
              let cell = tableView.dequeueReusableCell(withIdentifier: "gubunCell") as? GubunTableViewCell
        else {
            fatalError("identifier에 해당하는 셀이 없습니다.")
        }
        cell.titleLabel.text = model.dailyInfos[indexPath.row].gubun
        
        return cell
    }
    
}

