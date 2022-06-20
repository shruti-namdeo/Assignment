//
//  AsurionInitialVC.swift
//  Asurion-iOS
//  Copyright © 2022 Shruti. All rights reserved.
//

import Foundation
import UIKit

class AsurionInitialVC : UIViewController {
    
    @IBOutlet weak var parentSV: UIStackView!
    @IBOutlet weak var chatCallButtonsHStackView: UIStackView!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    
    @IBOutlet weak var officeTimingHStackView: UIStackView!
    @IBOutlet weak var OfficeTimingView: UIView!
    @IBOutlet weak var officeTimingsLabel: UILabel!
    @IBOutlet weak var petsList: UITableView!
    
    var petsViewModel: PetsDataViewModel!
    var settingsViewModel: SettingsViewModel!
    var configData: Config?
    var petsData: Pets?
    
    var urlToLoad:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupShadowforView()
        self.petsViewModel = PetsDataViewModel.init(networkLayer: NetworkLayer())
        self.settingsViewModel = SettingsViewModel.init(networkLayer: NetworkLayer())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareData()
    }
    
    func prepareData(){
        self.settingsViewModel.getSettingsData { (result) in
            switch result {
            case .failure( let error):
                self.showAlert(message: error.localizedDescription)
                
            case .success(let data):
                //parse data
                self.configData = data
                self.prepareUI()
            }
        }
        
        self.petsViewModel.getPetsData { (result) in
            switch result {
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            case .success(let data):
                self.petsData = data
                DispatchQueue.main.async {
                    self.petsList.dataSource = self
                    self.petsList.delegate = self
                    self.petsList.reloadData()
                }
            }
        }
    }
    
    func prepareUI(){
        DispatchQueue.main.async { [unowned self] in
            if let config = self.configData{
                self.callBtn.isHidden = !(config.settings.isCallEnabled)
                self.chatBtn.isHidden = !(config.settings.isChatEnabled)
                self.officeTimingsLabel.text = "Office Hours: \(config.settings.workHours)"
            }
        }
    }
}

extension AsurionInitialVC {
    /*func setupShadowforView() {
        // border radius
        OfficeTimingView.layer.cornerRadius = 30.0
        
        // border
        OfficeTimingView.layer.borderColor = UIColor.lightGray.cgColor
        OfficeTimingView.layer.borderWidth = 1.5
        
        // drop shadow
        OfficeTimingView.layer.shadowColor = UIColor.black.cgColor
        OfficeTimingView.layer.shadowOpacity = 0.8
        OfficeTimingView.layer.shadowRadius = 3.0
        OfficeTimingView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        officeTimingsLabel.text = "fsdaskjdffhjsdagdfhjklsaghlksdaghjkldsaghjl"
    } */
}

extension AsurionInitialVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.petsData?.pets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pets-reusable-cell") as? PetTableViewCell
        let pet = self.petsData?.pets[indexPath.row]
        cell?.petTitleView.text = pet?.title
        if let urlString = pet?.image_url,  let imageURL = URL.init(string: urlString){
            cell?.petImageView?.downloadImageFrom(url: imageURL, imageMode: .scaleAspectFill){
                cell?.setNeedsLayout()
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedRow = self.petsData?.pets[indexPath.row].content_url {
            urlToLoad = selectedRow
            self.performSegue(withIdentifier: "webviewSegue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! DetailVC
        dest.url = urlToLoad ?? ""
    }
}
extension AsurionInitialVC {
    func showAlert(message: String) {
        DispatchQueue.main.async {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
    }
}
