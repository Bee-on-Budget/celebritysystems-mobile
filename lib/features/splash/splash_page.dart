// class SplashPage extends StatefulWidget {
//   const SplashPage({super.key});

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   @override
//   void initState() {
//     super.initState();

//     context.read<AuthBloc>().add(AuthGetUserLocalInfo());
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(const Duration(seconds: 3), () {
//       print('token ${context.read<AuthBloc>().token}');

//       print('role ${context.read<AuthBloc>().role}');

//       if (context.read<AuthBloc>().token == null) {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (_) => const LoginPage()));
//       } else {
//         if (context.read<AuthBloc>().role ==
//             ConstManager.warehouseManagerRole) {
//           Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (_) => const WarehouseHomePage()));
//         } else if (context.read<AuthBloc>().role ==
//             ConstManager.deliveryManagerRole) {
//           Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (_) => const DeliveryHomePage()));
//         } else {
//           Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (_) => BottomNavigationBarWidget()));
//         }
//       }
//     });
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SizedBox(
//           height: 1200.h,
//           width: 1200.h,
//           child: Image.asset(AssetImageManager.logo),
//         ),
//       ),
//     );
//   }
// }
