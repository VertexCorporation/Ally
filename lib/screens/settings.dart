// settings.dart
//
// © 2026 Vertex Corporation
// ─────────────────────────────────────────────────────────────────────────────
// Settings: Account / Appearance / Notifications / Privacy / Language /
// Health integrations / About Ally / Vertex Corporation.
//
// All existing behaviour (logout, units, language, theme selection persisted
// through ThemeProvider, legal & about dialogs) is preserved; the theme
// selector now writes through the provider to the real `selectedTheme` key
// and supports the `system` option correctly.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../design_system/design_system.dart';
import '../l10n/app_localizations.dart';
import '../language.dart'; // LocaleProvider
import '../providers/health.dart';
import '../login/screen.dart';
import '../server/user.dart';
import '../theme.dart';
import '../widgets/notification.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Notifications state (persisted in the original implementation).
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  String _selectedLanguage = 'English';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? false;
    });
  }

  Future<void> _saveNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', _pushNotifications);
    await prefs.setBool('email_notifications', _emailNotifications);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _isInitialized = true;
    }

    // Dynamically update the displayed language name based on Provider state
    final currentLocale = context.watch<LocaleProvider>().locale;
    switch (currentLocale.languageCode) {
      case 'en':
        _selectedLanguage = 'English';
        break;
      case 'tr':
        _selectedLanguage = 'Türkçe';
        break;
      case 'es':
        _selectedLanguage = 'Español';
        break;
      case 'fr':
        _selectedLanguage = 'Français';
        break;
      case 'de':
        _selectedLanguage = 'Deutsch';
        break;
      case 'zh':
        _selectedLanguage = '中文';
        break;
      default:
        _selectedLanguage = 'English';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.clearDataOnSignOut();

    if (!mounted) return;

    final navigator = Navigator.of(context);
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _handleBack() {
    _controller.reverse().then((_) {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final themeProvider = context.watch<ThemeProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: AllyAppBar(title: l10n.settings, onBack: _handleBack),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AllySpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Account ─────────────────────────────────────
                          AllySectionHeader(title: l10n.account),
                          const SizedBox(height: AllySpacing.md),
                          AllySettingsGroup(
                            tiles: [
                              AllySettingsTile(
                                title: l10n.yourProfile,
                                icon: Icons.person_rounded,
                                accent: scheme.onSurfaceVariant,
                                onTap: () {},
                              ),
                              AllySettingsTile(
                                title: l10n.exit,
                                icon: Icons.logout_rounded,
                                accent: scheme.error,
                                showChevron: false,
                                onTap: () {
                                  AllyDialog.confirm(
                                    context,
                                    title: l10n.exit,
                                    message: l10n.exitAppConfirmation,
                                    confirmLabel: l10n.yes,
                                    cancelLabel: l10n.no,
                                    icon: Icons.logout_rounded,
                                    destructive: true,
                                  ).then((confirmed) {
                                    if (!confirmed) return;
                                    if (!mounted) return;
                                    _handleLogout();
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: AllySpacing.section),

                          // ── Appearance ──────────────────────────────────
                          AllySectionHeader(title: l10n.appearance),
                          const SizedBox(height: AllySpacing.md),
                          AllySettingsGroup(
                            tiles: [
                              AllySettingsTile(
                                title: l10n.theme,
                                subtitle: _themeDisplayName(
                                  themeProvider.currentTheme,
                                  l10n,
                                ),
                                icon: Icons.palette_rounded,
                                onTap: _showThemeSheet,
                              ),
                              AllySettingsTile(
                                title: l10n.language,
                                subtitle: _selectedLanguage,
                                icon: Icons.language_rounded,
                                onTap: _showLanguageSheet,
                              ),
                              AllySettingsTile(
                                title: l10n.units,
                                subtitle:
                                    context.watch<HealthProvider>().units ==
                                        'metric'
                                    ? l10n.metric
                                    : l10n.imperial,
                                icon: Icons.straighten_rounded,
                                onTap: _showUnitsSheet,
                              ),
                            ],
                          ),

                          const SizedBox(height: AllySpacing.section),

                          // ── Notifications ───────────────────────────────
                          AllySectionHeader(title: l10n.notifications),
                          const SizedBox(height: AllySpacing.md),
                          AllySettingsGroup(
                            tiles: [
                              SwitchListTile(
                                value: _pushNotifications,
                                onChanged: (value) {
                                  setState(() => _pushNotifications = value);
                                  _saveNotificationSettings();
                                },
                                title: Text(
                                  l10n.pushNotifications,
                                  style: AllyTypography.label(
                                    size: 15,
                                    color: scheme.onSurface,
                                  ),
                                ),
                                secondary: Icon(
                                  Icons.notifications_rounded,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                              SwitchListTile(
                                value: _emailNotifications,
                                onChanged: (value) {
                                  setState(() => _emailNotifications = value);
                                  _saveNotificationSettings();
                                },
                                title: Text(
                                  l10n.emailNotifications,
                                  style: AllyTypography.label(
                                    size: 15,
                                    color: scheme.onSurface,
                                  ),
                                ),
                                secondary: Icon(
                                  Icons.alternate_email_rounded,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AllySpacing.section),

                          // ── Privacy ─────────────────────────────────────
                          AllySectionHeader(title: l10n.privacySecurity),
                          const SizedBox(height: AllySpacing.md),
                          AllySettingsGroup(
                            tiles: [
                              AllySettingsTile(
                                title: l10n.privacySettings,
                                icon: Icons.privacy_tip_rounded,
                                onTap: () {},
                              ),
                              AllySettingsTile(
                                title: l10n.dataStorage,
                                icon: Icons.storage_rounded,
                                onTap: () {},
                              ),
                            ],
                          ),

                          const SizedBox(height: AllySpacing.section),

                          // ── Support & Legal ─────────────────────────────
                          AllySectionHeader(title: l10n.support),
                          const SizedBox(height: AllySpacing.md),
                          AllySettingsGroup(
                            tiles: [
                              AllySettingsTile(
                                title: l10n.support,
                                icon: Icons.help_rounded,
                                onTap: () {},
                              ),
                              AllySettingsTile(
                                title: l10n.legal,
                                icon: Icons.description_rounded,
                                onTap: _showLegalSheet,
                              ),
                              AllySettingsTile(
                                title: l10n.aboutAlly,
                                icon: Icons.info_rounded,
                                onTap: _showAboutSheet,
                              ),
                            ],
                          ),

                          const SizedBox(height: AllySpacing.sectionLg),

                          // ── Vertex Corporation ──────────────────────────
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'BY VERTEX',
                                  style: AllyTypography.label(
                                    size: 11,
                                    weight: FontWeight.w700,
                                    color: scheme.onSurfaceVariant,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: AllySpacing.xs),
                                Text(
                                  l10n.copyright,
                                  style: AllyTypography.caption(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AllySpacing.massive),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _themeDisplayName(String themeName, AppLocalizations l10n) {
    switch (themeName) {
      case AppTheme.system:
        return l10n.systemDefault;
      case AppTheme.dark:
        return l10n.darkMode;
      case AppTheme.light:
        return l10n.lightMode;
      default:
        // Preserved custom themes keep their readable names.
        return themeName[0].toUpperCase() + themeName.substring(1);
    }
  }

  // ── Sheets ────────────────────────────────────────────────────────────────

  void _showThemeSheet() {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.read<ThemeProvider>();
    final current = themeProvider.currentTheme;

    AllySheet.show(
      context,
      title: l10n.selectTheme,
      icon: Icons.palette_rounded,
      child: Column(
        children: [
          _OptionRow(
            text: l10n.systemDefault,
            selected: current == AppTheme.system,
            onTap: () {
              themeProvider.changeTheme(AppTheme.system);
              Navigator.pop(context);
            },
          ),
          _OptionRow(
            text: l10n.lightMode,
            selected: current == AppTheme.light,
            onTap: () {
              themeProvider.changeTheme(AppTheme.light);
              Navigator.pop(context);
            },
          ),
          _OptionRow(
            text: l10n.darkMode,
            selected: current == AppTheme.dark,
            onTap: () {
              themeProvider.changeTheme(AppTheme.dark);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet() {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.read<LocaleProvider>();

    AllySheet.show(
      context,
      title: l10n.selectLanguage,
      icon: Icons.language_rounded,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _OptionRow(
              text: 'English',
              selected: _selectedLanguage == 'English',
              onTap: () {
                setState(() => _selectedLanguage = 'English');
                localeProvider.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            _OptionRow(
              text: 'Español',
              selected: _selectedLanguage == 'Español',
              onTap: () {
                setState(() => _selectedLanguage = 'Español');
                localeProvider.setLocale(const Locale('es'));
                Navigator.pop(context);
              },
            ),
            _OptionRow(
              text: 'Français',
              selected: _selectedLanguage == 'Français',
              onTap: () {
                setState(() => _selectedLanguage = 'Français');
                localeProvider.setLocale(const Locale('fr'));
                Navigator.pop(context);
              },
            ),
            _OptionRow(
              text: 'Deutsch',
              selected: _selectedLanguage == 'Deutsch',
              onTap: () {
                setState(() => _selectedLanguage = 'Deutsch');
                localeProvider.setLocale(const Locale('de'));
                Navigator.pop(context);
              },
            ),
            _OptionRow(
              text: 'Türkçe',
              selected: _selectedLanguage == 'Türkçe',
              onTap: () {
                setState(() => _selectedLanguage = 'Türkçe');
                localeProvider.setLocale(const Locale('tr'));
                Navigator.pop(context);
              },
            ),
            _OptionRow(
              text: '中文',
              selected: _selectedLanguage == '中文',
              onTap: () {
                setState(() => _selectedLanguage = '中文');
                localeProvider.setLocale(const Locale('zh'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUnitsSheet() {
    final l10n = AppLocalizations.of(context)!;
    final healthProvider = context.read<HealthProvider>();
    final units = healthProvider.units;

    AllySheet.show(
      context,
      title: l10n.selectUnits,
      icon: Icons.straighten_rounded,
      child: Column(
        children: [
          _OptionRow(
            text: l10n.metric,
            selected: units == 'metric',
            onTap: () {
              healthProvider.setUnits('metric');
              Navigator.pop(context);
            },
          ),
          _OptionRow(
            text: l10n.imperial,
            selected: units == 'imperial',
            onTap: () {
              healthProvider.setUnits('imperial');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLegalSheet() {
    final l10n = AppLocalizations.of(context)!;

    AllySheet.show(
      context,
      title: l10n.legal,
      subtitle: l10n.readPolicies,
      icon: Icons.gavel_rounded,
      child: Column(
        children: [
          AllySettingsGroup(
            tiles: [
              AllySettingsTile(
                title: l10n.privacyPolicy,
                icon: Icons.privacy_tip_rounded,
                onTap: () {
                  CustomNotification.show(
                    context,
                    message: l10n.openingPrivacyPolicy,
                    icon: Icons.privacy_tip_rounded,
                  );
                },
              ),
              AllySettingsTile(
                title: l10n.termsOfService,
                icon: Icons.description_rounded,
                onTap: () {
                  CustomNotification.show(
                    context,
                    message: l10n.openingWebsite,
                    icon: Icons.description_rounded,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAboutSheet() {
    final l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    AllySheet.show(
      context,
      title: l10n.about,
      icon: Icons.info_rounded,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AllyRadius.sm),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: AllySpacing.md),
              Text(
                l10n.ally,
                style: AllyTypography.headline(
                  size: 20,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AllySpacing.md),
          Text(
            l10n.motto,
            textAlign: TextAlign.center,
            style: AllyTypography.body(
              size: 15,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AllySpacing.xl),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AllySpacing.lg,
              vertical: AllySpacing.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: AllyRadius.smAll,
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Text(
              l10n.version,
              style: AllyTypography.label(size: 13, color: scheme.onSurface),
            ),
          ),
          const SizedBox(height: AllySpacing.xl),
          AllySettingsGroup(
            tiles: [
              AllySettingsTile(
                title: l10n.visitWebsite,
                icon: Icons.language_rounded,
                onTap: () {
                  CustomNotification.show(
                    context,
                    message: l10n.openingWebsite,
                    icon: Icons.language_rounded,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Standard selectable row used inside the option sheets.
class _OptionRow extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _OptionRow({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AllyRadius.smAll,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AllySpacing.lg,
          vertical: AllySpacing.lg,
        ),
        decoration: BoxDecoration(
          color: selected
              ? scheme.onSurface.withValues(alpha: 0.06)
              : Colors.transparent,
          borderRadius: AllyRadius.smAll,
          border: Border.all(
            color: selected ? scheme.onSurface : scheme.outlineVariant,
            width: selected ? 1.4 : 1,
          ),
        ),
        margin: const EdgeInsets.only(bottom: AllySpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: AllyTypography.label(
                  size: 15,
                  weight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_rounded,
                size: AllyDimensions.iconMd,
                color: scheme.onSurface,
              ),
          ],
        ),
      ),
    );
  }
}
