import 'package:echo_lens/Widgets/drawer_global.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:echo_lens/Widgets/colors_global.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.themeColor,
      drawer: const DrawerGlobal(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GlobalColors.themeColor,
        title: Text(
          'A B O U T   U S',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontSize: 20,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color:
                  GlobalColors.mainColor, // Custom color for the hamburger icon
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: GlobalColors.mainColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Image Caption Generator for Blind Individuals',
                      style: TextStyle(
                        color: GlobalColors.mainColor,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _buildparagraph(
                        "We are a team of three passionate developers who have come together to create an advanced image captioning application. Our journey began with the exploration of various AI models for generating captions based on images."),
                    const SizedBox(height: 10),
                    _buildparagraph(
                        "Initially, we started with GPT-2, a powerful language model, to generate captions. However, while GPT-2 was capable of producing meaningful text, it didn't meet the high accuracy and relevance we aimed for in our project."),
                    const SizedBox(height: 10),
                    _buildparagraph(
                        "To overcome this, we transitioned to using the BLIP (Bootstrapped Language-Image Pretraining) model. BLIP provided significant improvements, allowing us to achieve more accurate and contextually relevant captions. This shift enabled us to set a new benchmark in our results, surpassing our expectations."),
                    const SizedBox(height: 10),
                    _buildparagraph(
                        "For our project, we used the Flickr8k dataset, which consists of 8,000 images, each paired with five different captions. This dataset provided a diverse range of examples that helped train our model effectively."),
                    const SizedBox(height: 10),
                    _buildparagraph(
                        "Through dedication and teamwork, we have successfully developed an application that stands out in its ability to accurately describe images. If you have any questions, suggestions, or feedback, we would love to hear from you!"),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: GlobalColors.mainColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'OUR TEAM',
                      style: TextStyle(
                        color: GlobalColors.mainColor,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _buildTeamMembersRow(context),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: GlobalColors.mainColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'PROJECT CORDINATOR',
                      style: TextStyle(
                        color: GlobalColors.mainColor,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _buildSupervisor(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildContactUs(context),
              const SizedBox(height: 32),
              _buildCopyright(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMembersRow(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTeamMember('Muhammad Sami', 'AI Developer',
                  'assets/profiles/m_sami.JPG'),
              _buildTeamMember(
                  'Mahnoor', 'UI/UX Designer', 'assets/profiles/mahnoor.jpg'),
              _buildTeamMember('Husnain', 'Backend Developer',
                  'assets/profiles/husnain.jpg'),
            ],
          );
        } else {
          return Column(
            children: [
              _buildTeamMember('Muhammad Sami', 'AI Developer',
                  'assets/profiles/m_sami.JPG'),
              const SizedBox(height: 16),
              _buildTeamMember(
                  'Mahnoor', 'UI/UX Designer', 'assets/profiles/mahnoor.jpg'),
              const SizedBox(height: 16),
              _buildTeamMember('Husnain', 'Backend Developer',
                  'assets/profiles/husnain.jpg'),
            ],
          );
        }
      },
    );
  }

  Widget _buildTeamMember(String name, String role, String imagePath) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: GlobalColors.mainColor, width: 2),
          ),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: 120,
              height: 120,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            color: GlobalColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          role,
          style: TextStyle(
            color: GlobalColors.textColor.withOpacity(0.7),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSupervisor() {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: GlobalColors.mainColor, width: 2),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/profiles/mam_asma.jpg',
              fit: BoxFit.cover,
              width: 120,
              height: 120,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Dr. Asma Kanwal',
          style: TextStyle(
            color: GlobalColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'Project Supervisor',
          style: TextStyle(
            color: GlobalColors.textColor.withOpacity(0.7),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContactUs(BuildContext context) {
    return Column(
      children: [
        Text(
          'Contact Us',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        _buildContactItem(
          context,
          Icons.email,
          'mahmermahmer8@gmail.com',
          'mailto:mahmermahmer8@gmail.com',
        ),
        const SizedBox(height: 8),
        _buildContactItem(
          context,
          Icons.phone,
          'Phone: 0349 1420673',
          'tel:+923491420673',
        ),
      ],
    );
  }

  Widget _buildContactItem(
      BuildContext context, IconData icon, String label, String urlString) {
    final Uri url = Uri.parse(urlString);
    return InkWell(
      onTap: () => _launchUrl(context, url),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: GlobalColors.mainColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: GlobalColors.textColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyright() {
    return Text(
      '© 2024 Echo Lens. All rights reserved.',
      style: TextStyle(
          color: GlobalColors.textColor.withOpacity(0.7), fontSize: 12),
      textAlign: TextAlign.center,
    );
  }

  Future<void> _launchUrl(BuildContext context, Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Could not launch URL."),
          backgroundColor: GlobalColors.textColor,
        ),
      );
    }
  }

  Widget _buildparagraph(String text) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
          color: GlobalColors.mainColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(color: GlobalColors.textColor, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }
}
