
import UIKit

final class SaleCollectionViewCell: UICollectionViewCell {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var saleImageViews: [UIImageView] = []

    private var currentIndex = 0
    private var timer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setConstraints()
        startImageScrolling()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addSubview(scrollView)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configureCell(imageNames: [String]) {
        saleImageViews.forEach { $0.removeFromSuperview() }
        saleImageViews.removeAll()

        for imageName in imageNames {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: imageName)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(imageView)
            saleImageViews.append(imageView)
        }

        for (index, imageView) in saleImageViews.enumerated() {
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                imageView.leadingAnchor.constraint(equalTo: index == 0 ? scrollView.leadingAnchor : saleImageViews[index - 1].trailingAnchor),
                imageView.trailingAnchor.constraint(equalTo: index == saleImageViews.count - 1 ? scrollView.trailingAnchor : saleImageViews[index + 1].leadingAnchor)
            ])
        }

        scrollView.contentSize = CGSize(width: CGFloat(saleImageViews.count) * frame.width, height: frame.height)
    }

    private func startImageScrolling() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollToNextImage), userInfo: nil, repeats: true)
    }

    @objc private func scrollToNextImage() {
        let nextPage = (currentIndex + 1) % saleImageViews.count
        let contentOffsetX = CGFloat(nextPage) * frame.width
        scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: true)
        currentIndex = nextPage
    }

    deinit {
        timer?.invalidate()
    }
}

