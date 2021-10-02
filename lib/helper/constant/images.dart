import 'package:flutter_commun_app/model/community/community_model.dart';

mixin Images {
  static const String onBoardPicOne =
      'assets/image/onboard/img_welcome_one.png';
  static const String onBoardPicTwo =
      'assets/image/onboard/img_welcome_two.png';
  static const String onBoardPicFour =
      'assets/image/onboard/img_welcome_four.png';

  /// Sign Up
  static const String appleLogo = 'assets/icon/signup/apple_logo.png';
  static const String twitterLogo = 'assets/icon/signup/twitter_logo.png';
  static const String emailIconBlack = 'assets/icon/signup/email_icon.png';
  static const String facebookLogo = 'assets/icon/signup/facebook_logo.png';
  static const String googleLogo = 'assets/icon/signup/google_logo.png';
  static const String instagramLogo = 'assets/icon/signup/instagram_logo.png';
  static const String phoneIcon = 'assets/icon/signup/phone_icon.png';

  static const String defaultUser =
      'assets/image/onboard/default_profile_img.png';

  static const String circleFacebookIcon =
      "assets/icon/social/circle_facebook_icon.png";
  static const String circleInstagramIcon =
      "assets/icon/social/circle_instagram_icon.png";
  static const String circleLinkedinIcon =
      "assets/icon/social/circle_linkedin_icon.png";
  static const String circleTwitterIcon =
      "assets/icon/social/circle_twitter_icon.png";
  static const String circleYoutubeIcon =
      "assets/icon/social/circle_youtube_icon.png";
  static const String circleGithubIcon =
      "assets/icon/social/circle_github_icon.png";
  static const String circleOtherLinkIcon =
      "assets/icon/social/circle_other_link.png";

  static String getSocialCircleImage(ESocialLinkType type) {
    switch (type) {
      case ESocialLinkType.facebook:
        return circleFacebookIcon;
      case ESocialLinkType.github:
        return circleGithubIcon;
      case ESocialLinkType.instagram:
        return circleInstagramIcon;
      case ESocialLinkType.linkedin:
        return circleLinkedinIcon;
      case ESocialLinkType.twitter:
        return circleTwitterIcon;
      case ESocialLinkType.youtube:
        return circleYoutubeIcon;
      case ESocialLinkType.other:
        return circleOtherLinkIcon;

      default:
        return circleOtherLinkIcon;
    }
  }
}
