import 'package:flutter/material.dart';

/// Экран бронирования стола (Заявка на начало пути).
///
/// Здесь гость (герой) может оставить свои данные для бронирования.
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _guestsController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateTimeController.dispose();
    _guestsController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    // Скрываем клавиатуру
    FocusScope.of(context).unfocus();

    // Показываем уведомление
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Герой, ваша заявка принята. Наши проводники свяжутся с вами в ближайшее время.',
          style: TextStyle(
            fontFamily: 'Museo Sans',
            color: Color(0xFFF2EDE4),
          ),
        ),
        backgroundColor: Color(0xFF2A2826),
        duration: Duration(seconds: 3),
      ),
    );

    // Возвращаемся назад
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF3D3A38);
    const textColor = Color(0xFFF2EDE4);
    const accentColor = Color(0xFF7BA5B8);
    const buttonColor = Color(0xFF8B1A1A);
    const fontFamily = 'Museo Sans';
    // Прозрачность 0.1 согласно дизайн-системе для разделителей
    final fieldUnderlineColor = textColor.withValues(alpha: 0.1);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Бронирование',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _nameController,
              hint: 'Имя',
              fontFamily: fontFamily,
              textColor: textColor,
              underlineColor: fieldUnderlineColor,
              accentColor: accentColor,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _phoneController,
              hint: 'Телефон',
              fontFamily: fontFamily,
              textColor: textColor,
              underlineColor: fieldUnderlineColor,
              accentColor: accentColor,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _dateTimeController,
              hint: 'Дата и время',
              fontFamily: fontFamily,
              textColor: textColor,
              underlineColor: fieldUnderlineColor,
              accentColor: accentColor,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _guestsController,
              hint: 'Количество гостей',
              fontFamily: fontFamily,
              textColor: textColor,
              underlineColor: fieldUnderlineColor,
              accentColor: accentColor,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _commentController,
              hint: 'Комментарий (повод, аллергии)',
              fontFamily: fontFamily,
              textColor: textColor,
              underlineColor: fieldUnderlineColor,
              accentColor: accentColor,
              maxLines: 3,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: textColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Отправить заявку',
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String fontFamily,
    required Color textColor,
    required Color underlineColor,
    required Color accentColor,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontFamily: fontFamily,
        color: textColor,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          color: textColor.withOpacity(0.5),
        ),
        filled: false,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: underlineColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: accentColor),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}
