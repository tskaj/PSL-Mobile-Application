import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/gradient_app_bar.dart';
import '../../../core/widgets/app_primary_icon_button.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // Frontend-only: this will later be filled by ML model output
  String translatedText = 'یہاں ترجمہ شدہ متن ظاہر ہوگا…';

  // Frontend-only: toggles for UI
  bool isSpeaking = false;

  void _onSpeak() {
    // Later: connect to flutter_tts (Urdu voice)
    setState(() => isSpeaking = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TTS will speak this text (later)')),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => isSpeaking = false);
    });
  }

  void _onClear() {
    setState(() => translatedText = '');
  }

  // Frontend-only: simulate “recognition”
  void _simulateOutput() {
    setState(() {
      translatedText =
          'سلام! آپ کیسے ہیں؟\n(Example output — later this will come from camera + model)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
  title: 'Camera',
  actions: [
    IconButton(
      tooltip: 'Simulate',
      onPressed: _simulateOutput,
      icon: const Icon(Icons.auto_fix_high_outlined),
    ),
  ],
),

      body: SafeArea(
        child: Column(
          children: [
            // --- Camera preview area (placeholder) ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: double.infinity,
                    color: Colors.black12,
                    child: Stack(
                      children: [
                        // Placeholder “preview”
                        const Center(
                          child: Icon(Icons.videocam_outlined, size: 64),
                        ),

                        // Minimal top hint overlay
                        Positioned(
                          left: 12,
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Text(
                              'Show your hand sign in the frame',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        // Placeholder “detection box” (optional)
                        Positioned(
                          left: 55,
                          top: 120,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // --- Bottom translation panel ---
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
              child: _TranslationPanel(
                text: translatedText,
                isSpeaking: isSpeaking,
                onSpeak: _onSpeak,
                onClear: _onClear,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TranslationPanel extends StatelessWidget {
  final String text;
  final bool isSpeaking;
  final VoidCallback onSpeak;
  final VoidCallback onClear;

  const _TranslationPanel({
    required this.text,
    required this.isSpeaking,
    required this.onSpeak,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Translated Text',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Text box area
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 70, maxHeight: 120),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black12),
              ),
              child: SingleChildScrollView(
                child: Text(
                  text.isEmpty ? 'No text yet…' : text,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Speak button
            AppPrimaryIconButton(
  onPressed: (text.isEmpty || isSpeaking) ? null : onSpeak,
  icon: isSpeaking ? Icons.volume_up : Icons.record_voice_over,
  text: isSpeaking ? 'Speaking…' : 'Listen (Urdu Voice)',
),

          ],
        ),
      ),
    );
  }
}

