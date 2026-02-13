import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resedential_app/screens/widgets/shimmer_widget.dart';
import 'package:resedential_app/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class FireBrigadeListScreen extends StatefulWidget {
  const FireBrigadeListScreen({super.key});

  @override
  State<FireBrigadeListScreen> createState() => _FireBrigadeListScreenState();
}

class _FireBrigadeListScreenState extends State<FireBrigadeListScreen> {
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<_FireBrigadeStation> _allStations = [
    _FireBrigadeStation(
      name: 'Saddar Fire Station',
      phone: '16',
    ),
    _FireBrigadeStation(
      name: 'Central Fire Station KPT',
      phone: '16',
    ),
    _FireBrigadeStation(
      name: 'Fire Brigade Station',
      phone: '16',
    ),
    _FireBrigadeStation(
      name: 'Manzoor Colony Fire Station',
      phone: '16',
    ),
    _FireBrigadeStation(
      name: 'CBC Fire Station',
      phone: '16',
    ),
    _FireBrigadeStation(
      name: 'Gulshan-e-Iqbal Fire Station',
      phone: '16',
    ),
    _FireBrigadeStation(
      name: 'NAZIMABAD FIRE STATION',
      phone: '16',
    ),
    _FireBrigadeStation(
      name: 'Gulistan-e-Jauhar Fire Station',
      phone: '16',
    ),
    _FireBrigadeStation(
      name: 'North Karachi Fire Brigade Station',
      phone: '16',
    ),
    _FireBrigadeStation(
      name: 'Karsaz Fire Station',
      phone: '16',
    ),
  ];

  List<_FireBrigadeStation> get _filteredStations {
    if (_searchQuery.isEmpty) {
      return _allStations;
    }
    return _allStations
        .where((station) =>
            station.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width > 600 ? 24.0 : (width > 400 ? 20.0 : AppTheme.horizontalPadding);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF7F7F7),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.white,
        appBar: AppBar(
          backgroundColor: AppTheme.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.black, size: 22),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: const Text(
            'Emergency Services',
            style: TextStyle(
              color: AppTheme.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: _isLoading
              ? _buildShimmerContent(horizontalPadding)
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
                      child: _buildSearchBar(),
                    ),
                    Expanded(
                      child: _filteredStations.isEmpty
                          ? _buildEmptyState()
                          : ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                              itemCount: _filteredStations.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final station = _filteredStations[index];
                                return _FireBrigadeCard(
                                  station: station,
                                  onCall: () => _callFireBrigade(station.phone),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.pageBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.textMuted.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search your Location',
          hintStyle: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 14,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.search,
              color: AppTheme.textMuted,
              size: 20,
            ),
            onPressed: () {
              // Search functionality handled by controller listener
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(
          color: AppTheme.black,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No fire stations found',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callFireBrigade(String phoneNumber) async {
    try {
      // Clean phone number - remove spaces, dashes, and other non-digit characters except +
      final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      
      if (cleanedNumber.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid phone number'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }
      
      // Use tel: scheme with the cleaned number - parse as URI
      final phoneUri = Uri.parse('tel:$cleanedNumber');
      
      // Try launching with externalApplication mode first (more reliable for tel:)
      try {
        final launched = await launchUrl(
          phoneUri,
          mode: LaunchMode.externalApplication,
        );
        
        if (!launched && mounted) {
          // Fallback to platformDefault if externalApplication fails
          final launched2 = await launchUrl(
            phoneUri,
            mode: LaunchMode.platformDefault,
          );
          
          if (!launched2 && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unable to make call. Please dial $cleanedNumber manually'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        // If externalApplication fails, try platformDefault
        try {
          await launchUrl(
            phoneUri,
            mode: LaunchMode.platformDefault,
          );
        } catch (e2) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unable to make call. Please dial $cleanedNumber manually'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to make call. Please dial $phoneNumber manually'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _buildShimmerContent(double horizontalPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Search bar shimmer
          ShimmerContainer(
            width: double.infinity,
            height: 48,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 24),
          // List items shimmer
          ...List.generate(5, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    ShimmerContainer(
                      width: 50,
                      height: 50,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShimmerContainer(
                        width: double.infinity,
                        height: 20,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    ShimmerContainer(
                      width: 40,
                      height: 40,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _FireBrigadeStation {
  _FireBrigadeStation({
    required this.name,
    required this.phone,
  });

  final String name;
  final String phone;
}

class _FireBrigadeCard extends StatelessWidget {
  const _FireBrigadeCard({
    required this.station,
    required this.onCall,
  });

  final _FireBrigadeStation station;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.textMuted.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fire_extinguisher,
              color: AppTheme.textSecondary,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              station.name,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.phone,
                color: AppTheme.primaryGold,
                size: 20,
              ),
            ),
            onPressed: onCall,
          ),
        ],
      ),
    );
  }
}
