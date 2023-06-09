//
//  ViewController.swift
//  Project7
//
//  Created by Marko Zivanovic on 21.2.23..
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
    }

        @objc func fetchJSON() {
            let urlString: String
            if navigationController?.tabBarItem.tag == 0 {
                urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
            } else {
                urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
            }
            
          //  DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        //MARK: We are ok to parse that data
                        //self?.parse(json: data)
                        parse(json: data)
                        return
                    }
                }
                //self?.showError()
                //showError()
           // }
            //MARK: Will run showError() method on the main thread
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    
   @objc func showError() {
       // DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "Check your internet connection", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        // self?.present(ac, animated: true)
       // }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
//            DispatchQueue.main.async { [weak self] in
//                self?.tableView.reloadData()
//            }
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

