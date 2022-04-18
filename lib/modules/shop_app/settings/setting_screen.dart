import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app/layout/shop_app/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

// ignore: must_be_immutable
class SettingScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;

        nameController.text = model.data.name;
        emailController.text = model.data.email;
        phoneController.text = model.data.phone;
        return SingleChildScrollView(
          child: Conditional.single(
            context: context,
            conditionBuilder: (context) => ShopCubit.get(context).userModel != null,
            widgetBuilder: (context) => Padding(
              padding:const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [

                    if(state is ShopLoadingUpdateUserState)
                      LinearProgressIndicator(),
                    SizedBox(height: 20.0,),
                    defaultFormField(
                      controller: nameController,
                      type: TextInputType.text,
                      validate: (String value){
                        if(value.isEmpty){
                          return 'Name Must Not Be Empty!!';
                        }
                        return null;
                      },
                      label: 'Name',
                      prefix: Icons.person,
                    ),
                      SizedBox(height: 20.0,),
                    defaultFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validate: (String value){
                        if(value.isEmpty){
                          return 'Email Must Not Be Empty!!';
                        }
                        return null;
                      },
                      label: 'Email',
                      prefix: Icons.email,
                    ),
                    SizedBox(height: 20.0,),
                    defaultFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validate: (String value){
                        if(value.isEmpty){
                          return 'Phone Must Not Be Empty!!';
                        }
                        return null;
                      },
                      label: 'Phone',
                      prefix: Icons.phone,
                    ),
                    SizedBox(height: 20.0,),
                    defaultButton(
                        function: (){
                          if(formKey.currentState.validate()){
                            ShopCubit.get(context).updateUserData(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text
                            );
                          }
                        },
                        text:'UPDATE'
                    ),
                    SizedBox(height: 20.0,),
                    defaultButton(
                        function: (){
                          signOut(context);
                        },
                        text:'LOGOUT'
                    ),
                  ],
                ),
              ),
            ),
            fallbackBuilder: (context) => Center(child: CircularProgressIndicator())
          ),
        );
      },
    );
  }
}
