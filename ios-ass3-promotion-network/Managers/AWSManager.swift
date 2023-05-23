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

class AWSManager{
    
    var s3:AWSS3?
    let bucketName = "ios-promnet"
    var image:UIImage?
    let configuration:AWSServiceConfiguration?
    
    init(){ //initializes AWSS3 bucket
        let myIdentityPoolId = "ap-southeast-2:f13b2ffa-6edd-4ca6-89b9-d21bec0fdf95"

        let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType:.APSoutheast2, identityPoolId: myIdentityPoolId)

        configuration = AWSServiceConfiguration(region:.APSoutheast2, credentialsProvider:credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        AWSS3.register(with: configuration!, forKey: "defaultKey")
        s3 = AWSS3.s3(forKey: "defaultKey")
        
    }
    
     func  getAllImages(){ //prints keys of all images in the bucket
        let listRequest: AWSS3ListObjectsRequest = AWSS3ListObjectsRequest()
        listRequest.bucket = bucketName
        var imagesArray: [AWSS3Object] = []
        s3?.listObjects(listRequest).continueWith { (task) -> AnyObject? in
             for object in (task.result?.contents)! {
                 print("Object key = \(object.key!)")
                imagesArray.append(object)
             }
             return nil
         }
    }
    
    func getOneImage(key:String) -> UIImage?{ //gets one image given the key of the image
        let getObjectRequest: AWSS3GetObjectRequest = AWSS3GetObjectRequest()
        getObjectRequest.bucket = bucketName
        getObjectRequest.key = key
        
        let image = s3?.getObject(getObjectRequest).continueWith{(task) -> AnyObject? in
            guard let error = task.error else{
                print("Error getting the image.")
                return
            }
            if var data = task.result?.body as? Data{
                self.image = UIImage(data: data)
            }
            return
        }
        
        return self.image
    }
    
    func writeImage(){ //dumb function I created to check that upload actually works => DELETE
        let remote_name = "MyFileName_" + UUID().uuidString + ".png"
        let awsTransferUtility = AWSS3TransferUtility.default()
        let fileURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first?.appending(component: "ice-cream.png") //change this with a local file
        let imageData = try! Data(contentsOf: fileURL!)
        let _ = UIImage(data: imageData) //how to store as image

        let _ = awsTransferUtility.uploadFile( fileURL!,
                                                  bucket: bucketName,
                                                  key: remote_name,
                                                  contentType: "image/png",
                                                  expression: nil,
                                                  completionHandler:nil)
            .continueWith(block: { (task) -> Any? in
                if let error = task.error  {
                    print("Error: \(error.localizedDescription)")
                }
                if let result = task.result {
                    print("Result: \(result)")
                }
                return nil
            }) as! AWSTask<AWSS3TransferUtilityUploadTask>
    }
    
    // the next code is from
    // https://www.swiftdevcenter.com/upload-image-video-audio-and-any-type-of-files-to-aws-s3-bucket-swift/
    
    func getUniqueFileName(fileUrl: URL) -> String { //returns a unique filename (Haven't tried this really)
           let strExt: String = "." + (URL(fileURLWithPath: fileUrl.absoluteString).pathExtension)
           return (ProcessInfo.processInfo.globallyUniqueString + (strExt))
        //return fileURL + UUID().uuidString + 'png'
       }
    
    //uploadImage given a UIImage =>STILL have to try when view controller is done but it looks like it should work
    func uploadImage(image: UIImage, progress: progressBlock?, completion: completionBlock?, pathAndFileName: String) -> Bool {
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { //COMPRESS
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
            return false
        }
        
        let tmpPath = NSTemporaryDirectory() as String //Store it in local directory to upload it
        let fileName: String = ProcessInfo.processInfo.globallyUniqueString + (".jpeg") //name it will use to store in the bucket
        let filePath = tmpPath + "/" + fileName
        let fileUrl = URL(fileURLWithPath: filePath)
        
        do {
            try imageData.write(to: fileUrl) //upload it to the bucket
            
            // Use pathAndFileName to set the path and name of the S3 file (e.g. for profile pic it's <username>/profilePicture)
            self.uploadfile(fileUrl: fileUrl, fileName: pathAndFileName, contenType: "image", progress: progress, completion: completion)
        } catch {
            // Print the error for debugging
            print("Couldn't upload file: \(error)")
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
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
        expression.progressBlock = {(task, awsProgress) in
            guard let uploadProgress = progress else { return }
            DispatchQueue.main.async {
                uploadProgress(awsProgress.fractionCompleted)
            }
        }
        
        // Completion block. What to do once uploaded. Prints the url it was uploaded to.
        // DOUBT? should we store the URL or the key??
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

