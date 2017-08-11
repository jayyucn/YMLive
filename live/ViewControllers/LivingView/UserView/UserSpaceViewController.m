//
//  OnlineUserView.m
//  qianchuo 用户详情
//
//  Created by jacklong on 16/3/7.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "UserSpaceViewController.h"
#import "UIImage+Category.h"  
#import "LiveAlertView.h"
#import "HomeUserInfoViewController.h"

#define COLOR_HEAD      0x30000000
#define COLOR_HEAD_BG   0x6fffffff
#define CIRCLE_LINE     0x50000000

#define PROMPT_ALL_OPERTE    ESLocalizedString(@"管理")
#define REPORT_ITEM          ESLocalizedString(@"举报")
#define GAG_ITEM             ESLocalizedString(@"禁言")
#define UN_GAG_ITEM          ESLocalizedString(@"解除禁言")
#define MANAGER_ADD_ITEM     ESLocalizedString(@"设为管理")
#define MANAGER_LIST_ITEM    ESLocalizedString(@"管理员列表")

#define USER_INFO_HEIGHT     190

@interface UserSpaceViewController()<UIActionSheetDelegate>
{
    BOOL isBlackUser;
//    UIView *bgView;
    int userInfoHeight;
    BOOL isAddAttentRequest;
    BOOL isRequesstUserDetailInfo;
    
    
    UIView      *_dispalyArea;
    
#pragma mark - 用户头像模块
    UIView      *_headLineView;
    UIImageView *_headBgImageView;
    UIImageView *_headImageView;
    UIImageView *_gradeFlagImgView;
    
    UIView      *_userAllView;
    
    UIView      *_userShowView;
    
#pragma mark - 用户详情模块
    UIImageView             *_userInfoView;
    UIVisualEffectView      *_effectview;
    UIView                  *_userInfocontentView;
    UIButton                *_controlViewBtn;
    UIButton                *_operateUserBtn;
    UIButton                *_playStateBtn;// 直播状态
    UIButton                *_upMikeBtn;// 上麦
    
    UIImageView             *_topUserBgHeadImageView;
    UIImageView             *_topUserHeadImageView;
//    UIImageView             *_topGradeFlagImgView;
    
    UIImageView             *_circleImageView;
    UILabel                 *_nickNameLabel;
    UILabel                 *_userIDLabel;
    UIImageView             *_sexImage;
    UILabel                 *_userGradeLabel;
    UIImageView             *_userLevelImg;
    UILabel     *_locationLabel;
    UILabel     *_certificationLabel;
    UILabel     *_userSignatureLabel;
    
#pragma mark - 用户粉丝模块
    MeFollowSegView *_detailFollowSegView;
    UIView       *_detailFansView;
    UIButton     *_attentLabelBtn;
    UIButton     *_fansLabelBtn;
    UIButton     *_reciverLabelBtn;
    
#pragma mark - 用户列表模块
    LiveUserDetailScrollView    *_userListScrollView;
    
#pragma mark - 用户底部模块
    UIView      *_bottomView;
    
#pragma mark 用户送出钻石
    UILabel     *_sendDiamondLabel;
    
    UIView      *_lineEndView;
    UIButton    *_attentBtn;
    UIView      *_oneLineView;
    UIButton    *_privChatBtn;
    UIView      *_twoLineView;
    UIButton    *_reviewBtn;
    UIView      *_threeLineView;
    UIButton    *_showHomePageBtn;
    UIButton    *_blackUserBtn;
    NSMutableDictionary *userInfoDict;
    STPopupController* popupController;
}

@end;

@implementation UserSpaceViewController

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.contentSizeInPopup = CGSizeMake(SCREEN_WIDTH - 60, ONLINE_USER_HEIGTH);
    }
    return self;
}

