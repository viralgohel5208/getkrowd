// API endpints

import 'package:getkrowd/api/ModelManager.dart';

const String methodAdminLogin = "adminLogin";
const String methodScanQRCode = "scanQrCode";
const String methodAddCouponValue = "addCouponValue";

String postLoginEndpoint =
    "${ModelManager.domainURL}apiKey=${ModelManager.shared.apiKey}&method=$methodAdminLogin&userName=${ModelManager.shared.userName}&password=${ModelManager.shared.passWord}";

String postAddCouponValue =
    "${ModelManager.domainURL}apiKey=${ModelManager.shared.apiKey}&method=$methodAddCouponValue&userName=${ModelManager.shared.userName}&password=${ModelManager.shared.passWord}";
