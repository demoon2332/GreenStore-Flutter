class ShortTitle{
  static String sortTitle(String title){
    return (title.length>30)? title.substring(0,30)+"...": title;
  }
}