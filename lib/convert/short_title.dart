class ShortTitle{
  static String sortTitle(String title){
    return (title.length>20)? title.substring(0,20)+"...": title;
  }
}