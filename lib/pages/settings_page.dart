import 'package:earthquake_reader/utils/helper_fxn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:earthquake_reader/providers/app_data_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Consumer<AppDataProvider>(
          builder: (context, provider, child) =>
              ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  Text('Time Settings', style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium,),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Start Time'),
                          subtitle: Text(provider.startTime),
                          trailing: IconButton(
                            onPressed: () async {
                              final date = await selectDate();
                              if(date!= null) {
                                provider.setStartTime(date);
                              }
                            },
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ),
                        ListTile(
                          title: const Text('End Time'),
                          subtitle: Text(provider.endTime),
                          trailing: IconButton(
                            onPressed: () async {
                              final date = await selectDate();
                              if(date!= null) {
                                provider.setEndTime(date);
                              }
                            },
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ),
                        ElevatedButton(
                            onPressed:() {
                              provider.getEarthquakeData();
                              showMsg(context, 'Updated');
                              },
                            child: const Text('Update Time Changes'),
                        )
                      ],
                    ),
                  )
                ],
              ),
        )
    );
  }

    Future<String?> selectDate() async {
      final dt = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      );
      if (dt != null) {
        return getFormattedDataTime(dt.millisecondsSinceEpoch);
      }
      return null;
    }
  }

