class ApiConstants {
  // API Key
  // static const apiKey = "c2a0433227924ab6b283c615b23d5cb4";

  // static const apiKey = "4a7bc2e33f8d44f59994b6ce43528f82";

  // static const apiKey = "a7aabda2667345b2bdfc501b2e4a71fb";

  // static const apiKey = "fa222260e33b4716952379ab158162d2";

  static const apiKey = "8e9843427b6c4c06b5266b375bd860b6";

  static const pageSize = 5;

  // BASE URL
  static const baseUrl =
      "https://newsapi.org/v2/everything?apiKey=${apiKey}&pageSize=${pageSize}";

  // DEFAULT URL
  static const defaultUrl =
      "https://newsapi.org/v2/top-headlines?country=us&apiKey=${apiKey}&pageSize=${pageSize}";
}
