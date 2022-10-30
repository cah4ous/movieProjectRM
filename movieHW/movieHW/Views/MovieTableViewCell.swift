// MovieTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка movie
final class MovieTableViewCell: UITableViewCell {
    // MARK: - Constants

    private enum Constants {
        static let defaultOrange = "defaultOrange"
        static let error = "init(coder:) has not been implemented"
        static let firstPathOfUrlString = "https://image.tmdb.org/t/p/w200/"
    }

    // MARK: - Public Visual Components

    private let movieImageView = UIImageView()
    private let movieNameLabel = UILabel()
    private let movieDescriptionLabel = UILabel()
    private let movieRatingLabel = UILabel()

    // MARK: Private Visual Components

    private let movieView = UIView()

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
        movieView.backgroundColor = UIColor(named: Constants.defaultOrange)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.error)
    }

    // MARK: - Public Methods

    func createImages(movie: Results) {
        let urlString = "\(Constants.firstPathOfUrlString)\(movie.posterPath)"
        guard
            let url = URL(string: urlString),
            let data = try? Data(contentsOf: url)
        else {
            return
        }
        movieDescriptionLabel.text = movie.overview
        movieRatingLabel.text = "\(movie.voteAverage)"
        movieNameLabel.text = movie.title
        movieImageView.image = UIImage(data: data)
    }

    // MARK: - Private Methods

    private func setupCell() {
        setupContentView()
        createMovieImageView()
        createMovieView()
        createNameLabel()
        createDescriptionLabel()
        createScoreLabel()
        addConstraints()
    }

    private func addConstraints() {
        createMovieRatingLabelConstraints()
        createMovieNameLabelConstraints()
        createMovieDescriptionLabelConstraints()
        createMovieViewConstraints()
        createMovieImageViewConstraints()
    }

    private func createScoreLabel() {
        movieRatingLabel.layer.masksToBounds = true
        movieRatingLabel.font = UIFont.boldSystemFont(ofSize: 15)
        movieRatingLabel.backgroundColor = .white
        movieRatingLabel.layer.borderWidth = 3
        movieRatingLabel.layer.borderColor = UIColor(named: Constants.defaultOrange)?.cgColor
        movieRatingLabel.layer.cornerRadius = 15
        movieRatingLabel.textColor = .black
        movieRatingLabel.textAlignment = .center
    }

    private func createMovieRatingLabelConstraints() {
        movieRatingLabel.translatesAutoresizingMaskIntoConstraints = false

        movieRatingLabel.leftAnchor.constraint(equalTo: movieImageView.leftAnchor, constant: 10).isActive = true
        movieRatingLabel.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -10).isActive = true
        movieRatingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        movieRatingLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }

    private func createDescriptionLabel() {
        movieDescriptionLabel.numberOfLines = 0
        movieDescriptionLabel.textAlignment = .center
        movieDescriptionLabel.font = UIFont.systemFont(ofSize: 16)
    }

    private func createMovieDescriptionLabelConstraints() {
        movieDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        movieDescriptionLabel.leftAnchor.constraint(equalTo: movieView.leftAnchor, constant: 10).isActive = true
        movieDescriptionLabel.rightAnchor.constraint(equalTo: movieView.rightAnchor, constant: -10).isActive = true
        movieDescriptionLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 10).isActive = true
        movieDescriptionLabel.bottomAnchor.constraint(equalTo: movieView.bottomAnchor, constant: -10).isActive = true
    }

    private func createNameLabel() {
        movieNameLabel.textAlignment = .center
        movieNameLabel.font = UIFont.boldSystemFont(ofSize: 19)
        movieNameLabel.textColor = .black
        movieNameLabel.numberOfLines = 2
        movieNameLabel.adjustsFontSizeToFitWidth = true
    }

    private func createMovieNameLabelConstraints() {
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false

        movieNameLabel.leftAnchor.constraint(equalTo: movieView.leftAnchor, constant: 10).isActive = true
        movieNameLabel.rightAnchor.constraint(equalTo: movieView.rightAnchor, constant: -10).isActive = true
        movieNameLabel.topAnchor.constraint(equalTo: movieView.topAnchor, constant: 20).isActive = true
        movieNameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    private func createMovieView() {
        movieView.backgroundColor = UIColor(named: Constants.defaultOrange)
        movieView.addSubview(movieNameLabel)
        movieView.addSubview(movieDescriptionLabel)
    }

    private func createMovieViewConstraints() {
        movieView.translatesAutoresizingMaskIntoConstraints = false

        movieView.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 0).isActive = true
        movieView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        movieView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -10).isActive = true
        movieView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }

    private func setupContentView() {
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true

        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1

        contentView.addSubview(movieImageView)
        contentView.addSubview(movieView)
    }

    private func createMovieImageView() {
        movieImageView.backgroundColor = .black
        movieImageView.contentMode = .scaleToFill
        movieImageView.addSubview(movieRatingLabel)
    }

    private func createMovieImageViewConstraints() {
        movieImageView.translatesAutoresizingMaskIntoConstraints = false

        movieImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        movieImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -10).isActive = true
        movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
}
