//
//  ViewController.swift
//  RecruitmentApp
//
//  Created by Yuichiro Tsuji on 2018/05/16.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView

class RecruitMentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var companyImage: [String] = []
    var companyName: [String] = []
    var companyLookingFor: [String] = []
    var companyDescription: [String] = []
    var cellCount: Int = 0
    
    
    let apiURL = "https://www.wantedly.com/api/v1/projects?q=swift&page=0"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell") as! CustomTableViewCell

        if indexPath.row < companyName.count {
            //会社ロゴ、会社名、募集人員をCellに表示
            cell.setCell(imageURL: companyImage[indexPath.row], companyNameText: companyName[indexPath.row], lookingForText: companyLookingFor[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルの選択解除
        tableView.deselectRow(at: indexPath, animated: true)
        let popUpView = SCLAlertView()
        popUpView.addButton("応募する！", action: {
            print("応募")
            })
        popUpView.showTitle(companyName[indexPath.row], subTitle: "この会社の求人に応募しますか？", style: .notice, closeButtonTitle: "やめておく...", colorStyle: 0x3D85C6, colorTextButton: 0xFFFF00, animationStyle: .bottomToTop)
    }
    
    //jsonから表示するデータをperse
    func loadData() {
        
        Alamofire.request(apiURL).validate().responseJSON {
            response in
            let result = try! JSONDecoder().decode(CompanyData.self, from: response.data!)
            
            //TODO: TotalPage数に合わせてapiURLのpageを変える
            print("TotalPage: \(result._metadata.total_pages)")
            self.cellCount = result._metadata.per_page * result._metadata.total_pages
            
            for data in result.data {
                self.companyImage.append(data.company?.avatar?.original ?? "error")
                self.companyName.append(data.company?.name ?? "error")
                self.companyLookingFor.append(data.looking_for ?? "error")
                self.companyDescription.append(data.description ?? "error")
            }
            //fordebug
            for i in result.data {
                print(i.company?.name! ?? "error")
            }
            
            self.tableView.reloadData()
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



