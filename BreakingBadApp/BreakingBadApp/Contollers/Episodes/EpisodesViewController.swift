//
//  EpisodesViewController.swift
//  BreakingBadApp
//
//  Created by Hasan Esat Tozlu on 22.11.2022.
//

import UIKit

class EpisodesViewController: UIViewController {

    @IBOutlet weak var episodesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var seasonEpisodes = [[EpisodeModel]]()
    let detailView = EpisodeDetailVew()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
        episodesTableView.register(UINib(nibName: "EpisodesTableViewCell", bundle: nil), forCellReuseIdentifier: "episodeCell")
        getEpisodes()
    }

    // to get episodes
    func getEpisodes() {
        activityIndicator.startAnimating()
        NetworkManager.getEpisodes { [weak self] episodes, error in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            if let episodes = episodes {
                self.createSeasonedEpisodes(episodes: episodes)
            } else {
                if let error = error {
                    self.alert(title: "Alert", message: error.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                self.episodesTableView.reloadData()
            }
        }
    }
    
    
    func createSeasonedEpisodes(episodes: [EpisodeModel]) {
        var seasonSet = Set<String>()
        episodes.forEach{ seasonSet.insert($0.season.trimmingCharacters(in: .whitespacesAndNewlines)) }
        let array = [[EpisodeModel]](repeating: [EpisodeModel](), count: seasonSet.count)
        var season = 0
        seasonEpisodes = array
        episodes.forEach{ seasonSet.insert($0.season) }
        
        seasonSet.forEach{ _ in
            episodes.forEach{ episode in
                if episode.season.trimmingCharacters(in: .whitespacesAndNewlines) == String(season){
                    seasonEpisodes[season-1].append(episode)
                }
            }
            season += 1
        }
    }
}

extension EpisodesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        seasonEpisodes.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        seasonEpisodes[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = episodesTableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath) as? EpisodesTableViewCell
        cell?.episode = seasonEpisodes[indexPath.section][indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailView.frame = view.bounds
        detailView.closeButtonDelegate = self
        detailView.characters.removeAll()
        detailView.characterNames = seasonEpisodes[indexPath.section][indexPath.row].characters
        view.addSubview(detailView)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Season: \(section+1)"
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let view = view as! UITableViewHeaderFooterView
        var content = view.defaultContentConfiguration()
        content.text = "Season: \(section+1)"
        content.textProperties.color = .white
        content.textProperties.font = .boldSystemFont(ofSize: 20)
        view.contentConfiguration = content
        view.contentView.backgroundColor = .systemGray
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension EpisodesViewController: subviewRemoveDelegate {
    func removeSubview() {
        print("delegate works")
        detailView.removeFromSuperview()
    }
}
