import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../providers/health_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  String _themeValue = 'system'; // system, light, dark
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
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? false;
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
    
    // Update language display based on current locale
    final currentLocale = Localizations.localeOf(context);
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

  void _handleBack() {
    _controller.reverse().then((_) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Get display strings based on current values
    final String themeDisplay = _themeValue == 'system' 
        ? l10n.systemDefault 
        : _themeValue == 'light' 
            ? l10n.lightMode 
            : l10n.darkMode;
    
    final healthProvider = Provider.of<HealthProvider>(context);
    final String unitsDisplay = healthProvider.units == 'metric' 
        ? l10n.metric 
        : l10n.imperial;
    
    return WillPopScope(
      onWillPop: () async {
        _handleBack();
        return false;
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
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: _handleBack,
                                    child: const Icon(Icons.chevron_left_rounded, size: 28),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    AppLocalizations.of(context)!.settings,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              
                              // Profile Section
                              _buildSectionTitle(AppLocalizations.of(context)!.profile),
                              const SizedBox(height: 12),
                              _buildGroupedTiles([
                                _buildIconTile(AppLocalizations.of(context)!.yourProfile, Icons.person_rounded, onTap: () {}),
                                _buildIconTile(AppLocalizations.of(context)!.pushNotifications, Icons.notifications_rounded, onTap: () {}),
                              ]),
                              
                              const SizedBox(height: 30),
                              
                              // Privacy & Security Section
                              _buildSectionTitle(AppLocalizations.of(context)!.privacySecurity),
                              const SizedBox(height: 12),
                              _buildGroupedTiles([
                                _buildIconTile(AppLocalizations.of(context)!.privacySettings, Icons.privacy_tip_rounded, onTap: () {}),
                                _buildIconTile(AppLocalizations.of(context)!.dataStorage, Icons.storage_rounded, onTap: () {}),
                              ]),
                              
                              const SizedBox(height: 30),
                              
                              // App Settings Section
                              _buildSectionTitle(AppLocalizations.of(context)!.appSettings),
                              const SizedBox(height: 12),
                              _buildGroupedTiles([
                                _buildIconTile(AppLocalizations.of(context)!.language, Icons.language_rounded, onTap: () => _showLanguageDialog()),
                                _buildIconTile(AppLocalizations.of(context)!.theme, Icons.palette_rounded, onTap: () => _showThemeDialog()),
                                _buildIconTile(AppLocalizations.of(context)!.units, Icons.straighten_rounded, onTap: () => _showUnitsDialog()),
                              ]),
                              
                              const SizedBox(height: 30),
                              
                              // Support Section
                              _buildSectionTitle(AppLocalizations.of(context)!.support),
                              const SizedBox(height: 12),
                              _buildGroupedTiles([
                                _buildIconTile(AppLocalizations.of(context)!.support, Icons.help_rounded, onTap: () {}),
                                _buildIconTile(AppLocalizations.of(context)!.legal, Icons.description_rounded, onTap: () => _showLegalDialog()),
                                _buildIconTile(AppLocalizations.of(context)!.aboutAlly, Icons.info_rounded, onTap: () => _showAboutAllyDialog()),
                              ]),
                            ],
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF888888),
      ),
    );
  }

  Widget _buildGroupedTiles(List<Widget> tiles) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: tiles,
      ),
    );
  }

  Widget _buildIconTile(String title, IconData icon, {VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.transparent : const Color(0xFFF0F0F0),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF4BAADF), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isDark ? Colors.white54 : const Color(0xFF888888),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context)!;
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
            MyApp.setLocale(context, const Locale('en'));
            Navigator.pop(context);
          }),
          _buildDialogOption('Español', _selectedLanguage == 'Español', () {
            setState(() => _selectedLanguage = 'Español');
            MyApp.setLocale(context, const Locale('es'));
            Navigator.pop(context);
          }),
          _buildDialogOption('Français', _selectedLanguage == 'Français', () {
            setState(() => _selectedLanguage = 'Français');
            MyApp.setLocale(context, const Locale('fr'));
            Navigator.pop(context);
          }),
          _buildDialogOption('Deutsch', _selectedLanguage == 'Deutsch', () {
            setState(() => _selectedLanguage = 'Deutsch');
            MyApp.setLocale(context, const Locale('de'));
            Navigator.pop(context);
          }),
          _buildDialogOption('Türkçe', _selectedLanguage == 'Türkçe', () {
            setState(() => _selectedLanguage = 'Türkçe');
            MyApp.setLocale(context, const Locale('tr'));
            Navigator.pop(context);
          }),
          _buildDialogOption('中文', _selectedLanguage == '中文', () {
            setState(() => _selectedLanguage = '中文');
            MyApp.setLocale(context, const Locale('zh'));
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    final l10n = AppLocalizations.of(context)!;
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
            MyApp.setThemeMode(context, ThemeMode.system);
            _saveSettings();
            Navigator.pop(context);
          }),
          _buildDialogOption(l10n.lightMode, _themeValue == 'light', () {
            setState(() => _themeValue = 'light');
            MyApp.setThemeMode(context, ThemeMode.light);
            _saveSettings();
            Navigator.pop(context);
          }),
          _buildDialogOption(l10n.darkMode, _themeValue == 'dark', () {
            setState(() => _themeValue = 'dark');
            MyApp.setThemeMode(context, ThemeMode.dark);
            _saveSettings();
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  void _showAboutAllyDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.info_rounded, color: Color(0xFF4BAADF), size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.about,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.healthClosestAlly,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                AppLocalizations.of(context)!.version,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                // Open website
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.openingWebsite),
                    backgroundColor: const Color(0xFF4BAADF),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                // TODO: Add URL launcher to open website
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.open_in_new_rounded,
                      size: 18,
                      color: Color(0xFF4BAADF),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Open Apache 2.0 license link
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.licensedApache),
                    backgroundColor: const Color(0xFF4BAADF),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
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
                        AppLocalizations.of(context)!.licensedApache2Short,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.gavel_rounded,
                      size: 18,
                      color: Color(0xFF4BAADF),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.copyright,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showLegalDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4BAADF).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.gavel_rounded, color: Color(0xFF4BAADF), size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.legal,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.readPolicies,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                // Open Privacy Policy link
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.openingPrivacyPolicy),
                    backgroundColor: const Color(0xFF4BAADF),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                // TODO: Add URL launcher to open privacy policy web page
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
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
                        AppLocalizations.of(context)!.privacyPolicy,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.open_in_new_rounded,
                      size: 18,
                      color: Color(0xFF4BAADF),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Open Terms of Service link
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.openingTerms),
                    backgroundColor: const Color(0xFF4BAADF),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                // TODO: Add URL launcher to open terms of service web page
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
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
                        AppLocalizations.of(context)!.termsOfService,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.open_in_new_rounded,
                      size: 18,
                      color: Color(0xFF4BAADF),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showUnitsDialog() {
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
          }),
          _buildDialogOption(l10n.imperial, Provider.of<HealthProvider>(context, listen: false).units == 'imperial', () {
            Provider.of<HealthProvider>(context, listen: false).setUnits('imperial');
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  // Scrollable dialog with fade effect for many options (like language)
  Widget _buildScrollableDialog(String title, IconData icon, Color color, List<Widget> options) {
    return Container(
      margin: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            child: Stack(
              children: [
                ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: options,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 60,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Simple dialog without scrolling for few options (like theme, units)
  Widget _buildSimpleDialog(String title, IconData icon, Color color, List<Widget> options) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: options,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDialogOption(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4BAADF).withOpacity(0.1)
              : (Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: const Color(0xFF4BAADF), width: 2) : null,
          boxShadow: isSelected ? [] : [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? const Color(0xFF4BAADF) : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF4BAADF),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
