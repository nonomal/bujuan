import 'package:bujuan/sheet_info/sheet_info_controller.dart';
import 'package:get/get.dart';

class SheetInfoBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SheetInfoController>(() => SheetInfoController());
  }

}