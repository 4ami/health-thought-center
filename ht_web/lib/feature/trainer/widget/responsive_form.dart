import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_bloc.dart';
import 'package:ht_web/feature/trainer/bloc/trainer_event.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_web/data/model/new_course.dart';
import 'dart:developer';

class DeskTop extends StatefulWidget {
  const DeskTop({super.key});

  @override
  State<DeskTop> createState() => _DeskTopState();
}

class _DeskTopState extends State<DeskTop> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      width: 850,
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _left(),
            _right(),
          ],
        ),
      ),
    );
  }

  Expanded _right() => Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _mode(),
            _actions(context),
          ],
        ),
      );

  Expanded _left() => Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field(
              type: TextInputType.name,
              label: 'Course Name',
              controller: _cname,
              validator: (p0) {
                if (p0 == null || p0.isEmpty) return 'Required';
                return null;
              },
            ),
            _field(
              type: TextInputType.multiline,
              label: 'Course Description (Optional)',
              controller: _cdesc,
              isTextArea: true,
            ),
            _field(
              type: TextInputType.number,
              label: 'Course Duration (Minutes)',
              controller: _cdura,
              validator: (p0) {
                if (p0 == null || p0.isEmpty) return 'Required';
                if (int.tryParse(p0) == null) return 'Only numbers';
                return null;
              },
            ),
            SizedBox(
              width: 150,
              child: _field(
                type: TextInputType.number,
                label: 'Course Price',
                controller: _cprice,
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) return 'Required';
                  if (int.tryParse(p0) == null) return 'Only numbers';
                  return null;
                },
              ),
            ),
            _dueDate(),
          ],
        ),
      );

  Material _dueDate() {
    return Material(
      child: InputDatePickerFormField(
        firstDate: DateTime.now(),
        lastDate: DateTime(3000),
        onDateSaved: (value) {
          setState(() {
            date = "${value.year}-${value.month}-${value.day}";
            log(date);
          });
        },
      ),
    );
  }

  Material _mode() {
    return Material(
      child: SwitchListTile(
        title: const Text('Live Course'),
        value: isLive,
        subtitle: const Text("Switch it on if course is LIVE."),
        onChanged: (v) {
          setState(() {
            isLive = v;
          });
        },
      ),
    );
  }
}

class Mobile extends StatefulWidget {
  const Mobile({super.key});

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 600,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field(
              type: TextInputType.name,
              label: 'Course Name',
              controller: _cname,
              validator: (p0) {
                if (p0 == null || p0.isEmpty) return 'Name is Required';
                if (p0.length > 37) return 'Name is too long';
                return null;
              },
            ),
            _field(
              type: TextInputType.multiline,
              label: 'Course Description (Optional)',
              controller: _cdesc,
              isTextArea: true,
            ),
            _field(
              type: TextInputType.number,
              label: 'Course Duration (Minutes)',
              controller: _cdura,
              validator: (p0) {
                if (p0 == null || p0.isEmpty) return 'Duration is Required';
                if (int.tryParse(p0) == null) return 'Only numbers';
                return null;
              },
            ),
            SizedBox(
              width: 150,
              child: _field(
                type: TextInputType.number,
                label: 'Course Price',
                controller: _cprice,
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) return 'Price is Required';
                  if (int.tryParse(p0) == null) return 'Only numbers';
                  return null;
                },
              ),
            ),
            _dueDate(),
            _mode(),
            _actions(context),
          ],
        ),
      ),
    );
  }

  Material _mode() {
    return Material(
      child: SwitchListTile(
        title: const Text('Live Course'),
        value: isLive,
        subtitle: const Text("Switch it on if course is LIVE."),
        onChanged: (v) {
          setState(() {
            isLive = v;
          });
        },
      ),
    );
  }

  Material _dueDate() {
    return Material(
      child: InputDatePickerFormField(
        firstDate: DateTime.now(),
        lastDate: DateTime(3000),
        onDateSaved: (value) {
          setState(() {
            date = "${value.year}-${value.month}-${value.day}";
            log(date);
          });
        },
      ),
    );
  }
}

Row _actions(BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(
        onPressed: () => context.pop(),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          if (_formKey.currentState?.validate() == true) {
            _formKey.currentState?.save();
            if (date.isEmpty) return;
            final NewCourse course = NewCourse(
              name: _cname.text,
              duration: int.parse(_cdura.text),
              mode: isLive ? 'LIVE' : 'RECORDED',
              price: double.parse(_cprice.text),
              dueDate: date,
              description: _cdesc.text,
            );
            context
                .read<TrainerBLOC>()
                .add(TrainerAddCourseRequest(course: course));
          }
        },
        child: const Text('Add'),
      ),
    ],
  );
}

SizedBox _field({
  required TextInputType type,
  required String label,
  required TextEditingController controller,
  bool isTextArea = false,
  String? Function(String?)? validator,
}) {
  return SizedBox(
    width: 300,
    child: Material(
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: isTextArea ? 4 : 1,
        validator: validator,
        decoration: InputDecoration(
          label: Text(label),
          border: isTextArea ? const OutlineInputBorder() : null,
        ),
      ),
    ),
  );
}

final TextEditingController _cname = TextEditingController();
final TextEditingController _cdesc = TextEditingController();
final TextEditingController _cdura = TextEditingController();
final TextEditingController _cprice = TextEditingController(text: "0");
bool isLive = false;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

String date = '';