- (STPopupController *)preferredPopupController
{
    STPopupController *popup = [super preferredPopupController];
    popupController = popup;
    popup.navigationBarHidden = YES;
    popup.tapBackgroundViewToDismiss = YES;
    popup.containerView.backgroundColor = [UIColor clearColor];
    return popup;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isShowBg) {
        self.popupController.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    } else {
        self.popupController.backgroundView.backgroundColor = [UIColor clearColor];
    }
    
    _dispalyArea = self.view;
    _dispalyArea.userInteractionEnabled=YES;
    _dispalyArea.backgroundColor = [UIColor clearColor];
    
    _userAllView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, _dispalyArea.width, _dispalyArea.height- 20)];
    _userAllView.backgroundColor = [UIColor clearColor];
    [_dispalyArea addSubview:_userAllView];
    
    _userShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, _dispalyArea.width, _dispalyArea.height-25)];
    _userShowView.backgroundColor = [UIColor whiteColor];
    
    UIBezierPath *showPath = [UIBezierPath bezierPathWithRoundedRect:_userShowView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *showLayer = [[CAShapeLayer alloc] init];
    showLayer.frame = _userShowView.bounds;
    showLayer.path = showPath.CGPath;
    _userShowView.layer.mask = showLayer;
    
    [_dispalyArea addSubview:_userShowView];
    
    
    _headBgImageView = [[UIImageView alloc] init];
    _headBgImageView.center = CGPointMake(_dispalyArea.width/2-35.f, 0);
    _headBgImageView.size = CGSizeMake(70.f, 70.f);
    // 圆形背景
    _headBgImageView.layer.borderWidth = 0.5f;
    _headBgImageView.layer.borderColor = RGBA16(CIRCLE_LINE).CGColor;
    _headBgImageView.layer.cornerRadius = _headBgImageView.frame.size.width/2;
    _headBgImageView.clipsToBounds = YES;
    _headBgImageView.image = [UIImage createImageWithColor:RGBA16(COLOR_HEAD_BG)];
    [_dispalyArea addSubview:_headBgImageView];
    
//    NSLog(@"%@",NSStringFromCGPoint(_headBgImageView.center));
//    NSLog(@"%@",NSStringFromCGRect(_userAllView.frame));
    _headImageView = [[UIImageView alloc] init];
    _headImageView.size = CGSizeMake(60.f, 60.f);
    _headImageView.center = CGPointMake(_headBgImageView.centerX,_headBgImageView.centerY);
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2;
    _headImageView.clipsToBounds = YES;
    _headImageView.image = [UIImage imageNamed:@"default_head"];
    [_dispalyArea addSubview:_headImageView];
    
    
    UIImage *gradeFlagImg = [UIImage imageNamed:@"image/yonghu/grade_flag/grade_flag_1"];
    _gradeFlagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_headImageView.right - gradeFlagImg.size.width, _headImageView.bottom - gradeFlagImg.size.height+2, gradeFlagImg.size.width, gradeFlagImg.size.height)];
    _gradeFlagImgView.image = gradeFlagImg;
    [_dispalyArea addSubview:_gradeFlagImgView];
    _gradeFlagImgView.hidden = YES;

    
    UIImage * closeImage = [UIImage imageNamed:@"image/liveroom/room_pop_up_shut"];
    _controlViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_controlViewBtn setBackgroundImage:closeImage
                               forState:UIControlStateNormal];
    
    _controlViewBtn.frame=CGRectMake(_dispalyArea.width-closeImage.size.width/2-10, _userShowView.top+15, closeImage.size.width/2,closeImage.size.height/2);
    [_controlViewBtn addTarget:self action:@selector(controlViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dispalyArea addSubview:_controlViewBtn];
    
    _playStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playStateBtn.frame=CGRectMake(_dispalyArea.width-80, _controlViewBtn.bottom+5, 80,40);
    _playStateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _playStateBtn.titleLabel.textColor = [UIColor whiteColor];
    _playStateBtn.titleLabel.shadowColor = [UIColor darkGrayColor];
    _playStateBtn.titleLabel.shadowOffset = CGSizeMake(0, -.5);
    [_playStateBtn addTarget:self action:@selector(onChangeRoomAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dispalyArea addSubview:_playStateBtn];
    _playStateBtn.hidden = YES;
    
    _upMikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _upMikeBtn.frame=CGRectMake(_dispalyArea.width-80, _controlViewBtn.bottom+5, 80,40);
    _upMikeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _upMikeBtn.titleLabel.textColor = [UIColor whiteColor];
    _upMikeBtn.titleLabel.shadowColor = [UIColor darkGrayColor];
    _upMikeBtn.titleLabel.shadowOffset = CGSizeMake(0, -.5);
    _upMikeBtn.titleLabel.text = @"邀请上麦";
    [_upMikeBtn setTitle:@"邀请上麦" forState:UIControlStateNormal];
    [_upMikeBtn addTarget:self action:@selector(onInviteUserUpMikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dispalyArea addSubview:_upMikeBtn];
    _upMikeBtn.hidden = YES;
    
    _headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _dispalyArea.width, 10)];
    _headLineView.backgroundColor = ColorPink;
    UIBezierPath *headLinePath = [UIBezierPath bezierPathWithRoundedRect:_headLineView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *headLayer = [[CAShapeLayer alloc] init];
    headLayer.frame = _headLineView.bounds;
    headLayer.path = headLinePath.CGPath;
    _userAllView.layer.mask = headLayer;
    [_userAllView addSubview:_headLineView];
    
    
    _userInfoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _dispalyArea.width, USER_INFO_HEIGHT)];
    [_userShowView addSubview:_userInfoView];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    _effectview.frame = CGRectMake(0, 0, _dispalyArea.width, USER_INFO_HEIGHT);
    [_userInfoView addSubview:_effectview];
    
    _userInfocontentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _dispalyArea.width, USER_INFO_HEIGHT)];
    [_userInfoView addSubview:_userInfocontentView];
    
    _operateUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_operateUserBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [_operateUserBtn setTitle:ESLocalizedString(@"管理") forState:UIControlStateNormal];
    [_operateUserBtn setTitleColor:ColorPink forState:UIControlStateNormal];
    _operateUserBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _operateUserBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _operateUserBtn.frame=CGRectMake(0,_userShowView.top+15, 40, 20);
    [_operateUserBtn addTarget:self action:@selector(operaAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dispalyArea addSubview:_operateUserBtn];
    _operateUserBtn.hidden = YES;
    
    
    
    if ([LCMyUser mine].showManager) {
        UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [resetButton setTitle:@"重置" forState:UIControlStateNormal];
        [resetButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [resetButton sizeToFit];
        resetButton.center = CGPointMake(_headImageView.center.x + 80, _headImageView.center.y);
        [_dispalyArea addSubview:resetButton];
        [resetButton addTarget:self action:@selector(onReset) forControlEvents:UIControlEventTouchUpInside];
    }

    
    _topUserBgHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_headBgImageView.left - 60, 15+_controlViewBtn.height, 40.f, 40.f)];
    // 圆形背景
    _topUserBgHeadImageView.layer.borderWidth = 0.5f;
    _topUserBgHeadImageView.layer.borderColor = RGBA16(CIRCLE_LINE).CGColor;
    _topUserBgHeadImageView.layer.cornerRadius = _topUserBgHeadImageView.frame.size.width/2;
    _topUserBgHeadImageView.clipsToBounds = YES;
    _topUserBgHeadImageView.image = [UIImage createImageWithColor:RGBA16(COLOR_HEAD_BG)];
    [_userInfocontentView addSubview:_topUserBgHeadImageView];
    
    _topUserHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_headBgImageView.left - 57, _operateUserBtn.bottom, 35.f, 35.f)];
    _topUserHeadImageView.center = CGPointMake(_topUserBgHeadImageView.centerX, _topUserBgHeadImageView.centerY);
    _topUserHeadImageView.layer.cornerRadius = _topUserHeadImageView.frame.size.width/2;
    _topUserHeadImageView.clipsToBounds = YES;
    _topUserHeadImageView.image = [UIImage imageNamed:@"default_head"];
    [_userInfocontentView addSubview:_topUserHeadImageView];
    
    _circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_topUserBgHeadImageView.right+10, _topUserBgHeadImageView.top, 8, 8)];
    _circleImageView.layer.borderWidth = 1;
    _circleImageView.layer.borderColor = RGBA16(CIRCLE_LINE).CGColor;
    _circleImageView.layer.cornerRadius = _circleImageView.frame.size.width/2;
    _circleImageView.clipsToBounds = YES;
    _circleImageView.image = [UIImage createImageWithColor:RGBA16(COLOR_HEAD_BG)];
    [_userInfocontentView addSubview:_circleImageView];
    
    _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20.f)];
    _nickNameLabel.textColor = [UIColor whiteColor];
    _nickNameLabel.shadowColor = [UIColor darkGrayColor];
    _nickNameLabel.shadowOffset = CGSizeMake(0, -.5);
    _nickNameLabel.top = _topUserBgHeadImageView.bottom;
    _nickNameLabel.text = @"nickname";
    [_nickNameLabel setFont:[UIFont systemFontOfSize:14.f]];
    [_userInfocontentView addSubview:_nickNameLabel];
    
    _sexImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _sexImage.bottom = _nickNameLabel.bottom;
    _sexImage.left = _nickNameLabel.right;
    [_userInfocontentView addSubview:_sexImage];
    
    _userLevelImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    _userLevelImg.bottom = _nickNameLabel.bottom;
    [_userInfocontentView addSubview:_userLevelImg];
    _userLevelImg.hidden = YES;
    
    _userGradeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _userGradeLabel.bottom = _nickNameLabel.bottom;
    _userGradeLabel.textColor = [UIColor whiteColor];
    _userGradeLabel.font = [UIFont systemFontOfSize:12];
    [_userInfocontentView addSubview:_userGradeLabel];
    _userGradeLabel.hidden = YES;
    
    _userIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _nickNameLabel.bottom, _dispalyArea.width - 20, 20)];
    _userIDLabel.textAlignment = NSTextAlignmentCenter;
    _userIDLabel.textColor = [UIColor whiteColor];
    _userIDLabel.shadowColor = [UIColor darkGrayColor];
    _userIDLabel.shadowOffset = CGSizeMake(0, -.5);
    [_userIDLabel setFont:[UIFont systemFontOfSize:12.f]];
    [_userInfocontentView addSubview:_userIDLabel];
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _userIDLabel.bottom, _dispalyArea.width - 20, 20.f)];
    _locationLabel.textAlignment = NSTextAlignmentCenter;
    _locationLabel.textColor = [UIColor whiteColor];
    _locationLabel.shadowColor = [UIColor darkGrayColor];
    _locationLabel.shadowOffset = CGSizeMake(0, -.5);
    [_locationLabel setFont:[UIFont systemFontOfSize:10.f]];
    [_userInfocontentView addSubview:_locationLabel];
    
    _certificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _locationLabel.bottom, _dispalyArea.width - 20, 20.f)];
    _certificationLabel.textAlignment = NSTextAlignmentCenter;
    _certificationLabel.textColor = [UIColor yellowColor];
    [_certificationLabel setFont:[UIFont systemFontOfSize:11.f]];
    [_userInfocontentView addSubview:_certificationLabel];
    
    _userSignatureLabel =  [[UILabel alloc] initWithFrame:CGRectMake(20, _certificationLabel.bottom, _dispalyArea.width - 40, 20.f)];
    _userSignatureLabel.textAlignment = NSTextAlignmentCenter;
    _userSignatureLabel.textColor = [UIColor whiteColor];
    _userSignatureLabel.shadowColor = [UIColor darkGrayColor];
    _userSignatureLabel.shadowOffset = CGSizeMake(0, -.5);
    [_userSignatureLabel setFont:[UIFont systemFontOfSize:10.f]];
    _userSignatureLabel.numberOfLines = 2;
    [_userInfocontentView addSubview:_userSignatureLabel];
    
    // 关注和粉丝人数
    _detailFansView = [[UIView alloc] initWithFrame:CGRectMake(0, _userInfoView.bottom, _dispalyArea.width, 10.f)];
    [_dispalyArea addSubview:_detailFansView];
    
    _attentLabelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _attentLabelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [_attentLabelBtn setTitle:ESLocalizedString(@"关注") forState:UIControlStateNormal];
    [_attentLabelBtn setTitleColor:ColorPink forState:UIControlStateNormal];
    _attentLabelBtn.frame=CGRectMake(0, 0, _dispalyArea.width/3,_detailFansView.height);
    [_attentLabelBtn addTarget:self action:@selector(attentListAction:) forControlEvents:UIControlEventTouchUpInside];
    [_detailFansView addSubview:_attentLabelBtn];
    
    _fansLabelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _fansLabelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [_fansLabelBtn setTitle:ESLocalizedString(@"粉丝") forState:UIControlStateNormal];
    [_fansLabelBtn setTitleColor:ColorPink forState:UIControlStateNormal];
    _fansLabelBtn.frame=CGRectMake(_dispalyArea.width/3, 0, _dispalyArea.width/3,_detailFansView.height);
    [_fansLabelBtn addTarget:self action:@selector(fansListAction:) forControlEvents:UIControlEventTouchUpInside];
    [_detailFansView addSubview:_fansLabelBtn];
    
    _reciverLabelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _reciverLabelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [_reciverLabelBtn setTitle:ESLocalizedString(@"有美币") forState:UIControlStateNormal];
    [_reciverLabelBtn setTitleColor:ColorPink forState:UIControlStateNormal];
    _reciverLabelBtn.frame=CGRectMake(_dispalyArea.width*2/3, 0, _dispalyArea.width/3,_detailFansView.height);
    [_reciverLabelBtn addTarget:self action:@selector(receiverListAction:) forControlEvents:UIControlEventTouchUpInside];
    [_detailFansView addSubview:_reciverLabelBtn];
    
    NSArray *name =  [[NSArray alloc] initWithObjects:ESLocalizedString(@"关注"),ESLocalizedString(@"粉丝"),ESLocalizedString(@"有美币"),nil];
    NSArray *detailNum =  [[NSArray alloc] initWithObjects:@"0",@"0",@"0",nil];
    _detailFollowSegView = [[MeFollowSegView alloc] initWithFrame:CGRectMake(0, _detailFansView.bottom, _dispalyArea.width, 40) andItemsName:name andItems:detailNum andSize:14 border:NO];
    _detailFollowSegView.delegate = self;
    [_dispalyArea addSubview:_detailFollowSegView];
    
    _userListScrollView = [[LiveUserDetailScrollView alloc] initWithFrame:CGRectMake(0, _detailFollowSegView.bottom, _dispalyArea.width, _dispalyArea.height - _detailFollowSegView.bottom+10)];
    _userListScrollView.segView = _detailFollowSegView;
    [_dispalyArea addSubview:_userListScrollView];
    _userListScrollView.hidden = YES;
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _userShowView.height-30.f-50.f-15, _dispalyArea.width, 50.f)];
    [_dispalyArea addSubview:_bottomView];
    
    _sendDiamondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, _dispalyArea.width, 20)];
    _sendDiamondLabel.textAlignment = NSTextAlignmentCenter;
    _sendDiamondLabel.textColor = [UIColor redColor];
    _sendDiamondLabel.text = ESLocalizedString(@"送出");
    [_sendDiamondLabel setFont:[UIFont boldSystemFontOfSize:14.f]];
    [_bottomView addSubview:_sendDiamondLabel];
    
    _lineEndView = [[UIView alloc] initWithFrame:CGRectMake(0, _sendDiamondLabel.bottom+15, _dispalyArea.width, 0.5f)];
    _lineEndView.backgroundColor = RGBA16(CIRCLE_LINE);
    [_bottomView addSubview:_lineEndView];
    _bottomView.userInteractionEnabled = YES;
    if (_isShowBg) {
        if (_isNoShowPrivChat) {
            _attentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _attentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            [_attentBtn setTitle:ESLocalizedString(@"关注") forState:UIControlStateNormal];
            [_attentBtn setTitleColor:ColorPink forState:UIControlStateNormal];
            
            _attentBtn.frame=CGRectMake(0,  _dispalyArea.height - _bottomView.height-20, _dispalyArea.width/2-0.5f, _bottomView.height-10.f);
            [_attentBtn addTarget:self action:@selector(attentAction:) forControlEvents:UIControlEventTouchUpInside];
            [_dispalyArea addSubview:_attentBtn];
            
            _oneLineView = [[UIView alloc] initWithFrame:CGRectMake(_attentBtn.right, _lineEndView.bottom +10.f, 0.5f, 20.f)];
            _oneLineView.backgroundColor = RGBA16(CIRCLE_LINE);
            [_bottomView addSubview:_oneLineView];
            
            if ([LCMyUser mine].liveType == LIVE_DOING && [LCMyUser mine].liveUserId) {
                _blackUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _blackUserBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
                [_blackUserBtn setTitle:ESLocalizedString(@"拉黑") forState:UIControlStateNormal];
                [_blackUserBtn setTitleColor:ColorPink forState:UIControlStateNormal];
                
                _blackUserBtn.frame=CGRectMake(_oneLineView.right, _attentBtn.top, _dispalyArea.width/2,_bottomView.height-10.f);
                [_blackUserBtn addTarget:self action:@selector(blackUserAction) forControlEvents:UIControlEventTouchUpInside];
                [_dispalyArea addSubview:_blackUserBtn];
            } else {
                _showHomePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _showHomePageBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
                [_showHomePageBtn setTitle:ESLocalizedString(@"主页") forState:UIControlStateNormal];
                [_showHomePageBtn setTitleColor:ColorPink forState:UIControlStateNormal];
                
                _showHomePageBtn.frame=CGRectMake(_oneLineView.right, _attentBtn.top, _dispalyArea.width/2,_bottomView.height-10.f);
                [_showHomePageBtn addTarget:self action:@selector(showUserHomeAction:) forControlEvents:UIControlEventTouchUpInside];
                [_dispalyArea addSubview:_showHomePageBtn];
            }
            
            
        } else {
            _attentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _attentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            [_attentBtn setTitle:ESLocalizedString(@"关注") forState:UIControlStateNormal];
            [_attentBtn setTitleColor:ColorPink forState:UIControlStateNormal];
            
            _attentBtn.frame=CGRectMake(0,  _dispalyArea.height - _bottomView.height-20, _dispalyArea.width/3-0.5f, _bottomView.height-10.f);
            [_attentBtn addTarget:self action:@selector(attentAction:) forControlEvents:UIControlEventTouchUpInside];
            [_dispalyArea addSubview:_attentBtn];
            
            
            _oneLineView = [[UIView alloc] initWithFrame:CGRectMake(_attentBtn.right, _lineEndView.bottom +10.f, 0.5f, 20.f)];
            _oneLineView.backgroundColor = RGBA16(CIRCLE_LINE);
            [_bottomView addSubview:_oneLineView];
            
            _privChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _privChatBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            [_privChatBtn setTitle:ESLocalizedString(@"私信") forState:UIControlStateNormal];
            [_privChatBtn setTitleColor:ColorPink forState:UIControlStateNormal];
            
            _privChatBtn.frame=CGRectMake(_oneLineView.right, _attentBtn.top, _dispalyArea.width/3-0.5f,_bottomView.height-10.f);
            [_privChatBtn addTarget:self action:@selector(privChatAction:) forControlEvents:UIControlEventTouchUpInside];
            [_dispalyArea addSubview:_privChatBtn];
            
            _twoLineView = [[UIView alloc] initWithFrame:CGRectMake(_privChatBtn.right, _lineEndView.bottom +10.f, 0.5f, 20.f)];
            _twoLineView.backgroundColor = RGBA16(CIRCLE_LINE);
            [_bottomView addSubview:_twoLineView];
            
           if ([LCMyUser mine].liveType == LIVE_DOING && [LCMyUser mine].liveUserId) {
               _blackUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
               _blackUserBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
               [_blackUserBtn setTitle:ESLocalizedString(@"拉黑") forState:UIControlStateNormal];
               [_blackUserBtn setTitleColor:ColorPink forState:UIControlStateNormal];
               
               _blackUserBtn.frame=CGRectMake(_twoLineView.right, _attentBtn.top, _dispalyArea.width/3,_bottomView.height-10.f);
               [_blackUserBtn addTarget:self action:@selector(blackUserAction) forControlEvents:UIControlEventTouchUpInside];
               [_dispalyArea addSubview:_blackUserBtn];
           } else {
               _showHomePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
               _showHomePageBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
               [_showHomePageBtn setTitle:ESLocalizedString(@"主页") forState:UIControlStateNormal];
               [_showHomePageBtn setTitleColor:ColorPink forState:UIControlStateNormal];
               
               _showHomePageBtn.frame=CGRectMake(_twoLineView.right, _attentBtn.top, _dispalyArea.width/3,_bottomView.height-10.f);
               [_showHomePageBtn addTarget:self action:@selector(showUserHomeAction:) forControlEvents:UIControlEventTouchUpInside];
               [_dispalyArea addSubview:_showHomePageBtn];
           }
        }
    } else {
        _attentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [_attentBtn setTitle:ESLocalizedString(@"关注") forState:UIControlStateNormal];
        [_attentBtn setTitleColor:ColorPink forState:UIControlStateNormal];
        
        _attentBtn.frame=CGRectMake(0,  _dispalyArea.height - _bottomView.height-20, _dispalyArea.width/4-0.5f, _bottomView.height-10.f);
        [_attentBtn addTarget:self action:@selector(attentAction:) forControlEvents:UIControlEventTouchUpInside];
        [_dispalyArea addSubview:_attentBtn];
        
        
        _oneLineView = [[UIView alloc] initWithFrame:CGRectMake(_attentBtn.right, _lineEndView.bottom +10.f, 0.5f, 20.f)];
        _oneLineView.backgroundColor = RGBA16(CIRCLE_LINE);
        [_bottomView addSubview:_oneLineView];
        
        _privChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _privChatBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [_privChatBtn setTitle:ESLocalizedString(@"私信") forState:UIControlStateNormal];
        [_privChatBtn setTitleColor:ColorPink forState:UIControlStateNormal];
        
        _privChatBtn.frame=CGRectMake(_oneLineView.right, _attentBtn.top, _dispalyArea.width/4-0.5f,_bottomView.height-10.f);
        [_privChatBtn addTarget:self action:@selector(privChatAction:) forControlEvents:UIControlEventTouchUpInside];
        [_dispalyArea addSubview:_privChatBtn];
        
        _twoLineView = [[UIView alloc] initWithFrame:CGRectMake(_privChatBtn.right, _lineEndView.bottom +10.f, 0.5f, 20.f)];
        _twoLineView.backgroundColor = RGBA16(CIRCLE_LINE);
        [_bottomView addSubview:_twoLineView];
        
        _reviewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reviewBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        //        [_reviewBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        [_reviewBtn setTitle:ESLocalizedString(@"回复") forState:UIControlStateNormal];
        [_reviewBtn setTitleColor:ColorPink forState:UIControlStateNormal];
        [_reviewBtn addTarget:self action:@selector(reviewMsgAction:) forControlEvents:UIControlEventTouchUpInside];
        _reviewBtn.frame=CGRectMake(_twoLineView.right, _attentBtn.top, _dispalyArea.width/4-0.5f, _bottomView.height-10.f);
        [_dispalyArea addSubview:_reviewBtn];
        
        _threeLineView = [[UIView alloc] initWithFrame:CGRectMake(_reviewBtn.right, _lineEndView.bottom +10.f, 0.5f, 20.f)];
        _threeLineView.backgroundColor = RGBA16(CIRCLE_LINE);
        [_bottomView addSubview:_threeLineView];
        
        if ([LCMyUser mine].liveType == LIVE_DOING && [LCMyUser mine].liveUserId) {
            _blackUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _blackUserBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            [_blackUserBtn setTitle:ESLocalizedString(@"拉黑") forState:UIControlStateNormal];
            [_blackUserBtn setTitleColor:ColorPink forState:UIControlStateNormal];
            
            _blackUserBtn.frame=CGRectMake(_threeLineView.right, _attentBtn.top, _dispalyArea.width/4,_bottomView.height-10.f);
            [_blackUserBtn addTarget:self action:@selector(blackUserAction) forControlEvents:UIControlEventTouchUpInside];
            [_dispalyArea addSubview:_blackUserBtn];
        } else {
            _showHomePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _showHomePageBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            [_showHomePageBtn setTitle:ESLocalizedString(@"主页") forState:UIControlStateNormal];
            [_showHomePageBtn setTitleColor:ColorPink forState:UIControlStateNormal];
            
            _showHomePageBtn.frame=CGRectMake(_threeLineView.right, _attentBtn.top, _dispalyArea.width/4,_bottomView.height-10.f);
            [_showHomePageBtn addTarget:self action:@selector(showUserHomeAction:) forControlEvents:UIControlEventTouchUpInside];
            [_dispalyArea addSubview:_showHomePageBtn];
        }
    }
    
    ESWeakSelf;
    _showUserDetailBlock = ^(NSDictionary *liveUserDict) {
        LiveUser *liveUser = [[LiveUser alloc] initWithPhone:liveUserDict[@"uid"] name:liveUserDict[@"nickname"] logo:liveUserDict[@"face"]];
        ESStrongSelf;
        [_self getUserDetailInfo:liveUser];
    };
    
    _userListScrollView.showUserDetailBlock = _showUserDetailBlock;
    
    [self getUserDetailInfo:_liveUser];
}

