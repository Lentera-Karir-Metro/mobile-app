import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Input field dengan rounded corners untuk form input
/// Digunakan di Auth screens (login, register, reset password)
///
/// Fitur:
/// - Border ungu saat di-focus (efek ungu saat diklik)
/// - Eye icon toggle untuk password field
/// - Label dan hint text
/// - Form validation support
/// - Auto scroll when focused (via onFocusChange callback)
class PrimaryTextField extends StatefulWidget {
  /// Hint text yang muncul di dalam field (placeholder)
  final String? hintText;

  /// Label text yang muncul di atas field
  final String? labelText;

  /// Apakah text harus disembunyikan (untuk password)
  /// Default: false
  final bool obscureText;

  /// Menampilkan eye icon untuk toggle visibility password
  /// Default: false
  final bool showPasswordToggle;

  /// Controller untuk mengakses value dari luar widget
  final TextEditingController? controller;

  /// Validator function untuk form validation
  final String? Function(String?)? validator;

  /// Tipe keyboard yang akan muncul
  final TextInputType? keyboardType;

  /// Jumlah baris maksimal (1 = single line)
  /// Default: 1
  final int? maxLines;

  /// Jika true, field diset menjadi read-only (tidak bisa diketik)
  /// Default: false
  final bool readOnly;

  /// Jika false, field dinonaktifkan (tidak menerima input)
  /// Default: true
  final bool enabled;

  /// Callback when focus changes - useful for scrolling into view
  final Function(bool hasFocus)? onFocusChange;

  const PrimaryTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled = true,
    this.onFocusChange,
  });

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  // State untuk toggle visibility password
  late bool _isObscured;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    widget.onFocusChange?.call(_focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label text (opsional)
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Text field
        SizedBox(
          // Height: AppDimensions.inputHeight (49px dari analisis)
          height: widget.maxLines == 1 ? AppDimensions.inputHeight : null,
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: _isObscured,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            // Input text style: body1 dengan color textPrimary
            style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              // Hint text style: body1 dengan color textSecondary (#747474)
              hintText: widget.hintText,
              hintStyle: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),

              // Background: cardBackground (#FFFFFF)
              filled: true,
              fillColor: AppColors.cardBackground,

              // Content padding untuk centering text
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
                vertical: 12,
              ),

              // Border: divider (#F9F9F9) 1px saat tidak focus
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                borderSide: BorderSide(color: AppColors.divider, width: 1),
              ),

              // Focus border: primaryPurple (#661FFF) 2px saat diklik (EFEK UNGU)
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                borderSide: const BorderSide(
                  color: AppColors.primaryPurple, // Efek ungu saat focus
                  width: 2,
                ),
              ),

              // Error border (merah saat validation error)
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),

              // Error border saat focus
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),

              // Eye icon untuk password toggle (opsional)
              suffixIcon: widget.showPasswordToggle
                  ? IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        size: AppDimensions.iconLarge, // 24px
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
