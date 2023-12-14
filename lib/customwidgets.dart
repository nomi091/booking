import 'package:flutter/material.dart';

ElevatedButton customButton({
  required Function() onPressed,
  required String data}){
  return ElevatedButton(onPressed: onPressed, style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(200.0, 50.0)) // Set the desired size
            ),
             child: Text(data,style: const TextStyle(fontSize: 10),),);
}
TextFormField customTextField({
required controller,
required labelText,
required hintText,
}){
  return TextFormField(
    controller: controller,
     decoration: InputDecoration(
                  labelText: labelText,
                  hintText: hintText
                ),
  );

}