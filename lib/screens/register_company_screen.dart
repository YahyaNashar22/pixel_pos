import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'package:pixel_pos/data/database_company_service.dart';
import 'package:pixel_pos/routes/app_routes.dart';

class RegisterCompanyScreen extends StatefulWidget {
  const RegisterCompanyScreen({super.key});

  @override
  State<RegisterCompanyScreen> createState() => _RegisterCompanyScreenState();
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  final TextEditingController _name = TextEditingController();
  final DatabaseCompanyService _dbCompanyService = DatabaseCompanyService();
  final _formKey = GlobalKey<FormState>();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isRegistering = false;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerCompany() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      setState(() {
        _isRegistering = true;
      });

      // save the image locally and get the new path
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(_imageFile!.path);
      final File localImage = await _imageFile!.copy(
        '${appDir.path}/$fileName',
      );

      // register company with the local image path
      await _dbCompanyService.registerCompany(_name.text, localImage.path);

      if (mounted) {
        setState(() {
          _isRegistering = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Company registered successfully")),
        );
        Navigator.pushReplacementNamed(context, AppRouter.login);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please fill all fields and select a logo"),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register Company")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // company name input
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: "Company Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a company name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // company logo input
              GestureDetector(
                onTap: _pickImage,
                child: SizedBox(
                  height: 150,
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.contain)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 50),
                            Text("Click to select a logo"),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // register button
              ElevatedButton(
                onPressed: _isRegistering ? null : _registerCompany,
                child: _isRegistering
                    ? const CircularProgressIndicator()
                    : Text("Register Company"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
