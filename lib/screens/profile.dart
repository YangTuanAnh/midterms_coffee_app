import 'package:flutter/material.dart';
import 'package:midterms_coffee_app/config.dart';

class Profile extends StatefulWidget {
  final String initialName;

  const Profile({required this.initialName, super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileInfo _profile = ProfileInfo("", "", "", "");

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSave() {
    Navigator.pop(context, _profile.name);
    _saveProfile();
  }

  Future<void> _loadProfile() async {
    ProfileInfo profile = await ProfileManager.getProfile();
    setState(() {
      _profile = profile;
    });
  }

  Future<void> _saveProfile() async {
    await ProfileManager.saveProfile(_profile);
  }

  bool _isEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primaryColor)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        leading: BackButton(
          color: Colors.black,
          onPressed: onSave,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTextField(Icons.person, "Name", _profile.name),
          _buildTextField(Icons.phone, "Phone Number", _profile.phoneNumber),
          _buildTextField(Icons.email, "Email", _profile.email),
          _buildTextField(Icons.house, "Address", _profile.address)
        ],
      ),
    );
  }

  Widget _buildTextField(IconData icon, String label, String initialValue) {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    return ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.black12,
          foregroundColor: Colors.black,
          child: Icon(icon)),
      trailing: GestureDetector(
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
        onTap: () {
          setState(() {
            _isEnabled = !_isEnabled;
          });
        },
      ),
      title: Text(label),
      subtitle: TextFormField(
        enabled: _isEnabled,
        controller: controller,
        decoration: InputDecoration(
          hintText: "Enter $label",
        ),
        onChanged: (value) async {
          switch (label) {
            case "Name":
              _profile.name = value;
              break;
            case "Phone Number":
              _profile.phoneNumber = value;
              break;
            case "Email":
              _profile.email = value;
              break;
            case "Address":
              _profile.address = value;
              break;
            default:
              break;
          }
          controller.value = TextEditingValue(
              text: value,
              selection: TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length)));
        },
      ),
    );
  }
}
