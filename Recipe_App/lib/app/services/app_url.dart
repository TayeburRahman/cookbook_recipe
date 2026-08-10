class ApiUrl {
  static const baseUrl = "https://backend.koumanisdietapp.com";
  // static const baseUrl = "http://10.10.28.71:5005";
  // static const baseUrl = "http://172.252.13.86:5005";
  // static const baseUrl = "http://10.10.20.62:5005";
  // static const baseUrl = "http://10.10.20.11:5005";

  ///================================= User Authentication url==========================
  static const register = "/auth/register";
  static const activateAccount = "/auth/activate-user";
  static const login = "/auth/login";
  static const forgotPassword = "/auth/forgot-password";
  static const forgotVerifyOtp = "/auth/verify-otp";
  static const checkProfileInfo = "/auth/check_profile_info";

  static String resetPassword({required String email}) {
    return "/auth/reset-password?email=$email";
  }

  //================Home Section===============
  static const banner = "/banner";
  static const category = "/category/get-category-drop-down";
  static const recipeForYou = "/dashboard/recipe_for_you";
  static const recipeBox = "/dashboard/get_all_recipe";
  static String searchRecipe(
      {required String name, int page = 1, int limit = 10}) {
    return "/dashboard/get_all_recipe?searchTerm=$name&page=$page&limit=$limit";
  }

  static String getCategories(
      {required String id, int page = 1, int limit = 10}) {
    return "/dashboard/get_all_recipe?category=$id&page=$page&limit=$limit";
  }

  static const getDietGoal =
      "/dashboard/get_all_recipe?weight_and_muscle=weight_loss";

  static String recipeBoxFilter({String? param, int page = 1, int limit = 10}) {
    final paginationParams = "page=$page&limit=$limit";
    return param == null || param.isEmpty
        ? "/dashboard/get_all_recipe?$paginationParams"
        : "/dashboard/get_all_recipe?$param&$paginationParams";
  }

  static String getWeightLossMuscleGain(
      {required String goal, int page = 1, int limit = 10}) {
    return "/dashboard/get_all_recipe?weight_and_muscle=$goal&page=$page&limit=$limit";
  }

  static String toggleIngredients({required String ingredientsId}) {
    return "/meal_plan/toggle_ingredient_buy_status/$ingredientsId";
  }

  static const toggleAisleItem = "/meal_plan/toggle-aisle-item";

  //================Recipe Section===============
  static const recipeCreate = "/dashboard/create_recipe";
  static const myAllRecipe = "/dashboard/my_all_recipe";
  static String recipeDetails({required String id}) {
    return "/dashboard/get_recipe_details/$id";
  }

  static String recipeUpdate({required String id}) {
    return "/dashboard/update_recipe/$id";
  }

  static String recipeDelete({required String id}) {
    return "/dashboard/delete_recipe/$id";
  }

  //================Favorite Section===============

  static const getFavorite = "/dashboard/get_user_favorites";

  static String addFavorite({required String id}) {
    return "/dashboard/toggle_favorite/$id";
  }

  //================Profile Section===============
  static const changePassword = "/auth/change-password";
  static const getProfile = "/auth/profile";
  static const profileEdit = "/auth/edit-profile";
  static const faq = "/dashboard/get-faqs";
  static const terms = "/dashboard/get-rules";
  static const privacyPolicy = "/dashboard/get-privacy-policy";
  static const contact = "/dashboard/send-message-support";

  static String deleteAccount({required String id}) {
    return "/auth/delete-account?authId=$id";
  }

//================Meal Plan And Grocery===============

  static const getWeeklyPlan = "/meal_plan/get_weekly_plane";
  static String mealPlanDetails({required String id}) {
    return "/meal_plan/get_mealPlan_details/$id";
  }

  static String groceryList({required String id}) {
    return "/meal_plan/get_grocery_list/$id";
  }

  static String groceryListAdvice({required String id}) {
    return "/meal_plan/grocery-list-advice/$id";
  }

  static String score({required String id, required String rating}) {
    return "/dashboard/score_review/send?recipeId=$id&ratting=$rating";
  }

  static String swapAdd({
    required String removeId,
    required String newId,
    required String day,
    required String planId,
  }) {
    return "/meal_plan/swap_plane_recipe"
        "?removeId=$removeId"
        "&newId=$newId"
        "&day=$day"
        "&planId=$planId";
  }

  static String swapRemove({
    required String removeId,
    required String day,
    required String planId,
  }) {
    return "/meal_plan/remove_plan_recipes"
        "?removeId=$removeId"
        "&day=$day"
        "&planId=$planId";
  }

  static String addRecipe({
    required String recipeId,
    required String day,
    required String planId,
  }) {
    return "/meal_plan/add_recipes?planId=$planId&day=$day&recipeId=$recipeId";
  }

  static const createCustomPlan = "/meal_plan/create_custom_plane";
  static const getCustomPlan = "/meal_plan/get_custom_plane";
  static String planeDelete({required String id}) {
    return "/meal_plan/delete_custom_plane/$id";
  }

  static String cleanMealPlan({required String id}) {
    return "/meal_plan/clean_plane_recipes/$id";
  }

  static String resetMealPlan({required String id}) {
    return "/meal_plan/reset-mealplan/$id";
  }

  // static String weekendPrep({required String id}) {
  //   return "/meal_plan/weekend-prep/$id";
  // }

  static const getFeaturePlan = "/meal_plan/get_featured_plane";

  //================Payment Section===============

  static const getSubscription = "/dashboard/get_all_subscriptions";
  static const createPayment = "/payment/create_checkout_session";
  static const successPayment = "/payment/stripe-webhooks";

  //================Other Section===============

  static const getNotification = "/meal_plan/get_notifications";

  //================Review===============

  static String getReview({required String id}) {
    return "/dashboard/review/get/$id";
  }

  static const reviewSend = "/dashboard/review/send";
}
