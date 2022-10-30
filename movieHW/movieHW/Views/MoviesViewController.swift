// MoviesViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран фильмов
final class MoviesViewController: UIViewController {
    // MARK: Constants

    private enum Constants {
        static let backBarButtonTitleText = "Movies"
        static let soonButtonText = "Скоро"
        static let popularButtonText = "Популярное"
        static let bestButtonText = "Лучшее"
    }

    private enum CellIdentifier {
        static let movieCellIdentifier = "MovieTableViewCell"
    }

    private enum Colors {
        static let defaultOrange = "defaultOrange"
        static let defaultBlack = "defaultBlack"
    }

    private enum UrlStrings {
        static let popularUrlString =
            "https://api.themoviedb.org/3/movie/popular?api_key=c4c9f43f1e9f5412ba0efa79f720438e&language=en-US&page=1"
        static let topRatedUrlString =
            "https://api.themoviedb.org/3/movie/top_rated?api_key=c4c9f43f1e9f5412ba0efa79f720438e&language=en-US&page=1"
        static let soonUrlString =
            "https://api.themoviedb.org/3/movie/upcoming?api_key=c4c9f43f1e9f5412ba0efa79f720438e&language=en-US&page=1"
    }

    // MARK: Private Visual Components

    private var movies: [Results] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private let request = MovieRequest()
    private let refresherControl = UIRefreshControl()
    private let tableView = UITableView()
    private let popularButton = UIButton(type: .system)
    private let topRatedButton = UIButton(type: .system)
    private let comingSoonButton = UIButton(type: .system)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initMethods()
    }

    // MARK: - Private Methods

    @objc private func handleRefreshAction() {
        refresherControl.endRefreshing()
    }

    @objc private func topRatedButtonAction() {
        loadMovies(urlString: UrlStrings.topRatedUrlString)
    }

    @objc private func comingSoonButtonAction() {
        loadMovies(urlString: UrlStrings.soonUrlString)
    }

    @objc private func popularButtonAction() {
        loadMovies(urlString: UrlStrings.popularUrlString)
    }

    private func initMethods() {
        loadMovies(urlString: UrlStrings.popularUrlString)
        createTopRatedButton()
        createCommingSoonButton()
        createPopularButton()
        configureView()
        createTableViewSettings()
        addTargets()
        setupNavigationBar()
        createConstraints()
    }

    private func addTargets() {
        refresherControl.addTarget(self, action: #selector(handleRefreshAction), for: .valueChanged)
    }

    private func createConstraints() {
        createTableViewConstraints()
        createPopularButtonConstraints()
        createTopRatedButtonConstraints()
        createCommingSoonButtonConstraints()
    }

    private func createPopularButton() {
        popularButton.setTitle(Constants.popularButtonText, for: .normal)
        popularButton.titleLabel?.adjustsFontSizeToFitWidth = true
        popularButton.backgroundColor = UIColor(named: Colors.defaultOrange)
        popularButton.setTitleColor(UIColor.white, for: .normal)
        popularButton.layer.cornerRadius = 9
        popularButton.layer.borderColor = UIColor.white.cgColor
        popularButton.layer.borderWidth = 1.0

        popularButton.addTarget(self, action: #selector(popularButtonAction), for: .touchUpInside)
    }

    private func createPopularButtonConstraints() {
        popularButton.translatesAutoresizingMaskIntoConstraints = false

        popularButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        popularButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        popularButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        popularButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    }

    private func createTopRatedButton() {
        topRatedButton.setTitle(Constants.bestButtonText, for: .normal)
        topRatedButton.setTitleColor(UIColor.white, for: .normal)
        topRatedButton.titleLabel?.adjustsFontSizeToFitWidth = true
        topRatedButton.backgroundColor = UIColor(named: Colors.defaultOrange)
        topRatedButton.layer.cornerRadius = 9
        topRatedButton.layer.borderColor = UIColor.white.cgColor
        topRatedButton.layer.borderWidth = 1.0

        topRatedButton.addTarget(self, action: #selector(topRatedButtonAction), for: .touchUpInside)
    }

    private func createTopRatedButtonConstraints() {
        topRatedButton.translatesAutoresizingMaskIntoConstraints = false

        topRatedButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15)
            .isActive = true
        topRatedButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        topRatedButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        topRatedButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    }

    private func createCommingSoonButton() {
        comingSoonButton.setTitle(Constants.soonButtonText, for: .normal)
        comingSoonButton.titleLabel?.adjustsFontSizeToFitWidth = true
        comingSoonButton.backgroundColor = UIColor(named: Colors.defaultOrange)
        comingSoonButton.setTitleColor(UIColor.white, for: .normal)
        comingSoonButton.layer.cornerRadius = 9
        comingSoonButton.layer.borderColor = UIColor.white.cgColor
        comingSoonButton.layer.borderWidth = 1.0

        comingSoonButton.addTarget(self, action: #selector(comingSoonButtonAction), for: .touchUpInside)
    }

    private func createCommingSoonButtonConstraints() {
        comingSoonButton.translatesAutoresizingMaskIntoConstraints = false

        comingSoonButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            .isActive = true
        comingSoonButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        comingSoonButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        comingSoonButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    }

    private func createTableViewSettings() {
        tableView.addSubview(refresherControl)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        tableView.register(
            MovieTableViewCell.self,
            forCellReuseIdentifier: CellIdentifier.movieCellIdentifier
        )

        tableView.separatorStyle = .none
    }

    private func createTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }

    private func loadMovies(urlString: String) {
        request.getMovies(
            urlString: urlString
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(movies):
                self.movies = movies
            }
        }
    }

    private func configureView() {
        view.addSubview(popularButton)
        view.addSubview(topRatedButton)
        view.addSubview(comingSoonButton)
        view.addSubview(tableView)
        view.backgroundColor = UIColor(named: Colors.defaultBlack)
    }

    private func setupNavigationBar() {
        let backButtonItem = UIBarButtonItem()
        backButtonItem.tintColor = .orange
        backButtonItem.title = Constants.backBarButtonTitleText

        navigationItem.backBarButtonItem = backButtonItem
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        movies.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.createImages(movie: movies[indexPath.section])

        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = tableView
            .dequeueReusableCell(withIdentifier: CellIdentifier.movieCellIdentifier)
            as? MovieTableViewCell else { return UITableViewCell() }
        movieCell.createImages(movie: movies[indexPath.section])

        return movieCell
    }
}
