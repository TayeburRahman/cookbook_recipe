import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/global/helper/extension/extension.dart';
import 'package:recipe_app/app/models/my_recipe/my_recipe_model.dart'
    show MyRecipeList;
import 'package:recipe_app/app/utils/enums/transation_type.dart'
    show TransitionType;
import 'package:recipe_app/app/view/screens/authentication/forget_password/forget_password_screen.dart';
import 'package:recipe_app/app/view/screens/authentication/otp/otp_screen.dart';
import 'package:recipe_app/app/view/screens/authentication/reset_password/reset_password_screen.dart';
import 'package:recipe_app/app/view/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:recipe_app/app/view/screens/authentication/sign_up/dietary_preferences/dietary_preferences.dart';
import 'package:recipe_app/app/view/screens/authentication/sign_up/disclaimer/disclaimer_screen.dart';
import 'package:recipe_app/app/view/screens/authentication/sign_up/goal_settings/goal_settings_screen.dart';
import 'package:recipe_app/app/view/screens/authentication/sign_up/select_photo/select_photo_screen.dart';
import 'package:recipe_app/app/view/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:recipe_app/app/view/screens/authentication/subscription_plan/subscription_plan_screen.dart';
import 'package:recipe_app/app/view/screens/grocery/grocery_screen.dart';
import 'package:recipe_app/app/view/screens/home/category_all/category_all_screen.dart';
import 'package:recipe_app/app/view/screens/home/category_screen/category_screen.dart';
import 'package:recipe_app/app/view/screens/home/diet_goals_screen/diet_goales_screen.dart';
import 'package:recipe_app/app/view/screens/home/home_screen.dart';
import 'package:recipe_app/app/view/screens/home/search_recipe/search_recipe.dart';
import 'package:recipe_app/app/view/screens/meal_plan/meal_plan_section.dart';
import 'package:recipe_app/app/view/screens/notification/notification_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/contact/contact_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/language_screen/language_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_favorites/my_favorites.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/add_recipe/add_recipe.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/my_recipe_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/my_recipe/recipe_details/recipe_details.dart';
import 'package:recipe_app/app/view/screens/profile_screen/personal_info/edit/edit_profile_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/personal_info/personal_info.dart';
import 'package:recipe_app/app/view/screens/profile_screen/profile_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/recipe_box/recipe_box.dart';
import 'package:recipe_app/app/view/screens/profile_screen/setting/change_password/change_password_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/setting/faq/faq_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/setting/setting_screen.dart';
import 'package:recipe_app/app/view/screens/profile_screen/setting/user_agreement/user_agreement_screen.dart';
import 'package:recipe_app/app/view/screens/splash/get_started/get_started_screen.dart';
import 'package:recipe_app/app/view/screens/splash/splash_screen.dart';
import '../view/screens/authentication/subscription_plan/web_view_screen/web_view_screen.dart';
import '../view/screens/profile_screen/setting/privacy/privacy_screen.dart';
import '../view/screens/profile_screen/setting/terms/terms_screen.dart';
import '../view/screens/meal_plan/prep_preview/prep_preview_screen.dart';
import '../view/screens/meal_plan/meal_plan_preview/meal_plan_preview_screen.dart';
import '../view/screens/grocery/grocery_preview/grocery_preview_screen.dart';
import '../view/screens/weekend_prep/weekend_prep_screen.dart';
import 'route_path.dart';

class AppRouter {
  static final GoRouter initRoute = GoRouter(
      initialLocation: RoutePath.splashScreen.addBasePath,
      debugLogDiagnostics: true,
      navigatorKey: GlobalKey<NavigatorState>(),
      routes: [
        ///======================= Initial Route =======================
        GoRoute(
          name: RoutePath.splashScreen,
          path: RoutePath.splashScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: SplashScreen(),
            state: state,
          ),
        ),

        //TODo >>>> Auth

        GoRoute(
          name: RoutePath.signInScreen,
          path: RoutePath.signInScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: SignInScreen(),
            state: state,
          ),
        ),