//- (void) viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    userInfoDict = nil;
//    
//    [_dispalyArea removeFromSuperview];
//}

#pragma mark - 动态改变view
- (void) layoutSubviews
{
    if (userInfoDict) {
        
        if (_dispalyArea.height == SCREEN_HEIGHT - 100)
        {
            [self showUserListLayout];
        }
        else
        {
            [self showUserInfoLayout];
        }
    }
}

- (void) viewWillLayoutSubviews
{
    if (userInfoDict) {
        
        if (_dispalyArea.height == SCREEN_HEIGHT - 100)
        {
            [self showUserListLayout];
        }
        else
        {
            [self showUserInfoLayout];
        }
    }
}

#pragma mark - 显示用户信息的布局
- (void) showUserInfoLayout
{
    UIImage *roomUserCloseImg = [UIImage imageNamed:@"image/liveroom/room_pop_up_shut"];
    [_controlViewBtn setBackgroundImage:roomUserCloseImg forState:UIControlStateNormal];
    [self updatePlayState];
    
    if (_certificationLabel.hidden && _userSignatureLabel.hidden) {
        _userInfoView.height = USER_INFO_HEIGHT - (_userSignatureLabel.height + _certificationLabel.height);
        
        _detailFansView.top = _userInfoView.bottom+40;
        _detailFollowSegView.top = _detailFansView.bottom;
        
        if ([userInfoDict[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            [self hiddenEventView];
            
            _bottomView.top = _userShowView.bottom - 50;
        } else {
            [self showEventView];
            
            _bottomView.top = _userShowView.bottom - 50 - 55;
        }
        
    } else if (_certificationLabel.hidden || _userSignatureLabel.hidden) {
        
        _userInfoView.height = USER_INFO_HEIGHT - ( _certificationLabel.height);
        
        _detailFansView.top = _userInfoView.bottom+40;
        _detailFollowSegView.top = _detailFansView.bottom;
        
        if ([userInfoDict[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            [self hiddenEventView];
            
            _bottomView.top = _userShowView.bottom - 50;
            
        } else {
            [self showEventView];
            
            _bottomView.top = _userShowView.bottom - 50 - 50;
        }
    } else {
        _userInfoView.height = USER_INFO_HEIGHT;
        
        _detailFansView.top = _userInfoView.bottom+40;
        _detailFollowSegView.top = _detailFansView.bottom;
        
        if ([userInfoDict[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            _bottomView.top = _userShowView.bottom - 50;
            
            [self hiddenEventView];
        } else {
            _bottomView.top = _userShowView.bottom - 50 - 60;
            
            [self showEventView];
        }
    }
    
    
    _attentBtn.top = _dispalyArea.height - _bottomView.height + 10;
    if (_privChatBtn) {
        _privChatBtn.top = _attentBtn.top;
    }
   
    if (_reviewBtn) {
        _reviewBtn.top = _attentBtn.top;
    }
    
    if ([LCMyUser mine].liveType == LIVE_DOING && [LCMyUser mine].liveUserId) {
        if (_blackUserBtn) {
            _blackUserBtn.top = _attentBtn.top;
        }
    } else {
        if (_showHomePageBtn) {
            _showHomePageBtn.top = _attentBtn.top;
        }
    }
   
    
    _userInfocontentView.height = _userInfoView.height;
    _effectview.height = _userInfoView.height;
    _userInfocontentView.hidden = NO;
    _userInfoView.hidden = NO;
    _headLineView.hidden = NO;
    _bottomView.hidden = NO;
    _userListScrollView.hidden = YES;
    
    UIBezierPath *showPath = [UIBezierPath bezierPathWithRoundedRect:_userShowView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *showLayer = [[CAShapeLayer alloc] init];
    showLayer.frame = _userShowView.bounds;
    showLayer.path = showPath.CGPath;
    _userShowView.layer.mask = showLayer;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_dispalyArea.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _dispalyArea.bounds;
    maskLayer.path = maskPath.CGPath;
    _dispalyArea.layer.mask = maskLayer;
}

#pragma mark - 显示用户列表的布局
- (void) showUserListLayout
{
    UIImage *roomPopImg = [UIImage imageNamed:@"image/liveroom/room_user_pop"];
    [_controlViewBtn setBackgroundImage:roomPopImg forState:UIControlStateNormal];
    _playStateBtn.hidden = YES;
    _upMikeBtn.hidden = YES;
    
    _headLineView.hidden = YES;
    _bottomView.hidden = YES;
    _showHomePageBtn.hidden = YES;
    _userListScrollView.hidden = NO;
    [self hiddenEventView];
    
    _detailFansView.top = 100;
    _detailFollowSegView.top = _detailFansView.bottom;
    _userListScrollView.top = _detailFollowSegView.bottom;
    _userListScrollView.height = _dispalyArea.height - _detailFollowSegView.bottom + 10;
    
    
    UIBezierPath *showPath = [UIBezierPath bezierPathWithRoundedRect:_userShowView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *showLayer = [[CAShapeLayer alloc] init];
    showLayer.frame = _userShowView.bounds;
    showLayer.path = showPath.CGPath;
    _userShowView.layer.mask = showLayer;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_dispalyArea.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _dispalyArea.bounds;
    maskLayer.path = maskPath.CGPath;
    _dispalyArea.layer.mask = maskLayer;
}

- (void) showEventView
{
    _attentBtn.hidden = NO;
    if (_reviewBtn) {
         _reviewBtn.hidden = NO;
    }
    
    if (_privChatBtn) {
       _privChatBtn.hidden = NO;
    }
    
    if ([LCMyUser mine].liveType == LIVE_DOING) {
        _blackUserBtn.hidden = NO;
    } else{
        _showHomePageBtn.hidden = NO;
    }
    
    
    _oneLineView.hidden = NO;
    _twoLineView.hidden = NO;
    _lineEndView.hidden = NO;
    if (_threeLineView) {
       _threeLineView.hidden = NO;
    }
    
}

- (void) hiddenEventView
{
    _attentBtn.hidden = YES;
    if (_reviewBtn) {
        _reviewBtn.hidden = YES;
    }
  
    if (_privChatBtn) {
        _privChatBtn.hidden = YES;
    }
    if ([LCMyUser mine].liveType == LIVE_DOING) {
        _blackUserBtn.hidden = YES;
    } else {
        _showHomePageBtn.hidden = YES;
    }
    
    _oneLineView.hidden = YES;
    _twoLineView.hidden = YES;
    _lineEndView.hidden = YES;
    if (_threeLineView) {
        _threeLineView.hidden = YES;
    }
}

-(void)setUserInfoDict:(NSMutableDictionary *)userInfoDetailDict
{
    userInfoDict = [NSMutableDictionary dictionaryWithDictionary:userInfoDetailDict];
    
    _userListScrollView.userInfoDict =  userInfoDict;
    
    NSString *faceString=[NSString faceURLString:userInfoDict[@"face"]];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:faceString]
                     placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    NSArray *tops = userInfoDict[@"tops"];
    if (tops && tops.count >= 1) {
        [_topUserHeadImageView sd_setImageWithURL:[NSURL URLWithString:tops[0][@"face"]]
                                 placeholderImage:[UIImage imageNamed:@"image/liveroom/live_shouhu_icon"]];
    } else {
        UIImage *shouhuImage = [UIImage imageNamed:@"image/liveroom/live_shouhu_icon"];
        _topUserHeadImageView.image = shouhuImage;
    }
    
    [_userInfoView sd_setImageWithURL:[NSURL URLWithString:faceString]
                     placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    int grade = ESIntValue(userInfoDetailDict[@"grade"]);
    if (grade > 0) {
        _gradeFlagImgView.image = [UIImage createUserGradeFlagImage:grade withIsManager:(userInfoDict[@"offical"] && [userInfoDict[@"offical"] intValue]==1)?true:false];
        _gradeFlagImgView.hidden = NO;
    } else {
        _gradeFlagImgView.hidden = YES;
    }
    
    if (userInfoDict[@"goodid"] && [userInfoDict[@"goodid"] intValue] != 0) {
        _userIDLabel.textColor = ColorPink;
        
        NSMutableAttributedString *mutableAttributedString = nil;
        NSString *goodIdInfoStr = [NSString stringWithFormat:@"d %@",userInfoDict[@"goodid"]];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:goodIdInfoStr];
        
        UIImage *goodIdImage = [UIImage imageNamed:@"image/liveroom/user_goodid"];
        
        NSTextAttachment *goodIdAttachment = [[NSTextAttachment alloc] init];
        goodIdAttachment.image = goodIdImage;
//        goodIdAttachment.image = [UIImage imageWithImage:goodIdImage scaleToSize:goodIdImage.size];
        goodIdAttachment.bounds = CGRectMake(0, -2, goodIdImage.size.width, goodIdImage.size.height);
        NSAttributedString *goodIdAttributedString = [NSAttributedString attributedStringWithAttachment:goodIdAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:goodIdAttributedString];
        _userIDLabel.attributedText = mutableAttributedString;
    } else {
        _userIDLabel.text = [NSString stringWithFormat:@"ID:%@",userInfoDict[@"uid"]];
        _userIDLabel.textColor = [UIColor whiteColor];
    }
    

    NSString *city = ESStringValue(userInfoDict[@"city"]);
    
    NSMutableAttributedString *mutableAttributedString = nil;
    NSString *locationInfoStr = [NSString stringWithFormat:@"d %@",(city&&city.length>0)?city:@"难道在火星"];
    mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:locationInfoStr];
    
    UIImage *locationImage = [UIImage imageNamed:@"image/liveroom/room_user_pop_location"];
    
    NSTextAttachment *locationAttachment = [[NSTextAttachment alloc] init];
    locationAttachment.image = locationImage;
//    locationAttachment.image = [UIImage imageWithImage:locationImage scaleToSize:locationImage.size];
    locationAttachment.bounds = CGRectMake(0, -1, locationImage.size.width, locationImage.size.height);
    NSAttributedString *locationAttributedString = [NSAttributedString attributedStringWithAttachment:locationAttachment];
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:locationAttributedString];
    _locationLabel.attributedText = mutableAttributedString;
    
    NSArray *detailNum = [[NSArray alloc] initWithObjects:userInfoDict[@"atten_total"],userInfoDict[@"fans_total"],userInfoDict[@"recv_diamond"],nil];
    [_detailFollowSegView setSelectIndex:-1];
    [_detailFollowSegView setItemsName:nil andItems:detailNum];
    
    [self updateNickNameRect];
    
    int sendDiamond;
    ESIntVal(&sendDiamond, userInfoDict[@"send_diamond"]);
    
    NSString *sendDiamondInfoStr = [NSString stringWithFormat:@"%@ %d d",ESLocalizedString(@"送出"), sendDiamond];
    mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:sendDiamondInfoStr];
    
    UIImage *diamondIcon = [UIImage imageNamed:@"image/liveroom/me_myaccount_reddiamond"];

    NSTextAttachment *diamondAttachment = [[NSTextAttachment alloc] init];
//    diamondAttachment.image = [UIImage imageWithImage:diamondIcon scaleToSize:CGSizeMake(diamondIcon.size.width, diamondIcon.size.height)];
    diamondAttachment.image = diamondIcon;
    NSAttributedString *diamondAttributedString = [NSAttributedString attributedStringWithAttachment:diamondAttachment];
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendDiamondInfoStr.length-1, 1) withAttributedString:diamondAttributedString];
    _sendDiamondLabel.attributedText = mutableAttributedString;
    
    if ([[LCMyUser mine] isAttentUser:userInfoDict[@"uid"]]) {
        [_attentBtn setTitle:ESLocalizedString(@"已关注") forState:UIControlStateNormal];
        [_attentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    } else {
        [_attentBtn setTitle:ESLocalizedString(@"关注") forState:UIControlStateNormal];
        [_attentBtn setTitleColor:ColorPink forState:UIControlStateNormal];
    }
    
    if ([LCMyUser mine].liveType == LIVE_DOING && [LCMyUser mine].liveUserId) {
        ESWeakSelf;
        [[RCIMClient sharedRCIMClient] getBlacklistStatus:userInfoDict[@"uid"] success:^(int bizStatus) {
            ESStrongSelf;
            ESDispatchOnMainThreadAsynchrony(^{
                ESStrongSelf;
                [_self updateBlackState:bizStatus];
            });
            
        } error:^(RCErrorCode status) {
            
        }];
    }
    
    NSString *tag;
    ESStringVal(&tag, userInfoDict[@"tag"]);
    if (tag && tag.length > 0)
    {
        NSMutableAttributedString *mutableAttributedString = nil;
        NSString *certInfoStr =  [NSString stringWithFormat:@"d 认证:%@",tag];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:certInfoStr];
        
        UIImage *certImage = [UIImage imageNamed:@"image/liveroom/me_renzheng"];
        
        NSTextAttachment *certAttachment = [[NSTextAttachment alloc] init];
        certAttachment.image = [UIImage imageWithImage:certImage scaleToSize:CGSizeMake(certImage.size.width/2, certImage.size.height/2-2)]; 
        certAttachment.bounds = CGRectMake(0, -2, certImage.size.width/2, certImage.size.height/2-2);
        NSAttributedString *certAttributedString = [NSAttributedString attributedStringWithAttachment:certAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:certAttributedString];
        _certificationLabel.attributedText = mutableAttributedString;
    }
    
    NSString *sign;
    ESStringVal(&sign, userInfoDict[@"signature"]);
//    sign = @"孤单寂寞冷";
    if (sign && sign.length > 0) {
        _userSignatureLabel.text = sign;
    }
    
    _locationLabel.top = _userIDLabel.bottom;
    
    if ((!tag || (tag && tag.length <= 0))  && (!sign || (sign && sign.length <= 0))) {
        if ([userInfoDict[@"uid"] isEqualToString:[LCMyUser mine].userID ]) {
           _dispalyArea.height = ONLINE_USER_HEIGTH - (_userSignatureLabel.height + _userSignatureLabel.height+_attentBtn.height);
          _userShowView.height = _dispalyArea.height - (_userSignatureLabel.height + _certificationLabel.height + _attentBtn.height*2/3)+25;
        } else {
           _dispalyArea.height = ONLINE_USER_HEIGTH - (_userSignatureLabel.height + _userSignatureLabel.height);
           _userShowView.height = _dispalyArea.height - (_userSignatureLabel.height + _certificationLabel.height)+25;
        }
        
        _userSignatureLabel.hidden = YES;
        _certificationLabel.hidden = YES;
    } else if (!tag || (tag && tag.length <= 0)){
        if ([userInfoDict[@"uid"] isEqualToString:[LCMyUser mine].userID ]) {
            _dispalyArea.height = ONLINE_USER_HEIGTH - ( _certificationLabel.height  + _attentBtn.height);
            _userShowView.height = _dispalyArea.height - (_certificationLabel.height + _attentBtn.height/2);
        } else {
            _dispalyArea.height = ONLINE_USER_HEIGTH - ( _certificationLabel.height);
            _userShowView.height = _dispalyArea.height - (_certificationLabel.height);
        }
        _userSignatureLabel.hidden = NO;
        _certificationLabel.hidden = YES;
        
        _userSignatureLabel.top = _locationLabel.bottom;
        
       [self setFitUserSignSize];
        
    } else if (!sign || (sign && sign.length <= 0)){
        if ([userInfoDict[@"uid"] isEqualToString:[LCMyUser mine].userID ]) {
            _dispalyArea.height = ONLINE_USER_HEIGTH - (_userSignatureLabel.height + _attentBtn.height);
            _userShowView.height = _dispalyArea.height - (_userSignatureLabel.height + _attentBtn.height/2);
        } else {
            _dispalyArea.height = ONLINE_USER_HEIGTH - (_userSignatureLabel.height);
            _userShowView.height = _dispalyArea.height - (_userSignatureLabel.height);
        }
       
        _userSignatureLabel.hidden = YES;
        _certificationLabel.hidden = NO;
        
        _certificationLabel.top = _locationLabel.bottom;
    } else {
        if ([userInfoDict[@"uid"] isEqualToString:[LCMyUser mine].userID ]) {
            _dispalyArea.height = ONLINE_USER_HEIGTH - _attentBtn.height;
            _userShowView.height = _dispalyArea.height - 10 - _attentBtn.height/2;
        } else {
            _dispalyArea.height = ONLINE_USER_HEIGTH - 10;
            _userShowView.height = _dispalyArea.height - 10;
        }
        
        _userSignatureLabel.top = _locationLabel.bottom;
        _certificationLabel.top = _userSignatureLabel.bottom;
        
        _userSignatureLabel.hidden = NO;
        _certificationLabel.hidden = NO;
 
        [self setFitUserSignSize];
    }

    userInfoHeight = _dispalyArea.height;
    self.contentSizeInPopup = CGSizeMake(SCREEN_WIDTH - 60, userInfoHeight);
    _dispalyArea.hidden = NO;
    
    [self operateShow];
}


#pragma mark - 更新直播显示状态
- (void) updatePlayState
{
    int isLive = ESIntValue(userInfoDict[@"is_live"]);

    NSLog(@"liveType:%d %@",(int)[LCMyUser mine].liveType,[LCMyUser mine].liveUserId);
    if (![LCCore globalCore].inviteChatUser && (isLive == 1 && (![LCMyUser mine].liveUserId
                    || ([LCMyUser mine].liveUserId && ![[LCMyUser mine].liveUserId isEqualToString:userInfoDict[@"uid"]]))
                    && ![[LCMyUser mine].userID isEqualToString:userInfoDict[@"uid"]])) {
        NSString *liveStr = @"d 正在直播";
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:liveStr];
        
        UIImage *liveIconImage = [UIImage imageNamed:@"image/liveroom/zhib"];
        
        NSTextAttachment *liveAttachment = [[NSTextAttachment alloc] init];
//        liveAttachment.image = [UIImage imageWithImage:liveIconImage scaleToSize:CGSizeMake(liveIconImage.size.width, liveIconImage.size.height)];
        liveAttachment.image = liveIconImage;
        NSAttributedString *liveAttributedString = [NSAttributedString attributedStringWithAttachment:liveAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:liveAttributedString];
        [_playStateBtn setAttributedTitle:mutableAttributedString forState:UIControlStateNormal];
        
        _playStateBtn.hidden = NO;
    } else {
        _playStateBtn.hidden = YES;
        
        if (_isInviteUpMike) {
            if (![[LCMyUser mine].liveUserId isEqualToString:userInfoDict[@"uid"]] && ![[LCMyUser mine].userID isEqualToString:userInfoDict[@"uid"]]) {
                
                _upMikeBtn.hidden = NO;
            } else {
                _upMikeBtn.hidden = YES;
            }
        } else {
            _upMikeBtn.hidden = YES;
        }
        
    }

}

#pragma mark - 更新黑名单状态
- (void) updateBlackState:(int)bizStatus
{
    if (bizStatus == 0) {
        isBlackUser = YES;
        [_blackUserBtn setTitle:ESLocalizedString(@"解除拉黑") forState:UIControlStateNormal];
        _blackUserBtn.titleLabel.text = ESLocalizedString(@"解除拉黑");
    } else {
        isBlackUser = NO;
        [_blackUserBtn setTitle:ESLocalizedString(@"拉黑") forState:UIControlStateNormal];
        _blackUserBtn.titleLabel.text = ESLocalizedString(@"拉黑");
    }

}

- (void) setFitUserSignSize
{
    CGSize signSize = [_userSignatureLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:10.f]}];
    
    if (signSize.width >= _dispalyArea.width - 40) {
        _userSignatureLabel.width =  _dispalyArea.width - 40;
        _userSignatureLabel.textAlignment = NSTextAlignmentCenter;
        _userSignatureLabel.centerX = _dispalyArea.width/2;
        [_userSignatureLabel sizeToFit];
    } else {
        _userSignatureLabel.width = signSize.width;
        _userSignatureLabel.centerX = _dispalyArea.width/2;
    }
}

