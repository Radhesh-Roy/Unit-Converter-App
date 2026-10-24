import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/unit_converter_provider.dart';
import '../widgets/category_tabs.dart';
import '../widgets/unit_dropdown.dart';
import '../widgets/result_card.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<UnitConverterProvider>(context, listen: false);
    _controller = TextEditingController(text: provider.inputValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UnitConverterProvider>(context);

    // Keep controller text updated if provider changes input externally
    if (_controller.text != provider.inputValue &&
        !FocusScope.of(context).hasFocus) {
      _controller.text = provider.inputValue;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Unit Converter',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CategoryTabs(),
            const SizedBox(height: 24),

            // Enter Value Field
            Text(
              'Enter Value',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: InputBorder.none,
                  hintText: 'Enter value',
                ),
                onChanged: (val) {
                  provider.setInputValue(val);
                },
              ),
            ),
            const SizedBox(height: 20),

            // From and To Dropdowns with Swap Button in the center
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    UnitDropdown(
                      label: 'From',
                      selectedUnit: provider.fromUnit,
                      units: provider.currentUnits,
                      onChanged: (unit) {
                        if (unit != null) provider.setFromUnit(unit);
                      },
                    ),
                    const SizedBox(height: 20),
                    UnitDropdown(
                      label: 'To',
                      selectedUnit: provider.toUnit,
                      units: provider.currentUnits,
                      onChanged: (unit) {
                        if (unit != null) provider.setToUnit(unit);
                      },
                    ),
                  ],
                ),
                // Floating Swap Button
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(37, 99, 235, 0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: const Color(0xFF2563EB),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          provider.swapUnits();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.swap_vert_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Result Display Card
            const ResultCard(),
          ],
        ),
      ),
    );
  }
}
