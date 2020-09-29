import UIKit
import MiniApp

class UserSettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var modifyProfileSettingsButton: UIBarButtonItem!

    var userProfileImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.roundedCornerImageView()
        setProfileImage(image: retrieveProfileSettings())
        addTapGestureForImage()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func setProfileImage(image: UIImage?) {
        guard let profileImage = image else {
            editPhotoButton.setTitle("Add Photo", for: .normal)
            return
        }
        editPhotoButton.setTitle("Edit", for: .normal)
        self.imageView.image = profileImage
        self.userProfileImage = profileImage
    }

    func addTapGestureForImage() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        showPhotoLibrary()
    }

    @IBAction func showPhotoLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }

    @IBAction func modifyProfileSettings() {
        if modifyProfileSettingsButton.title == "Edit" {
            modifyProfileSettingsButton.title = "Save"
        } else {
            if !saveProfileSettings() {
                return
            }
            modifyProfileSettingsButton.title = "Edit"
        }
        displayNameTextField.isEnabled = !displayNameTextField.isEnabled
        editPhotoButton.isEnabled = !editPhotoButton.isEnabled
        editPhotoButton.isHidden  = !editPhotoButton.isHidden
        self.displayNameTextField.becomeFirstResponder()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("User cancelled the operation")
            return
        }
        setProfileImage(image: image)
    }

    func saveProfileSettings(forKey key: String = "ProfileImage") -> Bool {
        displayNameTextField.text = displayNameTextField.text?.trimTrailingWhitespaces()
        return setProfileSettings(userDisplayName: displayNameTextField.text, profileImageURI: self.userProfileImage?.dataURI())
    }

    func retrieveProfileSettings(key: String = "ProfileImage") -> UIImage? {
        guard let userProfile = getProfileSettings() else {
            return nil
        }
        self.displayNameTextField.text = userProfile.displayName
        return userProfile.profileImageURI?.convertBase64ToImage()
    }
}

extension UIImageView {
    func roundedCornerImageView() {
        self.layer.cornerRadius = self.frame.width/2
        self.layer.masksToBounds = true
    }
}