#pragma mark - reset

- (void)onReset {
    ESWeakSelf;
    UIAlertView *alterView = [UIAlertView alertViewWithTitle:@"重置用户的昵称、头像、签名等信息" message:nil cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            ESStrongSelf;
            [_self requestResetUser];
        }
    } otherButtonTitles:@"确认", nil];
    [alterView show];
}

- (void)requestResetUser {
    
    if (!self.liveUser || !self.liveUser.userId) {
        return;
    }
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"liveuid":self.liveUser.userId, @"type":@(9)} //9 是重置
                                                  withPath:URL_BAN_LIVE
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:^(NSDictionary *responseDic) {
                                              [LCNoticeAlertView showClearBackgroundMsg:@"操作成功"];
                                          } withFailBlock:^(NSError *error) {
                                              [LCNoticeAlertView showClearBackgroundMsg:@"操作失败"];
                                          }];
}

#pragma mark - 关注列表 
- (void) attentListAction:(id)sender
{
    if ([_detailFollowSegView getSelectIndex] != 0)
    {
        [_detailFollowSegView setSelectIndex:0];
    }
    else
    {
        if (_detailFollowSegView.indicatorView.hidden)
        {
            [_detailFollowSegView setSelectIndex:-1];
//             [self showUserListView:0];
        }
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        _userListScrollView.scrollView.contentOffset = CGPointMake(0, 0);
    }];
    
    [_userListScrollView loadAttentData];
}

