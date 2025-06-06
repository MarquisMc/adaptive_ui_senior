// example/lib/main.dart

import 'package:flutter/material.dart';
import 'package:adaptive_ui_senior/adaptive_ui_senior.dart';
import 'package:flutter/services.dart';

// Define the global accessibility service instance for the example app.
// This assumes 'AccessibilityService' class is exported by the 'adaptive_ui_senior' package.
final AccessibilityService accessibilityService = AccessibilityService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the accessibility service
  await accessibilityService.initialized();

  runApp(const AdaptiveUIExampleApp());
}

class AdaptiveUIExampleApp extends StatelessWidget {
  const AdaptiveUIExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: accessibilityService,
      builder: (context, child) {
        return MaterialApp(
          title: 'Adaptive UI Senior Example',
          debugShowCheckedModeBanner: false,

          // Apply adaptive theming
          theme: AdaptiveTheme.getTheme(
            accessibilityService: accessibilityService,
            brightness: Brightness.light,
          ),
          darkTheme: AdaptiveTheme.getTheme(
            accessibilityService: accessibilityService,
            brightness: Brightness.dark,
          ),

          themeMode: accessibilityService.settings.themeMode,
          home: const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const TextExamplesTab(),
    const ButtonExamplesTab(),
    const AgeDemoTab(), // Added Age Demo Tab
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      accessibilityService: accessibilityService,
      appBar: AdaptiveAppBar(
        title: const AdaptiveText('Adaptive UI Senior'),
        accessibilityService: accessibilityService,
        actions: [
          AdaptiveIconButton(
            icon: Icons.accessibility_new,
            onPressed: () => _navigateToSettings(),
            tooltip: 'Accessibility Settings',
            accessibilityService: accessibilityService,
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: AdaptiveBottomNavigationBar(
        accessibilityService: accessibilityService,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: 'Text'),
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'Buttons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cake), // Icon for Age Demo
            label: 'Age Demo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: AdaptiveFloatingActionButton(
        onPressed: () => _showQuickAccessibilityMenu(),
        icon: Icons.accessibility,
        tooltip: 'Quick Accessibility',
        accessibilityService: accessibilityService,
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AccessibilitySettingsPanel(
          accessibilityService: accessibilityService,
        ),
      ),
    );
  }

  void _showQuickAccessibilityMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => CompactAccessibilitySettings(
        accessibilityService: accessibilityService,
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTextProvider(
      accessibilityService: accessibilityService,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(
              TapTargetUtils.getOptimalSpacing(accessibilityService),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdaptiveHeading(
                  'Welcome to Adaptive UI Senior',
                  level: 1,
                ),

                SizedBox(
                  height: TapTargetUtils.getOptimalSpacing(
                    accessibilityService,
                  ),
                ),

                const AdaptiveBodyText(
                  'This example app demonstrates how the adaptive_ui_senior package can make your Flutter apps more accessible for senior users.',
                ),

                SizedBox(
                  height:
                      TapTargetUtils.getOptimalSpacing(accessibilityService) *
                      2,
                ),

                const AdaptiveHeading('Key Features', level: 2),

                SizedBox(
                  height: TapTargetUtils.getOptimalSpacing(
                    accessibilityService,
                  ),
                ),

                _buildFeatureCard(
                  context,
                  icon: Icons.text_increase,
                  title: 'Dynamic Font Scaling',
                  description:
                      'Automatically adjusts text size based on user preferences',
                ),

                SizedBox(
                  height: TapTargetUtils.getOptimalSpacing(
                    accessibilityService,
                  ),
                ),

                _buildFeatureCard(
                  context,
                  icon: Icons.contrast,
                  title: 'High Contrast Mode',
                  description:
                      'Enhances visibility with stronger color contrasts',
                ),

                SizedBox(
                  height: TapTargetUtils.getOptimalSpacing(
                    accessibilityService,
                  ),
                ),

                _buildFeatureCard(
                  context,
                  icon: Icons.touch_app,
                  title: 'Larger Tap Targets',
                  description:
                      'Makes buttons and interactive elements easier to tap',
                ),

                SizedBox(
                  height:
                      TapTargetUtils.getOptimalSpacing(accessibilityService) *
                      2,
                ),

                Center(
                  child: AdaptiveElevatedButton(
                    text: 'Explore Accessibility Settings',
                    onPressed: () => _navigateToSettings(context),
                    accessibilityService: accessibilityService,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(
          TapTargetUtils.getOptimalSpacing(accessibilityService),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size:
                  TapTargetUtils.getEffectiveMinTapTargetSize(
                    accessibilityService,
                  ) *
                  0.6,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(
              width: TapTargetUtils.getOptimalSpacing(accessibilityService),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdaptiveText(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(
                    height:
                        TapTargetUtils.getOptimalSpacing(accessibilityService) /
                        2,
                  ),
                  AdaptiveText(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AccessibilitySettingsPanel(
          accessibilityService: accessibilityService,
        ),
      ),
    );
  }
}

class TextExamplesTab extends StatelessWidget {
  const TextExamplesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTextProvider(
      accessibilityService: accessibilityService,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(
              TapTargetUtils.getOptimalSpacing(accessibilityService),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdaptiveHeading('Text Examples', level: 1),

                SizedBox(
                  height: TapTargetUtils.getOptimalSpacing(
                    accessibilityService,
                  ),
                ),

                const AdaptiveBodyText(
                  'These examples show how text adapts to your accessibility settings.',
                ),

                SizedBox(
                  height:
                      TapTargetUtils.getOptimalSpacing(accessibilityService) *
                      2,
                ),

                // Heading examples
                const AdaptiveHeading('Heading Level 1', level: 1),
                const AdaptiveHeading('Heading Level 2', level: 2),
                const AdaptiveHeading('Heading Level 3', level: 3),
                const AdaptiveHeading('Heading Level 4', level: 4),
                const AdaptiveHeading('Heading Level 5', level: 5),
                const AdaptiveHeading('Heading Level 6', level: 6),

                SizedBox(
                  height:
                      TapTargetUtils.getOptimalSpacing(accessibilityService) *
                      2,
                ),

                // Body text examples
                const AdaptiveBodyText(
                  'This is body text that adapts to your font scale settings. '
                  'It maintains optimal line height and spacing for comfortable reading.',
                ),

                SizedBox(
                  height: TapTargetUtils.getOptimalSpacing(
                    accessibilityService,
                  ),
                ),

                const AdaptiveCaption(
                  'This is caption text that ensures minimum readability even at smaller sizes.',
                ),

                SizedBox(
                  height:
                      TapTargetUtils.getOptimalSpacing(accessibilityService) *
                      2,
                ),

                // Rich text example
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(
                      TapTargetUtils.getOptimalSpacing(accessibilityService),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AdaptiveHeading('Sample Article', level: 3),

                        SizedBox(
                          height: TapTargetUtils.getOptimalSpacing(
                            accessibilityService,
                          ),
                        ),

                        const AdaptiveBodyText(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                          'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
                        ),

                        SizedBox(
                          height: TapTargetUtils.getOptimalSpacing(
                            accessibilityService,
                          ),
                        ),

                        const AdaptiveBodyText(
                          'Duis aute irure dolor in reprehenderit in voluptate velit esse '
                          'cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat '
                          'cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ButtonExamplesTab extends StatelessWidget {
  const ButtonExamplesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTextProvider(
      accessibilityService: accessibilityService,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(
              TapTargetUtils.getOptimalSpacing(accessibilityService),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AdaptiveHeading('Button Examples', level: 1),

                  SizedBox(
                    height: TapTargetUtils.getOptimalSpacing(
                      accessibilityService,
                    ),
                  ),

                  const AdaptiveBodyText(
                    'These buttons automatically adjust their size based on your accessibility settings.',
                  ),

                  SizedBox(
                    height:
                        TapTargetUtils.getOptimalSpacing(accessibilityService) *
                        2,
                  ),

                  _buildButtonSection(context, 'Elevated Buttons', [
                    AdaptiveElevatedButton(
                      key: const ValueKey(
                        'elevated_primary_action',
                      ), // Added Key
                      text: 'Primary Action',
                      onPressed: () =>
                          _showSnackBar(context, 'Elevated button pressed'),
                      accessibilityService: accessibilityService,
                    ),
                    AdaptiveElevatedButton(
                      key: const ValueKey('elevated_disabled'), // Added Key
                      text: 'Disabled',
                      onPressed: null,
                      accessibilityService: accessibilityService,
                    ),
                  ]),

                  _buildButtonSection(context, 'Outlined Buttons', [
                    AdaptiveOutlinedButton(
                      key: const ValueKey(
                        'outlined_secondary_action',
                      ), // Added Key
                      text: 'Secondary Action',
                      onPressed: () =>
                          _showSnackBar(context, 'Outlined button pressed'),
                      accessibilityService: accessibilityService,
                    ),
                    AdaptiveOutlinedButton(
                      key: const ValueKey('outlined_cancel'), // Added Key
                      text: 'Cancel',
                      onPressed: () =>
                          _showSnackBar(context, 'Cancel button pressed'),
                      accessibilityService: accessibilityService,
                    ),
                  ]),

                  _buildButtonSection(context, 'Text Buttons', [
                    AdaptiveTextButton(
                      key: const ValueKey('text_action'), // Added Key
                      text: 'Text Action',
                      onPressed: () =>
                          _showSnackBar(context, 'Text button pressed'),
                      accessibilityService: accessibilityService,
                    ),
                    AdaptiveTextButton(
                      key: const ValueKey('text_learn_more'), // Added Key
                      text: 'Learn More',
                      onPressed: () =>
                          _showSnackBar(context, 'Learn more pressed'),
                      accessibilityService: accessibilityService,
                    ),
                  ]),

                  _buildButtonSection(context, 'Icon Buttons', [
                    AdaptiveIconButton(
                      icon: Icons.favorite,
                      onPressed: () =>
                          _showSnackBar(context, 'Favorite pressed'),
                      tooltip: 'Add to favorites',
                      accessibilityService: accessibilityService,
                    ),
                    AdaptiveIconButton(
                      icon: Icons.share,
                      onPressed: () => _showSnackBar(context, 'Share pressed'),
                      tooltip: 'Share',
                      accessibilityService: accessibilityService,
                    ),
                    AdaptiveIconButton(
                      icon: Icons.settings,
                      onPressed: () =>
                          _showSnackBar(context, 'Settings pressed'),
                      tooltip: 'Settings',
                      accessibilityService: accessibilityService,
                    ),
                  ]),

                  _buildButtonSection(context, 'Floating Action Button', [
                    AdaptiveFloatingActionButton(
                      onPressed: () => _showSnackBar(context, 'FAB pressed'),
                      icon: Icons.add,
                      tooltip: 'Add new item',
                      accessibilityService: accessibilityService,
                    ),
                  ]),

                  SizedBox(
                    height:
                        TapTargetUtils.getOptimalSpacing(accessibilityService) *
                        2,
                  ),

                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(
                        TapTargetUtils.getOptimalSpacing(accessibilityService),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AdaptiveHeading(
                            'Interactive Example',
                            level: 3,
                          ),
                          SizedBox(
                            height: TapTargetUtils.getOptimalSpacing(
                              accessibilityService,
                            ),
                          ),
                          const AdaptiveBodyText(
                            'Try adjusting the accessibility settings to see how button sizes change.',
                          ),
                          SizedBox(
                            height: TapTargetUtils.getOptimalSpacing(
                              accessibilityService,
                            ),
                          ),
                          Wrap(
                            spacing: TapTargetUtils.getOptimalSpacing(
                              accessibilityService,
                            ),
                            runSpacing: TapTargetUtils.getOptimalSpacing(
                              accessibilityService,
                            ),
                            children: [
                              AdaptiveElevatedButton(
                                text: 'Settings',
                                onPressed: () => _navigateToSettings(context),
                                accessibilityService: accessibilityService,
                              ),
                              AdaptiveOutlinedButton(
                                text: 'Quick Menu',
                                onPressed: () => _showQuickMenu(context),
                                accessibilityService: accessibilityService,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtonSection(
    BuildContext context,
    String title,
    List<Widget> buttons,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdaptiveHeading(title, level: 3),
        SizedBox(
          height: TapTargetUtils.getOptimalSpacing(accessibilityService),
        ),
        Wrap(
          spacing: TapTargetUtils.getOptimalSpacing(accessibilityService),
          runSpacing: TapTargetUtils.getOptimalSpacing(accessibilityService),
          children: buttons,
        ),
        SizedBox(
          height: TapTargetUtils.getOptimalSpacing(accessibilityService) * 2,
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AdaptiveText(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AccessibilitySettingsPanel(
          accessibilityService: accessibilityService,
        ),
      ),
    );
  }

  void _showQuickMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CompactAccessibilitySettings(
        accessibilityService: accessibilityService,
      ),
    );
  }
}

class AgeDemoTab extends StatefulWidget {
  const AgeDemoTab({super.key});

  @override
  State<AgeDemoTab> createState() => _AgeDemoTabState();
}

class _AgeDemoTabState extends State<AgeDemoTab> {
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text field if age is already set in service
    final settings = accessibilityService.settings;
    if (settings.useAgeBasedAdaptation && settings.age != null) {
      _ageController.text = settings.age.toString();
    }
    accessibilityService.addListener(_updateTextFieldFromService);
  }

  void _updateTextFieldFromService() {
    final serviceAge = accessibilityService.settings.age;
    if (serviceAge != null && _ageController.text != serviceAge.toString()) {
      _ageController.text = serviceAge.toString();
    } else if (serviceAge == null && _ageController.text.isNotEmpty) {
      _ageController.clear();
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    accessibilityService.removeListener(_updateTextFieldFromService);
    super.dispose();
  }

  void _onAgeChanged(String value) {
    final age = int.tryParse(value);
    AccessibilitySettings currentSettings = accessibilityService.settings;

    if (currentSettings.useAgeBasedAdaptation) {
      if (age != null && age > 0) {
        accessibilityService.updateSettings(currentSettings.copyWith(age: age));
      } else if (value.isEmpty) {
        // Allow clearing age if field is empty
        accessibilityService.updateSettings(
          currentSettings.copyWith(age: null),
        );
      }
      // If age is invalid (e.g., non-numeric, zero, or negative after parsing),
      // or if useAgeBasedAdaptation is false, do not update the service's age directly here.
      // The _updateTextFieldFromService listener and _onToggleAgeAdaptation
      // will handle syncing based on the service's authoritative state.
    }
  }

  void _onToggleAgeAdaptation(bool newIsEnabledState) {
    // newIsEnabledState is the new value from the Switch.
    AccessibilitySettings currentSettings = accessibilityService.settings;
    int? newAgeForService;

    if (newIsEnabledState) {
      // Age adaptation is being turned ON
      final ageFromTextField = int.tryParse(_ageController.text);
      if (ageFromTextField != null && ageFromTextField > 0) {
        newAgeForService = ageFromTextField;
      } else {
        newAgeForService =
            null; // No valid age in text field, so service age is null
      }
    } else {
      // Age adaptation is being turned OFF
      newAgeForService = null; // Age should be cleared in the service
    }

    accessibilityService.updateSettings(
      currentSettings.copyWith(
        useAgeBasedAdaptation: newIsEnabledState,
        age: newAgeForService,
      ),
    );
    // The _updateTextFieldFromService listener will sync the text field
    // based on the new service state.
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTextProvider(
      accessibilityService: accessibilityService,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListenableBuilder(
            listenable: accessibilityService,
            builder: (context, _) {
              final settings = accessibilityService.settings;
              final effectiveFontScale = accessibilityService
                  .getEffectiveFontScale();
              final effectiveTapTargetSize = accessibilityService
                  .getEffectiveMinTapTargetSize();

              return SingleChildScrollView(
                padding: EdgeInsets.all(
                  TapTargetUtils.getOptimalSpacing(accessibilityService),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AdaptiveHeading(
                      'Age-Based Adaptation Demo',
                      level: 1,
                    ),
                    SizedBox(
                      height: TapTargetUtils.getOptimalSpacing(
                        accessibilityService,
                      ),
                    ),
                    const AdaptiveBodyText(
                      'Enable age-based adaptation and enter an age to see how UI elements adjust. '
                      'This feature uses recommendations for font size and tap target size based on age.',
                    ),
                    SizedBox(
                      height:
                          TapTargetUtils.getOptimalSpacing(
                            accessibilityService,
                          ) *
                          2,
                    ),
                    SwitchListTile(
                      title: const AdaptiveText('Enable Age-Based Adaptation'),
                      value: settings.useAgeBasedAdaptation,
                      onChanged: _onToggleAgeAdaptation,
                      contentPadding: EdgeInsets.zero,
                    ),
                    SizedBox(
                      height: TapTargetUtils.getOptimalSpacing(
                        accessibilityService,
                      ),
                    ),
                    TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Enter Your Age',
                        border: const OutlineInputBorder(),
                        hintText: 'e.g., 65',
                        enabled: settings.useAgeBasedAdaptation,
                      ),
                      onChanged: _onAgeChanged,
                    ),
                    SizedBox(
                      height:
                          TapTargetUtils.getOptimalSpacing(
                            accessibilityService,
                          ) *
                          2,
                    ),
                    AdaptiveHeading(
                      'Current Effective Settings:',
                      level: 3,
                      accessibilityService: accessibilityService,
                    ),
                    AdaptiveText(
                      'Font Scale: ${effectiveFontScale.toStringAsFixed(2)}x '
                      '(${FontScaleUtils.getFontScaleDescription(effectiveFontScale)})',
                      accessibilityService: accessibilityService,
                    ),
                    AdaptiveText(
                      'Tap Target Size: ${effectiveTapTargetSize.toStringAsFixed(1)}px '
                      '(${TapTargetUtils.getTapTargetSizeDescription(effectiveTapTargetSize)})',
                      accessibilityService: accessibilityService,
                    ),
                    SizedBox(
                      height:
                          TapTargetUtils.getOptimalSpacing(
                            accessibilityService,
                          ) *
                          2,
                    ),
                    const AdaptiveHeading(
                      'Adaptive Elements Preview',
                      level: 2,
                    ),
                    SizedBox(
                      height: TapTargetUtils.getOptimalSpacing(
                        accessibilityService,
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(
                          TapTargetUtils.getOptimalSpacing(
                            accessibilityService,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AdaptiveText(
                              'Sample Text (Adapts Font Size)',
                              style: Theme.of(context).textTheme.headlineSmall,
                              accessibilityService: accessibilityService,
                            ),
                            SizedBox(
                              height:
                                  TapTargetUtils.getOptimalSpacing(
                                    accessibilityService,
                                  ) /
                                  2,
                            ),
                            AdaptiveText(
                              'This paragraph demonstrates adaptive text scaling. '
                              'The size of this text will change based on the effective font scale, '
                              'which can be influenced by your age if age-based adaptation is enabled.',
                              accessibilityService: accessibilityService,
                            ),
                            SizedBox(
                              height: TapTargetUtils.getOptimalSpacing(
                                accessibilityService,
                              ),
                            ),
                            AdaptiveElevatedButton(
                              text: 'Adaptive Button',
                              onPressed: () {},
                              accessibilityService: accessibilityService,
                              semanticLabel:
                                  'This button adapts its size based on tap target settings.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTextProvider(
      accessibilityService: accessibilityService,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(
              TapTargetUtils.getOptimalSpacing(accessibilityService),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdaptiveHeading('Settings', level: 1),

                SizedBox(
                  height: TapTargetUtils.getOptimalSpacing(
                    accessibilityService,
                  ),
                ),

                const AdaptiveBodyText(
                  'Configure your accessibility preferences and app settings.',
                ),

                SizedBox(
                  height:
                      TapTargetUtils.getOptimalSpacing(accessibilityService) *
                      2,
                ),

                // Compact accessibility settings
                CompactAccessibilitySettings(
                  accessibilityService: accessibilityService,
                ),

                SizedBox(
                  height:
                      TapTargetUtils.getOptimalSpacing(accessibilityService) *
                      2,
                ),

                // Other app settings
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(
                      TapTargetUtils.getOptimalSpacing(accessibilityService),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AdaptiveHeading('App Settings', level: 3),

                        SizedBox(
                          height: TapTargetUtils.getOptimalSpacing(
                            accessibilityService,
                          ),
                        ),

                        ListTile(
                          leading: const Icon(Icons.notifications),
                          title: const AdaptiveText('Notifications'),
                          subtitle: const AdaptiveText(
                            'Manage app notifications',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () =>
                              _showSnackBar(context, 'Notifications settings'),
                          contentPadding: EdgeInsets.zero,
                          isThreeLine: true,
                        ),

                        ListTile(
                          leading: const Icon(Icons.privacy_tip),
                          title: const AdaptiveText('Privacy'),
                          subtitle: const AdaptiveText(
                            'Privacy and data settings',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () =>
                              _showSnackBar(context, 'Privacy settings'),
                          contentPadding: EdgeInsets.zero,
                          isThreeLine: true,
                        ),

                        ListTile(
                          leading: const Icon(Icons.help),
                          title: const AdaptiveText('Help & Support'),
                          subtitle: const AdaptiveText(
                            'Get help and contact support',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _showSnackBar(context, 'Help & Support'),
                          contentPadding: EdgeInsets.zero,
                          isThreeLine: true,
                        ),

                        ListTile(
                          leading: const Icon(Icons.info),
                          title: const AdaptiveText('About'),
                          subtitle: const AdaptiveText(
                            'App version and information',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _showAboutDialog(context),
                          contentPadding: EdgeInsets.zero,
                          isThreeLine: true,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height:
                      TapTargetUtils.getOptimalSpacing(accessibilityService) *
                      2,
                ),

                // Action buttons
                Center(
                  child: Column(
                    children: [
                      AdaptiveElevatedButton(
                        key: const ValueKey(
                          'Settings_Full_Accessibility',
                        ), // Added Key
                        text: 'Full Accessibility Settings',
                        onPressed: () => _navigateToFullSettings(context),
                        accessibilityService: accessibilityService,
                      ),

                      SizedBox(
                        height: TapTargetUtils.getOptimalSpacing(
                          accessibilityService,
                        ),
                      ),

                      AdaptiveOutlinedButton(
                        key: const ValueKey('Settings_reset_all'), // Added Key
                        text: 'Reset All Settings',
                        onPressed: () => _showResetDialog(context),
                        accessibilityService: accessibilityService,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AdaptiveText(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToFullSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AccessibilitySettingsPanel(
          accessibilityService: accessibilityService,
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const AdaptiveText('About Adaptive UI Senior'),
          content: const AdaptiveText(
            'This example app demonstrates the adaptive_ui_senior package, '
            'which helps make Flutter apps more accessible for senior users.\n\n'
            'Version: 1.0.0\n'
            'Package: adaptive_ui_senior',
          ),
          actions: [
            AdaptiveTextButton(
              text: 'Close',
              onPressed: () => Navigator.of(context).pop(),
              accessibilityService: accessibilityService,
            ),
          ],
        );
      },
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const AdaptiveText('Reset All Settings?'),
          content: const AdaptiveText(
            'This will reset all accessibility and app settings to their default values. '
            'This action cannot be undone.',
          ),
          actions: [
            AdaptiveTextButton(
              key: const ValueKey('dialog_reset_cancel'), // Added Key
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
              accessibilityService: accessibilityService,
            ),
            AdaptiveElevatedButton(
              key: const ValueKey('dialog_reset_confirm'), // Added Key
              text: 'Reset',
              onPressed: () {
                accessibilityService.resetToDefaults();
                Navigator.of(context).pop();
                _showSnackBar(context, 'All settings have been reset');
              },
              accessibilityService: accessibilityService,
            ),
          ],
        );
      },
    );
  }
}
