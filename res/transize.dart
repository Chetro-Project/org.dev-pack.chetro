import "dart:io";
import "dart:math";
extension LB on File{
  String get lineBreak{
    String firstLine = this.readAsLinesSync()[0];
    int fll = firstLine.length;
    String src = readAsStringSync();
    if(fll < src.length){
      String base = src.substring(fll,fll+1);
      if(firstLine.length+1 < src.length){
        String sub = src.substring(fll+1,fll+2);
        if(sub == "\n"){
          return "\r\n";
        }else if(base=="\n"){
          return "\n";
        }else{
          return "\r";
        }
      }else{
        if(base=="\n"){
          return "\n";
        }else{
          return "\r";
        }
      }
    }else{
      return "";
    }
  }
}
extension LBS on String{
  String get unEsc => this.replaceAll("\n","\\n").replaceAll("\r","\\r").replaceAll("\t","\\t");
}
void main(){
  List<int> cheched = [];
  List<int> unsup = [];
  File f = File("./../style/chocolate.style.css");
  File fs = File("./../style/s.chocolate.style.css");
  double per =0.22;
  String lb = f.lineBreak;
  print(lb.unEsc);
  String src = f.readAsStringSync();
  String calced = src.split(lb).map<String>((String s){
    if(s.contains("vw")){
      try{
        return s.split(" ").map<String>((String si){
          if(si.endsWith("vw")||si.endsWith("vw;")){
            print("match: $s");
            String sub = si.substring(0,si.length-(si.endsWith("vw;") ? 3 : 2));
            double len = double.parse(sub);
            double cd = (len * per * 1000).floor() /1000;
            return "$cd"+ (si.endsWith("vw;") ? "vw;" : "vw");
          }else{
            return si;
          }
        }).join(" ");
      }catch (e){
        print(s);
        return s;
      }
    }else{
      return s;
    }
  }).toList().indexedMap<String>((int ind, String s){
    if(!s.endsWith(";")&&!s.endsWith("{")&&!s.endsWith("}")){
      cheched.add(ind);
    }
    if(s.contains("-webkit-")){
      unsup.add(ind);
    }
    print("checked: $s");
    return s;
  }).toList().indexedMapN<String>((int ind, String s){
    print("removes fese: $ind, $s");
    do{
      if(unsup.contains(ind)){
        print("unsup match: $ind");
        return null;
      }else if(cheched.contains(ind-1)){
        ind--;
        print("noend match: ${ind+1}-> $ind");
      }else{
        print("any nomatch: $ind");
        return s;
      }

    }while(ind >= 0);
    return s;
  }).whereType<String>().join(lb);
  fs.writeAsStringSync(calced);
}
extension IndexedMap<T, E> on List<T> {
  List<E> indexedMap<E>(E Function(int index, T item) function) {
    final list = <E>[];
    this.asMap().forEach((index, element) {
      list.add(function(index, element));
    });
    return list;
  }
  List<E?> indexedMapN<E>(E? Function(int index, T item) function) {
    final list = <E?>[];
    this.asMap().forEach((index, element) {
      list.add(function(index, element));
    });
    return list;
  }
}