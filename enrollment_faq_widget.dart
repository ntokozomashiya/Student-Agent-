import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class EnrollmentFaqWidget extends StatefulWidget {
  const EnrollmentFaqWidget({super.key});

  @override
  State<EnrollmentFaqWidget> createState() => _EnrollmentFaqWidgetState();
}

class _EnrollmentFaqWidgetState extends State<EnrollmentFaqWidget> {
  final List<Map<String, dynamic>> _faqData = [
    {
      'question': 'What is device enrollment?',
      'answer':
          'Device enrollment registers your device with your institution\'s management system, enabling secure access to educational resources and ensuring compliance with school policies.',
      'isExpanded': false,
    },
    {
      'question': 'What permissions are required?',
      'answer':
          'The app requires device administrator permissions to manage apps, enforce policies, and ensure a safe learning environment. These permissions help protect your device and maintain educational standards.',
      'isExpanded': false,
    },
    {
      'question': 'Can I use my device for personal activities?',
      'answer':
          'Yes, you can use your device for personal activities outside of school hours. The management system only enforces educational policies during designated learning times and for specific educational apps.',
      'isExpanded': false,
    },
    {
      'question': 'What happens if enrollment fails?',
      'answer':
          'If enrollment fails, check your internet connection and ensure the code is entered correctly. Contact your IT administrator if problems persist. Alternative enrollment methods may be available.',
      'isExpanded': false,
    },
    {
      'question': 'Is my personal data safe?',
      'answer':
          'Yes, your personal data is protected. The system only monitors educational activities and app usage during school hours. Personal files, messages, and non-educational activities remain private.',
      'isExpanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'help_outline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Enrollment Benefits & FAQ',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildBenefitsSection(),
          SizedBox(height: 3.h),
          _buildFaqSection(),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection() {
    final benefits = [
      {
        'icon': 'security',
        'title': 'Enhanced Security',
        'description': 'Protected browsing and app usage monitoring',
      },
      {
        'icon': 'school',
        'title': 'Educational Focus',
        'description': 'Access to curated educational content and apps',
      },
      {
        'icon': 'support_agent',
        'title': 'IT Support',
        'description': 'Remote assistance and troubleshooting capabilities',
      },
      {
        'icon': 'update',
        'title': 'Automatic Updates',
        'description': 'Seamless app updates and security patches',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Benefits of Enrollment',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 1.h),
        ...benefits.map((benefit) => _buildBenefitItem(benefit)).toList(),
      ],
    );
  }

  Widget _buildBenefitItem(Map<String, dynamic> benefit) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(1.w),
            ),
            child: CustomIconWidget(
              iconName: benefit['icon'],
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 4.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit['title'],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  benefit['description'],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 1.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _faqData.length,
          itemBuilder: (context, index) {
            return _buildFaqItem(index);
          },
        ),
      ],
    );
  }

  Widget _buildFaqItem(int index) {
    final faq = _faqData[index];

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: ExpansionTile(
        title: Text(
          faq['question'],
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: CustomIconWidget(
          iconName: faq['isExpanded'] ? 'expand_less' : 'expand_more',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 6.w,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _faqData[index]['isExpanded'] = expanded;
          });
        },
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
            child: Text(
              faq['answer'],
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
