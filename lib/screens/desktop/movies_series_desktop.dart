import 'package:flutter/material.dart';
import 'package:xpvault/layouts/desktop_layout.dart';
import 'package:xpvault/themes/app_color.dart';
import 'package:xpvault/widgets/my_dropdownbutton.dart';
import 'package:xpvault/widgets/my_imagecontainer.dart';
import 'package:xpvault/widgets/my_textformfield.dart';
import 'package:xpvault/widgets/my_movie_grid.dart';


class MoviesSeriesDesktop extends StatefulWidget {
  const MoviesSeriesDesktop({super.key});

  @override
  State<MoviesSeriesDesktop> createState() => _MoviesSeriesDesktopState();
}

class _MoviesSeriesDesktopState extends State<MoviesSeriesDesktop> {
  String dropdownvalue = "";
  // mymovieResults tiene datos de prueba
  // Ahí dentro debería entrar sin más las 0...10 películas encontradas nada más
  List<Map<String, dynamic>> mymovieResults = [
    {
      "Title": "The Lake House",
      "Year": "2006",
      "imdbID": "tt0410297",
      "Type": "movie",
      "Poster": "https://m.media-amazon.com/images/M/MV5BMTYxMTgxNDI3MV5BMl5BanBnXkFtZTcwMzIxMTIzMw@@._V1_SX300.jpg"
    },
    {
      "Title": "Eden Lake",
      "Year": "2008",
      "imdbID": "tt1020530",
      "Type": "movie",
      "Poster": "https://m.media-amazon.com/images/M/MV5BNWNmNDI2ZTYtYTliOC00ZjExLWE5MTktZjQzMjUzYWEwMTc3XkEyXkFqcGc@._V1_SX300.jpg"
    },
    {
      "Title": "Lake Placid",
      "Year": "1999",
      "imdbID": "tt0139414",
      "Type": "movie",
      "Poster": "https://m.media-amazon.com/images/M/MV5BNzY3NTk4NjYtODIzMS00YmM5LWFiODUtZDUxNThjNTNiZGRjXkEyXkFqcGc@._V1_SX300.jpg"
    },
    {
      "Title": "Under the Silver Lake",
      "Year": "2018",
      "imdbID": "tt5691670",
      "Type": "movie",
      "Poster": "https://m.media-amazon.com/images/M/MV5BMTMzN2JkZDAtYjgyMy00M2QxLWE2NWItNTEyZGVlNTgyYTViXkEyXkFqcGc@._V1_SX300.jpg"
    },
    {
      "Title": "Caddo Lake",
      "Year": "2024",
      "imdbID": "tt15552142",
      "Type": "movie",
      "Poster": "https://m.media-amazon.com/images/M/MV5BZmIyOGI3NjgtZWJlYS00NzQ0LWJkMDUtNjhlYmFkYjI3NTM5XkEyXkFqcGc@._V1_SX300.jpg"
    },
    {
      "Title": "Top of the Lake",
      "Year": "2013–2017",
      "imdbID": "tt2103085",
      "Type": "series",
      "Poster": "https://m.media-amazon.com/images/M/MV5BMjAxMjU3NDkwOV5BMl5BanBnXkFtZTgwMDI3Mzg0MTI@._V1_SX300.jpg"
    },
    {
      "Title": "Lake Mungo",
      "Year": "2008",
      "imdbID": "tt0816556",
      "Type": "movie",
      "Poster": "https://m.media-amazon.com/images/M/MV5BNTQ2YjY1ZmItZWM1MC00YzllLTgzZmItN2E1MmNlMGM5OTBjXkEyXkFqcGc@._V1_SX300.jpg"
    },
    {
      "Title": "Shimmer Lake",
      "Year": "2017",
      "imdbID": "tt1386691",
      "Type": "movie",
      "Poster": "https://m.media-amazon.com/images/M/MV5BYTI0NjZiZTctNWQ2MC00Yjc0LTg5ZTMtNjNlNTllZjE4ZDZkXkEyXkFqcGc@._V1_SX300.jpg"
    },
    {
      "Title": "Stranger by the Lake",
      "Year": "2013",
      "imdbID": "tt2852458",
      "Type": "movie",
      "Poster": "https://m.media-amazon.com/images/M/MV5BMjE5MjcxODYxMl5BMl5BanBnXkFtZTgwNzA2NjYwMTE@._V1_SX300.jpg"
    },
    {
      "Title": "To the Lake",
      "Year": "2019–2022",
      "imdbID": "tt9151230",
      "Type": "series",
      "Poster": "https://m.media-amazon.com/images/M/MV5BZTEyMmUxNDctMmI5Yy00YmZmLTkxNmYtZjUxNzNiYjA3NGUzXkEyXkFqcGc@._V1_SX300.jpg"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return DesktopLayout(
      title: "XPVAULT",
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: MyTextformfield(
                    hintText: "Search",
                    obscureText: false,
                    suffixIcon: Icon(Icons.search, color: AppColors.textMuted),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: MyDropdownbutton(
                    hint: dropdownvalue.isEmpty ? "Select genre" : dropdownvalue,
                    items: const [
                      DropdownMenuItem(
                        value: "Action",
                        child: Text("Action"),
                      ),
                      DropdownMenuItem(
                        value: "Horror",
                        child: Text("Horror"),
                      ),
                      DropdownMenuItem(
                        value: "Adventure",
                        child: Text("Adventure"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value is String) {
                        setState(() {
                          dropdownvalue = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Movies",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MyMovieGrid(movies: mymovieResults),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Last seen",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}