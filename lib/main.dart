import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.red,
         title: Text("Logging Page", 
         style: TextStyle(color: Colors.white)),
          centerTitle: true, ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("My Application", style: TextStyle(color: Colors.blue, fontSize: 30, 
              fontWeight: FontWeight.w900),),
               Text("Enter Username",),
               TextField(),
              Text("Enter Password"),
              TextField(),
              SizedBox(height: 20),
              MaterialButton(onPressed: (){}, 
              child: Text("Login", style: TextStyle(color: Colors.white)),
               color: Colors.amber,),
            ],
          ),
          ), 
        
      ),
    );
  
}