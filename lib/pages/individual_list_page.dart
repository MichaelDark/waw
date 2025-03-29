// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gedcom_structures/gedcom_7.dart';
import 'package:who_are_we/extensions/gedcom_structure_extension.dart';
import 'package:who_are_we/pages/individual_page.dart';
import 'package:who_are_we/widgets/gedcom_document_scope.dart';
import 'package:who_are_we/widgets/list_tiles/individual_list_tile.dart';

class IndividualListPage extends StatefulWidget {
  static Route getRoute() => MaterialPageRoute(
        builder: (_) => IndividualListPage._(),
      );

  const IndividualListPage._();

  @override
  State<IndividualListPage> createState() => _IndividualListPageState();
}

class _IndividualListPageState extends State<IndividualListPage> {
  IndividualListFilter _filter = IndividualListFilter();

  List<IndividualStructure> _applyFilter(
    Iterable<IndividualStructure> individuals,
  ) {
    List<IndividualStructure> list = individuals.toList();

    list = switch (_filter.showDeceased) {
      null => list,
      true => list.where((indi) => indi.deatList.isNotEmpty).toList(),
      false => list.where((indi) => indi.deatList.isEmpty).toList(),
    };

    list = switch (_filter.sortByBirth) {
      null => list,
      true => (list
            ..sortBy<DateTime>(
              (indi) =>
                  indi.birtList.firstOrNull?.date?.valueDateTime ??
                  DateTime(1970, 1, 1),
            ))
          .reversed
          .toList(),
      false => list
        ..sortBy<DateTime>(
          (indi) =>
              indi.birtList.firstOrNull?.date?.valueDateTime ??
              DateTime(1970, 1, 1),
        ),
    };

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final document = context.document;

    final allIndividuals = document.getAll<IndividualStructure>();
    final individuals = _applyFilter(allIndividuals);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.file.name),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              final filter = await showDialog(
                context: context,
                builder: (_) => _IndividualFilterDialog(initialFilter: _filter),
              );
              if (filter is IndividualListFilter) {
                setState(() => _filter = filter);
              }
            },
            icon: Icon(Icons.filter_alt),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: individuals.length,
        itemBuilder: (context, index) => IndividualListTile(
          individuals[index],
          onTap: () => Navigator.of(context).push(
            IndividualPage.getRoute(individuals[index]),
          ),
        ),
      ),
    );
  }
}

class IndividualListFilter {
  final bool? sortByBirth;
  final bool? showDeceased;

  const IndividualListFilter({
    this.sortByBirth,
    this.showDeceased,
  });
}

class _IndividualFilterDialog extends StatefulWidget {
  final IndividualListFilter initialFilter;

  const _IndividualFilterDialog({required this.initialFilter});

  @override
  State<_IndividualFilterDialog> createState() =>
      _IndividualFilterDialogState();
}

class _IndividualFilterDialogState extends State<_IndividualFilterDialog> {
  late bool? _sortByBirth;
  late bool? _showDeceased;

  @override
  void initState() {
    super.initState();
    _sortByBirth = widget.initialFilter.sortByBirth;
    _showDeceased = widget.initialFilter.showDeceased;
  }

  IndividualListFilter _createFilter() {
    return IndividualListFilter(
      sortByBirth: _sortByBirth,
      showDeceased: _showDeceased,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Filters'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(_createFilter()),
              icon: Icon(Icons.check),
            ),
          ],
        ),
        body: ListView(
          children: [
            CheckboxListTile(
              title: Text('Birthday Sorting'),
              subtitle: Text(
                switch (_sortByBirth) {
                  null => 'Disabled',
                  true => 'Young first',
                  false => 'Senior first',
                },
              ),
              value: _sortByBirth,
              tristate: true,
              onChanged: (newValue) {
                setState(() => _sortByBirth = newValue);
              },
            ),
            CheckboxListTile(
              title: Text(
                switch (_showDeceased) {
                  null => 'Show alive and dead',
                  true => 'Show only dead',
                  false => 'Show only alive',
                },
              ),
              value: _showDeceased,
              tristate: true,
              onChanged: (newValue) {
                setState(() => _showDeceased = newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
