//
//  MovieListViewController.swift
//  Nonton
//
//  Created by Michael on 04/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Armchair

class MovieListViewController: UIViewController {

    enum NavigationEvent {
        case movieDetail(movie: Movie)
    }
    
    var onNavigationEvent: ((NavigationEvent) -> (Void))?
    
    @IBOutlet weak var inTheaterCollectionView: UICollectionView!
    @IBOutlet weak var comingSoonCollectionView: UICollectionView!
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var refreshControl: UIRefreshControl!
    let disposeBag = DisposeBag()
    
    fileprivate var viewModel: MovieListViewModel?
    
    init() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(viewModel: MovieListViewModel) {
        self.init()
        self.viewModel = viewModel
        
		
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		commonInit()
		
        viewModel?.retrieveInTheaterMovies()
        viewModel?.retrieveComingSoonMovies()
        viewModel?.retrieveTrendingMovies()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
    
    func commonInit() {
		self.navigationController?.navigationBar.isHidden = true
		bindViewModel()
		configureCollectionView()
    }
    
    func configureCollectionView() {
		
        self.inTheaterCollectionView.delegate = self
        self.inTheaterCollectionView.dataSource = self
        self.inTheaterCollectionView.register(UINib(nibName: String(describing: MovieCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "inTheaterCell")
		
        self.comingSoonCollectionView.delegate = self
        self.comingSoonCollectionView.dataSource = self
        self.comingSoonCollectionView.register(UINib(nibName: String(describing: MovieCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "comingSoonCell")
		
        self.trendingCollectionView.delegate = self
        self.trendingCollectionView.dataSource = self
        self.trendingCollectionView.register(UINib(nibName: String(describing: MovieCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "trendingCell")

    }
    
    func bindViewModel() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.movieInTheaterCellViewModels.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                
                self?.inTheaterCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.movieComingSoonCellViewModels.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
				
                self?.comingSoonCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.movieTrendingCellViewModels.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
				
                self?.trendingCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }

	@IBAction func rateButtonOnTap(_ sender: Any) {
		
		Armchair.Manager.defaultManager.reset()
		Armchair.showPrompt()
	}
}

// MARK: - UICollectionViewDataSource
extension MovieListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let viewModel = viewModel else {
            return 0
        }
        
        if collectionView == inTheaterCollectionView {
            return viewModel.movieInTheaterCellViewModels.value.count
        } else if collectionView == comingSoonCollectionView {
            return viewModel.movieComingSoonCellViewModels.value.count
        } else if collectionView == trendingCollectionView {
            return viewModel.movieTrendingCellViewModels.value.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var identifier: String!
        if collectionView == inTheaterCollectionView {
            identifier = "inTheaterCell"
        } else if collectionView == comingSoonCollectionView {
            identifier = "comingSoonCell"
        } else if collectionView == trendingCollectionView {
            identifier = "trendingCell"
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == inTheaterCollectionView {
            guard let cellViewModel = viewModel?.movieInTheaterCellViewModels.value[indexPath.row],
                let cell = cell as? MovieCollectionViewCell else {
                    return
            }
            cell.bind(viewModel: cellViewModel)
        } else if collectionView == comingSoonCollectionView {
            guard let cellViewModel = viewModel?.movieComingSoonCellViewModels.value[indexPath.row],
                let cell = cell as? MovieCollectionViewCell else {
                    return
            }
            cell.bind(viewModel: cellViewModel)
        } else if collectionView == trendingCollectionView {
            guard let cellViewModel = viewModel?.movieTrendingCellViewModels.value[indexPath.row],
                let cell = cell as? MovieCollectionViewCell else {
                    return
            }
            cell.bind(viewModel: cellViewModel)
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.inTheaterCollectionView {
            return CGSize(width: 150, height: 300)
        } else if collectionView == self.comingSoonCollectionView ||
			collectionView == self.trendingCollectionView {
            return CGSize(width: 100, height: 200)
		}
		
        return CGSize(width: 0, height: 0)
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

// MARK: - UICollectionViewDelegate
extension MovieListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var movie: Movie?
        if collectionView == inTheaterCollectionView {
            movie = viewModel?.movieInTheaterCellViewModels.value[indexPath.row].movie.value
        } else if collectionView == comingSoonCollectionView {
            movie = viewModel?.movieComingSoonCellViewModels.value[indexPath.row].movie.value
        } else if collectionView == trendingCollectionView {
            movie = viewModel?.movieTrendingCellViewModels.value[indexPath.row].movie.value
        }
        
        guard let validMovie = movie else {
            return
        }
        
        self.onNavigationEvent?(.movieDetail(movie: validMovie))
    }
}
