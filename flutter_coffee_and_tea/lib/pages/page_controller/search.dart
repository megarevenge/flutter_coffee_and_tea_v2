import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(color: Color(0xffF3E4C9), fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff8A5F41),
      ),
      backgroundColor: Colors.white, 
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Ensures taps pass through and register on empty spaces
        onTap: () {
          FocusScope.of(context).unfocus(); // Drops keyboard focus away cleanly
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 40), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20), 
                child: Row(
                  children: [
                    Expanded( 
                      
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search, color: Colors.grey), 
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff8A5F41)), 
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}