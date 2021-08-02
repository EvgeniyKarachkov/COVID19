//
//  DataTableViewCell.swift
//  My Full App
//
//  Created by Admin on 26.07.2021.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    @IBOutlet var country: UILabel!
    @IBOutlet var newCases: UILabel!
    @IBOutlet var newDeath: UILabel!
    @IBOutlet var totalCases: UILabel!
    @IBOutlet var totalDeath: UILabel!
    @IBOutlet var countryFlag: UIImageView!
    
    func configure(with data: CovidData) {
        let allCountryCodes = CountryCode.all
        
        country.text = "Страна:" + " " + data.country!
        newCases.text = "Новые заражения:" + " " +   data.newCases!
        newDeath.text = "Новые случаи смерти:"  + " " + data.newDeath!
        totalCases.text = "Всего заболело:"   + " " + data.totalCases!
        totalDeath.text = "Всего умерло:"  + " " + data.totalDeath!
        
        let url = CountryCode.getURLofImage(dict: allCountryCodes , value: data.country!)
        
        
        DispatchQueue.global().async {
            
            let image: UIImage?
            
            if let url = url, let imageUrl = URL(string: url), let imageData = try? Data(contentsOf: imageUrl) {
                image = UIImage(data: imageData)
            } else {
                image = UIImage(named: "NoImage")
            }
            
            DispatchQueue.main.async {
                self.countryFlag.image = image
            }
        }
    }
    
    
}




