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
    
    var selectedPet :Pet?
    
    var workingHourViewModel: WorkingHourViewModel?
    var workDays: String!
    var startTime: String!
    var endTime: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AsurionHomeConstants.screenTitle.rawValue
        self.petsViewModel = PetsDataViewModel.init(networkLayer: NetworkLayer())
        self.settingsViewModel = SettingsViewModel.init(networkLayer: NetworkLayer())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareData()
    }
    
    func prepareData(){
           self.getSettingsData()
           self.getPetsData()
       }
    
    private func getSettingsData(){
        self.settingsViewModel.getSettingsData { (result) in
            switch result {
            case .failure( let error):
                self.showAlert(message: error.localizedDescription)
                
            case .success(let data):
                //parse data
                self.configData = data
                self.workingHourViewModel = WorkingHourViewModel.init(schedule: (self.configData?.settings.workHours)!)
                self.prepareUI()
            }
        }
    }
    
    private func getPetsData(){
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
                self.officeTimingsLabel.text = AsurionHomeConstants.officeHoursLabel.rawValue + config.settings.workHours
            }
        }
    }
    
    @IBAction func onChatButtonClicked(_ sender: Any) {
        guard let message = self.workingHourViewModel?.isCurrentDateTimeWithinWorkingHours() else {
            return
        }
        showAlert(message: message)
    }
    @IBAction func onCallButtonClicked(_ sender: Any) {
        guard let message = self.workingHourViewModel?.isCurrentDateTimeWithinWorkingHours() else {
            return
        }
        showAlert(message: message)
    }    
}

extension AsurionInitialVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.petsData?.pets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AsurionHomeConstants.reusableCellIdentifier.rawValue) as? PetTableViewCell{
            let pet = self.petsData?.pets[indexPath.row]
            cell.petTitleView.text = pet?.title
            if let urlString = pet?.image_url,  let imageURL = URL.init(string: urlString){
                cell.petImageView?.downloadImageFrom(url: imageURL, imageMode: .scaleAspectFill){
                    cell.setNeedsLayout()
                }
            }
            return cell
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedRow = self.petsData?.pets[indexPath.row] {
            self.selectedPet = selectedRow
            self.performSegue(withIdentifier: AsurionHomeConstants.webSegueIdentifier.rawValue, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! DetailVC
        dest.pet = selectedPet
    }
}
extension AsurionInitialVC {
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: AlertButtonTitles.title.rawValue, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: AlertButtonTitles.close.rawValue, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
    }
}
