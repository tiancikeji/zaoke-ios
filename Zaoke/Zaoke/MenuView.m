//
//  MenuView.m
//  Zaoke
//
//  Created by Johnil on 13-9-13.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "MenuView.h"
#import "UIImage+StackBlur.h"
@implementation MenuView {
	UIView *keyWordBar;
	UILabel *priceType;
	UILabel *price;
	UIImageView *photoView;

	UIImageView *blurImg;
	UITextView *content;
	NSString *contentText;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.clipsToBounds = YES;
		photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		photoView.image = [UIImage imageNamed:@"test.png"];
		photoView.contentMode = UIViewContentModeScaleAspectFill;
		[self addSubview:photoView];

		priceType = [[UILabel alloc] initWithFrame:CGRectMake(320-90, 75, 28, 35)];
		priceType.text = @"¥";
		priceType.backgroundColor = [UIColor clearColor];
		priceType.textColor = COLOR_ORANGE;
		priceType.font = FontWithSize(32);
		[self addSubview:priceType];

		price = [[UILabel alloc] initWithFrame:CGRectMake(320-70, 70, 70, 40)];
		price.text = @"10";
		price.backgroundColor = [UIColor clearColor];
		price.textColor = COLOR_ORANGE;
		price.minimumScaleFactor = .1;
		price.adjustsFontSizeToFitWidth = YES;
		price.font = FontWithSize(40);
		[self addSubview:price];
    }
    return self;
}

- (void)setInfo:(NSDictionary *)info{
	[photoView setImageWithURL:[NSURL URLWithString:[info valueForKey:@"image_url"]]];
	price.text = [[info valueForKey:@"sale_price"] stringValue];
	contentText = [info valueForKey:@"desc"];
	NSArray *keywords = [info valueForKey:@"tags"];
	if (keywords!=nil) {
		NSMutableArray *widthArr = [NSMutableArray array];
		float width = 0;
		for (NSString *temp in keywords) {
			float w = [temp sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 17)].width+10;
			[widthArr addObject:@(w)];
			width+=w;
		}
		UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(32, 1, width, 18)];
		keyWordBar = [[UIView alloc] initWithFrame:CGRectMake(0, 80, width+32, 20)];
		[self addSubview:keyWordBar];

		UILabel *redView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 20)];
		redView.backgroundColor = [UIColor colorWithFullRed:243 green:84 blue:63 alpha:1];
		redView.text = @"NEW";
		redView.textColor = [UIColor whiteColor];
		redView.font = [UIFont systemFontOfSize:12];
		redView.minimumScaleFactor = .1;
		redView.textAlignment = NSTextAlignmentCenter;
		redView.adjustsFontSizeToFitWidth = YES;
		[keyWordBar addSubview:redView];

		blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7];
		[keyWordBar addSubview:blackView];
		width = 5;
		int i=0;
		for (NSNumber *w in widthArr) {
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width, 0, w.floatValue, 18)];
			label.backgroundColor = [UIColor clearColor];
			label.text = [keywords objectAtIndex:i];
			label.font = [UIFont systemFontOfSize:10];
			label.minimumScaleFactor = .1;
			label.adjustsFontSizeToFitWidth = YES;
			label.textColor = [UIColor colorWithFullRed:247 green:242 blue:218 alpha:1];
			[blackView addSubview:label];
			width += w.floatValue;
			i++;
		}
	}
}

- (void)blur{
	if (blurImg!=nil) {
		return;
	}
	blurImg = [[UIImageView alloc] initWithImage:[[self toImage] stackBlur:60]];
	blurImg.frame = self.window.bounds;
	[self addSubview:blurImg];
	[blurImg fadeIn];
}

- (void)cancelBlur{
	[blurImg fadeOutOnComplet:^(BOOL f) {
		[blurImg removeFromSuperview];
		blurImg = nil;
	}];
}

- (void)showStory{
	if (blurImg==nil) {
		blurImg = [[UIImageView alloc] initWithImage:[[self toImage] stackBlur:60]];
		blurImg.frame = self.window.bounds;
		[self addSubview:blurImg];
		[blurImg fadeIn];
		content = [[UITextView alloc] initWithFrame:blurImg.frame];
		UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStory)];
		[content addGestureRecognizer:tap];
		content.font = [UIFont systemFontOfSize:17];
		content.height -= 91;
		content.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
		content.scrollIndicatorInsets = content.contentInset;
		content.editable = NO;
		content.text = contentText;
		//[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"temp" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
		content.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.3];
		[self addSubview:content];
		[content fadeIn];
	} else {
		[blurImg fadeOut];
		[content fadeOutOnComplet:^(BOOL f) {
			[blurImg removeFromSuperview];
			[content removeFromSuperview];
			blurImg = nil;
			content = nil;
		}];
	}
}

@end
