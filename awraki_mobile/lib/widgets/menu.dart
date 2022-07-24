import 'package:awraki_poc/shared.dart';
import 'package:flutter/material.dart';

import '../routes.dart';

Drawer menu(BuildContext context) => Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: 50,
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Account",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              Shared.keystore.address,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Routes.login);
                    },
                    icon: const Icon(
                      Icons.logout,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 20,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.article,
                size: 30,
              ),
              title: const Text(
                "Documents",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.document);
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.insert_drive_file,
                size: 30,
              ),
              title: const Text(
                "Drafts",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.draft);
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.verified,
                size: 30,
              ),
              title: const Text(
                "Verify",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.verify);
              },
            ),
          )
        ],
      ),
    );
