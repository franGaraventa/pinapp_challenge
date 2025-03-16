import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinapp_challenge/core/utils/colors.dart';
import 'package:pinapp_challenge/features/home/presentation/widget/like_icon.dart';

void main() {
  testWidgets('LikeIcon should display disabled icon when isEnabled is false', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: LikeIcon()),
      ),
    );

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.icon, CupertinoIcons.heart);
    expect(icon.color, Colors.black);
  });

  testWidgets('LikeIcon should display enabled icon when isEnabled is true', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LikeIcon(isEnabled: true),
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.icon, CupertinoIcons.heart_fill);
    expect(icon.color, ColorTheme.secondaryColor);
  });

  testWidgets('LikeIcon should call onTap with correct value when tapped', (WidgetTester tester) async {
    bool? tappedValue;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LikeIcon(
            isEnabled: false,
            onTap: (value) {
              tappedValue = value;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell));

    expect(tappedValue, false);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LikeIcon(
            isEnabled: true,
            onTap: (value) {
              tappedValue = value;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell));

    expect(tappedValue, true);
  });

  testWidgets('LikeIcon should use custom icons and colors if provided', (WidgetTester tester) async {
    const customDisabledIcon = Icons.star;
    const customEnabledIcon = Icons.star_border;
    const customEnabledColor = Colors.red;
    const customDisabledColor = Colors.blue;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LikeIcon(
            isEnabled: false,
            disabledIcon: customDisabledIcon,
            enabledIcon: customEnabledIcon,
            enabledColor: customEnabledColor,
            disabledColor: customDisabledColor,
          ),
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.icon, customDisabledIcon);
    expect(icon.color, customDisabledColor);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LikeIcon(
            isEnabled: true,
            disabledIcon: customDisabledIcon,
            enabledIcon: customEnabledIcon,
            enabledColor: customEnabledColor,
            disabledColor: customDisabledColor,
          ),
        ),
      ),
    );

    final icon2 = tester.widget<Icon>(find.byType(Icon));
    expect(icon2.icon, customEnabledIcon);
    expect(icon2.color, customEnabledColor);
  });
}
