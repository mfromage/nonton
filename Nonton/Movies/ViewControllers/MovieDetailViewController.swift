//
//  MovieDetailViewController.swift
//  Nonton
//
//  Created by Michael Fromage on 06/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class MovieDetailViewController: UIViewController {

    enum NavigationEvent {
        case movieDetail(movie: Movie)
    }
    
    var onNavigationEvent: ((NavigationEvent) -> (Void))?
    
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var backdropGradientView: UIView!
    @IBOutlet weak var releaseYearWrapperView: UIView!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var voteWrapperView: UIView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var similarMoviesTableView: UITableView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    @IBOutlet weak var similarMoviesTableViewHeight: NSLayoutConstraint!
    var viewModel: MovieDetailViewModel?
    private let disposeBag = DisposeBag()
    private let tableViewCellHeight = CGFloat(200)
    
    init() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    convenience init(viewModel: MovieDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		

        setupView()
        bindViewModel()
        viewModel?.retrieveDetailMovie()
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		configureGradient()
	}
	
    
    private func setupView() {
		self.navigationController?.navigationBar.isHidden = true
		
        voteWrapperView.backgroundColor = UIColor.clear
        releaseYearWrapperView.layer.cornerRadius = 7
		
		
        configureTableView()
        configureCollectionView()
    }
    
    private func configureGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = backdropGradientView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        backdropGradientView.backgroundColor = UIColor.clear
        backdropGradientView.layer.insertSublayer(gradient, at: 0)
    }
	
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        castCollectionView.collectionViewLayout = layout
        castCollectionView.backgroundColor = UIColor.clear
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        castCollectionView.register(UINib(nibName: String(describing: CastCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "CastCell")
        
    }
    
    private func configureTableView() {
        similarMoviesTableView.backgroundColor = UIColor.clear
        similarMoviesTableView.separatorStyle = .none
        similarMoviesTableView.delegate = self
        similarMoviesTableView.dataSource = self
        similarMoviesTableView.register(UINib(nibName: String(describing: MovieTableViewCell.self), bundle: nil), forCellReuseIdentifier: "SimilarMovieCell")
    }
    
    private func bindViewModel() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.movie.asObservable()
            .map({ movie -> String? in

                return movie.releaseYear()
            })
            .bind(to: releaseYearLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .map({ movie -> String? in
				
                return movie.formattedVoteAverage()
            })
            .bind(to: voteAverageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .map({ movie -> String? in
                guard let voteCount = movie.voteCount else {
                    return nil
                }
                return String(format: "(%d)", voteCount)
            })
            .bind(to: voteCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .map({ movie -> String? in
				
                return movie.title
            })
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .map({ movie -> String? in
				
                return movie.overview
            })
            .bind(to: overviewLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .map({ movie -> String? in
				
                return movie.genreString(separator: "   ")
            })
            .bind(to: genreLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.movie.asObservable()
            .map({ movie -> URL? in
				
				return movie.originalBackdropImageURL()
            })
            .subscribe(onNext: ({ [weak self] backdropURL in
				
                self?.backdropImageView.sd_setImage(with: backdropURL, completed: nil)
            }))
            .disposed(by: disposeBag)
        
        viewModel.movieCastCellViewModels.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in

                self?.castCollectionView.reloadData()
                
            })
            .disposed(by: disposeBag)
        
        viewModel.movieSimilarCellViewModels.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
				
                self?.similarMoviesTableView.reloadData()
                
            })
            .disposed(by: disposeBag)
        
        viewModel.movieSimilarCellViewModels.asObservable()
            .observeOn(MainScheduler.instance)
            .map({ [weak self] viewModels -> CGFloat in
                
                guard let `self` = self else {
                    return 0
                }
                
                return (CGFloat(viewModels.count)*self.tableViewCellHeight)
            })
            .bind(to: similarMoviesTableViewHeight.rx.constant)
            .disposed(by: disposeBag)
        
    }

	@IBAction func backButtonOnTap(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
}

extension MovieDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.movieSimilarCellViewModels.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SimilarMovieCell") {
            return cell
        } else {
            let cell = MovieTableViewCell.init(style: .default, reuseIdentifier: "SimilarMovieCell")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let viewModel = viewModel?.movieSimilarCellViewModels.value[indexPath.row],
        let cell = cell as? MovieTableViewCell else {
            return
        }
        cell.bindViewModel(viewModel: viewModel)
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
		
		guard let viewModel = viewModel else {
			return
		}
        let movie = viewModel.movieSimilarCellViewModels.value[indexPath.row].movie.value
        self.onNavigationEvent?(.movieDetail(movie: movie))
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.movieCastCellViewModels.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel?.movieCastCellViewModels.value[indexPath.row],
        let cell = cell as? CastCollectionViewCell else {
            return
        }
        cell.bindViewModel(viewModel: viewModel)
    }
}

extension MovieDetailViewController: UICollectionViewDelegate {
    
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 75, height: 100)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}