#pragma mark - 粉丝列表
- (void) fansListAction:(id)sender
{
    if ([_detailFollowSegView getSelectIndex] != 1)
    {
        [_detailFollowSegView setSelectIndex:1];
    }
    else
    {
        if (_detailFollowSegView.indicatorView.hidden)
        {
            [_detailFollowSegView setSelectIndex:-1];
//            [self showUserListView:1];
        }
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        _userListScrollView.scrollView.contentOffset = CGPointMake(_userListScrollView.scrollView.frame.size.width, 0);
    }];
    
     [_userListScrollView loadFansData];
}

#pragma mark - 收入列表
-(void) receiverListAction:(id)sender
{
    if ([_detailFollowSegView getSelectIndex] != 2) {
        [_detailFollowSegView setSelectIndex:2];
    }
    else
    {
        if (_detailFollowSegView.indicatorView.hidden) {
//            [self showUserListView:2];
            [_detailFollowSegView setSelectIndex:-1];
        }
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        _userListScrollView.scrollView.contentOffset = CGPointMake(_userListScrollView.scrollView.frame.size.width*2, 0);
    }];
    
    [_userListScrollView loadReceiverData];
}

#pragma mark - 回复
- (void) reviewMsgAction:(id)sender
{
    [self.popupController dismiss];

    if (_reViewBlock && userInfoDict) {
        _reViewBlock(userInfoDict);
    }
}

