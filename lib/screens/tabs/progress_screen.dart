// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CourseProgress {
  final String name;
  final Color color;
  final List<FlSpot> weeklyData; 
  final int totalLessons;
  final int completedLessons;
  final String category;

  const CourseProgress({
    required this.name,
    required this.color,
    required this.weeklyData,
    required this.totalLessons,
    required this.completedLessons,
    required this.category,
  });

  double get percentage => (completedLessons / totalLessons) * 100;
}
//  SCREEN

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _chartController;
  late Animation<double> _fadeAnim;
  late Animation<double> _chartAnim;

  int _selectedCourseIndex = 0;

  // ── Sample data
  final List<CourseProgress> _courses = [
    CourseProgress(
      name: 'Flutter Development',
      color: const Color(0xFF6C63FF),
      category: 'Mobile',
      totalLessons: 40,
      completedLessons: 28,
      weeklyData: const [
        FlSpot(1, 5),
        FlSpot(2, 15),
        FlSpot(3, 25),
        FlSpot(4, 40),
        FlSpot(5, 52),
        FlSpot(6, 60),
        FlSpot(7, 70),
      ],
    ),
    CourseProgress(
      name: 'Python & Data Science',
      color: const Color(0xFF00C9A7),
      category: 'AI/ML',
      totalLessons: 60,
      completedLessons: 18,
      weeklyData: const [
        FlSpot(1, 2),
        FlSpot(2, 8),
        FlSpot(3, 14),
        FlSpot(4, 20),
        FlSpot(5, 25),
        FlSpot(6, 28),
        FlSpot(7, 30),
      ],
    ),
    CourseProgress(
      name: 'UI/UX Design',
      color: const Color(0xFFFF6584),
      category: 'Design',
      totalLessons: 25,
      completedLessons: 22,
      weeklyData: const [
        FlSpot(1, 10),
        FlSpot(2, 24),
        FlSpot(3, 40),
        FlSpot(4, 55),
        FlSpot(5, 68),
        FlSpot(6, 80),
        FlSpot(7, 88),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _chartAnim =
        CurvedAnimation(parent: _chartController, curve: Curves.easeInOut);

    _fadeController.forward();
    _chartController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _chartController.dispose();
    super.dispose();
  }

  void _selectCourse(int index) {
    setState(() => _selectedCourseIndex = index);
    _chartController.forward(from: 0);
  }

  //  BUILD
  @override
  Widget build(BuildContext context) {
    final selected = _courses[_selectedCourseIndex];

    return Scaffold(
    appBar: AppBar(
    title: const Text('Progress'),
    ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildSummaryRow(),
                const SizedBox(height: 28),
                _buildCourseSelector(),
                const SizedBox(height: 20),
                _buildChartCard(selected),
                const SizedBox(height: 24),
                _buildCourseDetailsList(),
                const SizedBox(height: 20),
                _buildWeeklyGoalBanner(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //  HEADER
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'My Progress',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Track your learning journey 🚀',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
             color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.emoji_events_rounded,
              color: Color(0xFFFFD700), size: 22),
        ),
      ],
    );
  }

  //  SUMMARY CARDS ROW

  Widget _buildSummaryRow() {
    final totalLessons =
    _courses.fold<int>(0, (sum, c) => sum + c.totalLessons);
    final completedLessons =
    _courses.fold<int>(0, (sum, c) => sum + c.completedLessons);
    final overallPct = ((completedLessons / totalLessons) * 100).toInt();

    return Row(
      children: [
        _summaryCard('Overall', '$overallPct%', Icons.bar_chart_rounded,
            const Color(0xFF6C63FF)),
        const SizedBox(width: 12),
        _summaryCard('Courses', '${_courses.length}',
            Icons.menu_book_rounded, const Color(0xFF00C9A7)),
        const SizedBox(width: 12),
        _summaryCard('Done', '$completedLessons',
            Icons.check_circle_rounded, const Color(0xFFFF6584)),
      ],
    );
  }

  Widget _summaryCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label,
                style:
                const TextStyle(color: Colors.black54, fontSize: 11)),
          ],
        ),
      ),
    );
  }
  //  COURSE SELECTOR CHIPS
  Widget _buildCourseSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Course',
            style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _courses.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final isSelected = i == _selectedCourseIndex;
              final c = _courses[i];
              return GestureDetector(
                onTap: () => _selectCourse(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? c.color
                        : const Color(0xFF1E1E30),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                        isSelected ? c.color : Colors.white12),
                  ),
                  child: Text(
                    c.name.split(' ').first,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white54,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  //  LINE CHART CARt
  Widget _buildChartCard(CourseProgress course) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
          color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: course.color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
              color: course.color.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(course.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: course.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${course.percentage.toInt()}%',
                  style: TextStyle(
                      color: course.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${course.completedLessons} of ${course.totalLessons} lessons completed',
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 20),
          // ── Animated Line Chart ──
          AnimatedBuilder(
            animation: _chartAnim,
            builder: (context, _) {
              return SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minX: 1,
                    maxX: 7,
                    minY: 0,
                    maxY: 100,
                    clipData: const FlClipData.all(),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 25,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: Colors.white.withOpacity(0.06),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 25,
                          reservedSize: 36,
                          getTitlesWidget: (value, _) => Text(
                            '${value.toInt()}%',
                            style: const TextStyle(
                                color: Colors.white30, fontSize: 10),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, _) => Text(
                            'W${value.toInt()}',
                            style: const TextStyle(
                                color: Colors.white30, fontSize: 10),
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _animatedSpots(
                            course.weeklyData, _chartAnim.value),
                        isCurved: true,
                        curveSmoothness: 0.4,
                        color: course.color,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, pct, bar, idx) =>
                              FlDotCirclePainter(
                                radius: 4,
                                color: course.color,
                                strokeWidth: 2,
                                strokeColor: const Color(0xFF1A1A2E),
                              ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              course.color.withOpacity(0.25),
                              course.color.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => const Color(0xFF252540),
                        getTooltipItems: (spots) => spots
                            .map((s) => LineTooltipItem(
                          '${s.y.toInt()}%\nWeek ${s.x.toInt()}',
                          TextStyle(
                              color: course.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text('Weekly Progress',
                style: TextStyle(color: Colors.white24, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  /// Animate chart spots from y=0 to full value
  List<FlSpot> _animatedSpots(List<FlSpot> spots, double t) {
    return spots.map((s) => FlSpot(s.x, s.y * t)).toList();
  }
  //  COURSE DETAILS LIST
  Widget _buildCourseDetailsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('All Courses',
            style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ..._courses.asMap().entries.map((entry) {
          final i = entry.key;
          final c = entry.value;
          return GestureDetector(
            onTap: () => _selectCourse(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: i == _selectedCourseIndex
                    ? c.color.withOpacity(0.12)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: i == _selectedCourseIndex
                      ? c.color.withOpacity(0.5)
                      : Colors.white10,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: c.color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(c.category,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 11)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${c.percentage.toInt()}%',
                        style: TextStyle(
                            color: c.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: c.percentage / 100,
                            minHeight: 5,
                            backgroundColor: Colors.white10,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(c.color),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
  //  WEEKLY GOAL BANNER
  Widget _buildWeeklyGoalBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF48CAE4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_rounded,
              color: Colors.deepOrange, size: 32),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weekly Goal: 5 Lessons',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                SizedBox(height: 3),
                Text('3 of 5 done this week. Keep going! 💪',
                    style:
                    TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}