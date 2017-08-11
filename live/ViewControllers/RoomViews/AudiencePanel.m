//
//  AudiencePanel.m
//  live
//
//  Created by AlexiChen on 15/10/21.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import "AudiencePanel.h"

#import "UIView+CustomAutoLayout.h"

@interface AudiencePanelCell : UICollectionViewCell
{
@protected
    UIImageView *_headIcon;
    UILabel     *_nickName;
}

- (void)config:(LiveUser *)dic;

@end

@implementation AudiencePanelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addOwnViews];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


- (void)addOwnViews
{
    _headIcon = [[UIImageView alloc] init];
    _headIcon.layer.cornerRadius = 30;
    _headIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    _headIcon.layer.borderWidth = 2;
    _headIcon.layer.masksToBounds = YES;
//    _headIcon.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_headIcon];
    
    _nickName = [[UILabel alloc] init];
    _nickName.textAlignment = NSTextAlignmentCenter;
    _nickName.font = [UIFont systemFontOfSize:13];
    _nickName.textColor = [UIColor whiteColor];
//    _nickName.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_nickName];
}

- (void)config:(LiveUser *)dic
{
    _nickName.text = dic.userName;
    

//    NSInteger width = 60;

    NSString *logo = dic.userLogo;
    if(logo.length == 0)
    {
        _headIcon.image = [UIImage imageNamed:@"default_head"];
    }
    else
    {
        [_headIcon sd_setImageWithURL:[NSURL URLWithString:[NSString faceURLString:logo]] placeholderImage:[UIImage imageWithColor:RGB16(COLOR_FONT_WHITE) andSize:_headIcon.frame.size]];
    }
    
}

- (void)relayoutFrameOfSubViews
{
//    CGSize size = self.contentView.bounds.size;
    
    CGRect rect = self.contentView.bounds;
    
    rect.origin.y = rect.size.height - 24;
    rect.size.height = 24;

    _nickName.frame = rect;
    
    CGRect headRect = self.contentView.bounds;
    headRect.size.height -= 24;
    _headIcon.frame = CGRectInset(headRect, (headRect.size.width - 60)/2, (headRect.size.height - 60)/2);
    
//    size.width -= 10;
//    
//    [_headIcon sizeWith:CGSizeMake(size.width, size.width)];
//    _headIcon.layer.cornerRadius = size.width/2;
//    [_headIcon alignParentTopWithMargin:5];
//    [_headIcon layoutParentHorizontalCenter];
//    
//    [_nickName sizeWith:CGSizeMake(size.width, size.height - size.width - 5 * 3)];
//    [_nickName layoutBelow:_headIcon margin:5];
//    [_nickName layoutParentHorizontalCenter];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}
@end


@interface AudiencePanelSectionHeader : UICollectionReusableView
{
@protected
    UILabel *_headerTitle;
}

- (void)config:(NSString *)title;

@end

@implementation AudiencePanelSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _headerTitle = [[UILabel alloc] init];
        _headerTitle.textColor = [UIColor whiteColor];
        _headerTitle.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_headerTitle];
    }
    return self;
}

- (void)config:(NSString *)title
{
    _headerTitle.text = title;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _headerTitle.frame = self.bounds;
}

@end

@implementation AudiencePanel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = RGBAColor(80, 80, 80, 0.8);
        [self addSubview:_contentView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_contentView addSubview:_titleLabel];
        
        _msgView = [[UIButton alloc] init];
        [_msgView setImage:[UIImage imageNamed:@"invite_msg"] forState:UIControlStateNormal];
        [_msgView setImage:[UIImage imageNamed:@"invite_msg_selected"] forState:UIControlStateSelected];
        [_msgView addTarget:self action:@selector(onShowMsg:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_msgView];
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:_line];
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(70, 100);
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.headerReferenceSize = CGSizeMake(self.bounds.size.width, 20);

        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[AudiencePanelCell class] forCellWithReuseIdentifier:@"AudiencePanelCell"];
        [_collectionView registerClass:[AudiencePanelSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AudiencePanelSectionHeader"];
    
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_contentView addSubview:_collectionView];
        
        _contentView.layer.cornerRadius = 8;
        _contentView.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBackground:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint tp = [touch locationInView:self];
    return !CGRectContainsPoint(_contentView.frame, tp);
}

- (void)onClickBackground:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [self onShowMsg:nil];
    }
}

