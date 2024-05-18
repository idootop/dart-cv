import 'package:dart_cv/dart_cv.dart';
import 'package:pdf/widgets.dart';

void main() async {
  const savePath = 'example/resume.pdf';
  final success = await XPDF.render(
    savePath,
    margin: EdgeInsets.all(24.px),
    body: (Context context) => <Widget>[
      // Profile
      XHeader(
        name: 'Your Name',
        descriptions: [
          XText('(+86) 123456789'), // Phone number
          XLink('mailto:me@xbox.work', text: 'me@xbox.work'), // Email
          XLink('https://github.com/idootop',
              text: 'github.com/idootop'), // Github
        ],
      ),
      // Education
      XSection('Education'),
      XProject(
        gap: 6.px,
        title: 'University name',
        time: '2017.09-2021.06',
        description: "Bachelor's Degree in Computer Science",
      ),
      // Work Experience
      XSection('Work Experience'),
      XProject(
        gap: 6.px,
        title: 'Company name',
        time: '2020.12-Present',
        description: 'Front End Developer, New York',
        bullets: [
          XBullet('Managed a team of 4 front-end developers and designers'),
          XBullet('Responsible for maintaining websites in a timely manner'),
        ],
      ),
      // Side Projects
      XSection('Side Projects'),
      XProject(
        gap: 6.px,
        title: 'Project name',
        time: '2021.02',
        link: 'https://github.com/idootop/dart-cv', // Project Link
        description: 'ReactFlow node auto layout and Figma-like edge editing.',
        bullets: [
          XBullet('Enables automatic layout of nodes with dynamic sizing.'),
          XBullet(
              'Supports various auto layout algorithms like Dagre, ELK, D3-hierarchy and more.'),
        ],
      ),
      // Skills
      XSection('Skills'),
      XBulletBase(
        children: [
          XText('Frontend [3 years]: ', bold: true),
          XText('React, Next.js, Tailwind.css, TypeScript, Vite'),
        ],
      ),
    ],
  );
  if (success) {
    print('✅ Your resume has been successfully saved at $savePath!');
  } else {
    print('❌ Failed to generate your resume :(');
  }
}
