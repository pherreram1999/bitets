import 'package:flutter/material.dart';

class AsyncPickerField extends StatelessWidget {
  const AsyncPickerField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.enabled,
    required this.onTap,
    this.onClear,
  });

  final String label;
  final IconData icon;
  final String? value;
  final bool enabled;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasValue = value != null && value!.isNotEmpty;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
          suffixIcon: !enabled
              ? null
              : (hasValue && onClear != null
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Limpiar',
                        onPressed: onClear,
                      )
                    : Icon(
                        hasValue ? Icons.edit_outlined : Icons.search,
                        color: colorScheme.onSurfaceVariant,
                      )),
        ),
        child: Text(
          hasValue ? value! : 'Tocar para buscar...',
          style: TextStyle(
            color: hasValue
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
