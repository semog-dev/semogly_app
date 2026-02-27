import 'package:flutter/material.dart';
import 'package:semogly_app/core/theme/app_styles.dart';

class OtpField extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;
  final Function(String) onChanged;

  const OtpField({
    super.key,
    this.length = 6,
    required this.onCompleted,
    required this.onChanged,
  });

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    // RECURSO DE COLAR: Se o valor tiver mais de 1 caractere, tentamos preencher os outros
    if (value.length > 1) {
      _handlePaste(value);
      return;
    }

    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    _notifyListeners();
  }

  void _handlePaste(String data) {
    for (int i = 0; i < widget.length; i++) {
      if (i < data.length) {
        _controllers[i].text = data[i];
      } else {
        _controllers[i].clear();
      }
    }

    // Move o foco para o último campo preenchido ou o último da lista
    int nextFocus = data.length < widget.length
        ? data.length
        : widget.length - 1;
    _focusNodes[nextFocus].requestFocus();

    _notifyListeners();
  }

  void _notifyListeners() {
    String code = _controllers.map((c) => c.text).join();
    widget.onChanged(code);
    if (code.length == widget.length) {
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.length,
        (index) => SizedBox(
          width: 45,
          child: TextFormField(
            autofillHints: const [AutofillHints.oneTimeCode],
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            onChanged: (value) => _onChanged(value, index),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: AppStyles.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              counterText: "", // Esconde o contador de caracteres
              filled: true,
              fillColor: AppStyles.background,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppStyles.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppStyles.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
