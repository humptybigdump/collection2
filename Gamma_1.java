package greek;
class Gamma {
  void accessMethod() {
    Alpha a = new Alpha();
    a.iAmProtected = 10;   // zul�ssig
    a.protectedMethod();   // zul�ssig
  }
}

