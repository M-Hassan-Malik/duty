class DataHolder {
  static Map<String, dynamic> dataHolder = {
    "title": "hassan",
    "description": "goku",
    "place": {"lat": 34.33},
    "date": "timestamp",
    "person": 1,
    "payment": 0
  };

  getMap(){
   print(dataHolder.runtimeType);
  }

}