        GoRoute(
          name: RoutePath.signUpScreen,
          path: RoutePath.signUpScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: SignUpScreen(),
            state: state,
          ),
        ),

        GoRoute(
          name: RoutePath.getStartedScreen,
          path: RoutePath.getStartedScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const GetStartedScreen(),
            state: state,
          ),
        ),

        GoRoute(
          name: RoutePath.selectPhotoScreen,
          path: RoutePath.selectPhotoScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: SelectPhotoScreen(),
            state: state,
          ),
        ),

        GoRoute(
          name: RoutePath.dietaryPreferences,
          path: RoutePath.dietaryPreferences.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: DietaryPreferences(),
            state: state,
          ),
        ),

        GoRoute(
          name: RoutePath.goalSettingsScreen,
          path: RoutePath.goalSettingsScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: GoalSettingsScreen(),
            state: state,
          ),
        ),

        GoRoute(
          name: RoutePath.subscriptionPlanScreen,
          path: RoutePath.subscriptionPlanScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: SubscriptionPlanScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.webViewScreen,
          path: RoutePath.webViewScreen.addBasePath,
          pageBuilder: (context, state) {
            final url = state.extra as String? ?? '';
            return _buildPageWithAnimation(
              child: WebViewScreen(url: url),
              state: state,
            );
          },
        ),

        GoRoute(
          name: RoutePath.forgetPasswordScreen,
          path: RoutePath.forgetPasswordScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: ForgetPasswordScreen(),
            state: state,
          ),
        ),

        GoRoute(
          name: RoutePath.termsScreen,
          path: RoutePath.termsScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: TermsScreen(),
            state: state,
          ),
        ),

        GoRoute(
          name: RoutePath.privacyPolicyScreen,
          path: RoutePath.privacyPolicyScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: PrivacyPolicyScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.resetPasswordScreen,
          path: RoutePath.resetPasswordScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: ResetPasswordScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.otpScreen,
          path: RoutePath.otpScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: OtpScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.disclaimerScreen,
          path: RoutePath.disclaimerScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const DisclaimerScreen(),
            state: state,
          ),
        ),

        ///ToDo======================= Top Screen =======================
        GoRoute(
          name: RoutePath.mealPlanSection,
          path: RoutePath.mealPlanSection.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const MealPlanSection(),
              state: state,
              disableAnimation: true),
        ),

        ///======================= GroceryScreen =======================
        GoRoute(
          name: RoutePath.groceryScreen,
          path: RoutePath.groceryScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const GroceryScreen(),
              state: state,
              disableAnimation: true),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.categoryScreen,
          path: RoutePath.categoryScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const CategoryScreen(),
              state: state,
              transitionType: TransitionType.detailsScreen),
        ),

        ///======================= RecipeBox =======================
        GoRoute(
          name: RoutePath.recipeBox,
          path: RoutePath.recipeBox.addBasePath,
          pageBuilder: (context, state) {
            final extraData = state.extra as Map<String, dynamic>?;

            return _buildPageWithAnimation(
              child: RecipeBox(extraData: extraData),
              state: state,
              disableAnimation: true,
            );
          },
        ),

        ///======================= RecipeDetails =======================
        GoRoute(
          name: RoutePath.recipeDetails,
          path: RoutePath.recipeDetails.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const RecipeDetails(),
              state: state,
              transitionType: TransitionType.detailsScreen),
        ),

        ///======================= ProfileScreen =======================
        GoRoute(
          name: RoutePath.profileScreen,
          path: RoutePath.profileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const ProfileScreen(),
              state: state,
              disableAnimation: true),
        ),

        ///======================= Weekend Prep =======================
        GoRoute(
          name: RoutePath.weekendPrep,
          path: RoutePath.weekendPrep.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const WeekendPrepScreen(),
              state: state,
              disableAnimation: true),
        ),

        ///======================= Meal Plan Preview ===================
        GoRoute(
          name: RoutePath.mealPlanPreview,
          path: RoutePath.mealPlanPreview.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const MealPlanPreviewScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.groceryPreview,
          path: RoutePath.groceryPreview.addBasePath,
          pageBuilder: (context, state) {
            final extraData = state.extra as Map<String, dynamic>?;
            return _buildPageWithAnimation(
              child: GroceryPreviewScreen(extraData: extraData),
              state: state,
            );
          },
        ),
        GoRoute(
          name: RoutePath.prepPreview,
          path: RoutePath.prepPreview.addBasePath,
          pageBuilder: (context, state) {
            final extraData = state.extra as Map<String, dynamic>?;
            return _buildPageWithAnimation(
              child: PrepPreviewScreen(extraData: extraData),
              state: state,
            );
          },
        ),

        ///======================= GroceryScreen =======================
        GoRoute(
          name: RoutePath.homeScreen,
          path: RoutePath.homeScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const HomeScreen(), state: state, disableAnimation: true),
        ),

        ///======================= dietGoalesScreen =======================
        GoRoute(
          name: RoutePath.dietGoalesScreen,
          path: RoutePath.dietGoalesScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const DietGoalesScreen(),
              state: state,
              transitionType: TransitionType.detailsScreen),
        ),

        //ToDo
        ///======================= PersonalInfo =======================
        GoRoute(
          name: RoutePath.personalInfo,
          path: RoutePath.personalInfo.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: PersonalInfo(),
            state: state,
          ),
        ),

        ///======================= SearchRecipe =======================
        GoRoute(
          name: RoutePath.searchRecipe,
          path: RoutePath.searchRecipe.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const SearchRecipe(),
              state: state,
              transitionType: TransitionType.detailsScreen),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.languageScreen,
          path: RoutePath.languageScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: LanguageScreen(),
            state: state,
          ),
        ),

        ///======================= ContactScreen =======================
        GoRoute(
          name: RoutePath.contactScreen,
          path: RoutePath.contactScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: ContactScreen(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.categoryAllScreen,
          path: RoutePath.categoryAllScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: CategoryAllScreen(),
            state: state,
          ),
        ),

        ///======================= addRecipe =======================
        GoRoute(
          name: RoutePath.addRecipe,
          path: RoutePath.addRecipe.addBasePath,
          pageBuilder: (context, state) {
            // Safely handle nullable extra
            final data = state.extra
                as MyRecipeList?; // Cast to your data model (nullable)

            return _buildPageWithAnimation(
                child: AddRecipe(data: data), // Pass the data or null
                state: state,
                transitionType: TransitionType.detailsScreen);
          },
        ),

        ///======================= SettingScreen =======================
        GoRoute(
          name: RoutePath.settingScreen,
          path: RoutePath.settingScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: SettingScreen(),
            state: state,
          ),
        ),

        ///======================= myRecipeScreen =======================
        GoRoute(
          name: RoutePath.myRecipeScreen,
          path: RoutePath.myRecipeScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const MyRecipeScreen(),
            state: state,
          ),
        ),

        ///======================= NotificationScreen =======================
        GoRoute(
          name: RoutePath.notificationScreen,
          path: RoutePath.notificationScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const NotificationScreen(),
              state: state,
              transitionType: TransitionType.detailsScreen),
        ),

        ///======================= FaqScreen =======================
        GoRoute(
          name: RoutePath.faqScreen,
          path: RoutePath.faqScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: FaqScreen(),
            state: state,
          ),
        ),

        ///======================= EditProfileScreen =======================
        GoRoute(
          name: RoutePath.editProfileScreen,
          path: RoutePath.editProfileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const EditProfileScreen(),
            state: state,
          ),
        ),

        ///======================= UserAgreementScreen =======================
        GoRoute(
          name: RoutePath.userAgreementScreen,
          path: RoutePath.userAgreementScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: UserAgreementScreen(),
            state: state,
          ),
        ),

        ///======================= UserAgreementScreen =======================
        GoRoute(
          name: RoutePath.myFavorites,
          path: RoutePath.myFavorites.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const MyFavorites(),
            state: state,
          ),
        ),

        ///======================= ChangePasswordScreen =======================
        GoRoute(
          name: RoutePath.changePasswordScreen,
          path: RoutePath.changePasswordScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: ChangePasswordScreen(),
            state: state,
          ),
        ),
      ]);

  static CustomTransitionPage _buildPageWithAnimation({
    required Widget child,
    required GoRouterState state,
    bool disableAnimation = false,
    TransitionType transitionType = TransitionType.defaultTransition,
  }) {
    if (disableAnimation) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionDuration: Duration.zero, // Disable animation
        transitionsBuilder: (_, __, ___, child) => child, // No transition
      );
    }

    // Custom transition for Details Screen (center open animation)
    if (transitionType == TransitionType.detailsScreen) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Center Open Animation
          var curve = Curves.easeOut; // Smooth opening
          var tween = Tween(begin: 0.0, end: 1.0); // Scale transition
          var scaleAnimation =
              animation.drive(tween.chain(CurveTween(curve: curve)));

          return ScaleTransition(
            scale: scaleAnimation,
            child: child,
          );
        },
      );
    }

    // Default Slide Transition (right to left)
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static GoRouter get route => initRoute;
}
