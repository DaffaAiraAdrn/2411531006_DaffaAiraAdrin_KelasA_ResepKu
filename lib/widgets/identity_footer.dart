import 'package:flutter/material.dart';


const String kNIM = '2411531006';
const String kNama = 'Daffa Aira Adrin';

class IdentityFooter extends StatelessWidget {
    const IdentityFooter({super.key, required this.child});

    final Widget child;

    @override
    Widget build(BuildContext context){
        return Column(
            children: [
                Expanded(
                    child:MediaQuery.removePadding(
                        context: context,
                        removeBottom: true,
                        child:child,
                    ),
                ),
                Material(
                    color: Colors.black87,
                    child: SafeArea(
                        top:false,
                        child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Text(
                                    '$kNIM • $kNama',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                            ),
                        ),
                    ),
                ),
            ],
        );
    }

}