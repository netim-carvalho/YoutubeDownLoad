abstract class Utils {
  static String removeEspecialCharacters({required String value}){
    return value.replaceAll(RegExp("[^A-Za-z0-9]"), " ");
  }

}