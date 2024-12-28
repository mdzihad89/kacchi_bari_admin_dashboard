import 'package:flutter/material.dart';



class Responsive{
  static isMobile(BuildContext context)=>MediaQuery.sizeOf(context).width<850;
  static isTablet(BuildContext context)=>MediaQuery.sizeOf(context).width<1100 && MediaQuery.sizeOf(context).width>=850;
  static isDesktop(BuildContext context)=>MediaQuery.sizeOf(context).width>=1150;

}