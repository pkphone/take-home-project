import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:take_home_project/controller/data_controller.dart';
import 'package:take_home_project/res/custom_colors.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final dataController = Get.find<DataController>();
  late String _selectedDate;
  late String _bookDate;

  @override
  void initState() {
    _selectedDate = '';
    _bookDate = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.primary,
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectableDayPredicate: (DateTime dateTime) {
                      // disable and enable date according to the slots
                      for (int i = 0; i < dataController.slots.length; i++) {
                        List<String> ymd =
                            dataController.slots[i].date.split('-');
                        bool sameDate = false;
                        if (dateTime ==
                            DateTime(int.parse(ymd[0]), int.parse(ymd[1]),
                                int.parse(ymd[2]))) {
                          sameDate = true;
                        }
                        bool available = false;
                        for (int j = 0;
                            j < dataController.slots[i].slots.length;
                            j++) {
                          if (dataController.slots[i].slots[j].available) {
                            available = true;
                            break;
                          }
                        }
                        if (sameDate && available) {
                          return true;
                        }
                      }
                      return false;
                    }),
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text('Book on $_bookDate'),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: _renderTime(),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDate = args.value.toString();
      _bookDate = DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse(
          _selectedDate)); // convert date to Book on Tuesday, June 7, 2022 format
    });
  }

  // render list of available time
  _renderTime() {
    List<Widget> widgets = [];
    // extract from the slots and get the time
    for (int i = 0; i < dataController.slots.length; i++) {
      List<String> dateSplit = _selectedDate.split(' ');
      if (dateSplit[0] == dataController.slots[i].date) {
        for (int j = 0; j < dataController.slots[i].slots.length; j++) {
          if (dataController.slots[i].slots[j].available) {
            List<String> timeSplit =
                dataController.slots[i].slots[j].startTime.split(' ');
            widgets.add(Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: Text(timeSplit[1])));
          }
        }
      }
    }
    return widgets;
  }
}
