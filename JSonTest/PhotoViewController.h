//
//  PhotoViewController.h
//  JSonTest
//
//  Created by Alexey Baranov on 19.01.2022.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "AlbumPhoto.h"
#import "ModelData.h"

@interface PhotoViewController : UIViewController
{
    // AlbumPhoto for visualisation
    AlbumPhoto *albumPhoto;
    // album for visualitation
    Album *album;
    // field for photo visualisation
    UITextView *textView;
    UIImageView *imageView;
}

-(void)readPhoto: (NSUInteger) photoID;
-(void)setAlbum: (Album *) album andAlbumPhoto: (AlbumPhoto *) albumPhoto;

@end

