import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/character.dart';
import 'package:flutter_application_1/screens/character_detail.dart';
import 'package:flutter_application_1/services/api_service.dart';

class CharacterList extends StatefulWidget {
  const CharacterList({super.key});

  @override
  State<CharacterList> createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  List<Character> characters = [];
  int currentPage = 1;
  bool isLoading = true;
  bool hasError = true;

  @override
  void initState() {
    super.initState();
    loadCharacters();
  }

  Future<void> loadCharacters() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final newCharacters = await CharacterService.getCharacters(
        page: currentPage,
      );
      setState(() {
        characters.addAll(newCharacters);
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
        hasError = true;
      });

      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load characters')));
    }
  }

  Future<void> loadNextPage() async {
    currentPage++;
    try {
      final newCharacters = await CharacterService.getCharacters(
        page: currentPage,
      );
      setState(() {
        characters.addAll(newCharacters);
      });
    } catch (e) {
      // Handle error
      currentPage--;

      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load more characters')));
    }
  }

  Color getStatusColor(String state) {
    switch (state.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      case 'unknown':
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF34495E),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Rick and Morty Characters',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF2C3E50),
      ),
      body:
          isLoading && characters.isEmpty
              ? Center(child: CircularProgressIndicator())
              : hasError
              ? Center(
                child: Text(
                  'Error loading characters',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              )
              : RefreshIndicator(
                onRefresh: () async {
                  currentPage = 1;
                  await loadCharacters();
                },
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.75, // Ajustado para ser más rectangular
                  ),
                  itemCount: characters.length + 1,
                  itemBuilder: (context, index) {
                    if (index == characters.length) {
                      return Padding(
                        padding: EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: loadNextPage,
                          child: Text('Load More'),
                        ),
                      );
                    }

                    final character = characters[index];
                    return Card(
                      margin: EdgeInsets.all(4.0),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      CharacterDetail(character: character),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            // Imagen de fondo
                            SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Image.network(
                                character.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey[600],
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Overlay oscuro en la parte inferior
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.8),
                                      Colors.black.withValues(alpha: 0.6),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Nombre del personaje
                                    Text(
                                      character.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 2,
                                            color: Colors.black.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),

                                    // Status y species
                                    Text(
                                      '${character.status} • ${character.species}',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        fontSize: 12,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 2,
                                            color: Colors.black.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Indicador de status (punto de color en la esquina superior derecha)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: getStatusColor(character.status),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
