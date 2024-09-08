// import 'dart:async';
// import 'dart:io';
// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
// import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';

// class PrintService {
//   final PrinterManager _printerManager = PrinterManager.instance;
//   BluetoothPrinter? _selectedPrinter;
//   StreamSubscription<PrinterDevice>? _discoverySubscription;
//   StreamSubscription<BTStatus>? _btStatusSubscription;
//   bool _isConnected = false;

//   PrintService() {
//     _init();
//   }

//   void _init() {
//     _btStatusSubscription = _printerManager.stateBluetooth.listen((status) {
//       if (status == BTStatus.connected) {
//         _isConnected = true;
//       } else {
//         _isConnected = false;
//         _scanAndConnectPrinter();
//       }
//     });
//     _scanAndConnectPrinter();
//   }

//   void _scanAndConnectPrinter() {
//     _discoverySubscription?.cancel();
//     _discoverySubscription = _printerManager
//         .discovery(type: PrinterType.bluetooth, isBle: false)
//         .listen((device) {
//       if (device.name == 'InnerPrinter') {
//         _selectedPrinter = BluetoothPrinter(
//           deviceName: device.name,
//           address: device.address,
//           typePrinter: PrinterType.bluetooth,
//           isBle: false,
//         );
//         _connectPrinter();
//         _discoverySubscription?.cancel();
//       }
//     });
//   }

//   Future<void> _connectPrinter() async {
//     if (_selectedPrinter == null) return;
//     await _printerManager.connect(
//       type: _selectedPrinter!.typePrinter,
//       model: BluetoothPrinterInput(
//         name: _selectedPrinter!.deviceName,
//         address: _selectedPrinter!.address!,
//         isBle: _selectedPrinter!.isBle ?? false,
//         autoConnect: true,
//       ),
//     );
//   }

//   Future<void> printReceipt({
//     required String action,
//     required String amount,
//     required String time,
//     required String phone,
//   }) async {
//     if (_selectedPrinter == null) {
//       print('No printer selected. Attempting to connect...');
//       _scanAndConnectPrinter();
//       await Future.delayed(Duration(seconds: 5)); // Wait for connection
//     }

//     if (_selectedPrinter == null) {
//       print('Failed to connect to printer');
//       return;
//     }

//     final profile = await CapabilityProfile.load(name: 'XP-N160I');
//     final generator = Generator(PaperSize.mm80, profile);

//     List<int> bytes = [];
//     bytes += generator.text('Impalapay Receipt',
//         styles: const PosStyles(align: PosAlign.center));
//     bytes += generator.text('Action: $action');
//     bytes += generator.text('Amount: $amount');
//     bytes += generator.text('Time: $time');
//     bytes += generator.text('Phone: $phone');
//     bytes += generator.cut();

//     try {
//       await _printerManager.send(
//           type: _selectedPrinter!.typePrinter, bytes: bytes);
//       print('Print job sent successfully');
//     } catch (e) {
//       print('Error sending print job: $e');
//     }
//   }

//   void dispose() {
//     _btStatusSubscription?.cancel();
//     _discoverySubscription?.cancel();
//   }
// }

// class BluetoothPrinter {
//   String? deviceName;
//   String? address;
//   bool? isBle;
//   PrinterType typePrinter;

//   BluetoothPrinter({
//     this.deviceName,
//     this.address,
//     this.isBle,
//     this.typePrinter = PrinterType.bluetooth,
//   });
// }