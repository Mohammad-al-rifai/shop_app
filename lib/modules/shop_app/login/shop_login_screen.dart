import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app/layout/shop_app/shop_layout.dart';
import 'package:shop_app/modules/shop_app/login/cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/login/cubit/states.dart';
import 'package:shop_app/modules/shop_app/register/shop_register_Screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

// ignore: must_be_immutable
class ShopLoginScreen extends StatelessWidget {


  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context )=>ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginStates>(
        listener: (context , state){
          if(state is ShopLoginSuccessState){
            if(state.loginModel.status){
              print(state.loginModel.message);
              print(state.loginModel.data.token);
              CacheHelper.saveData(
                  key: 'token',
                  value: state.loginModel.data.token
              ).then((value){
                //Important Note! => here The Token Will be saved Every Login Process
                //because after logout the old token is stall saved
                //but we need The new token after logout so we saved it again✔️
                token = state.loginModel.data.token;
                navigateAndFinish(context, ShopLayout());
              });
            }else{
              print(state.loginModel.message);
              showToast(
                text: state.loginModel.message,
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context , state){
          return Scaffold(
            appBar: AppBar(
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.black),
                        ),
                        SizedBox(height: 15.0,),
                        Text(
                          'Login now to Browse our hot offers ',
                          style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String value){
                              if(value.isEmpty){
                                return 'Please Enter Your Email Address';
                              }
                            },
                            label: 'Email Address',
                            prefix: Icons.email_outlined
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (String value){
                              if(value.isEmpty){
                                return 'Password Is Too Short!!';
                              }
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            suffix: ShopLoginCubit.get(context).suffix,
                            isPassword: ShopLoginCubit.get(context).isPassWord,
                            suffixAction: (){
                              ShopLoginCubit.get(context).changeVisibility();
                            },
                            onSubmit: (value){
                              if(formKey.currentState.validate()){
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text
                                );
                              }
                            }
                        ),
                        SizedBox(height: 30.0,),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (context) => state is! ShopLoginLoadingState,
                          widgetBuilder: (context) => defaultButton(
                            function: (){
                              if(formKey.currentState.validate()){
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text
                                );
                              }
                            },
                            text: 'login',
                            isUpperCase: true,
                          ),
                          fallbackBuilder: (context) =>Center(child: CircularProgressIndicator()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t Have Account? ',
                            ),
                            defaultTextButton(
                              function: (){
                                navigateTo(context, ShopRegisterScreen());
                              },
                              text: 'register',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
