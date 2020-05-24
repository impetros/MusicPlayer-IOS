//
//  ViewController.swift
//  Petros-MusicPlayer
//
//  Created by user166111 on 5/7/20.
//  Copyright © 2020 FMI. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var songs = [Song]()
    var searchingNames = [Song]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSongs()
        table.keyboardDismissMode = .onDrag
        table.delegate = self
        table.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func configureSongs() {
        let path = Bundle.main.path(forResource: "songs", ofType: "txt") // file path for file "data.txt"
        let string = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        print(string)
        let array = string.components(separatedBy: "\r\n")
        print(array)
        for element in array {
            let elementArray = element.components(separatedBy: "^")
            print(elementArray)
            if(elementArray.count == 5) {
                    songs.append(Song(name: elementArray[0],
                                    albumName: elementArray[1],
                                    artistName: elementArray[2],
                                    imageName: elementArray[3],
                                    trackName: elementArray[4]))
            }
        }
    }

    // Nr melodii -> nr elemente tabela
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingNames.count
        }
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = searching ? searchingNames[indexPath.row] : songs[indexPath.row]

        // Configurare
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: song.imageName)
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)

        return cell
    }

    // Inaltime rand pentru ca era foarte mic default
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselectam dupa ce apasam
        tableView.deselectRow(at: indexPath, animated: true)

        var position = 0
        if searching {
            let selectedSong = searchingNames[indexPath.row]
            for i in 0..<songs.count{
                if(selectedSong == songs[i]){
                    position = i;
                    break;
                }
            }
        } else {
            position = indexPath.row
        }
            
        // Configuram player viewul si deschidem viewul de player
        guard let vc = storyboard?.instantiateViewController(identifier: "player") as? PlayerViewController else {
            return
        }
        vc.songs = songs
        vc.position = position
        present(vc, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingNames.removeAll()
        let searchTextLowerCased = searchText.lowercased()
        for song in songs {
            if(song.albumName.lowercased().hasPrefix(searchTextLowerCased) || song.artistName.lowercased().hasPrefix(searchTextLowerCased) ||
                song.name.lowercased().hasPrefix(searchTextLowerCased)){
                searchingNames.append(song)
            }
        }
        searching = true
        table.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.endEditing(true)
        table.reloadData()
    }

}

struct Song: Equatable {
    let name: String
    let albumName: String
    let artistName: String
    let imageName: String
    let trackName: String
    
        static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.name == rhs.name && lhs.albumName == rhs.albumName &&
            lhs.artistName == rhs.artistName && lhs.imageName == rhs.imageName &&
            lhs.trackName == rhs.trackName
    }
}
