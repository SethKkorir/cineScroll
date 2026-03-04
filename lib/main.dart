import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(backgroundColor: Colors.red,
        //  title: Text("Logging Page", 
        //  style: TextStyle(color: Colors.white)),
        //   centerTitle: true, ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                // Text("CineScroll", 
                // style: TextStyle(color: Colors.blue, fontSize: 30, 
                // fontWeight: FontWeight.w900),),
                Image.asset("assets/logo.png", height: 200, width: 400,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Enter Username", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter Username",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                      child: Text("Enter Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
            
                SizedBox(height: 20),
                // MaterialButton(onPressed: (){},
                //  color: Colors.amber, 
                // child: Text("Login", style: TextStyle(color: Colors.white)),),
                Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 238, 0), 
                  borderRadius: BorderRadius.circular(20)),
                 child: Center(child: Text("Login", style: TextStyle(color: Colors.black, fontSize: 20)),),
              )],
            ),
            ),
          ),
        ),
      ),
    );
}