import 'package:flutter/material.dart';
import 'package:genbi/components/glass.dart';
import 'package:genbi/components/primary_button.dart';

class Transform extends StatefulWidget {
  final String companyName;
  const Transform({super.key, required this.companyName});

  @override
  State<Transform> createState() => _TransformState();
}

class _TransformState extends State<Transform> {
  int activeTabIndex = 0;
  List<String> uploadedDataPaths = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              "GenInsight",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6A11CB),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {},
              child: Text(
                "Dashboard",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {},
              child: Text(
                "Transformations",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {},
              child: Text(
                "History",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            const Spacer(),
            CircleAvatar(
              backgroundColor: Colors.purple.shade50,
              child: Icon(Icons.person, color: Color(0xFF6A11CB)),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(width: 1, color: Colors.grey.shade300),
              ),
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.business,
                            color: Color(0xFF6A11CB),
                            size: 35,
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.companyName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Enterprise Account",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      PrimaryButton(
                        text: "+ New Analysis",
                        expand: true,
                        onTap: () {},
                      ),
                      const SizedBox(height: 20),
                      // Selectable Tabs
                    ],
                  ),
                ),
              ),
            ),
          ),
          indexBuild(activeTabIndex),
          //Expanded(flex: 3, child: Container(color: Colors.green)),
          //Expanded(flex: 1, child: Container(color: Colors.blue)),
        ],
      ),
    );
  }

  Widget indexBuild(int index) {
    if (index == 0) {
      if (uploadedDataPaths.isEmpty) {
        return Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Upload Dataset",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Power your business analysis with raw data. Our GenAI engine supports\nstructured datasets for predictive modelling, transformation and\ndeep insight extraction.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Colors.grey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 550,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF6A11CB),
                        width: 2.0,
                      ),
                      color: Colors.grey.shade100,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.purple.shade50,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Icon(
                              Icons.cloud_upload_outlined,
                              color: Colors.deepPurple.shade600,
                              size: 35,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Drag and drop your files here",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Supports CSV, XLSX and JSON upto 100 MB",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(text: "Browse Files", onTap: () {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 550,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.indeterminate_check_box,
                                color: Colors.deepPurple.shade800,
                                size: 25,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Not ready to upload?",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Color.fromARGB(255, 51, 27, 235),
                                      size: 25,
                                    ),
                                  ],
                                ),
                                Text(
                                  "Choose a sample dataset from one of our curated datasets",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: const Color(0xFF6A11CB),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.purple.shade50,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            "ONLINE RETAIL DATASET",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6A11CB),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.purple.shade50,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            "FINANCIAL DATASET",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6A11CB),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.purple.shade50,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            "IPL 2026 DATASET",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6A11CB),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return Placeholder();
  }
}
