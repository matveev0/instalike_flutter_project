import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instalike_flutter_project/components/custom_suffix_icon.dart';
import 'package:instalike_flutter_project/components/default_button.dart';
import 'package:instalike_flutter_project/components/user.dart';
import 'package:instalike_flutter_project/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';

class EditProfileForm extends StatefulWidget {
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  LocalUserModel localUser;
  final _formKey = GlobalKey<FormState>();
  String nameText;

  @override
  Widget build(BuildContext context) {
    localUser = Provider.of<LocalUserModel>(context);

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(localUser.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());

          localUser = LocalUserModel.fromDocument(snapshot.data);

          return Form(
            key: _formKey,
            child: Column(
              children: [
                buildNameFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                DefaultButton(
                  text: "Save",
                  press: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      applyNameChanges();
                      Navigator.pushNamedAndRemoveUntil(context, ProfileScreen.routeName,
                              (Route<dynamic> route) => false);
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      onSaved: (newValue) => nameText = newValue,
      initialValue: localUser.name,
      onChanged: (value) {
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  applyNameChanges() {
    FirebaseFirestore.instance.collection('users').doc(localUser.id).update({
      "name": nameText
    });
  }
}
