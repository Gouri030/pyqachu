import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// Model class for PYQ document
class PyqachuDocument {
  final String pdfUrl;
  final String subject;
  final String year;
  final String semester;
  final String regulation;
  final String uploadedBy;
  final String reviewedBy;
  final String reviewNotes;
  bool isBookmarked;

  PyqachuDocument({
    required this.pdfUrl,
    required this.subject,
    required this.year,
    required this.semester,
    required this.regulation,
    required this.uploadedBy,
    required this.reviewedBy,
    required this.reviewNotes,
    this.isBookmarked = false,
  });
}

class PdfViewerPage extends StatefulWidget {
  final PyqachuDocument document;

  const PdfViewerPage({Key? key, required this.document}) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _showInfoDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Document Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow('Subject', widget.document.subject),
            _buildInfoRow('Year', widget.document.year),
            _buildInfoRow('Semester', widget.document.semester),
            _buildInfoRow('Regulation', widget.document.regulation),
            _buildInfoRow('Uploaded by', widget.document.uploadedBy),
            _buildInfoRow('Reviewed by', widget.document.reviewedBy),
            const SizedBox(height: 16),
            const Text(
              'Review Notes',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.document.reviewNotes,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    final TextEditingController reportController = TextEditingController();
    String? selectedReason;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Issue'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select reason for reporting:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              ...['Wrong Subject', 'Wrong Year', 'Wrong Semester', 'Wrong Regulation', 'Corrupted File', 'Other']
                  .map((reason) => RadioListTile<String>(
                        title: Text(reason, style: const TextStyle(fontSize: 14)),
                        value: reason,
                        groupValue: selectedReason,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedReason = value;
                          });
                        },
                      ))
                  .toList(),
              const SizedBox(height: 16),
              TextField(
                controller: reportController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Additional details (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedReason == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a reason')),
                );
                return;
              }
              _submitReport(selectedReason!, reportController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReport(String reason, String details) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report submitted: $reason'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _toggleBookmark() {
    setState(() {
      widget.document.isBookmarked = !widget.document.isBookmarked;
    });

    // TODO: Replace with actual API call
    _updateBookmarkStatus(widget.document.isBookmarked);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.document.isBookmarked 
              ? 'Added to bookmarks' 
              : 'Removed from bookmarks',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _updateBookmarkStatus(bool isBookmarked) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));
    print('Bookmark status updated: $isBookmarked');
  }

  Future<void> _downloadPdf() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Text('Downloading PDF...'),
          ],
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // TODO: Implement actual download logic
    // You can use packages like dio + path_provider + permission_handler
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF downloaded successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.document.subject,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: _showInfoDialog,
            tooltip: 'Document Info',
          ),
          IconButton(
            icon: const Icon(Icons.flag_outlined, color: Colors.black),
            onPressed: _showReportDialog,
            tooltip: 'Report Issue',
          ),
          IconButton(
            icon: Icon(
              widget.document.isBookmarked 
                  ? Icons.bookmark 
                  : Icons.bookmark_border,
              color: widget.document.isBookmarked 
                  ? Colors.amber[700] 
                  : Colors.black,
            ),
            onPressed: _toggleBookmark,
            tooltip: 'Bookmark',
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Colors.black),
            onPressed: _downloadPdf,
            tooltip: 'Download PDF',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
          : SfPdfViewer.network(
              widget.document.pdfUrl,
              key: _pdfViewerKey,
              enableDoubleTapZooming: true,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              onDocumentLoadFailed: (details) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error loading PDF: ${details.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
    );
  }
}

// Example usage:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => PdfViewerPage(
//       document: PyqachuDocument(
//         pdfUrl: 'https://example.com/sample.pdf',
//         subject: 'Computer Networks',
//         year: '2023',
//         semester: 'Semester 6',
//         regulation: '19EAC311',
//         uploadedBy: 'John Doe',
//         reviewedBy: 'Dr. Smith',
//         reviewNotes: 'Verified and accurate. Contains all questions from the examination.',
//         isBookmarked: false,
//       ),
//     ),
//   ),
// );