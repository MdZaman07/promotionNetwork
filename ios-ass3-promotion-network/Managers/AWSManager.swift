//
//  AWSManager.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 14/5/23.
//

import Foundation
import AWSCore
import AWSS3

typealias progressBlock = (_ progress: Double) -> Void //2
typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void


class AWSManager {

    static let shared = AWSManager()

    var s3: AWSS3?
    let bucketName = "ios-promnet"
    var image: UIImage?
    let configuration: AWSServiceConfiguration?


    init() { //initializes AWSS3 bucket
        let myIdentityPoolId = "ap-southeast-2:f13b2ffa-6edd-4ca6-89b9-d21bec0fdf95"

        let credentialsProvider: AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType: .APSoutheast2, identityPoolId: myIdentityPoolId)

        configuration = AWSServiceConfiguration(region: .APSoutheast2, credentialsProvider: credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration

        AWSS3.register(with: configuration!, forKey: "defaultKey")
        s3 = AWSS3.s3(forKey: "defaultKey")

    }


    //gets one image given the key of the image
    func getOneImage(key: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let getObjectRequest: AWSS3GetObjectRequest = AWSS3GetObjectRequest()
        getObjectRequest.bucket = bucketName
        getObjectRequest.key = key

        s3?.getObject(getObjectRequest).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Void in
            if let _ = task.error {
                completion(.failure(task.error!))
            }
            let data: Data? = task.result?.body as? Data
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            completion(.success(image))
        }

    }

    // the next code is from
    // https://www.swiftdevcenter.com/upload-image-video-audio-and-any-type-of-files-to-aws-s3-bucket-swift/


    //uploadImage given a UIImage
    func uploadImage(image: UIImage, progress: progressBlock?, completion: completionBlock?, pathAndFileName: String) -> Bool {

        guard let imageData = image.jpegData(compressionQuality: 1.0) else { //COMPRESS
            let error = NSError(domain: "", code: 402, userInfo: [NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
            return false
        }

        let tmpPath = NSTemporaryDirectory() as String //Store it in local directory to upload it

        //create unique URL
        let fileName: String = ProcessInfo.processInfo.globallyUniqueString + (".jpeg")
        let filePath = tmpPath + "/" + fileName
        let fileUrl = URL(fileURLWithPath: filePath)

        do {
            try imageData.write(to: fileUrl) //upload it to the bucket

            // Use pathAndFileName to set the key/path of the image.
            self.uploadfile(fileUrl: fileUrl, fileName: pathAndFileName, contenType: "image", progress: progress, completion: completion)
        } catch {
            // Print the error for debugging
            print("Couldn't upload file: \(error)")
            let error = NSError(domain: "", code: 402, userInfo: [NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
            return false
        }

        // Return true to use with validation
        return true
    }

    //upload a file to the bucket
    private func uploadfile(fileUrl: URL, fileName: String, contenType: String, progress: progressBlock?, completion: completionBlock?) {

        // Upload progress block
        let expression = AWSS3TransferUtilityUploadExpression() // var supload  Progess set to int from 1-100
        expression.progressBlock = { (task, awsProgress) in
            guard let uploadProgress = progress else { return }
            DispatchQueue.main.async {
                uploadProgress(awsProgress.fractionCompleted)
            }
        }

        // Completion block. What to do once uploaded. Prints the url it was uploaded to.
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(self.bucketName).appendingPathComponent(fileName)
                    print("Uploaded to:\(String(describing: publicURL))")
                    if let completionBlock = completion {
                        completionBlock(publicURL?.absoluteString, nil)
                    }
                } else {
                    if let completionBlock = completion {
                        completionBlock(nil, error)
                    }
                }
            })
        }
        // Start uploading using AWSS3TransferUtility
        let awsTransferUtility = AWSS3TransferUtility.default()
        awsTransferUtility.uploadFile(fileUrl, bucket: bucketName, key: fileName, contentType: contenType, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            if let error = task.error {
                print("error is: \(error.localizedDescription)")
            }
            if let _ = task.result {
                print("Image uploaded!")
            }
            return nil
        }
    }

}