- (void)onShowMsg:(UIButton *)bnt
{
    if ([_delegate respondsToSelector:@selector(onHidePanel:)])
    {
        [_delegate onHidePanel:self];
    }
}
- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)onClose
{
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect rect = self.frame;
//        CGRect superRect = self.superview.bounds;
//        self.frame = CGRectMake(rect.origin.x, superRect.origin.y + superRect.size.width, rect.size.width, rect.size.height);
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    [self onShowMsg:_msgView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGRect rect = self.bounds;
//    _contentView.frame = rect;
    
    CGRect rect = _contentView.bounds;
    
    CGRect titleRect = rect;
    titleRect.size.height = 50;
    
    CGRect lineRect = titleRect;
    lineRect.origin.y += titleRect.size.height;
    lineRect.size.height = 1;
    _line.frame = CGRectInset(lineRect, 8, 0);
    
    titleRect = CGRectInset(titleRect, 8, 8);
    titleRect.size.width -= 58;
    _titleLabel.frame = titleRect;
    
    titleRect.origin.x += titleRect.size.width + 8;
    titleRect.size.width = 50;
    _msgView.frame = titleRect;

    _collectionView.frame = CGRectMake(rect.origin.x, lineRect.origin.y + lineRect.size.height + 8, rect.size.width, rect.size.height - (lineRect.origin.y + lineRect.size.height + 8));
}

- (void)config:(NSArray *)audienceList
{
    // 取出互动观众
    // 取出普通观众
    CGRect rect = self.frame;
    rect = CGRectInset(rect, 20, 0);
    if (!audienceList.count)
    {
        
        rect = CGRectInset(rect, 0, (rect.size.height - rect.size.width)/2);
        _contentView.frame = rect;
        return;
    }
    
    _audienceDictionary = [NSMutableDictionary dictionary];
    
    const NSInteger colCount = (rect.size.width - 8 - 8)/(70 + 5);
    
    NSInteger height = 50 + 8 + 8;
    
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:audienceList];
    NSMutableArray *inviteUsers = [NSMutableArray array];
    for (LiveUser *lu in array)
    {
        if (lu.isInvited)
        {
            [inviteUsers addObject:lu];
        }
        
    }
    
    if (inviteUsers.count)
    {
        
        [_audienceDictionary setObject:inviteUsers forKey:@"互动观众"];
        
        
        NSInteger row = inviteUsers.count % colCount == 0 ? inviteUsers.count / colCount : inviteUsers.count / colCount + 1;
        height += row * (100 + 5) + 20;
    }
    
    [array removeObjectsInArray:inviteUsers];
    if (array.count)
    {
        NSMutableArray *norArray = [NSMutableArray arrayWithArray:array];
        
        NSInteger row = norArray.count % colCount == 0 ? norArray.count / colCount : norArray.count / colCount + 1;
        height += row * (100 + 5) + 20;
        [_audienceDictionary setObject:norArray forKey:@"普通观众"];
    }
    
    
    
    [_collectionView reloadData];
    
    if (height > rect.size.height * 3 / 5)
    {
        height = rect.size.height * 3 / 5;
    }
    
    rect = CGRectInset(rect, 0, (rect.size.height - height)/2);
    _contentView.frame = rect;
    [self layoutSubviews];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _audienceDictionary.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *allKeys = [_audienceDictionary allKeys];
    NSArray *values = _audienceDictionary[allKeys[section]];
    return values.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AudiencePanelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AudiencePanelCell" forIndexPath:indexPath];
    NSArray *allKeys = [_audienceDictionary allKeys];
    NSArray *values = _audienceDictionary[allKeys[indexPath.section]];
    
    LiveUser *dic = values[indexPath.row];
    [cell config:dic];
    
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    AudiencePanelSectionHeader *headerView = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AudiencePanelSectionHeader" forIndexPath:indexPath];
    }
    
    NSArray *allKeys = [_audienceDictionary allKeys];
    NSArray *values = _audienceDictionary[allKeys[indexPath.section]];
    [headerView config:[NSString stringWithFormat:@"  %@（%lu）",  allKeys[indexPath.section], (unsigned long)values.count]];
    
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *allKeys = [_audienceDictionary allKeys];
    NSArray *values = _audienceDictionary[allKeys[indexPath.section]];
    LiveUser *dic = values[indexPath.row];
    
 
    
    
    BOOL isClose = YES;
    if([_delegate respondsToSelector:@selector(onClickPanel:userInfo:isNormal:)])
    {
        isClose = [_delegate onClickPanel:self userInfo:dic isNormal:[dic isNormal]];
        
    }
    if (isClose)
    {
        [self onClose];
    }

}



@end