#pragma mark 关注
- (void) attentAction:(id)sender
{
    if ([[LCMyUser mine] isAttentUser:userInfoDict[@"uid"]] || !userInfoDict[@"uid"] ||[(NSString *)userInfoDict[@"uid"] isEqualToString:@""]) {
        return;
    }
     // 添加关注
    if (isAddAttentRequest) {
        return;
    }
    
    isAddAttentRequest = YES;
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic)
    {
        ESStrongSelf;
        _self->isAddAttentRequest = NO;
        NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
        if (URL_REQUEST_SUCCESS == code)
        {
            [[LCMyUser mine] addAttentUser:userInfoDict[@"uid"]];
            if (_self.attentUserBlock && userInfoDict) {
                _self.attentUserBlock(userInfoDict[@"uid"]);
            }
            
            NSArray *detailNum = [[NSArray alloc] initWithObjects:userInfoDict[@"atten_total"],@([userInfoDict[@"fans_total"]intValue] + 1),userInfoDict[@"recv_diamond"],nil];
            [_self->_detailFollowSegView setSelectIndex:-1];
            [_self->_detailFollowSegView setItemsName:nil andItems:detailNum];
            
            [_self->_attentBtn setTitle:ESLocalizedString(@"已关注") forState:UIControlStateNormal];
            [_self->_attentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        [LCNoticeAlertView showMsg:@"Error！"];
        ESStrongSelf;
        _self->isAddAttentRequest = NO;
    };
    
    NSDictionary *paramter = @{@"u":userInfoDict[@"uid"]};
//    NSLog(@"paramter %@",paramter);
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
                                                  withPath:URL_ADD_ATTENT_USER
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

#pragma mark - 显示主页
- (void) showUserHomeAction:(id)sender
{
   [self.popupController dismiss];
    
    if (_showUserHomeBlock && userInfoDict) {
        _showUserHomeBlock([NSString stringWithFormat:@"%d",[userInfoDict[@"uid"] intValue]]);
    } else {
        if (_showUserHomeBlock) {
            _showUserHomeBlock(_liveUser.userId);
        }
    }
}

#pragma mark  - 黑名单
- (void) blackUserAction
{
        if (!userInfoDict) {
            return ;
        }
        if (isBlackUser) {
            ESWeakSelf;
            [[RCIMClient sharedRCIMClient] removeFromBlacklist:userInfoDict[@"uid"] success:^{
                ESStrongSelf;
                ESDispatchOnMainThreadAsynchrony(^{
                    ESStrongSelf;
                    [_self updateBlackState:1];
                });
            } error:^(RCErrorCode status) {
                NSLog(@"blcak code:%d",(int)status);
                [LCNoticeAlertView showMsg:@"解除拉黑失败！"];
            }];
        } else {
            ESWeakSelf;
          UIAlertView *alert =  [UIAlertView alertViewWithTitle:ESLocalizedString(@"提示") message:ESLocalizedString(@"拉黑后Ta不能再私信你") cancelButtonTitle:@"取消" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    ESStrongSelf;
                    [[RCIMClient sharedRCIMClient] addToBlacklist:userInfoDict[@"uid"] success:^{
                        ESStrongSelf;
                        ESDispatchOnMainThreadAsynchrony(^{
                            ESStrongSelf;
                            [_self updateBlackState:0];
                        });
                    } error:^(RCErrorCode status) {
                        NSLog(@"blcak code:%d",(int)status);
                        [LCNoticeAlertView showMsg:@"拉黑失败！"];
                    }];
                }
            } otherButtonTitles:ESLocalizedString(@"拉黑"), nil];
            [alert show];
        }
}

