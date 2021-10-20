import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:sqlbrite/sqlbrite.dart';

class MyDatabase {
  static BriteDatabase getBriteDatabase({required BuildContext context}) {
    return Provider.of<BriteDatabase>(context);
  }

  static List<Cellar> getCellars({required BuildContext context}) {
    return Provider.of<List<Cellar>>(context);
  }

  static List<Block> getBlocks({required BuildContext context}) {
    return Provider.of<List<Block>>(context);
  }

  static List<Position> getPositions({required BuildContext context}) {
    return Provider.of<List<Position>>(context);
  }

  static List<Position> getPositionsByBlockId(
      {required BuildContext context, required String blockId}) {
    return getPositions(context: context)
        .where((position) => position.block == blockId)
        .toList();
  }

  static List<Wine> getWines({required BuildContext context}) {
    return Provider.of<List<Wine>>(context);
  }

  static List<Map<String, dynamic>> getEnhancedWines(
      {required BuildContext context}) {
    List<Map<String, dynamic>> wines = [];

    Provider.of<List<Wine>>(context, listen: false).forEach(
      (wine) {
        Map<String, dynamic>? enhancedWine =
            getEnhancedWineById(context: context, wineId: wine.id);
        if (enhancedWine != null) wines.add(enhancedWine);
      },
    );

    return wines;
  }

  static Wine? getWineById(
      {required BuildContext context, required String wineId}) {
    return Provider.of<List<Wine>>(context, listen: false)
        .firstWhereOrNull((wine) => wine.id == wineId);
  }

  static Map<String, dynamic>? getEnhancedWineById(
      {required BuildContext context, required String wineId}) {
    Wine? wine = getWineById(context: context, wineId: wineId);

    if (wine == null) return null;

    Map<String, dynamic> enhancedWine = wine.toJsonWithBool();

    Map<String, dynamic>? enhancedAppellation = getEnhancedAppellationById(
      context: context,
      appellationId: enhancedWine["appellation"],
    );

    Domain? domain = getDomainById(
      context: context,
      domainId: enhancedWine["domain"],
    );

    if (enhancedAppellation == null || domain == null) return null;

    enhancedWine["appellation"] = enhancedAppellation;
    enhancedWine["domain"] = domain;

    return enhancedWine;
  }

  static List<dynamic> getOnce(
      {required BuildContext context, required List<dynamic> dataList}) {
    List<dynamic> result = [];

    dataList.forEach((data) => result.indexWhere((dataAdded) =>
                data.name.toLowerCase() == dataAdded.name.toLowerCase()) ==
            -1
        ? result.add(data)
        : null);

    result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    print(result);
    return result;
  }

  static List<Appellation> getAppellations(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Appellation>>(context, listen: listen);
  }

  static List<Appellation> getAppellationsWithStock(
      {required BuildContext context}) {
    return getAppellations(context: context, listen: false)
        .where((a) =>
            getQuantityOfAppellation(context: context, appellationId: a.id) > 0)
        .toList();
  }

  static Appellation? getAppellationById(
      {required BuildContext context, required String appellationId}) {
    return Provider.of<List<Appellation>>(context, listen: false)
        .firstWhereOrNull((appellation) => appellation.id == appellationId);
  }

  static Map<String, dynamic>? getEnhancedAppellationById(
      {required BuildContext context, required String appellationId}) {
    Appellation? appellation =
        getAppellationById(context: context, appellationId: appellationId);

    if (appellation == null) return null;

    Map<String, dynamic> enhancedAppellation = appellation.toJsonWithBool();

    Map<String, dynamic>? enhancedRegion = getEnhancedRegionById(
      context: context,
      regionId: enhancedAppellation["region"],
    );

    if (enhancedRegion == null) return null;

    enhancedAppellation["region"] = enhancedRegion;

    return enhancedAppellation;
  }

  static List<Region> getRegions(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Region>>(context, listen: listen);
  }

  static List<Region> getRegionsWithStock({required BuildContext context}) {
    return Provider.of<List<Region>>(context, listen: false)
        .where((r) => getQuantityOfRegion(context: context, regionId: r.id) > 0)
        .toList();
  }

  static Region? getRegionById(
      {required BuildContext context, required String regionId}) {
    return Provider.of<List<Region>>(context, listen: false)
        .firstWhereOrNull((region) => region.id == regionId);
  }

  static Map<String, dynamic>? getEnhancedRegionById(
      {required BuildContext context, required String regionId}) {
    Region? region = getRegionById(context: context, regionId: regionId);

    if (region == null) return null;

    Map<String, dynamic> enhancedRegion = region.toJsonWithBool();

    Country? country = getCountryById(
      context: context,
      countryId: enhancedRegion["country"],
    );

    if (country == null) return null;

    enhancedRegion["country"] = country;

    return enhancedRegion;
  }

  static List<Country> getCountries({required BuildContext context}) {
    return Provider.of<List<Country>>(context);
  }

  static List<Country> getCountriesWithStock({required BuildContext context}) {
    return Provider.of<List<Country>>(context, listen: false)
        .where(
            (c) => getQuantityOfCountry(context: context, countryId: c.id) > 0)
        .toList();
  }

