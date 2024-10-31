import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 선택을 위한 패키지
import 'dart:io'; // 파일 입출력을 위한 패키지
import 'package:path_provider/path_provider.dart'; // 디렉토리 경로를 얻기 위한 패키지
import 'package:image/image.dart' as img; // 이미지 처리 패키지
import 'package:provider/provider.dart'; // 상태 관리를 위한 패키지
import 'package:photo_view/photo_view.dart'; // 이미지 확대를 위한 패키지
import 'package:photo_view/photo_view_gallery.dart'; // 갤러리 기능을 위한 패키지

// 앱의 시작점
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ImageProviderModel(),
      child: DayNightClassifierApp(),
    ),
  );
}

// 상태 관리를 위한 모델 클래스
class ImageProviderModel extends ChangeNotifier {
  bool isDarkMode = false; // 다크 모드 여부를 저장
  int brightnessThreshold = 128; // 밝기 기준값을 저장

  // 다크 모드 토글 함수
  void toggleDarkMode(bool value) {
    isDarkMode = value;
    notifyListeners(); // 상태 변경을 알림
  }

  // 밝기 기준값 설정 함수
  void setBrightnessThreshold(int value) {
    brightnessThreshold = value;
    notifyListeners(); // 상태 변경을 알림
  }
}

// 앱의 메인 위젯
class DayNightClassifierApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '낮과 밤 분류기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      // 다크 모드 설정에 따라 테마를 적용
      themeMode: context.watch<ImageProviderModel>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: WelcomeScreen(), // 첫 화면으로 WelcomeScreen을 표시
    );
  }
}

// 환영 화면 위젯
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 배경과 디자인 요소를 위한 Stack 위젯
      body: Stack(
        children: <Widget>[
          // 배경 그라데이션을 위한 컨테이너
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // 중앙에 환영 메시지와 버튼을 표시
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '환영합니다',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  child: Text('접속'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    // 메인 화면으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // 설정 아이콘은 WelcomeScreen에서는 필요 없으므로 제거
        ],
      ),
    );
  }
}

// 메인 기능을 담당하는 화면
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

// 메인 화면의 상태 클래스
class _MainScreenState extends State<MainScreen> {
  final ImagePicker _picker = ImagePicker(); // 이미지 선택을 위한 ImagePicker
  File? _displayedImage; // 화면에 표시할 이미지 파일
  int? _imageBrightness; // 이미지의 평균 밝기 값
  int? _brightnessThreshold; // 설정된 밝기 기준 값
  String? _classificationResult; // 분류 결과 ('낮' 또는 '밤')

  // 사진을 업로드하거나 촬영하는 함수
  void _uploadPhoto(BuildContext context, ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);

      if (image != null) {
        File imageFile = File(image.path);
        int brightness = await _calculateBrightness(imageFile);

        // 설정된 밝기 기준값 가져오기
        int threshold = context.read<ImageProviderModel>().brightnessThreshold;
        String folderName = brightness > threshold ? '낮' : '밤';

        await _saveImage(imageFile, folderName);

        // 상태 업데이트
        setState(() {
          _displayedImage = imageFile;
          _imageBrightness = brightness;
          _brightnessThreshold = threshold;
          _classificationResult = folderName;
        });

        // 사진이 저장되었음을 알리는 스낵바 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진이 "$folderName" 폴더에 저장되었습니다.')),
        );

