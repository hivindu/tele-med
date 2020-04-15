import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'file:///D:/personalize/personal/self_learning/tele_med/lib/doctor/DoctorScreens/patientLog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telemed/otherWidgetsAndScreen/cardCode.dart';
import 'package:telemed/otherWidgetsAndScreen/cardIcinContent.dart';
import 'file:///D:/personalize/personal/self_learning/tele_med/lib/doctor/DoctorScreens/AppointmentList.dart';
import 'file:///D:/personalize/personal/self_learning/tele_med/lib/doctor/DoctorScreens/Notification.dart';

class DoctorHome extends StatefulWidget {
  DoctorHome({this.mail});

  final String mail;

  @override
  DoctorHomeState createState() => DoctorHomeState(
    email: this.mail
  );
}

class DoctorHomeState extends State<DoctorHome> {
  DoctorHomeState({this.email});

 String Name="";
 String email="";

 @override
 void initState()
 {
   super.initState();
   assignValue();
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'),backgroundColor: Colors.redAccent,),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: StreamBuilder(
                stream: Firestore.instance.collection('DoctorName').where('email', isEqualTo: this.email).snapshots(),
                builder:(context, snapshot){
                  if(!snapshot.hasData)
                    return Text('Connecting');
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context , index){
                      DocumentSnapshot ds = snapshot.data.documents[0];
                      this.Name= ds['name'];
                      return Text(
                        ds['name'],
                      );
                    },
                  );
                } ,
              ),
              accountEmail: Text('$email'),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill ,
                  image: NetworkImage("https://storage.pixteller.com/designs/designs-images/2019-03-27/05/simple-background-backgrounds-passion-simple-1-5c9b95c3a34f9.png"),
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                return Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Patient Log'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> PatientLog(email: this.email,name: this.Name,)));
              },
            ),
            ListTile(
              title: Text('Appointment List'),
              trailing:  Icon(Icons.arrow_forward_ios),
              onTap: (){
                return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> AppointmentLog(email: this.email,name: this.Name,)));
              },
            ),
            ListTile(
              title: Text('Notifications'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                return Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> NotificationList()));
              },
            ),
            Divider(height:400.0 ,),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Colors.redAccent[700],
              elevation: 7.0,
              child: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed:(){
                return Alert(
                  context: context,
                  type: AlertType.warning,
                  title: "LOG OUT",
                  desc: "Are you sure You Want To Log Out",
                  buttons: [
                    DialogButton(child: Text('Yes', style: TextStyle(color: Colors.black87),),
                      color: Colors.greenAccent,
                      onPressed: (){Navigator.pushNamed(context, '/DoctorLogin');
                      },
                    ),
                    DialogButton(child: Text('No', style: TextStyle(color: Colors.black87),),
                      color: Colors.greenAccent,
                      onPressed: (){Navigator.of(context).pop();
                      },
                    ),
                  ],
                ).show();
              } ,
            ),
          ],
        ),
      ),

      body: Center(
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[

                Expanded(
                    child: RepeatCode(
                        colour: Color(0xFFe0e0e0),
                        onpress: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return PatientLog(name: this.Name,);
                          },
                          )
                          );
                        },
                      CardChild: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: IconContent(
                            icon:Icons.account_circle,
                            text: 'My Patient',
                          ),
                        )
                      ),
                    ),
                ),
                Expanded(
                    child:RepeatCode(
                      colour: Color(0xFFe0e0e0),
                      onpress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return AppointmentLog();
                        },
                        )
                        );
                      },
                      CardChild: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: IconContent(
                            icon: Icons.library_books,
                            text: 'Today Schedule',
                          ),
                        ),
                      ),
                    )
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(

                    child: RepeatCode(
                      colour: Color(0xFFe0e0e0),
                      onpress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return NotificationList();
                        },
                        )
                        );
                      },
                      CardChild: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconContent(
                          icon: Icons.notification_important,
                          text: 'Notifications',
                        ),
                      ),
                    )
                )
              ],
            )
          ],
        ),
        ),

      );
  }

  void assignValue()
  {
    StreamBuilder(
      stream: Firestore.instance.collection('DoctorName').where('email', isEqualTo: this.email).snapshots(),
      builder:(context, snapshot){
        if(!snapshot.hasData)
          return Text('Connecting');
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context , index){
            DocumentSnapshot ds = snapshot.data.documents[0];
            return this.Name=ds['name'];
          },
        );
      },
    );
  }


}



