// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Imports for app resources
import '../l10n/app_localizations.dart';
import '../providers/health.dart';
import '../language.dart'; // LocaleProvider
import '../theme.dart';    // ThemeProvider
import '../server/user.dart';
import '../login/screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Settings State
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  String _themeValue = 'system'; // system, light, dark
  String _selectedLanguage = 'English';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();

    // Animation Setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? false;
      // We load the theme for the UI selector, though the Provider handles the actual app theme
      _themeValue = prefs.getString('theme') ?? 'system';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications', _pushNotifications);
    await prefs.setBool('email_notifications', _emailNotifications);
    await prefs.setString('theme', _themeValue);
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
      case 'en': _selectedLanguage = 'English'; break;
      case 'tr': _selectedLanguage = 'Türkçe'; break;
      case 'es': _selectedLanguage = 'Español'; break;
      case 'fr': _selectedLanguage = 'Français'; break;
      case 'de': _selectedLanguage = 'Deutsch'; break;
      case 'zh': _selectedLanguage = '中文'; break;
      default:   _selectedLanguage = 'English';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLogout(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    await userProvider.clearDataOnSignOut();
    
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
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
    // --- Dynamic Sizing Logic ---
    final Size size = MediaQuery.of(context).size;
    // Reference design width (e.g., iPhone 11 Pro is ~375)
    final double scaleFactor = size.width / 375.0;

    // Helper functions for dynamic scaling
    double rw(double val) => val * scaleFactor; // Relative Width/General Scale
    double rh(double val) => val * (size.height / 812.0); // Relative Height
    double rs(double val) => val * scaleFactor; // Relative Font Size

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: SafeArea(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(rw(20.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: _handleBack,
                                    child: Icon(Icons.chevron_left_rounded, size: rs(28)),
                                  ),
                                  SizedBox(width: rw(16)),
                                  Text(
                                    AppLocalizations.of(context)!.settings,
                                    style: TextStyle(
                                      fontSize: rs(20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: rh(30)),

                              // Profile Section
                              _buildSectionTitle(AppLocalizations.of(context)!.profile, rs),
                              SizedBox(height: rh(12)),
                              _buildGroupedTiles(
                                [
                                  _buildIconTile(AppLocalizations.of(context)!.yourProfile, Icons.person_rounded, rw, rs, onTap: () {}),
                                  _buildIconTile(AppLocalizations.of(context)!.pushNotifications, Icons.notifications_rounded, rw, rs, onTap: () {}),
                                ],
                                rw,
                              ),

                              SizedBox(height: rh(30)),

                              // Privacy & Security Section
                              _buildSectionTitle(AppLocalizations.of(context)!.privacySecurity, rs),
                              SizedBox(height: rh(12)),
                              _buildGroupedTiles(
                                [
                                  _buildIconTile(AppLocalizations.of(context)!.privacySettings, Icons.privacy_tip_rounded, rw, rs, onTap: () {}),
                                  _buildIconTile(AppLocalizations.of(context)!.dataStorage, Icons.storage_rounded, rw, rs, onTap: () {}),
                                ],
                                rw,
                              ),

                              SizedBox(height: rh(30)),

                              // App Settings Section
                              _buildSectionTitle(AppLocalizations.of(context)!.appSettings, rs),
                              SizedBox(height: rh(12)),
                              _buildGroupedTiles(
                                [
                                  _buildIconTile(AppLocalizations.of(context)!.language, Icons.language_rounded, rw, rs, onTap: () => _showLanguageDialog(rw, rs)),
                                  _buildIconTile(AppLocalizations.of(context)!.theme, Icons.palette_rounded, rw, rs, onTap: () => _showThemeDialog(rw, rs)),
                                  _buildIconTile(AppLocalizations.of(context)!.units, Icons.straighten_rounded, rw, rs, onTap: () => _showUnitsDialog(rw, rs)),
                                ],
                                rw,
                              ),

                              SizedBox(height: rh(30)),

                              // Support Section
                              _buildSectionTitle(AppLocalizations.of(context)!.support, rs),
                              SizedBox(height: rh(12)),
                              _buildGroupedTiles(
                                [
                                  _buildIconTile(AppLocalizations.of(context)!.support, Icons.help_rounded, rw, rs, onTap: () {}),
                                  _buildIconTile(AppLocalizations.of(context)!.legal, Icons.description_rounded, rw, rs, onTap: () => _showLegalDialog(rw, rs)),
                                  _buildIconTile(AppLocalizations.of(context)!.aboutAlly, Icons.info_rounded, rw, rs, onTap: () => _showAboutAllyDialog(rw, rs)),
                                ],
                                rw,
                              ),

                              SizedBox(height: rh(30)),

                              _buildSectionTitle(AppLocalizations.of(context)!.account, rs),
                              SizedBox(height: rh(12)),
                              _buildGroupedTiles(
                                [
                                  _buildIconTile(
                                    AppLocalizations.of(context)!.exit,
                                    Icons.logout_rounded,
                                    rw, rs,
                                    onTap: () => _handleLogout(context),
                                  ),
                                ],
                                rw,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: rh(100))),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double Function(double) rs) {
    return Text(
      title,
      style: TextStyle(
        fontSize: rs(16),
        fontWeight: FontWeight.bold,
        color: const Color(0xFF888888),
      ),
    );
  }

  Widget _buildGroupedTiles(List<Widget> tiles, double Function(double) rw) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(rw(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: rw(10),
            offset: Offset(0, rw(2)),
          ),
        ],
      ),
      child: Column(
        children: tiles,
      ),
    );
  }

  Widget _buildIconTile(String title, IconData icon, double Function(double) rw, double Function(double) rs, {VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rw(14)),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.transparent : const Color(0xFFF0F0F0),
              width: 1, // Hairline borders are usually kept 1.0 or 0.5
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(rw(8)),
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(rw(8)),
              ),
              child: Icon(icon, color: const Color(0xFF4BAADF), size: rs(18)),
            ),
            SizedBox(width: rw(12)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: rs(15),
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: rs(16),
              color: isDark ? Colors.white54 : const Color(0xFF888888),
            ),
          ],
        ),
      ),
    );
  }

  // --- Dialogs with Dynamic Sizing Passed Down ---

  void _showLanguageDialog(double Function(double) rw, double Function(double) rs) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.read<LocaleProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildScrollableDialog(
        l10n.selectLanguage,
        Icons.language_rounded,
        const Color(0xFF4BAADF),
        [
          _buildDialogOption('English', _selectedLanguage == 'English', () {
            setState(() => _selectedLanguage = 'English');
            localeProvider.setLocale(const Locale('en'));
            Navigator.pop(context);
          }, rw, rs),
          _buildDialogOption('Español', _selectedLanguage == 'Español', () {
            setState(() => _selectedLanguage = 'Español');
            localeProvider.setLocale(const Locale('es'));
            Navigator.pop(context);
          }, rw, rs),
          _buildDialogOption('Français', _selectedLanguage == 'Français', () {
            setState(() => _selectedLanguage = 'Français');
            localeProvider.setLocale(const Locale('fr'));
            Navigator.pop(context);
          }, rw, rs),
          _buildDialogOption('Deutsch', _selectedLanguage == 'Deutsch', () {
            setState(() => _selectedLanguage = 'Deutsch');
            localeProvider.setLocale(const Locale('de'));
            Navigator.pop(context);
          }, rw, rs),
          _buildDialogOption('Türkçe', _selectedLanguage == 'Türkçe', () {
            setState(() => _selectedLanguage = 'Türkçe');
            localeProvider.setLocale(const Locale('tr'));
            Navigator.pop(context);
          }, rw, rs),
          _buildDialogOption('中文', _selectedLanguage == '中文', () {
            setState(() => _selectedLanguage = '中文');
            localeProvider.setLocale(const Locale('zh'));
            Navigator.pop(context);
          }, rw, rs),
        ],
        rw, rs,
      ),
    );
  }

  void _showThemeDialog(double Function(double) rw, double Function(double) rs) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.read<ThemeProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSimpleDialog(
        l10n.selectTheme,
        Icons.palette_rounded,
        const Color(0xFF4BAADF),
        [
          _buildDialogOption(l10n.systemDefault, _themeValue == 'system', () {
            setState(() => _themeValue = 'system');
            // Assuming system defaults to light/dark in logic, or passing a specific string if handled
            themeProvider.changeTheme('light');
            _saveSettings();
            Navigator.pop(context);
          }, rw, rs),
          _buildDialogOption(l10n.lightMode, _themeValue == 'light', () {
            setState(() => _themeValue = 'light');
            themeProvider.changeTheme('light');
            _saveSettings();
            Navigator.pop(context);
          }, rw, rs),
          _buildDialogOption(l10n.darkMode, _themeValue == 'dark', () {
            setState(() => _themeValue = 'dark');
            themeProvider.changeTheme('dark');
            _saveSettings();
            Navigator.pop(context);
          }, rw, rs),
        ],
        rw, rs,
      ),
    );
  }

  void _showAboutAllyDialog(double Function(double) rw, double Function(double) rs) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(rw(16)),
        padding: EdgeInsets.all(rw(24)),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(rw(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(rw(16)),
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.info_rounded, color: const Color(0xFF4BAADF), size: rs(32)),
            ),
            SizedBox(height: rw(16)),
            Text(
              AppLocalizations.of(context)!.about,
              style: TextStyle(
                fontSize: rs(24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: rw(8)),
            Text(
              AppLocalizations.of(context)!.motto,
              style: TextStyle(
                fontSize: rs(16),
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: rw(20)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rw(8)),
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(rw(12)),
              ),
              child: Text(
                AppLocalizations.of(context)!.version,
                style: TextStyle(
                  fontSize: rs(14),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(height: rw(24)),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.openingWebsite),
                    backgroundColor: const Color(0xFF4BAADF),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: rw(20), vertical: rw(16)),
                margin: EdgeInsets.symmetric(vertical: rw(6)),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(rw(16)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.visitWebsite,
                        style: TextStyle(
                          fontSize: rs(16),
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.open_in_new_rounded,
                      size: rs(18),
                      color: const Color(0xFF4BAADF),
                    ),
                  ],
                ),
              ),
            ),
            // ... Similar dynamic sizing for other buttons ...
            SizedBox(height: rw(20)),
            Text(
              AppLocalizations.of(context)!.copyright,
              style: TextStyle(
                fontSize: rs(12),
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: rw(20)),
          ],
        ),
      ),
    );
  }

  void _showLegalDialog(double Function(double) rw, double Function(double) rs) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(rw(16)),
        padding: EdgeInsets.all(rw(24)),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(rw(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(rw(16)),
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.gavel_rounded, color: const Color(0xFF4BAADF), size: rs(32)),
            ),
            SizedBox(height: rw(16)),
            Text(
              AppLocalizations.of(context)!.legal,
              style: TextStyle(
                fontSize: rs(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: rw(8)),
            Text(
              AppLocalizations.of(context)!.readPolicies,
              style: TextStyle(
                fontSize: rs(14),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: rw(24)),
            // Example Button with dynamic sizing
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.openingPrivacyPolicy),
                    backgroundColor: const Color(0xFF4BAADF),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: rw(20), vertical: rw(16)),
                margin: EdgeInsets.symmetric(vertical: rw(6)),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(rw(16)),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.privacyPolicy,
                        style: TextStyle(fontSize: rs(16), fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                    Icon(Icons.open_in_new_rounded, size: rs(18), color: const Color(0xFF4BAADF)),
                  ],
                ),
              ),
            ),
            // ... Repeat for Terms of Service ...
            SizedBox(height: rw(20)),
          ],
        ),
      ),
    );
  }

  void _showUnitsDialog(double Function(double) rw, double Function(double) rs) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSimpleDialog(
        l10n.selectUnits,
        Icons.straighten_rounded,
        const Color(0xFF4BAADF),
        [
          _buildDialogOption(l10n.metric, Provider.of<HealthProvider>(context, listen: false).units == 'metric', () {
            Provider.of<HealthProvider>(context, listen: false).setUnits('metric');
            Navigator.pop(context);
          }, rw, rs),
          _buildDialogOption(l10n.imperial, Provider.of<HealthProvider>(context, listen: false).units == 'imperial', () {
            Provider.of<HealthProvider>(context, listen: false).setUnits('imperial');
            Navigator.pop(context);
          }, rw, rs),
        ],
        rw, rs,
      ),
    );
  }

  // Scrollable dialog with fade effect
  Widget _buildScrollableDialog(String title, IconData icon, Color color, List<Widget> options, double Function(double) rw, double Function(double) rs) {
    return Container(
      margin: EdgeInsets.all(rw(16)),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(rw(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: rw(20)),
          Container(
            padding: EdgeInsets.all(rw(16)),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: rs(32)),
          ),
          SizedBox(height: rw(16)),
          Text(
            title,
            style: TextStyle(
              fontSize: rs(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: rw(20)),
          Flexible(
            child: Stack(
              children: [
                ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: options,
                ),
                Positioned(
                  bottom: 0, left: 0, right: 0, height: rw(60),
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.0),
                            Theme.of(context).scaffoldBackgroundColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: rw(20)),
        ],
      ),
    );
  }

  // Simple dialog without scrolling
  Widget _buildSimpleDialog(String title, IconData icon, Color color, List<Widget> options, double Function(double) rw, double Function(double) rs) {
    return Container(
      margin: EdgeInsets.all(rw(16)),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(rw(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: rw(20)),
          Container(
            padding: EdgeInsets.all(rw(16)),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: rs(32)),
          ),
          SizedBox(height: rw(16)),
          Text(
            title,
            style: TextStyle(
              fontSize: rs(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: rw(20)),
          Column(children: options),
          SizedBox(height: rw(20)),
        ],
      ),
    );
  }

  Widget _buildDialogOption(String text, bool isSelected, VoidCallback onTap, double Function(double) rw, double Function(double) rs) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: rw(16), vertical: rw(6)),
        padding: EdgeInsets.symmetric(horizontal: rw(20), vertical: rw(16)),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4BAADF).withValues(alpha: 0.1)
              : (Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white),
          borderRadius: BorderRadius.circular(rw(16)),
          border: isSelected ? Border.all(color: const Color(0xFF4BAADF), width: 2) : null,
          boxShadow: isSelected ? [] : [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black12,
              blurRadius: rw(10),
              offset: Offset(0, rw(2)),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: rs(16),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? const Color(0xFF4BAADF) : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: const Color(0xFF4BAADF), size: rs(24)),
          ],
        ),
      ),
    );
  }
}