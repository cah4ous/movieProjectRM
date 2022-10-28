// DetailViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран детального описания фильма
final class DetailViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let defaultBlack = "defaultBlack"
        static let defaultOrange = "defaultOrange"
        static let watch = "Смотреть"
        static let shareButtonImageName = "square.and.arrow.up"
        static let clearString = ""
    }

    // MARK: Private Visual Components

    private var movieImageView = UIImageView()
    private var movieDescriptionLabel = UILabel()
    private var watchButton = UIButton(type: .system)
    private var scrollView = UIScrollView()
    private var movieRatingLabel = UILabel()

    // MARK: - Private Properties

    private var movieTitle: String = Constants.clearString

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initMethods()
    }

    // MARK: - Public Methods

    func createImages(urlString: String, descriptionInfo: String, ratingInfo: String, titleText: String) {
        guard let url = URL(string: urlString) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        movieImageView.image = UIImage(data: data)
        movieDescriptionLabel.text = descriptionInfo
        movieRatingLabel.text = ratingInfo
        movieTitle = titleText
    }

    // MARK: - Private Methods

    @objc private func shareButtonAction() {
        let activityViewController = UIActivityViewController(
            activityItems: [movieTitle],
            applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }

    private func initMethods() {
        setupScrollView()
        setupView()
        setupNavigationBar()
        setConstraints()
    }

    private func setConstraints() {
        setMovieImageView()
        setMovieDescriptionLabel()
        setWatchButton()
        setScrollView()
        setRatingLabel()
    }

    private func setWatchButton() {
        watchButton.translatesAutoresizingMaskIntoConstraints = false

        watchButton.setTitle(Constants.watch, for: .normal)
        watchButton.titleLabel?.adjustsFontSizeToFitWidth = true
        watchButton.backgroundColor = UIColor(named: Constants.defaultOrange)
        watchButton.setTitleColor(UIColor.white, for: .normal)

        watchButton.translatesAutoresizingMaskIntoConstraints = false

        watchButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        watchButton.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 20).isActive = true
        watchButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        watchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        watchButton.layer.cornerRadius = 9
        watchButton.layer.borderColor = UIColor.white.cgColor
        watchButton.layer.borderWidth = 1.0
    }

    private func setMovieImageView() {
        movieImageView.translatesAutoresizingMaskIntoConstraints = false

        movieImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        movieImageView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        movieImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: 460).isActive = true
        movieImageView.contentMode = .scaleToFill
    }

    private func setScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100).isActive = true
        scrollView.backgroundColor = UIColor(named: Constants.defaultBlack)
    }

    private func setMovieDescriptionLabel() {
        movieDescriptionLabel.numberOfLines = 0

        movieDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        movieDescriptionLabel.topAnchor.constraint(equalTo: movieRatingLabel.bottomAnchor, constant: 15).isActive = true
        movieDescriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        movieDescriptionLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 5).isActive = true
        movieDescriptionLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -5).isActive = true
        movieDescriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -100).isActive = true
    }

    private func setRatingLabel() {
        movieRatingLabel.font = .boldSystemFont(ofSize: 25)
        movieRatingLabel.textColor = UIColor.white
        movieRatingLabel.textAlignment = .center

        movieRatingLabel.translatesAutoresizingMaskIntoConstraints = false

        movieRatingLabel.topAnchor.constraint(equalTo: watchButton.bottomAnchor, constant: 10).isActive = true
        movieRatingLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        movieRatingLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        movieRatingLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        movieRatingLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func setupScrollView() {
        scrollView.addSubview(watchButton)
        scrollView.addSubview(movieImageView)
        scrollView.addSubview(movieDescriptionLabel)
        scrollView.addSubview(movieRatingLabel)
    }

    private func setupView() {
        view.addSubview(scrollView)
        view.backgroundColor = UIColor(named: Constants.defaultBlack)
    }

    private func setupNavigationBar() {
        let shareButton = UIButton(type: .system)
        shareButton.setImage(UIImage(systemName: Constants.shareButtonImageName), for: .normal)
        shareButton.tintColor = UIColor(named: Constants.defaultOrange)
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
        navigationItem.title = movieTitle
    }
}
