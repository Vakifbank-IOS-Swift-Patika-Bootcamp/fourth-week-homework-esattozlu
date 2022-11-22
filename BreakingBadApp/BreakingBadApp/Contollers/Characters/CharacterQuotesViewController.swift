//
//  CharacterQuotesViewController.swift
//  BreakingBadApp
//
//  Created by Hasan Esat Tozlu on 22.11.2022.
//

import UIKit

class CharacterQuotesViewController: UIViewController {

    @IBOutlet weak var quotesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        quotesTableView.delegate = self
        quotesTableView.dataSource = self
    }

}

extension CharacterQuotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
}
