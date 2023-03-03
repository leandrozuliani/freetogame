import 'package:flutter/material.dart';

class GenresDropdown extends StatefulWidget {
  final Map<String, bool> genresMap;
  final Map<String, bool> selectedGenres;
  final Function(String, bool) onGenreSelectionChanged;

  const GenresDropdown({
    Key? key,
    required this.genresMap,
    required this.selectedGenres,
    required this.onGenreSelectionChanged,
  }) : super(key: key);

  @override
  GenresDropdownState createState() => GenresDropdownState();
}

class GenresDropdownState extends State<GenresDropdown> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.black38.withOpacity(0.85),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width > 580 ? 160 : 200,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                widget.selectedGenres.values
                        .where((selected) => !selected)
                        .isNotEmpty
                    ? 'Gênero: ${widget.selectedGenres.values.where((selected) => !selected).length} excluído(s)'
                    : 'Gênero: (todos)',
                style: const TextStyle(fontSize: 11),
              ),
            ),
            icon: const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Icon(
                Icons.arrow_downward,
                size: 18,
              ),
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  widget.selectedGenres[newValue] =
                      !widget.selectedGenres[newValue]!;
                  widget.onGenreSelectionChanged(
                      newValue, widget.selectedGenres[newValue]!);
                });
              }
            },
            value: null,
            items: widget.genresMap.entries
                .map(
                  (entry) => DropdownMenuItem<String>(
                    value: entry.key,
                    child: Row(
                      children: [
                        Checkbox(
                          value: widget.selectedGenres[entry.key],
                          onChanged: (value) {
                            setState(() {
                              widget.selectedGenres[entry.key] = value!;
                              widget.onGenreSelectionChanged(entry.key, value);
                              Navigator.pop(context);
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                          child: Text(
                            entry.key,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
