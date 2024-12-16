import 'package:earthquake_reader/pages/settings_page.dart';
import 'package:earthquake_reader/providers/app_data_provider.dart';
import 'package:earthquake_reader/utils/helper_fxn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void didChangeDependencies() {
    Provider.of<AppDataProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquake App'),
        actions: [
          IconButton(onPressed: _showSortingDialog,
              icon: const Icon(Icons.sort),
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Consumer<AppDataProvider> (
        builder: (context, provider, child) => provider.hasDataLoaded ? 
        provider.earthquakeModels!.features!.isEmpty ?
        const Center(child: Text('No record found'),) :
        ListView.builder(
          itemCount: provider.earthquakeModels!.features!.length,
          itemBuilder: (context, index) {
            final data = provider.earthquakeModels!.features![index].properties!;
            return ListTile(
              title: Text(data.place ?? data.title ?? 'Unknown'),
              subtitle: Text(getFormattedDataTime(data.time!, 'EEE MM dd yyyy hh:mm a')),
              trailing: Chip(
                avatar: data.alert == null ? null :
                CircleAvatar(
                  backgroundColor: provider.getAlertColor(data.alert!),
                ),
                label: Text('${data.mag}'),
              ),
            );
        },    
        ) : const Center(
          child: Text('Please Wait...'),
        ),
      ),

    );
  }
  void _showSortingDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(
        title: const Text ('Sort by'),
        content: Consumer<AppDataProvider>(
          builder: (context, provider, child) => Column (
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioGroup(groupValue: provider.orderBy,
                  value: 'magnitude',
                  label: 'Magnitude-Desc',
                  onChange: (value) {
                    provider.setOrder(value!);
                  },
              ),
              RadioGroup(groupValue: provider.orderBy,
                value: 'magnitude-asc',
                label: 'Magnitude-Asc',
                onChange: (value) {
                  provider.setOrder(value!);
                },
              ),
              RadioGroup(groupValue: provider.orderBy,
                value: 'time',
                label: 'Time-Desc',
                onChange: (value) {
                  provider.setOrder(value!);
                },
              ),
              RadioGroup(groupValue: provider.orderBy,
                value: 'time-asc',
                label: 'Time-Asc',
                onChange: (value) {
                  provider.setOrder(value!);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
          )
        ],
    )
    );
  }
}

class RadioGroup extends StatelessWidget {
  final String groupValue;
  final String value;
  final String label;
  final Function(String?) onChange;

  const RadioGroup({
    super.key, required this.groupValue, required this.value, required this.label, required this.onChange,
});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChange,
        ),
        Text(label)
      ],
    );
  }
}
