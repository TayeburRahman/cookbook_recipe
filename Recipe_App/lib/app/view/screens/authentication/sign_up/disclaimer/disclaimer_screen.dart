import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/app/utils/app_colors/app_colors.dart';
import 'package:recipe_app/app/utils/app_strings/app_strings.dart';
import 'package:recipe_app/app/view/common_widgets/custom_appbar/custom_appbar.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarBgColor: AppColors.white,
        appBarContent: AppStrings.disclaimer,
        iconData: Icons.arrow_back,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10.h),

                // Section 1
                _buildSection(
                  title: 'App Medical Disclaimer',
                  body:
                      'The Koumanis Diet Mobile App Meal Planner is intended for informational and educational purposes only and does not constitute medical advice.\n\nThe app provides:',
                  bullets: [
                    'Meal planning tools',
                    'Nutritional tracking (calories, protein, fat, fiber, etc.)',
                    'Recipe recommendations',
                    'General wellness guidance',
                  ],
                  footer:
                      'This app is not intended to diagnose, treat, cure, or prevent any disease. It does not also guarantee any results of any kind.',
                ),

                // Section 2
                _buildSection(
                  title: 'Consult Your Physician',
                  body:
                      'Before using this app or making changes to your diet, exercise, or lifestyle, you should consult with your physician or qualified healthcare provider, especially if you:',
                  bullets: [
                    'Have diabetes, cardiovascular disease, kidney disease, or metabolic disorders',
                    'Are on weight loss medications (including GLP-1 medications such as Semaglutide)',
                    'Have food allergies or dietary restrictions',
                    'Are pregnant or breastfeeding',
                  ],
                ),

                // Section 3
                _buildSection(
                  title: 'Data & Accuracy Disclaimer',
                  body:
                      'While the app strives to provide accurate nutritional data:',
                  bullets: [
                    'Nutritional values are estimates and may vary',
                    'Food databases may contain inaccuracies',
                    'Users are responsible for verifying information where necessary',
                  ],
                ),

                // Section 4
                _buildSection(
                  title: 'User Responsibility',
                  body: 'By using the app, you acknowledge that:',
                  bullets: [
                    'You are responsible for your own health decisions',
                    'You will use the app at your own risk',
                    'You will seek professional guidance when needed',
                  ],
                ),

                // Section 5
                _buildSection(
                  title: 'No Medical Monitoring',
                  body: 'This app does not provide:',
                  bullets: [
                    'Medical monitoring',
                    'Emergency services',
                    'Real-time clinical supervision',
                  ],
                  footer:
                      'If you experience a medical emergency, contact your physician or emergency services immediately.',
                ),

                // Section 6
                _buildSection(
                  title: 'Limitation of Liability',
                  body: 'To the maximum extent permitted by law:',
                  bullets: [
                    'Dr. Dimitri Koumanis and all affiliated entities shall not be liable for any health complications, injuries, or damages resulting from the use of this app.',
                  ],
                ),

                // Section 7
                _buildSection(
                  title: 'HIPAA & Health Information Consent',
                  body:
                      'By enrolling in The Koumanis Diet Health System and/or using The Koumanis Diet Mobile App, you acknowledge that you may voluntarily provide personal health information, including but not limited to:',
                  bullets: [
                    'Weight, BMI, and body measurements',
                    'Dietary habits and lifestyle data',
                    'Laboratory results (if submitted)',
                    'Medication use, including weight loss medications',
                  ],
                  subSections: [
                    const _SubSection(
                      intro: 'You understand and agree that:',
                      bullets: [
                        'This information may be collected, stored, and processed to provide personalized insights, reports, and recommendations',
                        'All reasonable administrative, technical, and physical safeguards are used to protect your information in accordance with applicable privacy laws, including HIPAA where applicable',
                      ],
                    ),
                    const _SubSection(
                      intro: 'However:',
                      bullets: [
                        'The Koumanis Diet Health System and Mobile App are not intended to function as covered entities or healthcare providers under HIPAA unless explicitly stated in a formal clinical relationship',
                        'Submission of information through the app or program does not establish a physician-patient relationship',
                      ],
                    ),
                  ],
                  footer:
                      'By using the platform, you consent to the collection and use of your information as described.',
                ),

                // Section 8
                _buildSection(
                  title: 'GLP-1 / Weight Loss Medication Disclaimer',
                  body:
                      'If you are currently using or considering weight loss medications, including GLP-1 receptor agonists such as Semaglutide or Tirzepatide, you acknowledge that:',
                  bullets: [
                    'The Koumanis Diet program is not a substitute for medical supervision or medication management',
                    'Dietary changes, intermittent fasting, and exercise may interact with medications and could lead to: Hypoglycemia, Gastrointestinal symptoms, Electrolyte imbalances, Nutritional deficiencies',
                  ],
                  subSections: [
                    const _SubSection(
                      intro: 'You agree that:',
                      bullets: [
                        'You will consult your prescribing physician before combining this program with any medication',
                        'You will not adjust medication dosages without physician guidance',
                        'You assume full responsibility for monitoring your health while using medications in conjunction with this program',
                      ],
                    ),
                  ],
                ),

                // Section 9
                _buildSection(
                  title: 'No Doctor–Patient Relationship',
                  body:
                      'Use of The Koumanis Diet Health System, Mobile App, educational materials, or coaching services does not establish a physician-patient relationship between you and Dr. Dimitri Koumanis or any affiliated providers.\n\nSpecifically:',
                  bullets: [
                    'No diagnosis, treatment, or individualized medical care is being provided',
                    'Communications via app, email, video content, or messaging platforms are for educational purposes only',
                    'Any health-related decisions should be made in consultation with your own licensed healthcare provider',
                  ],
                  subSections: [
                    const _SubSection(
                      intro:
                          'A physician-patient relationship is only established through:',
                      bullets: [
                        'A formal consultation',
                        'Signed medical consent forms',
                        'Direct clinical evaluation',
                      ],
                    ),
                  ],
                ),

                // Section 10 - Arbitration
                _buildSection(
                  title: 'Binding Arbitration & Waiver of Jury Trial',
                  body:
                      'To the fullest extent permitted by law, you agree that any dispute, claim, or controversy arising out of or relating to The Koumanis Diet Health System, the Mobile App, coaching services, or any associated content shall be resolved exclusively through binding arbitration.\n\nYou further agree that:',
                  bullets: [
                    'You waive your right to a jury trial',
                    'Arbitration shall be conducted in the State of New York under the rules of the American Arbitration Association',
                    'Each party shall bear its own legal costs unless otherwise determined by the arbitrator',
                    'The arbitrator\'s decision shall be final and enforceable in any court of competent jurisdiction',
                  ],
                  footer:
                      'Class Action Waiver: Any claims will be brought individually and not as part of a class action or collective proceeding.\n\nException: This clause does not apply where prohibited by law, including certain medical malpractice claims where arbitration agreements are restricted.',
                ),

                // Section 11 - Acknowledgements
                _buildSection(
                  title: 'Consent & Acknowledgements',
                  body:
                      'By checking the agreement on the sign-up screen, you specifically acknowledge:',
                  bullets: [
                    'The Koumanis Diet is an educational program and not medical advice. I agree to consult my physician before starting any diet, exercise, or fasting program.',
                    'Results are not guaranteed and I assume full responsibility for my health decisions.',
                    'No doctor-patient relationship is created by this program or app.',
                    'I agree to the Terms of Use, Medical Disclaimer, and Binding Arbitration Agreement.',
                  ],
                ),

                // Section 12 - Acceptance
                _buildSection(
                  title: 'Acceptance of Terms',
                  body:
                      'By downloading, subscribing to, or using The Koumanis Diet Mobile App Meal Planner, you agree to this disclaimer.',
                ),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String body,
    List<String> bullets = const [],
    List<_SubSection> subSections = const [],
    String? footer,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.green,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            body,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.black,
              height: 1.6,
            ),
          ),
          if (bullets.isNotEmpty) ...[
            SizedBox(height: 8.h),
            ...bullets.map((b) => _buildBullet(b)),
          ],
          if (subSections.isNotEmpty)
            ...subSections.map((s) => _buildSubSection(s)),
          if (footer != null) ...[
            SizedBox(height: 10.h),
            Text(
              footer,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.black,
                fontStyle: FontStyle.italic,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubSection(_SubSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Text(
          section.intro,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            height: 1.6,
          ),
        ),
        SizedBox(height: 4.h),
        ...section.bullets.map((b) => _buildBullet(b)),
      ],
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, top: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ',
              style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.green,
                  fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.black,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubSection {
  final String intro;
  final List<String> bullets;
  const _SubSection({required this.intro, required this.bullets});
}