#pragma mark 私信
- (void) privChatAction:(id)sender
{
    [self.popupController dismiss];
    
    if (_privateChatBlock && userInfoDict) {
        _privateChatBlock(userInfoDict);
    }
}

#pragma mark - 换房间
- (void) onChangeRoomAction:(id)sender
{
    if (_changeLiveRoomBlock && userInfoDict) {
        [self.popupController dismiss];
        
        _changeLiveRoomBlock(userInfoDict);
    }
}

#pragma mark - 邀请上麦
- (void) onInviteUserUpMikeAction:(id)sender
{
    if (_inviteUpmikeBlock && userInfoDict) {
        [self.popupController dismiss];
        
        _inviteUpmikeBlock(userInfoDict);
    }
}

#pragma mark - 控制view
- (void) controlViewAction:(id)sender
{
    if (_dispalyArea.height != (SCREEN_HEIGHT - 100))
    {
        // 重置segment
        _detailFollowSegView.indicatorView.hidden = YES;
        [_detailFollowSegView setSelectIndex:-1];
        // 关闭当前view
//        [UIView animateWithDuration:.3 animations:^{
//            _dispalyArea.top = SCREEN_HEIGHT;
//        } completion:^(BOOL finished) {
            [self.popupController dismiss];
//        }];
    }
    else
    {
        _userListScrollView.hidden = YES;
        _detailFollowSegView.indicatorView.hidden = YES;
        [_detailFollowSegView setSelectIndex:-1];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            _dispalyArea.height = userInfoHeight;
        self.contentSizeInPopup = CGSizeMake(SCREEN_WIDTH - 60, userInfoHeight);
        _userShowView.height = _dispalyArea.height - 25;
//        });
    }
}

- (void) showUserDetailView
{
    _detailFollowSegView.indicatorView.hidden = YES;
    [_detailFollowSegView setSelectIndex:-1];
    if (userInfoHeight > 0) {
        _dispalyArea.height = userInfoHeight;
        _userShowView.height = _dispalyArea.height - 25;
    }
}

#pragma mark - 操作
- (void) operaAction:(id)sender
{
    if ([_operateUserBtn.titleLabel.text isEqualToString:PROMPT_ALL_OPERTE]) { // 主播操作
        UIActionSheet *myActionSheet =nil;
        
        if ([[LCMyUser mine] isGagUser:userInfoDict[@"uid"]]) {
            myActionSheet =  [[UIActionSheet alloc]
                              initWithTitle:nil
                              delegate:self
                              cancelButtonTitle:ESLocalizedString(@"取消")
                              destructiveButtonTitle:nil
                              otherButtonTitles:UN_GAG_ITEM,MANAGER_ADD_ITEM,MANAGER_LIST_ITEM,nil];
        } else {
            myActionSheet =  [[UIActionSheet alloc]
                              initWithTitle:nil
                              delegate:self
                              cancelButtonTitle:ESLocalizedString(@"取消")
                              destructiveButtonTitle:nil
                              otherButtonTitles:GAG_ITEM,MANAGER_ADD_ITEM,MANAGER_LIST_ITEM,nil];
        }
      
        [myActionSheet showInView:self.view];
    } else if ([_operateUserBtn.titleLabel.text isEqualToString:GAG_ITEM]) {// 管理员操作
        [self gagUser];
    } else if ([_operateUserBtn.titleLabel.text isEqualToString:REPORT_ITEM]) {// 举报操作
        [[Business sharedInstance] liveReportSucc:^(NSString *msg, id data) {
            [LCNoticeAlertView showMsg:msg];
        } fail:^(NSString *error) {
            [LCNoticeAlertView showMsg:error];
        }];
    } else if ([_operateUserBtn.titleLabel.text isEqualToString:UN_GAG_ITEM]) { // 解除禁言
        [self unGagUser];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle= [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:MANAGER_ADD_ITEM]) { // 设为管理员
         [self addManagerAction];
    } else if ([buttonTitle isEqualToString:GAG_ITEM]) {// 禁言
        [self gagUser];
    } else if ([buttonTitle isEqualToString:MANAGER_LIST_ITEM]) {// 管理员列表
        [self showManagerListView];
    } else if ([buttonTitle isEqualToString:UN_GAG_ITEM]){
        [self unGagUser];
    }
}

#pragma mark  禁言操作
- (void) gagUser
{
    if (![LCMyUser mine].liveUserId || !userInfoDict) {
        return;
    }
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {

            [[LCMyUser mine] addGagUser:userInfoDict[@"uid"]];
            
            // 显示操作
            [_self operateShow];
            
            if (_self.gagUserBlock) {
                _self.gagUserBlock(userInfoDict);
            }
            
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        [LCNoticeAlertView showMsg:@"网络异常！"];
    };
    
    
    NSDictionary *parameter = @{@"user":userInfoDict[@"uid"],@"liveuid":[LCMyUser mine].liveUserId};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVE_GAG_USER
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

- (void) unGagUser
{
    if (![LCMyUser mine].liveUserId || !userInfoDict) {
        return;
    }
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {

            [[LCMyUser mine] removeGagUser:userInfoDict[@"uid"]];
            
            // 显示操作
            [_self operateShow];
            
            if (_self.unGagUserBlock) {
                _self.unGagUserBlock(userInfoDict);
            }
            
            [LCNoticeAlertView showMsg:ESLocalizedString(@"解除禁言成功！")];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        [LCNoticeAlertView showMsg:@"Error！"];
    };
    
    
    NSDictionary *parameter = @{@"user":userInfoDict[@"uid"],@"liveuid":[LCMyUser mine].liveUserId, @"type":@(1)};
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVE_GAG_USER
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


#pragma mark 添加管理员
- (void) addManagerAction
{
    if (!userInfoDict[@"uid"] || !userInfoDict) {
        return;
    }
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        if (URL_REQUEST_SUCCESS == [[responseDic objectForKey:@"stat"] integerValue])
        {
            if (_self.addManagerBlock)
            {
                _self.addManagerBlock(userInfoDict);
            }
            
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        [LCNoticeAlertView showMsg:@"Error！"];
    };
    
    
    NSDictionary *parameter = @{@"user":userInfoDict[@"uid"],@"liveuid":[LCMyUser mine].liveUserId,@"type":@"1"};
//    NSLog(@"parameter:%@",parameter);
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:parameter
                                                  withPath:URL_LIVE_OPERATE_MANAGER
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];

}

#pragma mark 显示管理员列表
- (void) showManagerListView
{
    [self.popupController dismiss];
    if(_showManagerListBlock){
        _showManagerListBlock();
    }
}


#pragma mark - segment事件
- (void)segmentView:(MeFollowSegView*)segmentView selectIndex:(NSInteger)index
{
    if (_dispalyArea.hidden)
    {
        return;
    }
    
    [self showUserListView:index];
}

#pragma mark - 显示用户列表
- (void) showUserListView:(NSInteger)index
{
    if (_detailFollowSegView.indicatorView.hidden)
    {
        _detailFollowSegView.indicatorView.hidden = NO;
    }
    
    if (index >= 0) {
        [UIView animateWithDuration:0.2f animations:^{
            _userListScrollView.scrollView.contentOffset = CGPointMake(_userListScrollView.scrollView.frame.size.width*index, 0);
        }];
        
        if (index == 0) {
            [_userListScrollView loadAttentData];
        } else if (index == 1) {
            [_userListScrollView loadFansData];
        } else if (index == 2){
            [_userListScrollView loadReceiverData];
        }
    }
   
    if (_dispalyArea.height != (SCREEN_HEIGHT - 100))
    {
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        _dispalyArea.height = SCREEN_HEIGHT - 100;
        self.contentSizeInPopup = CGSizeMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 100);
        _userShowView.height = _dispalyArea.height - 20;
        _userInfoView.height = 60;
        _userInfocontentView.hidden = YES;
        _effectview.height = _userInfoView.height;
        //        });
    }
}