  static Country? getCountryById(
      {required BuildContext context, required String countryId}) {
    return Provider.of<List<Country>>(context, listen: false)
        .firstWhereOrNull((country) => country.id == countryId);
  }

  static List<Domain> getDomains(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Domain>>(context, listen: listen);
  }

  static List<Domain> getDomainsWithStock({required BuildContext context}) {
    return Provider.of<List<Domain>>(context, listen: false)
        .where((d) => getQuantityOfDomain(context: context, domainId: d.id) > 0)
        .toList();
  }

  static Domain? getDomainById(
      {required BuildContext context, required String domainId}) {
    return Provider.of<List<Domain>>(context, listen: false)
        .firstWhereOrNull((domain) => domain.id == domainId);
  }

  static List<Map<String, Object>> getFreeWines(
      {required BuildContext context}) {
    List<Wine> wines = getWines(context: context);
    List<Position> positions = getPositions(context: context);
    List<Map<String, Object>> listOfFreeWines = [];

    wines.forEach((Wine wine) {
      int freeQuantity = wine.quantity -
          positions.where((position) => position.wine == wine.id).length;
      if (freeQuantity > 0)
        listOfFreeWines.add({"wine": wine, "freeQuantity": freeQuantity});
    });
    return listOfFreeWines;
  }

  static int countFreeWines({required BuildContext context}) {
    int totalFreeWines = 0;
    getFreeWines(context: context)
        .forEach((map) => totalFreeWines += map["freeQuantity"] as int);
    return totalFreeWines;
  }

  static int countFreeWineById(
      {required BuildContext context, required String wineId}) {
    Wine? wine = getWineById(context: context, wineId: wineId);
    List<Position> positions = getPositions(context: context);

    if (wine == null) return 0;

    return wine.quantity -
        positions.where((position) => position.wine == wineId).length;
  }

  static Future<void> addWine(
      {required BuildContext context, required Wine wine}) {
    BriteDatabase _briteDb = getBriteDatabase(context: context);
    return _briteDb.insert(
      'wines',
      wine.toJson(),
    );
  }

  static Map<String, dynamic>? getEnhancedWineByPosition({
    required BuildContext context,
    required String block,
    required int x,
    required int y,
  }) {
    List<Position> positions = getPositions(context: context);
    Position? position = positions.firstWhereOrNull(
      (element) => element.y == y && element.x == x && element.block == block,
    );

    if (position == null) return null;

    Map<String, dynamic>? wine =
        getEnhancedWineById(context: context, wineId: position.wine);

    return wine;
  }

  static String? getColorByPosition(
      {required BuildContext context,
      required String block,
      required int x,
      required int y}) {
    List<Position> positions = getPositions(context: context);
    Position? position = positions.firstWhereOrNull(
      (element) => element.y == y && element.x == x && element.block == block,
    );

    if (position == null) return null;

    List<Appellation> appellations = getAppellations(context: context);

    List<Wine> wines = getWines(context: context);

    Wine? wine = wines.firstWhereOrNull((wine) => wine.id == position.wine);

    if (wine == null) return null;

    Appellation? appellation = appellations
        .firstWhereOrNull((appellation) => appellation.id == wine.appellation);

    if (appellation == null) return null;

    return appellation.color;
  }

  static int getQuantityOfAppellation({
    required BuildContext context,
    required String appellationId,
  }) {
    final List<Wine> _wines = Provider.of<List<Wine>>(context, listen: false);
    int quantity = 0;

    _wines
        .where((wine) => wine.appellation == appellationId)
        .forEach((wine) => quantity += wine.quantity);

    return quantity;
  }

  static int getQuantityOfDomain({
    required BuildContext context,
    required String domainId,
  }) {
    final List<Wine> _wines = Provider.of<List<Wine>>(context, listen: false);
    int quantity = 0;

    _wines
        .where((wine) => wine.domain == domainId)
        .forEach((wine) => quantity += wine.quantity);

    return quantity;
  }

  static int getQuantityOfCountry({
    required BuildContext context,
    required String countryId,
  }) {
    final List<Region> _regions =
        Provider.of<List<Region>>(context, listen: false);
    final List<Appellation> _appellations =
        Provider.of<List<Appellation>>(context, listen: false);
    final List<Wine> _wines = Provider.of<List<Wine>>(context, listen: false);
    int quantity = 0;

    _regions.where((region) => region.country == countryId).forEach(
          (r) => _appellations.where((a) => a.region == r.id).forEach(
                (a) => _wines
                    .where((w) => w.appellation == a.id)
                    .forEach((wine) => quantity += wine.quantity),
              ),
        );

    return quantity;
  }

  static int getQuantityOfRegion({
    required BuildContext context,
    required String regionId,
  }) {
    final List<Appellation> _appellations =
        Provider.of<List<Appellation>>(context, listen: false);
    final List<Wine> _wines = Provider.of<List<Wine>>(context, listen: false);
    int quantity = 0;

    _appellations.where((a) => a.region == regionId).forEach(
          (a) => _wines
              .where((w) => w.appellation == a.id)
              .forEach((wine) => quantity += wine.quantity),
        );

    return quantity;
  }
}
