import UIKit

protocol FilterDelegate: AnyObject {
    func didApplyFilters(_ filters: FilterOptions)
}

class FilterViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var statusSegment: UISegmentedControl!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!

    weak var delegate: FilterDelegate?
    private var currentFilters: FilterOptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateExistingFilters()
    }
    
    func configure(with filters: FilterOptions) {
        self.currentFilters = filters
    }
    
    private func populateExistingFilters() {
        guard let filters = currentFilters else { return }
        
        nameTextField.text = filters.name
        speciesTextField.text = filters.species
        
        if let status = filters.status,
           let statusIndex = (0..<statusSegment.numberOfSegments)
            .first(where: { statusSegment.titleForSegment(at: $0)?.lowercased() == status.lowercased() }) {
            statusSegment.selectedSegmentIndex = statusIndex
        }
        
        if let gender = filters.gender,
           let genderIndex = (0..<genderSegment.numberOfSegments)
            .first(where: { genderSegment.titleForSegment(at: $0)?.lowercased() == gender.lowercased() }) {
            genderSegment.selectedSegmentIndex = genderIndex
        }
    }
    
    private func clearAllFilters() {
        nameTextField.text = ""
        speciesTextField.text = ""
        statusSegment.selectedSegmentIndex = 0
        genderSegment.selectedSegmentIndex = 0
    }

    @IBAction func applyFilters(_ sender: UIButton) {
        let name = nameTextField.text
        let species = speciesTextField.text
        let status = statusSegment.titleForSegment(at: statusSegment.selectedSegmentIndex)
        let gender = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)
        
        let filters = FilterOptions(name: name, status: status, species: species, gender: gender)
        delegate?.didApplyFilters(filters)
        dismiss(animated: true)
    }
    
    @IBAction func clearAllButtonTapped(_ sender: UIButton) {
        clearAllFilters()
        let emptyFilters = FilterOptions()
        delegate?.didApplyFilters(emptyFilters)
    }
}
