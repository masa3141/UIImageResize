//
//  ViewController.m
//  UIImageResize
//
//  Created by 廣川政樹 on 2013/05/24.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self checkRGB:<#(UIImageView *)#>]
    _library = [[ALAssetsLibrary alloc] init];
    //カメラロールのフォルダ名、適当に変えて！！！
    _AlbumName = @"Test";
    _AlAssetsArr = [NSMutableArray array];
    _originArr = [NSMutableArray array];
    _cameraArr = [NSMutableArray array];
    [self resizeImage];

    //AlAssetsLibraryからALAssetGroupを検索
    [_library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                            usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                
                                //ALAssetsLibraryのすべてのアルバムが列挙される
                                if (group) {
                                    
                                    //アルバム名が「_AlbumName」と同一だった時の処理
                                    if ([_AlbumName compare:[group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
                                        
                                        //assetsEnumerationBlock
                                        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                            
                                            if (result) {
                                                //asset をNSMutableArraryに格納
                                                [_AlAssetsArr addObject:result];
                                                
                                            }else{
                                                //NSMutableArraryに格納後の処理
                                                for (int i=0; i<[_AlAssetsArr count]; i++) {
                                                    int x,y;
                                                    
                                                    //タイル上に並べるためのx、yの計算
                                                    x = ((i % 5) * 50) + 10;
                                                    y = ((i / 5) * 50) + 10;
                                                    
                                                    //ALAssetからサムネール画像を取得してUIImageに変換
                                                    UIImage *image = [UIImage imageWithCGImage:[[_AlAssetsArr objectAtIndex:i] thumbnail]];
                                                    
                                                    //表示させるためにUIImageViewを作成
                                                    UIImageView *imageView = [[UIImageView alloc] init];
                                                    
                                                    //UIImageViewのサイズと位置を設定
                                                    imageView.frame = CGRectMake(x,y,50,50);
                                                    UIImage *sampleImage = [Image resize:image
                                                                                    rect:CGRectMake(0, 0, 10, 10)];
                                                    //imageView.backgroundColor = [self checkColor:sampleImage];
                                                    //imageView.image = image;
                                                    NSArray *arr = [self checkColor:sampleImage];
                                                    //imageView.backgroundColor = [UIColor colorWithRed:[arr[0] floatValue]  green:[arr[1] floatValue] blue:[arr[2] floatValue] alpha:1.0];
                                                    [_cameraArr addObject:[self checkColor:sampleImage]];
                                                    
                                                    //ViewにaddSubView
                                                    [self.view addSubview:imageView];
                                                }
                                            }
                                            
                                        };
                                        
                                        //アルバム(group)からALAssetの取得        
                                        [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
                                    }            
                                }
                                
                            } failureBlock:nil];
    [self makemozaiku];
}

-(IBAction)btn:(id)sender{
    NSLog(@"origine %@",_originArr);
    NSLog(@"camera %@",_cameraArr);
    
    
    for (int i=0; i<16*16; i++) {
        //float min_value = 999;
        float max_value = 0;
        NSLog(@"今=%d/256",i);
        for (int j=0; j<[_cameraArr count]; j++) {
            int x,y;
            NSArray *arr1 = [_originArr objectAtIndex:i];
            NSArray *arr2 = [_cameraArr objectAtIndex:j];
            float r1 = [arr1[0] floatValue];
            float g1 = [arr1[1] floatValue];
            float b1 = [arr1[2] floatValue];
            float r2 = [arr2[0] floatValue];
            float g2 = [arr2[1] floatValue];
            float b2 = [arr2[2] floatValue];
            
            //float diff = fabs(r1-r2) + fabs(g1-g2) + fabs(b1-b2);
            float diff = (r1*r2 + g1*g2 + b1*b2 )/ sqrt( r1*r1 + g1*g1 + b1*b1 ) /sqrt(r2*r2 + g2*g2 + b2*b2 );
            //NSLog(@"%f,%f,%f",r1,g1,b1);
            //NSLog(@"%f,%f,%f",r2,g2,b2);
            //NSLog(@"%f,%f,%f",r1-r2,g1-g2,b1-b2);
            //NSLog(@"%f,%f,%f",fabs(r1-r2),fabs(g1-g2),fabs(b1-b2));

            //NSLog(@"%f,%f,%f",sqrt([arr1[0] floatValue]- [arr2[0] floatValue]) ,sqrt([arr1[1] floatValue]- [arr2[1] floatValue]) ,sqrt([arr1[2] floatValue]- [arr2[2] floatValue]));
            //NSLog(@"%f",[arr1[0] floatValue]);
            //NSLog(@"%f",[arr2[0] floatValue]);
            //NSLog(@"%f",[arr2[0] floatValue]-[arr2[0] floatValue]);
            //NSLog(@"%f",r1-r2);

            //NSLog(@"%f",sqrt([arr2[0] floatValue]-[arr2[0] floatValue]));

            //NSLog(@"arr1=%@,arr2=%@",arr1,arr2);
            //NSLog(@"i=%d,diff=%f",i,diff);
           // if (diff < min_value) {
            if (diff > max_value) {
                max_value = diff;
                //min_value = diff;
                //タイル上に並べるためのx、yの計算
                x = ((i / 16) * 16) ;
                y = ((i % 16) * 16) ;
                NSLog(@"i=%d,x=%d,y=%d,diff=%f",i,x,y,diff);
                //ALAssetからサムネール画像を取得してUIImageに変換
                UIImage *image = [UIImage imageWithCGImage:[[_AlAssetsArr objectAtIndex:j] thumbnail]];
                
                //表示させるためにUIImageViewを作成
                UIImageView *imageView = [[UIImageView alloc] init];
                
                //UIImageViewのサイズと位置を設定
                imageView.frame = CGRectMake(x,y,16,16);
                /*
                 UIImage *sampleImage = [Image resize:image
                 rect:CGRectMake(0, 0, 10, 10)];
                 */
                //imageView.backgroundColor = [self checkColor:sampleImage];
                imageView.image = image;
                
                //ViewにaddSubView
                [self.view addSubview:imageView];
            }
        }
        
    }
}
-(void) makemozaiku{
    
    NSLog(@"origine %@",_originArr);
    NSLog(@"camera %@",_cameraArr);
    
    
}

