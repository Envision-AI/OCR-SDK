# Envision OCR  SDK Documentation

## Current OCR SDK version
Version: 1.0
Release Date: 16/07/2018

# Overview

The Envision OCR SDK is capable for reading scene text(text appearing in the wild) and dense text present in documents accurately and quickly. The SDK is currently available for iOS. The SDK is able to recognise over 60 different languages and provide the text, position of the words on the image and the language detected. 

With the OCR SDK you can have apps read all kinds of text such as train numbers, menu cards in a restaurant, etc. The SDK currently supports devices that run iOS 10 and above. You can use it with both Swift and Objective-C and all platforms that interop with them.

# iOS SDK Setup

1. The SDK is available as a framework that can be  installed by simply dragging and dropping the framework into the Xcode project. You will then need to go to your Project name → General → Click on the "+" in Embedded Binaries and select the EnvisionOCR.framework file from the dropdown. 

![](ScreenShot2018-07-16at11-5f0ffdd3-c3e0-454b-9431-6dd5b0225cdb.01.09.png)

2. The framework also requires a small pod function effectively. You add 'SwiftyJSON' in your Podfile like seen below.

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'envisionOCRTest' do
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!
pod 'SwiftyJSON'
end

# Reading Text Instantly

Instant text recognition allows you to read short pieces of text in the real-world easily. It can be used to read signs in a train station,etc. The input can be provided both in terms of an image or a CMSampleBuffer object if you're running this on a live feed.

import EnvisionOCR

var envision = Envision()

override func viewDidLoad() {
super.viewDidLoad()
envision.instantText(image: image, apiKey: "API_KEY") 
{ (result) in
print("output text: \(results[0]["description"])")
print("output language: \(results[0]["language"])")
}
}

# Reading Document text

Document text recognition is meant for dense text such as text found in documents, books, etc. Envision can easily detect text in such items and easily return the language and segment the output into blocks, paragraphs, lines and words. 

The Document text function works both with images and CMSampleBuffer objects returned from a live camera stream. 

import EnvisionOCR

var envision = Envision()

override func viewDidLoad() {
super.viewDidLoad()
envision.documentText(image: image, apiKey: "API_KEY") 
{ (result) in
print("output text: \(results[0]["description"])")
print("output language: \(results[0]["language"])")
}
}

# Accessing the backend

The Envision OCR backend provides you with information on the current usage of your application and also allows you make request for new purchases. Currently, the usage data is updated every hour. 

You can access the dashboard by going to : https://www.letsenvision.com/dashboard/<company-name>

You will need a password to access this page and that would be provided by Envision when you sign up for the SDK service. 

# Troubleshooting and Support

The SDK is robust enough to work across iPhone, iPad and currently supports iOS 10 and above. If you're current running into issues with the service you can write to us at sdksupport@letsenvision.com and we would be able to help you with it.

