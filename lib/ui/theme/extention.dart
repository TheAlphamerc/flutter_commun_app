part of 'theme.dart';

extension TextStyleHelpers on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get white => copyWith(color: Colors.white);
  TextStyle primary(context) => copyWith(color: Theme.of(context).primaryColor);
  TextStyle onPrimary(context) =>
      copyWith(color: Theme.of(context).colorScheme.onPrimary);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle size(double value) => copyWith(fontSize: value);
}

extension PaddingHelper on Widget {
  Padding get p16 => Padding(padding: EdgeInsets.all(16), child: this);

  /// Set all side padding according to `value`
  Padding p(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  /// Set all side padding according to `value`
  Padding pH(double value) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);

  Padding pV(double value) =>
      Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);

  /// Horizontal Padding 16
  Padding get hP4 =>
      Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: this);
  Padding get hP8 =>
      Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: this);
  Padding get hP16 =>
      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: this);

  /// Vertical Padding 16
  Padding get vP16 =>
      Padding(padding: EdgeInsets.symmetric(vertical: 16), child: this);
  Padding get vP8 =>
      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: this);
  Padding get vP12 =>
      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: this);
  Padding get vP4 =>
      Padding(padding: EdgeInsets.symmetric(vertical: 4), child: this);

  ///Horrizontal Padding for Title
  Padding get hP30 =>
      Padding(padding: EdgeInsets.only(left: 30.0), child: this);

  ///Facebook/Google logo text Padding Helper
  Padding get vP5 =>
      Padding(padding: EdgeInsets.only(bottom: 5.5), child: this);

  /// Set right side padding according to `value`
  Padding pR(double value) =>
      Padding(padding: EdgeInsets.only(right: value), child: this);

  /// Set left side padding according to `value`
  Padding pL(double value) =>
      Padding(padding: EdgeInsets.only(left: value), child: this);

  /// Set Top side padding according to `value`
  Padding pT(double value) =>
      Padding(padding: EdgeInsets.only(top: value), child: this);

  /// Set bottom side padding according to `value`
  Padding pB(double value) =>
      Padding(padding: EdgeInsets.only(bottom: value), child: this);
}

extension Extended on Widget {
  Expanded get extended => Expanded(
        child: this,
      );
}

extension CornerRadius on Widget {
  ClipRRect get circular => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        child: this,
      );
  ClipRRect cornerRadius(double value) => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(value)),
        child: this,
      );
}

extension OnPressed on Widget {
  Widget ripple(Function onPressed,
          {BorderRadiusGeometry borderRadius =
              const BorderRadius.all(Radius.circular(5))}) =>
      Stack(
        children: <Widget>[
          this,
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: FlatButton(
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                onPressed: () {
                  if (onPressed != null) {
                    onPressed();
                  }
                },
                child: Container()),
          )
        ],
      );
}

extension ExAlignment on Widget {
  Widget get alignTopCenter => Align(
        child: this,
        alignment: Alignment.topCenter,
      );
  Widget get alignTopLeft => Align(
        child: this,
        alignment: Alignment.topLeft,
      );
  Widget get alignTopRight => Align(
        child: this,
        alignment: Alignment.topRight,
      );
  Widget get alignCenter => Align(
        child: this,
        alignment: Alignment.center,
      );

  Widget get alignCenterRight => Align(
        child: this,
        alignment: Alignment.centerRight,
      );
  Widget get alignBottomCenter => Align(
        child: this,
        alignment: Alignment.bottomCenter,
      );
  Widget get alignBottomLeft => Align(
        child: this,
        alignment: Alignment.bottomLeft,
      );
  Widget get alignBottomRight => Align(
        child: this,
        alignment: Alignment.bottomRight,
      );
}

extension StringHelper on String {
  String takeOnly(int value) {
    if (this != null && this.length >= value) {
      return this.substring(0, value);
    } else {
      return this;
    }
  }
}

extension ThemeHelper on BuildContext {
  ThemeData get theme => Theme.of(this);
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;
  TextTheme get textTheme => Theme.of(this).textTheme;
  Color get bodyTextColor => Theme.of(this).textTheme.bodyText1.color;
  Color get disabledColor => Theme.of(this).disabledColor;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  ThemeType get themeType => Theme.of(this).brightness == Brightness.light
      ? ThemeType.LIGHT
      : ThemeType.DARK;
}

extension NavigationHelper on BuildContext {
  NavigatorState get navigate => Navigator.of(this);
}

extension SizeHelper on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}

extension ListHelper<T> on List<T> {
  Option<List<T>> get value {
    if (this != null && this.isNotEmpty) {
      return some(this);
    } else {
      return none();
    }
  }

  bool get notNullAndEmpty => this != null && this.isNotEmpty;
}

extension ApplocalisationHelper on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this);
}
