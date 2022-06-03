import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../repository/MemUserInfoRepos.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    var memUserInfoRepos = Provider.of<MemUserInfoRepos>(context, listen: false);
    _initLoading(memUserInfoRepos);
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'My Account',
              style: TextStyle(color: Colors.black),
            ),
            iconTheme: const IconThemeData(
              color: Colors.green,
            ),
            actions: [
              InkWell(
                  onTap: () {
                    _submitResult(memUserInfoRepos);
                  },
                  child: const Icon(Icons.done))
            ],
          ),
          body: Container(padding: const EdgeInsets.all(16), child: buildBody()),
        ),
      );
  }

  void _initLoading(MemUserInfoRepos memUserInfoRepos) {
    if(!isInit){
      _nameController.text = memUserInfoRepos.getName();
      _addressController.text = memUserInfoRepos.getAddress();
      _phoneController.text = memUserInfoRepos.getPhone();
      isInit = true;
    }
  }

  Widget buildBody() {
    return ListView(
      children: [
        buildForm(),
      ],
    );
  }

  Widget buildForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      child: Form(
          key: _formKey,
          child: Column(children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
            ),
            const SizedBox(height: 32),
            buildTitle(Icons.person, 'Full name'),
            const SizedBox(height: 16),
            nameField(),
            const SizedBox(height: 24),
            buildTitle(Icons.phone, 'Phone'),
            const SizedBox(height: 16),
            phoneField(),
            const SizedBox(height: 24),
            buildTitle(Icons.location_on, 'Address'),
            const SizedBox(height: 16),
            addressField(),
            const SizedBox(height: 16),
          ])),
    );
  }

  Widget buildTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }

  Widget addressField() {
    return TextFormField(
      validator: (value) => addressValidator(value!),
      controller: _addressController,
      decoration: InputDecoration(
          hintText: 'Enter your address',
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16))),
    );
  }

  Widget nameField() {
    return TextFormField(
      validator: (value) => nameValidator(value!),
      controller: _nameController,
      decoration: InputDecoration(
          hintText: 'Enter your full name',
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16))),
    );
  }

  Widget phoneField() {
    return TextFormField(
      validator: (value) => phoneValidator(value!),
      controller: _phoneController,
      decoration: InputDecoration(
          hintText: 'Enter your phone number',
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(16))),
    );
  }

  void _submitResult(MemUserInfoRepos memUserInfoRepos) {
    if (_formKey.currentState!.validate()) {
      memUserInfoRepos.setAllData(_addressController.text, _nameController.text, _phoneController.text);
      Navigator.pop(context);
    }
  }

  String? phoneValidator(String value) {
    if (value == null || value.isEmpty) {
      return "Enter phone number";
    } else if (!RegExp("[0-9]").hasMatch(value)) {
      return "It's not phone format";
    }
    return null;
  }

  String? nameValidator(String value) {
    if (value == null || value.isEmpty) {
      return "Enter your name";
    } else if (RegExp("[0-9]").hasMatch(value)) {
      return "Wrong name format";
    }
    return null;
  }

  String? addressValidator(String value) {
    if (value == null || value.isEmpty) {
      return "Enter your name";
    }
    return null;
  }
}
