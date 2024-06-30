//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Julius on 12/04/2024.
//

import UIKit
import essential_feed_case_study

public protocol CellController {
    func view( in tableView: UITableView) -> UITableViewCell
    func preload()
    func cancelLoad()
}

public extension CellController {
    func preload() {}
    func cancelLoad() {}
}

public final class ListViewController: UITableViewController, UITableViewDataSourcePrefetching, ResourceLoadingView, ResourceErrorView {
    //@IBOutlet public var refreshController: FeedRefreshViewController?
    @IBOutlet private(set) public var errorView: ErrorView?
    private var loadingControllers = [IndexPath: CellController]()
    
    private var isViewAppeared = false
    private var onViewIsAppearing: ((ListViewController) -> Void)?
    private var tableModel = [CellController]() {
        // use property observer to relaod table view
        // Since not every operation will dispatch work in the background queue
        // eg inMemory-cache that returns immediately if something is in the cache
        didSet {
            tableView.reloadData()
        }
    }
    
    public var onRefresh: (() -> Void )?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the refresh control
        //refreshControl = refreshController?.view // now done in storyboard
        // we need to tell the table view to repopulate
        //tableView.prefetchDataSource = self // move to storyboard
        //refreshController?.refresh() // do not show uirefresh control warnings
        
        onViewIsAppearing = { vc in
            vc.refreshControl?.beginRefreshing()
            vc.onViewIsAppearing = nil
            //vc.refresh()
            //self.refreshController?.refresh()
            self.refresh()
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeTableHeaderToFit()
    }
    
    @IBAction private func refresh() {
        onRefresh?()
    }
    
    public func display(_ cellControllers: [CellController]) {
        loadingControllers = [:]
        tableModel = cellControllers
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        errorView?.message = viewModel.message
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        onViewIsAppearing?(self)
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    // cell creation/configuration
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // tells imageloader to cancel an image data load from a url
        // cancel a task for agiven indexpath
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> CellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        
        return controller
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil // if we cancel it we do not need it anymore
    }
}
