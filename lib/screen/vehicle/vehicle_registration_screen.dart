import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../const/app_colors.dart';
import '../../model/vehicle_model.dart';
import '../../provider/vehicle_provider.dart';
import '../../widget/custom_button.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  State<VehicleRegistrationScreen> createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState
    extends State<VehicleRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().loadVehicleTypes();
    });
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<VehicleProvider>();

    if (provider.selectedType == null) {
      _showSnack('Please select a vehicle type', isError: true);
      return;
    }
    if (provider.selectedContract == null) {
      _showSnack('Please select a contract', isError: true);
      return;
    }

    final success = await provider.registerVehicle(
      vehicleNumber: _numberCtrl.text.trim().toUpperCase(),
      vehicleName: _nameCtrl.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      final msg = provider.errorMessage.isNotEmpty
          ? provider.errorMessage   // "already registered" soft-success message
          : 'Vehicle registered successfully!';
      _showSnack(msg, isError: false);
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) context.go('/dashboard');
    } else {
      _showSnack(provider.errorMessage, isError: true);
    }
  }

  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.poppins(fontSize: 13)),
      backgroundColor: isError ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _TopHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Vehicle Registration Number'),
                    const SizedBox(height: 8),
                    _NumberField(controller: _numberCtrl),
                    const SizedBox(height: 20),
                    _label('Vehicle Name / Model'),
                    const SizedBox(height: 8),
                    _NameField(controller: _nameCtrl),
                    const SizedBox(height: 20),
                    _label('Vehicle Type'),
                    const SizedBox(height: 8),
                    const _VehicleTypeDropdown(),
                    const SizedBox(height: 20),
                    _label('Contract'),
                    const SizedBox(height: 8),
                    const _ContractDropdown(),
                    const SizedBox(height: 32),
                    Consumer<VehicleProvider>(
                      builder: (context, p, child) => CustomButton(
                        label: 'Register Vehicle',
                        isLoading: p.isSubmitting,
                        onTap: _submit,
                        icon: const Icon(Icons.directions_car_rounded,
                            size: 18, color: AppColors.primaryDark),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/dashboard'),
                        child: Text('Skip for now',
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(text,
        style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.3));
  }
}

// ── DARK HEADER ──────────────────────────────
class _TopHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 12, 20, 28),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/dashboard'),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.surface, size: 16),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vehicle Registration',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.surface)),
              Text('Register your vehicle to start trips',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.surface.withValues(alpha: 0.5))),
            ],
          ),
        ],
      ),
    );
  }
}

// ── VEHICLE NUMBER FIELD ──────────────────────
class _NumberField extends StatelessWidget {
  final TextEditingController controller;
  const _NumberField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\-]')),
        LengthLimitingTextInputFormatter(13),
      ],
      style: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 2),
      decoration: _inputDecoration(
        hint: 'MH-01-AB-1234',
        icon: Icons.pin_rounded,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Enter vehicle number';
        if (v.trim().length < 6) return 'Enter a valid vehicle number';
        return null;
      },
    );
  }
}

// ── VEHICLE NAME FIELD ────────────────────────
class _NameField extends StatelessWidget {
  final TextEditingController controller;
  const _NameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: _inputDecoration(
        hint: 'e.g. Toyota Innova',
        icon: Icons.directions_car_rounded,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Enter vehicle name / model';
        return null;
      },
    );
  }
}

InputDecoration _inputDecoration({required String hint, required IconData icon}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 14),
    prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.8)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1.8)),
  );
}

// ── VEHICLE TYPE DROPDOWN ─────────────────────
class _VehicleTypeDropdown extends StatelessWidget {
  const _VehicleTypeDropdown();

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleProvider>(
      builder: (context, p, child) {
        if (p.isLoadingTypes) return _LoadingField(label: 'Loading vehicle types...');

        if (p.vehicleTypes.isEmpty) {
          return _ErrorField(
            label: 'No vehicle types found',
            onRetry: p.loadVehicleTypes,
          );
        }

        return _StyledDropdown<VehicleType>(
          hint: 'Select vehicle type',
          icon: Icons.category_rounded,
          value: p.selectedType,
          items: p.vehicleTypes,
          onChanged: p.onVehicleTypeSelected,
        );
      },
    );
  }
}

// ── CONTRACT DROPDOWN ─────────────────────────
class _ContractDropdown extends StatelessWidget {
  const _ContractDropdown();

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleProvider>(
      builder: (context, p, child) {
        if (p.selectedType == null) {
          return _DisabledField(label: 'Select vehicle type first');
        }
        if (p.isLoadingContracts) return _LoadingField(label: 'Loading contracts...');

        if (p.contracts.isEmpty) {
          return _ErrorField(
            label: 'No contracts available',
            onRetry: () => p.onVehicleTypeSelected(p.selectedType!),
          );
        }

        return _StyledDropdown<Contract>(
          hint: 'Select contract',
          icon: Icons.handshake_rounded,
          value: p.selectedContract,
          items: p.contracts,
          onChanged: p.selectContract,
        );
      },
    );
  }
}

// ── SHARED DROPDOWN WIDGET ────────────────────
class _StyledDropdown<T> extends StatelessWidget {
  final String hint;
  final IconData icon;
  final T? value;
  final List<T> items;
  final void Function(T) onChanged;

  const _StyledDropdown({
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Row(children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 10),
            Text(hint,
                style: GoogleFonts.poppins(
                    color: AppColors.textSecondary, fontSize: 14)),
          ]),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary),
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(item.toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary)),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

// ── HELPER FIELD STATES ───────────────────────
class _LoadingField extends StatelessWidget {
  final String label;
  const _LoadingField({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        const SizedBox(
            width: 18, height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
        const SizedBox(width: 12),
        Text(label,
            style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
      ]),
    );
  }
}

class _DisabledField extends StatelessWidget {
  final String label;
  const _DisabledField({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.6))),
    );
  }
}

class _ErrorField extends StatelessWidget {
  final String label;
  final VoidCallback onRetry;
  const _ErrorField({required this.label, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        const Icon(Icons.warning_rounded, color: AppColors.error, size: 18),
        const SizedBox(width: 10),
        Expanded(
            child: Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.error))),
        TextButton(
          onPressed: onRetry,
          child: Text('Retry',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark)),
        ),
      ]),
    );
  }
}
