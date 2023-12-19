import 'package:flutter/material.dart';
class ApiData {

  static const String domainPath = "https://test.mlmreadymade.com/token_app/jhg7q/";
  static const String registerPath = "${domainPath}register";
  static const String checkAddress = "${domainPath}user/check_useraddress";
  static const String dashboard = "${domainPath}user/dashboard";
  static const String getTransferFund = "${domainPath}fund/get_transfer_wallet";
  static const String transferFund = "${domainPath}fund/transfer";
  static const String sendOtp = "${domainPath}fund/send_otp";
  static const String withdraw = "${domainPath}fund/fund_withdraw";
  static const String packages = "${domainPath}membership/get_packages";
  static const String autoTopup = "${domainPath}membership/auto_topup";
  static const String supportType = "${domainPath}support/support_type";
  static const String support = "${domainPath}support";
  static const String supportList = "${domainPath}support/list";
  static const String transaction = "${domainPath}transaction";
  static const String transactionIncome = "${domainPath}transaction/incomes";
  static const String editProfile = "${domainPath}profile/edit_profile";
  static const String userDetail = "${domainPath}user/info";
  static const String claimRoi = "${domainPath}fund/roi_claim";
  static const String teamGeneration = "${domainPath}team/generation_team";
  static const String levelStatus = "${domainPath}user/level_status";
  static const String rewards = "${domainPath}user/rewards";


}