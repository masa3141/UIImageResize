//
//  ViewController.h
//  UIImageResize
//
//  Created by 廣川政樹 on 2013/05/24.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    //StoryBoardに配置したボタン
    IBOutlet UIButton *_button;
    
    UIImagePickerController *_pickerController;
    
    ALAssetsLibrary *_library;
    NSURL *_groupURL;
    NSString *_AlbumName;
    
    //アルバムが写真アプリに既にあるかどうかの判定用
    BOOL _albumWasFound;
    
    NSMutableArray *_AlAssetsArr;
    NSMutableArray *_originArr;
    NSMutableArray *_cameraArr;
}

@end
