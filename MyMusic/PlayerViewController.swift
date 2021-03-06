//
//  PlayerViewController.swift
//  Petros-MusicPlayer
//
//  Created by user166111 on 5/7/20.
//  Copyright © 2020 FMI. All rights reserved.
//

import AVFoundation
import UIKit

class PlayerViewController: UIViewController {

    public var position: Int = 0
    public var songs: [Song] = []

    //am conectat storyboardul cu holder
    @IBOutlet var holder: UIView!

    var player: AVAudioPlayer?

    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 // line wrap
        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 // line wrap
        return label
    }()

    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 // line wrap
        return label
    }()

    let playPauseButton = UIButton()
    let shuffleButton = UIButton()
    let repeatButton = UIButton()
    public var isShuffleChecked = false
    public var isRepeatChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0 {
            configure()
        }
    }

    func configure() {

        let song = songs[position]

        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")

        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

            guard let urlString = urlString else {
                print("urlstring is nil")
                return
            }

            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)

            guard let player = player else {
                print("player is nil")
                return
            }
            player.volume = 0.5

            player.play()
        }
        catch {
            print("error occurred")
        }

        // Setare interfata pleyerului

        // Poza album
        albumImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: holder.frame.size.width-20,
                                      height: holder.frame.size.width-20)
        albumImageView.image = UIImage(named: song.imageName)
        holder.addSubview(albumImageView)

        // Labeluri: Song name, album, artist
        songNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10,
                                     width: holder.frame.size.width-20,
                                     height: 70)
        albumNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10 + 70,
                                     width: holder.frame.size.width-20,
                                     height: 70)
        artistNameLabel.frame = CGRect(x: 10,
                                       y: albumImageView.frame.size.height + 10 + 140,
                                       width: holder.frame.size.width-20,
                                       height: 70)

        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName

        holder.addSubview(songNameLabel)
        holder.addSubview(albumNameLabel)
        holder.addSubview(artistNameLabel)

        // Butoane
        let nextButton = UIButton()
        let backButton = UIButton()

        
        // Frame
        let yPosition = artistNameLabel.frame.origin.y + 70 + 20
        let size: CGFloat = 70

        playPauseButton.frame = CGRect(x: (holder.frame.size.width - size) / 2.0,
                                       y: yPosition,
                                       width: size,
                                       height: size)

        nextButton.frame = CGRect(x: holder.frame.size.width - size - 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)

        backButton.frame = CGRect(x: 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)

        shuffleButton.frame = CGRect(x: 20,
                                  y: albumImageView.frame.size.height + 10 + 140,
                                  width: size/2,
                                  height: size/2)
        
        repeatButton.frame = CGRect(x: holder.frame.size.width - 50,
                                  y: albumImageView.frame.size.height + 10 + 140,
                                  width: size/2,
                                  height: size/2)
        
        // Actiunea butoanelor
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        shuffleButton.addTarget(self, action: #selector(didTapShuffleButton), for: .touchUpInside)
        repeatButton.addTarget(self, action: #selector(didTapRepeatButton), for: .touchUpInside)
        
        // Poza + culoare butoane

        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        shuffleButton.setBackgroundImage(UIImage(named: "shuffle"), for: .normal)
        repeatButton.setBackgroundImage(UIImage(named: "repeat"), for: .normal)
        
        playPauseButton.tintColor = .black
        backButton.tintColor = .black
        nextButton.tintColor = .black

        shuffleButton.layer.shadowColor = UIColor.blue.cgColor
        shuffleButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        shuffleButton.layer.shadowRadius = 5
        if isShuffleChecked {
            shuffleButton.layer.shadowOpacity = 0.5
        } else {
            shuffleButton.layer.shadowOpacity = 0
        }
        
        repeatButton.layer.shadowColor = UIColor.blue.cgColor
        repeatButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        repeatButton.layer.shadowRadius = 5
        if isRepeatChecked {
            repeatButton.layer.shadowOpacity = 0.5
        } else {
            repeatButton.layer.shadowOpacity = 0
        }
        
        holder.addSubview(playPauseButton)
        holder.addSubview(nextButton)
        holder.addSubview(backButton)
        holder.addSubview(shuffleButton)
        holder.addSubview(repeatButton)

        
        // slider
        let slider = UISlider(frame: CGRect(x: 20,
                                            y: holder.frame.size.height-60,
                                            width: holder.frame.size.width-40,
                                            height: 50))
        slider.value = 0.5
        // de cate ori se modifica valoarea sliderului
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        holder.addSubview(slider)
    }

    @objc func didTapRepeatButton() {
        isRepeatChecked = !isRepeatChecked
        if isRepeatChecked {
            repeatButton.layer.shadowOpacity = 0.5
        } else {
            repeatButton.layer.shadowOpacity = 0
        }
                
    }
    
    
    @objc func didTapShuffleButton() {
        isShuffleChecked = !isShuffleChecked
        if isShuffleChecked {
            shuffleButton.layer.shadowOpacity = 0.5
        } else {
            shuffleButton.layer.shadowOpacity = 0
        }
                
    }
    
    @objc func didTapBackButton() {
        if position > 0 {
            position = position - 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }

    @objc func didTapNextButton() {
        if isShuffleChecked {
            var newposition = position
            repeat {
                newposition = Int.random(in: 0 ..< songs.count)
            } while(newposition == position)
            position = newposition
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        } else if position < (songs.count - 1) {
            position = position + 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        } else if isRepeatChecked{
            position = 0
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapPlayPauseButton() {
        if player?.isPlaying == true {
            // Pause
            player?.pause()
            // Schimba imaginea cu play
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)

            // Micsoreaza imaginea
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 30,
                                                   y: 30,
                                                   width: self.holder.frame.size.width-60,
                                                   height: self.holder.frame.size.width-60)
            })
        }
        else {
            // Play
            player?.play()
            // Schimba imaginea cu pause
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)

            // Mareste imaginea (la normal, dupa ce a fost micsorata)
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 10,
                                              y: 10,
                                              width: self.holder.frame.size.width-20,
                                              height: self.holder.frame.size.width-20)
            })
        }
    }

    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        player?.volume = value
    }

    //
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }

}