        // 상태 변경 알림
        context.read<ImageProviderModel>().notifyListeners();
      }
    } catch (e) {
      // 오류 발생 시 스낵바로 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사진 업로드 중 오류가 발생했습니다.')),
      );
    }
  }

  // 이미지의 평균 밝기를 계산하는 함수
  Future<int> _calculateBrightness(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes(); // 이미지 바이트 읽기
      final img.Image? image = img.decodeImage(bytes); // 이미지 디코딩

      if (image == null) return 0;

      int totalBrightness = 0;
      int sampleCount = 0;

      // 이미지의 픽셀을 일정 간격으로 샘플링하여 밝기 계산
      for (int y = 0; y < image.height; y += 10) {
        for (int x = 0; x < image.width; x += 10) {
          int pixel = image.getPixel(x, y);
          int r = img.getRed(pixel);
          int g = img.getGreen(pixel);
          int b = img.getBlue(pixel);
          totalBrightness += (r + g + b) ~/ 3;
          sampleCount++;
        }
      }
      int avgBrightness = totalBrightness ~/ sampleCount; // 평균 밝기 계산
      return avgBrightness;
    } catch (e) {
      return 0; // 오류 발생 시 0 반환
    }
  }

  // 이미지를 지정된 폴더에 저장하는 함수
  Future<void> _saveImage(File imageFile, String folderName) async {
    try {
      final directory = await getApplicationDocumentsDirectory(); // 앱의 문서 디렉토리 가져오기
      final folder = Directory('${directory.path}/$folderName'); // 폴더 경로 설정
      if (!(await folder.exists())) {
        await folder.create(recursive: true); // 폴더가 없으면 생성
      }
      final fileName = imageFile.path.split('/').last; // 파일 이름 추출
      await imageFile.copy('${folder.path}/$fileName'); // 이미지 복사하여 저장
    } catch (e) {
      // 파일 저장 중 오류 처리
    }
  }

  // 갤러리 화면으로 이동하는 함수
  void _openGallery(BuildContext context, String folderName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryScreen(folderName: folderName),
      ),
    );
  }

  // 설정 화면으로 이동하는 함수
  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('낮과 밤 분류기'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _openSettings(context); // 설정 화면으로 이동
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 이미지가 있을 경우 표시
                if (_displayedImage != null)
                  Column(
                    children: [
                      Text(
                        '업로드한 이미지:',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Image.file(
                        _displayedImage!,
                        height: 200,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '분류 결과: $_classificationResult',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '이미지 밝기: $_imageBrightness',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '밝기 기준값: $_brightnessThreshold',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                // 사진 촬영 버튼
                ElevatedButton.icon(
                  icon: Icon(Icons.photo_camera),
                  label: Text('사진 촬영'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () => _uploadPhoto(context, ImageSource.camera),
                ),
                SizedBox(height: 20),
                // 사진 업로드 버튼
                ElevatedButton.icon(
                  icon: Icon(Icons.photo_library),
                  label: Text('사진 업로드'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () => _uploadPhoto(context, ImageSource.gallery),
                ),
                SizedBox(height: 30),
                // 낮 갤러리 보기 버튼
                ElevatedButton.icon(
                  icon: Icon(Icons.wb_sunny),
                  label: Text('낮 갤러리 보기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () => _openGallery(context, '낮'),
                ),
                SizedBox(height: 20),
                // 밤 갤러리 보기 버튼
                ElevatedButton.icon(
                  icon: Icon(Icons.nights_stay),
                  label: Text('밤 갤러리 보기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () => _openGallery(context, '밤'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 갤러리 화면 위젯
class GalleryScreen extends StatefulWidget {
  final String folderName; // 표시할 폴더 이름 ('낮' 또는 '밤')

  GalleryScreen({required this.folderName});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

// 갤러리 화면의 상태 클래스
class _GalleryScreenState extends State<GalleryScreen> {
  List<File> _images = []; // 이미지 파일 목록
  bool _isLoading = true; // 로딩 상태를 나타냄
  List<File> _filteredImages = []; // 검색된 이미지 목록
  TextEditingController _searchController = TextEditingController(); // 검색어 입력 컨트롤러

  @override
  void initState() {
    super.initState();
    _loadImages(); // 이미지를 로드
    _searchController.addListener(_filterImages); // 검색어 변경 시 필터링
  }

  @override
  void dispose() {
    _searchController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  // 이미지 로드 함수
  void _loadImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folder = Directory('${directory.path}/${widget.folderName}');
      if (await folder.exists()) {
        final files = folder
            .listSync()
            .where((item) =>
                item.path.endsWith(".png") ||
                item.path.endsWith(".jpg") ||
                item.path.endsWith(".jpeg"))
            .map((item) => File(item.path))
            .toList();

        setState(() {
          _images = files;
          _filteredImages = files;
          _isLoading = false;
        });
      } else {
        setState(() {
          _images = [];
          _filteredImages = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _images = [];
        _filteredImages = [];
        _isLoading = false;
      });
    }
  }

  // 이미지 검색 필터링 함수
  void _filterImages() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredImages = _images.where((image) {
        String fileName = image.path.split('/').last.toLowerCase();
        return fileName.contains(query);
      }).toList();
    });
  }

  // 이미지를 자세히 보기 위해 화면으로 이동하는 함수
  void _showImage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDetailScreen(
          images: _filteredImages,
          initialIndex: index,
        ),
      ),
    );
  }

  // 이미지를 삭제하는 함수
  void _deleteImage(File imageFile) async {
    try {
      if (await imageFile.exists()) {
        await imageFile.delete();
        _loadImages(); // 이미지 목록 갱신
      }
    } catch (e) {
      // 오류 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('"${widget.folderName}" 갤러리'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filteredImages.isEmpty
              ? Center(child: Text('이미지가 없습니다.'))
              : Column(
                  children: [
                    // 검색 창
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: '검색',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    // 이미지 그리드
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemCount: _filteredImages.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _showImage(context, index),
                            onLongPress: () async {
                              // 이미지 삭제 확인 다이얼로그
                              bool? confirmDelete = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('이미지 삭제'),
                                  content: Text('이미지를 삭제하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      child: Text('취소'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                      child: Text('삭제'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmDelete == true) {
                                _deleteImage(_filteredImages[index]);
                              }
                            },
                            child: Image.file(
                              _filteredImages[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

// 이미지 상세 보기 화면 위젯
class ImageDetailScreen extends StatefulWidget {
  final List<File> images; // 이미지 목록
  final int initialIndex; // 처음 표시할 이미지의 인덱스

  ImageDetailScreen({required this.images, required this.initialIndex});

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}

// 이미지 상세 보기 화면의 상태 클래스
class _ImageDetailScreenState extends State<ImageDetailScreen> {
  late PageController _pageController; // 페이지 컨트롤러
  late int _currentIndex; // 현재 페이지 인덱스

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  // 현재 이미지를 삭제하는 함수
  void _deleteCurrentImage() async {
    try {
      File imageFile = widget.images[_currentIndex];
      if (await imageFile.exists()) {
        await imageFile.delete();
        setState(() {
          widget.images.removeAt(_currentIndex);
          if (widget.images.isEmpty) {
            Navigator.of(context).pop();
          } else if (_currentIndex >= widget.images.length) {
            _currentIndex = widget.images.length - 1;
            _pageController.jumpToPage(_currentIndex);
          }
        });
      }
    } catch (e) {
      // 오류 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이미지 보기'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              // 이미지 삭제 확인 다이얼로그
              bool? confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('이미지 삭제'),
                  content: Text('이미지를 삭제하시겠습니까?'),
                  actions: [
                    TextButton(
                      child: Text('취소'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: Text('삭제'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );
              if (confirmDelete == true) {
                _deleteCurrentImage();
              }
            },
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        itemCount: widget.images.length,
        pageController: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(widget.images[index]),
            minScale: PhotoViewComputedScale.contained * 1.0,
            maxScale: PhotoViewComputedScale.covered * 2.0,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }
}

// 설정 화면 위젯
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ImageProviderModel>().isDarkMode; // 다크 모드 여부
    int brightnessThreshold =
        context.watch<ImageProviderModel>().brightnessThreshold; // 밝기 기준값

    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: ListView(
        children: [
          // 다크 모드 토글 스위치
          SwitchListTile(
            title: Text('다크 모드'),
            value: isDarkMode,
            onChanged: (value) {
              context.read<ImageProviderModel>().toggleDarkMode(value);
            },
            secondary: Icon(Icons.brightness_6),
          ),
          // 밝기 기준 조정 옵션
          ListTile(
            title: Text('밝기 기준 조정'),
            subtitle: Text('현재 값: $brightnessThreshold'),
            trailing: Icon(Icons.tune),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => BrightnessThresholdDialog(),
              );
            },
          ),
          // 다른 설정 옵션을 추가할 수 있음
        ],
      ),
    );
  }
}

// 밝기 기준값을 조정하는 다이얼로그 위젯
class BrightnessThresholdDialog extends StatefulWidget {
  @override
  _BrightnessThresholdDialogState createState() =>
      _BrightnessThresholdDialogState();
}

class _BrightnessThresholdDialogState
    extends State<BrightnessThresholdDialog> {
  late double _currentValue; // 현재 밝기 기준값

  @override
  void initState() {
    super.initState();
    _currentValue =
        context.read<ImageProviderModel>().brightnessThreshold.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('밝기 기준 조정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 밝기 기준값을 조정하는 슬라이더
          Slider(
            value: _currentValue,
            min: 0,
            max: 255,
            divisions: 255,
            label: _currentValue.round().toString(),
            onChanged: (value) {
              setState(() {
                _currentValue = value;
              });
            },
          ),
          Text('현재 값: ${_currentValue.round()}'),
        ],
      ),
      actions: [
        TextButton(
          child: Text('취소'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('확인'),
          onPressed: () {
            context
                .read<ImageProviderModel>()
                .setBrightnessThreshold(_currentValue.round());
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
