//
//  KSVideoPlayerLiteView.m
//  kinsun
//
//  Created by kinsun on 2018/12/10.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSVideoPlayerLiteView.h"
#import "KSLayout.h"

@interface KSVideoPlayerLiteView ()

@property (nonatomic, weak, readonly) KSVideoLayer *player;
@property (nonatomic, assign, getter=playerIsInView, readonly) BOOL playerInView;

@end

@implementation KSVideoPlayerLiteView {
    BOOL _isHiddenAnimating;
}
@synthesize player = _player;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didChangedPlayerSuperLayer:) name:KSVideoLayerDidChangedNotification object:nil];
    }
    return self;
}

- (void)initView {
    _videoGravity = KSVideoLayerGravityResizeAspect;
    _volume = 1.f;
    self.backgroundColor = UIColor.blackColor;
    self.clipsToBounds = YES;
    
    UIImageView *coverView = [[UIImageView alloc] init];
    coverView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:coverView];
    _coverView = coverView;
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.imageView.contentMode = UIViewContentModeCenter;
    [playButton setImage:[UIImage imageNamed:@"icon_video_play"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"icon_video_pause"] forState:UIControlStateSelected];
    [playButton addTarget:self action:@selector(_clikeCenterButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playButton];
    _playButton = playButton;
    
    [self addTarget:self action:@selector(_didClickVideo) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGSize size = bounds.size;
    _coverView.frame = bounds;
    k_creatFrameElement;
    k_creatSizeElementOfSize(size);
    
    CGSize k_size = [_playButton sizeThatFits:size];
    viewW = k_size.width; viewH = k_size.height;
    viewX = (windowWidth-viewW)*0.5f; viewY = (windowHeight-viewH)*0.5f;
    k_settingFrame(_playButton);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (self.playerIsInView) {
        _player.frame = layer.bounds;
    }
}

- (void)settingToolsViewHidden:(BOOL)hidden {
    if (hidden != _playButton.hidden) {
        _playButton.hidden = hidden;
        CATransition *fade = [CATransition animation];
        fade.duration = 0.4f;
        fade.type = kCATransitionFade;
        [_playButton.layer addAnimation:fade forKey:nil];
    }
    if (_playButton.selected && !hidden && !_isHiddenAnimating) {
        _isHiddenAnimating = YES;
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf _autoHiddenTools];
        });
    }
}

- (void)_autoHiddenTools {
    _isHiddenAnimating = NO;
    if (_playButton.selected)
        [self settingToolsViewHidden:YES];
}

- (void)_clikeCenterButton:(UIButton *)btn {
    if (btn.selected) {
        [self pause];//暂停
    } else {
        [self play];//播放
    }
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    _playerItem = playerItem;
    [self _resetViewStatus];
}

- (void)_didChangedPlayerSuperLayer:(NSNotification *)noti {
    KSVideoLayer *player = noti.object;
    if (player == _player && player.superlayer != self.layer) {
        [self _resetViewStatus];
    }
}

- (void)_resetViewStatus {
    [self pause];
//    _playButton.selected = NO;
//    _playButton.hidden = NO;
    _coverView.hidden = NO;
}

- (void)play {
    if (_playerItem != nil && !_playButton.selected) {
        _coverView.hidden = YES;
        _playButton.selected = YES;
        CALayer *layer = self.layer;
        KSVideoLayer *player = self.player;
        if (player.superlayer != layer) {
            [layer insertSublayer:player atIndex:0];
            [layer setNeedsLayout];
            player.videoGravity = _videoGravity;
            player.volume = _volume;
            __weak typeof(self) weakSelf = self;
            [player setVideoPlaybackFinished:^{
                [weakSelf _resetViewStatus];
                void (^videoPlaybackFinished)(void) = self.videoPlaybackFinished;
                if (videoPlaybackFinished != nil) {
                    videoPlaybackFinished();
                }
            }];
            [NSNotificationCenter.defaultCenter postNotificationName:KSVideoLayerDidChangedNotification object:player];
        }
        player.playerItem = _playerItem;
        [self settingToolsViewHidden:NO];
    }
}

- (void)pause {
    if (self.playerIsInView) {
        [_player pause];
    }
    _playButton.selected = NO;
    [self settingToolsViewHidden:NO];
}

- (BOOL)playerIsInView {
    return _player != nil && _player.superlayer == self.layer;
}

- (KSVideoLayer *)player {
    if (_player == nil) {
        _player = [KSVideoLayer shareInstance];
    }
    return _player;
}

- (BOOL)isPlaying {
    return _playButton.selected;
}

- (void)_didClickVideo {
    if (_playButton.selected)
        [self settingToolsViewHidden:!_playButton.hidden];
}

- (void)dealloc {
    if (self.playerIsInView) {
        [_player resetPlayer];
    }
    [NSNotificationCenter.defaultCenter removeObserver:self name:KSVideoLayerDidChangedNotification object:nil];
}

@end