#pragma CATransition动画实现
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = .5;
    
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        
        //设置子类
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}


#pragma mark - 获取用户详情
- (void) getUserDetailInfo:(LiveUser *)liveUser
{
    if (_dispalyArea.hidden
        &&  userInfoDict
        && [userInfoDict[@"uid"] isEqualToString:liveUser.userId]) {
        
    }
    else
    {
        if (!_dispalyArea.hidden) {
            if ([userInfoDict[@"uid"] isEqualToString:liveUser.userId]) {
                return;
            } else {
                
                [self showUserDetailView];
                    
                [self requestUserInfo:liveUser];
            }
        } else {
            [self requestUserInfo:liveUser];
        }
     
        _liveUser.isInRoom = liveUser.isInRoom;
        
        [self operateShow];
    }
}

- (void) requestUserInfo:(LiveUser *)liveUser
{
    if (isRequesstUserDetailInfo || !liveUser.userId) {
        return;
    }
    
    isRequesstUserDetailInfo = true;
    
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        ESStrongSelf;
        _self->isRequesstUserDetailInfo = false;
        if ([responseDic objectForKey:@"stat"]) {
            NSInteger code = [[responseDic objectForKey:@"stat"] integerValue];
            if (URL_REQUEST_SUCCESS == code)
            {
                _self.userInfoDict = responseDic[@"userinfo"];
            }
            else
            {
                if (!responseDic[@"msg"]) {
                    return;
                }
                [LCNoticeAlertView showMsg:responseDic[@"msg"]];
            }
        }
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        ESStrongSelf;
        [LCNoticeAlertView showMsg:@"Error！"];
        _self->isRequesstUserDetailInfo = false;
    };
    
    NSDictionary *paramter = @{@"u":liveUser.userId};
//    NSLog(@"paramter %@",paramter);
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:paramter
                                                  withPath:URL_LIVE_USER_DETAIL
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}


//#pragma mark 屏幕点击
//- (void) singleTap
//{
//    if (!_dispalyArea.isHidden){
//    
//        [UIView animateWithDuration:0.5f animations:^{
//            _dispalyArea.top = SCREEN_HEIGHT;
//            
//        } completion:^(BOOL finish) {
//           _dispalyArea.hidden = YES;
//            
//            [self showUserDetailView];
//            
//            [self.popupController dismiss];
//        }];
//    }
//}
//
//#pragma mark - 点击范围
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if (!_dispalyArea.hidden) {
//        CGPoint point = [touch locationInView:_dispalyArea];
//        NSLog(@"online displayArea %@",NSStringFromCGRect(_dispalyArea.frame));
//        if (point.x > 0 && point.x < _dispalyArea.frame.size.width &&
//            point.y > 0 && point.y < _dispalyArea.frame.size.height)
//        {
//            return NO;
//        }
//    }
//    return YES;
//}

#pragma mark - 操作事件
- (void) operateShow
{
    if (!_isShowBg && _liveUser.isInRoom) {// 在房间
        
        if ([userInfoDict[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            _operateUserBtn.hidden = YES;
        } else {
           _operateUserBtn.hidden = NO;
            if ([LCMyUser mine].liveType == LIVE_DOING) { // 主播
                _operateUserBtn.hidden = NO;
                [_operateUserBtn setTitle:PROMPT_ALL_OPERTE forState:UIControlStateNormal];
            } else {// 观众
                if (([LCMyUser mine].liveUserId
                     && [userInfoDict[@"uid"] isEqualToString:[LCMyUser mine].liveUserId])) {// 看的是主播
                    _operateUserBtn.hidden = NO;
                    [_operateUserBtn setTitle:REPORT_ITEM forState:UIControlStateNormal];
                } else {
                    if([LCMyUser mine].isManager || [LCMyUser mine].showManager) {// 我是管理员
                        if ([[LCMyUser mine] isGagUser:userInfoDict[@"uid"]]) { // 解除禁言
                            _operateUserBtn.hidden = NO;
                            [_operateUserBtn setTitle:UN_GAG_ITEM forState:UIControlStateNormal];
                        } else {
                            _operateUserBtn.hidden = NO;
                            [_operateUserBtn setTitle:GAG_ITEM forState:UIControlStateNormal];
                        }
                    } else {
                        _operateUserBtn.hidden = YES;
                    }
                }
            }
        }
        [_operateUserBtn sizeToFit];
    } else {
        _operateUserBtn.hidden = YES;
    }
}

#pragma mark - 更新用户等级信息
- (void) updateNickNameRect
{
    UIImage *sexImage;
    int sex = 0;
    ESIntVal(&sex, userInfoDict[@"sex"]);
    int grade = 0;
    ESIntVal(&grade, userInfoDict[@"grade"]);
    
    if(sex==1)
    {
        sexImage=[UIImage imageNamed:@"global_male"];
    }
    else
    {
        sexImage=[UIImage imageNamed:@"global_female"];
    }
    
    NSString *nickname=@"";
    ESStringVal(&nickname, userInfoDict[@"nickname"]);
    
    _nickNameLabel.text = nickname;
    _nickNameLabel.height = 20;
    
    _sexImage.image = sexImage;
    _sexImage.bottom = _nickNameLabel.bottom;
    float nameWidth = [self getNicNameWidth:nickname withFont:_nickNameLabel.font];
    
    if (nameWidth > _dispalyArea.width - 60) {
        nameWidth = _dispalyArea.width - 60;
        _sexImage.left = (_dispalyArea.width - 20)/2 + nameWidth/2-sexImage.size.width-10;
    } else {
        _sexImage.left = (_dispalyArea.width - 20)/2 + nameWidth/2 + 5;
    }
   
    _sexImage.width = sexImage.size.width;
    _sexImage.height = sexImage.size.height;
    _nickNameLabel.centerX = (_dispalyArea.width - 20)/2;
    
    if (grade > 0) {
        _userLevelImg.hidden = NO;
        _userGradeLabel.hidden = NO;
        int officalType = 0;
        if (userInfoDict[@"offical"]) {
            officalType = [userInfoDict[@"offical"] intValue];
        }
        UIImage *levelImage = [UIImage createUserGradeImage:grade withIsManager:officalType==1?true:false];
        CGFloat gradeWidth = 0;
        if (officalType != 1) {
            UIEdgeInsets insets = UIEdgeInsetsMake(0, levelImage.size.width - 10, 0, 5);
            // 伸缩后重新赋值
            levelImage = [levelImage resizableImageWithCapInsets:insets];
            gradeWidth = [self getGradeSize:grade];
        } else {
            _userGradeLabel.hidden = YES;
        }
        
        _userLevelImg.width = levelImage.size.width+gradeWidth;
        _userLevelImg.height = levelImage.size.height;
        _userLevelImg.left = _sexImage.right + 5;
        _userLevelImg.image = levelImage;
        _userLevelImg.bottom = _nickNameLabel.bottom-3;
        
        _sexImage.bottom = _userLevelImg.bottom;
        _userGradeLabel.top = _userLevelImg.top;
        _userGradeLabel.left = _userLevelImg.left+levelImage.size.width*4/5;
        _userGradeLabel.width = _userLevelImg.width;
        _userGradeLabel.height = _userLevelImg.height;
        _userGradeLabel.text = [NSString stringWithFormat:@"%d",grade];
        
        float allWidth = _dispalyArea.width - 20;
        if (nameWidth >= (allWidth - sexImage.size.width - (levelImage.size.width+gradeWidth) - 10 - 10)) {
            _nickNameLabel.width = (allWidth - sexImage.size.width - (levelImage.size.width+gradeWidth) - 10 - 10);
        } else {
            _nickNameLabel.width = nameWidth;
        }
    } else {
        _nickNameLabel.width = [self getNicNameWidth:nickname withFont:_nickNameLabel.font];
        _sexImage.bottom = _nickNameLabel.bottom-3;
        _userGradeLabel.hidden = YES;
        _userLevelImg.hidden = YES;
    }
    _nickNameLabel.centerX = (_dispalyArea.width - 20)/2;
}

- (CGFloat) getNicNameWidth:(NSString *)nickName withFont:(UIFont *)font
{
    NSMutableString *tempStr = [NSMutableString stringWithFormat:@"%@",nickName];
    CGSize size = [tempStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return size.width;
}

#pragma mark - 获取等级宽度
- (CGFloat) getGradeSize:(int)grade
{
    NSMutableString *tempStr = [NSMutableString stringWithFormat:@"%d",grade];
    CGSize size = [tempStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    
    return size.width;
}

@end