- (void)resizeImage
{
    //画像をリサイズして UIImageに格納
    UIImage *sampleImage = [Image resize:[Image getUIImageFromResources:@"test" ext:@"jpg"]
                                    rect:CGRectMake(0, 0, 16, 16)];
    
    //画像を UIImageViewに格納
    UIImageView *sampleImageView = [[UIImageView alloc] initWithImage:sampleImage];
    sampleImageView.frame =CGRectMake(0, 0, 320, 320);
    //画面に追加
    //[self.view addSubview:sampleImageView];
    [self checkRGB:sampleImageView];
    
}


- (NSArray *)checkColor:(UIImage *)img{
    CGImageRef  imageRef = img.CGImage;
    
    // データプロバイダを取得する
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    // ビットマップデータを取得する
    CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(dataRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    
    UInt8 *pixelPtr;
    UInt8 r;
    UInt8 g;
    UInt8 b;
    
    int red =0 ;
    int green = 0;
    int blue = 0;
    // 画像全体を１ピクセルずつ走査する
    for (int checkX = 0; checkX < img.size.width; checkX++) {
        for (int checkY=0; checkY < img.size.height; checkY++) {
            // ピクセルのポインタを取得する
            pixelPtr = buffer + (int)(checkY) * bytesPerRow + (int)(checkX) * 4;
            
            // 色情報を取得する
            r = *(pixelPtr + 2);  // 赤
            g = *(pixelPtr + 1);  // 緑
            b = *(pixelPtr + 0);  // 青
            red += r;
            green += g;
            blue += b;
           // NSLog(@"x:%d y:%d R:%d G:%d B:%d", checkX, checkY, r, g, b);
            //UIImageView *imgView= [[UIImageView alloc] init];
            //imgView.frame =CGRectMake(checkX*16, checkY*16, 16, 16);
            //imgView.backgroundColor = [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:1];
            //[self.view addSubview:imgView];
            
        }
        
        int averageRGB = (int)r + (int)g + (int)b;
    }
    CFRelease(dataRef);
    int num = img.size.width * img.size.height;
    NSArray *colorarr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:(float)red/255.0/num],[NSNumber numberWithFloat:(float)green/255.0/num],[NSNumber numberWithFloat:(float)blue/255.0/num], nil];
    //NSLog(@"確認%@",colorarr);

    return colorarr;
    //TODO: RGBの平均値を返す
    //    float averageRGB = [self getAverageColor];
    //
    //    return averageRGB;

}


- (void)checkRGB:(UIImageView *)iv
{
    //現在解析中のImageViewをcurrentImageViewに表示させる
    
    NSLog(@"iv is %@", iv);
    
    // CGImageを取得する
    CGImageRef  imageRef = iv.image.CGImage;
    
    // データプロバイダを取得する
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    // ビットマップデータを取得する
    CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(dataRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    
    UInt8 *pixelPtr;
    UInt8 r;
    UInt8 g;
    UInt8 b;
    

    // 画像全体を１ピクセルずつ走査する
    for (int checkX = 0; checkX < iv.image.size.width; checkX++) {
        for (int checkY=0; checkY < iv.image.size.height; checkY++) {
            // ピクセルのポインタを取得する
            pixelPtr = buffer + (int)(checkY) * bytesPerRow + (int)(checkX) * 4;
            
            // 色情報を取得する
            r = *(pixelPtr + 2);  // 赤
            g = *(pixelPtr + 1);  // 緑
            b = *(pixelPtr + 0);  // 青
            
            //NSLog(@"x:%d y:%d R:%d G:%d B:%d", checkX, checkY, r, g, b);
            UIImageView *imgView= [[UIImageView alloc] init];
            imgView.frame =CGRectMake(checkX*16, checkY*16, 16, 16);
            imgView.backgroundColor = [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:1];
            [self.view addSubview:imgView];
            NSArray *colorarr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:(float)r/255.0],[NSNumber numberWithFloat:(float)g/255.0],[NSNumber numberWithFloat:(float)b/255.0], nil];
            [_originArr addObject:colorarr];
            //NSLog(@"add logic%@",_originArr);
        }
        
        int averageRGB = (int)r + (int)g + (int)b;
    }

    CFRelease(dataRef);
    
    //TODO: RGBの平均値を返す
    //    float averageRGB = [self getAverageColor];
    //
    //    return averageRGB;
    
}


@end
