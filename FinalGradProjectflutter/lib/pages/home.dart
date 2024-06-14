import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:first_project/pages/feedback.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:first_project/models/category_model.dart';
import 'package:first_project/models/news_article.dart';
import 'package:first_project/models/slider_model.dart';
import 'package:first_project/pages/contact_us.dart';
import 'package:first_project/pages/delete_account.dart';
import 'package:first_project/pages/settings.dart';
import 'package:first_project/services/news_service.dart';
import 'package:flutter/material.dart';
import 'package:first_project/pages/FAQ.dart';
import 'package:first_project/services/data.dart';
import 'package:first_project/services/slider_data.dart';
import 'package:http/http.dart' as http;
import 'package:first_project/pages/landing.dart';

void main() {
  runApp(MaterialApp(home: Home(),
  debugShowCheckedModeBanner: false,
   routes: {
    '/settings': (context) => SettingsPage(),
    '/contact_us': (context) => ContactUsPage(),
    '/faq': (context) => FAQPage(),
    '/delete_account': (context) => DeleteAccountPage(),
    '/feedback': (context) => FeedbackPage(),
    '/landing': (context) => LandingPage(),
  }));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<sliderModel> sliders = [];
  List<NewsArticle> newsArticles = [];
  List<NewsArticle> topHeadlines = [];

  int activeIndex = 0;
  int selectedCategoryIndex = 0;
  late PageController _pageController;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    sliders = getSliders();
    selectedCategoryIndex = 0;
    _pageController = PageController(initialPage: selectedCategoryIndex);
    fetchNewsArticlesForCategory(categories[selectedCategoryIndex].categoryName!);
    fetchTopHeadlines();
    fetchWorldNews();
  }

  Future<void> fetchNewsArticlesForCategory(String category) async {
    try {
      NewsService newsService = NewsService();
      List<NewsArticle> articles = await newsService.fetchNews(category);
      await _applyReliabilityPredictions(articles);
      setState(() {
        newsArticles = articles;
      });
    } catch (error) {
      print('Error fetching news articles for category $category: $error');
    }
  }

  Future<void> fetchTopHeadlines() async {
    try {
      NewsService newsService = NewsService();
      List<NewsArticle> articles = await newsService.fetchTopHeadlines();
      await _applyReliabilityPredictions(articles);
      setState(() {
        topHeadlines = articles;
        print('Fetched ${articles.length} top headlines');
      });
    } catch (error) {
      print('Error fetching top headlines: $error');
    }
  }

  Future<void> fetchWorldNews() async {
    try {
      final response = await http.get(
        Uri.parse('https://gnews.io/api/v4/top-headlines?topic=world&token=6401e1ce265271782bb5ec5c1d059fc6&lang=en'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<NewsArticle> articles = (data['articles'] as List)
            .map((json) => NewsArticle.fromJson(json))
            .toList();
        await _applyReliabilityPredictions(articles);
        setState(() {
          topHeadlines = articles;
        });
      } else {
        throw Exception('Failed to load world news');
      }
    } catch (error) {
      print('Error fetching world news: $error');
    }
  }

  Future<void> _applyReliabilityPredictions(List<NewsArticle> articles) async {
    for (var article in articles) {
      final prediction = await _getReliabilityPrediction(article.content);
      if (prediction != null) {
        article.prediction = prediction['prediction'];
        article.reliabilityScore = (prediction['reliability_score'] as num?)?.toDouble();
        article.sentiment = prediction['sentiment'];
      }
    }
  }

  Future<Map<String, dynamic>?> _getReliabilityPrediction(String? content) async {
    if (content == null || content.isEmpty) return null;
    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.185:8000/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': content}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (error) {
      print('Error fetching reliability prediction: $error');
      return null;
    }
  }

  Future<void> _searchNews(String text) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.185:8000/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        _showResultDialog(result);
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (error) {
      print('Error searching news: $error');
    }
  }

  void _showResultDialog(Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Prediction: ${result['prediction']}'),
              Text('Reliability Score: ${result['reliability_score']}%'),
              Text('Sentiment: ${result['sentiment']}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void handleMenuSelection(String value) {
    switch (value) {
      case 'Settings':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'Contact Us':
        Navigator.pushNamed(context, '/contact_us');
        break;
      case 'FAQ':
        Navigator.pushNamed(context, '/faq');
        break;
      case 'Delete Account':
        Navigator.pushNamed(context, '/delete_account');
        break;
      case 'Sign Out':
        Navigator.pushNamed(context, '/landing');
        break;
      case 'Feedback':
        Navigator.pushNamed(context, '/feedback');
        break;
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.1,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Factual"),
            Text(
              " Eye",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                iconSize: 30,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded),
            color: Colors.black,
            onPressed: () {},
          ),
          SizedBox(width: 15),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(Icons.search),
                      ),
                      hintText: 'Search article',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    ),
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        _searchNews(text);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: 55.0),
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                handleMenuSelection('Settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact Us'),
              onTap: () {
                handleMenuSelection('Contact Us');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('FAQ'),
              onTap: () {
                handleMenuSelection('FAQ');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Account'),
              onTap: () {
                handleMenuSelection('Delete Account');
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sign Out'),
              onTap: () {
                handleMenuSelection('Sign Out');
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
            height: 35.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryTile(
                  categoryName: categories[index].categoryName!,
                  isSelected: index == selectedCategoryIndex,
                  onTap: (categoryName) {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                    fetchNewsArticlesForCategory(categoryName);
                  },
                );
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (categories[selectedCategoryIndex].categoryName == 'All')
                    ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Breaking News",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 21.0),
                            ),
                            Text(
                              "View all",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.0),
                      topHeadlines.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : CarouselSlider.builder(
                              itemCount: topHeadlines.length,
                              itemBuilder: (context, index, realIndex) {
                                return buildCarouselItem(topHeadlines[index]);
                              },
                              options: CarouselOptions(
                                  enableInfiniteScroll: true,
                                  height: 200,
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.height,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      activeIndex = index;
                                    });
                                  })),
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(child: buildIndicator()),
                      SizedBox(height: 15.0),
                    ],
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (categories[selectedCategoryIndex].categoryName ==
                            'All')
                          ...[
                            Text(
                              "Recommendation",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 21.0),
                            ),
                            Text(
                              "View all",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0),
                            ),
                          ]
                        else ...[
                          SizedBox(width: 0),
                          SizedBox(width: 0),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ...newsArticles.map((article) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          children: [
                            if (article.imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                                child: Image.network(
                                  article.imageUrl!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ListTile(
                              contentPadding: EdgeInsets.all(15.0),
                              title: Text(
                                article.title ?? 'No title available',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.description ?? 'No description available',
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Reliability: ${article.prediction ?? 'Unknown'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Score: ${article.reliabilityScore != null ? article.reliabilityScore!.toStringAsFixed(2) : 'N/A'}%',
                                  ),
                                  Text(
                                    'Sentiment: ${article.sentiment ?? 'Unknown'}',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCarouselItem(NewsArticle article) => Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.imageUrl != null)
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        article.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Text(
                  article.title ?? 'No title available',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: topHeadlines.length,
        effect: ScrollingDotsEffect(
          dotWidth: 10,
          dotHeight: 10,
          activeDotColor: Colors.blue,
          dotColor: Colors.grey,
        ),
      );
}

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final bool isSelected;
  final Function(String) onTap;

  CategoryTile({
    required this.categoryName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(categoryName),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            categoryName,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
