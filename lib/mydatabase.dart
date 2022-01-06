import 'package:flutter/material.dart';
import 'package:mywine/shelf.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:sqlbrite/sqlbrite.dart';

class MyDatabase {
  static BriteDatabase getBriteDatabase(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<BriteDatabase>(context, listen: listen);
  }

  static List<Cellar> getCellars(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Cellar>>(context, listen: listen);
  }

  static Cellar? getCellarById(
      {required BuildContext context,
      bool listen = true,
      required String cellarId}) {
    return Provider.of<List<Cellar>>(context, listen: listen)
        .firstWhereOrNull((cellar) => cellar.id == cellarId);
  }

  static Block? getBlockById(
      {required BuildContext context,
      bool listen = true,
      required String blockId}) {
    return Provider.of<List<Block>>(context, listen: listen)
        .firstWhereOrNull((block) => block.id == blockId);
  }

  static List<Block> getBlocks(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Block>>(context, listen: listen);
  }

  static List<Position> getPositions(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Position>>(context, listen: listen);
  }

  static List<Position> getPositionsByCellarId(
      {required BuildContext context,
      bool listen = true,
      required String cellarId}) {
    List<Block> blocks = MyDatabase.getBlocks(context: context, listen: false);
    return getPositions(context: context, listen: listen)
        .where((position) =>
            blocks.firstWhere((block) => block.id == position.block).cellar ==
            cellarId)
        .toList();
  }

  static List<Position> getPositionsByBlockId(
      {required BuildContext context,
      bool listen = true,
      required String blockId}) {
    return getPositions(context: context, listen: listen)
        .where((position) => position.block == blockId)
        .toList();
  }

  static Position? getPositionByBlockIdAndCoor(
      {required BuildContext context,
      bool listen = true,
      required String blockId,
      required Map<String, dynamic> coor}) {
    return getPositions(context: context, listen: listen).firstWhere(
        (position) =>
            position.block == blockId &&
            position.x == coor["x"] &&
            position.y == coor["y"]);
  }

  static List<Wine> getWines(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Wine>>(context, listen: listen);
  }

  static List<Map<String, dynamic>> getEnhancedWines(
      {required BuildContext context, bool listen = true}) {
    List<Map<String, dynamic>> wines = [];

    getWines(context: context, listen: listen).forEach(
      (wine) {
        Map<String, dynamic>? enhancedWine = getEnhancedWineById(
            context: context, listen: listen, wineId: wine.id);
        if (enhancedWine != null) wines.add(enhancedWine);
      },
    );

    return wines;
  }

  static Wine? getWineById(
      {required BuildContext context,
      bool listen = true,
      required String wineId}) {
    return Provider.of<List<Wine>>(context, listen: listen)
        .firstWhereOrNull((wine) => wine.id == wineId);
  }

  static Map<String, dynamic>? getEnhancedWineById(
      {required BuildContext context,
      bool listen = true,
      required String wineId}) {
    Wine? wine = getWineById(context: context, listen: listen, wineId: wineId);

    if (wine == null) return null;

    Map<String, dynamic> enhancedWine = wine.toJsonWithBool();

    Map<String, dynamic>? enhancedAppellation = getEnhancedAppellationById(
      context: context,
      appellationId: enhancedWine["appellation"],
      listen: listen,
    );

    Domain? domain = getDomainById(
      context: context,
      domainId: enhancedWine["domain"],
      listen: listen,
    );

    if (enhancedAppellation == null || domain == null) return null;

    enhancedWine["appellation"] = enhancedAppellation;
    enhancedWine["domain"] = domain;

    return enhancedWine;
  }

  static List<dynamic> getOnce(
      {required BuildContext context, required List<dynamic> dataList}) {
    List<dynamic> result = [];

    dataList.forEach((data) =>
        result.indexWhere((dataAdded) => data.name == dataAdded.name) == -1
            ? result.add(data)
            : null);

    result.sort((a, b) => a.name.compareTo(b.name));

    return result;
  }

  static List<Appellation> getAppellations(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Appellation>>(context, listen: listen);
  }

  // static List<Appellation> getUsedAppellations(
  //     {required BuildContext context, bool listen = true}) {
  //   List<Appellation> listUsedAppellations = [];
  //   List<Wine> listWines = MyDatabase.getWines(context: context, listen: false)
  //       .where((element) => element.size > 0)
  //       .toList();

  //   listWines.forEach((wine) {
  //     Appellation? appellation = MyDatabase.getAppellationById(
  //         context: context, appellationId: wine.appellation);
  //     if (appellation == null) return;
  //     listUsedAppellations.add(appellation);
  //   });
  //   return List<Appellation>.from(
  //       MyDatabase.getOnce(context: context, dataList: listUsedAppellations));
  // }

  static List<Appellation> getAppellationsWithStock(
      {required BuildContext context, bool listen = true}) {
    return getAppellations(context: context, listen: listen)
        .where((a) =>
            getQuantityOfAppellation(context: context, appellationId: a.id) > 0)
        .toList();
  }

  static Appellation? getAppellationById(
      {required BuildContext context,
      required String appellationId,
      bool listen = true}) {
    return Provider.of<List<Appellation>>(context, listen: listen)
        .firstWhereOrNull((appellation) => appellation.id == appellationId);
  }

  static Map<String, dynamic>? getEnhancedAppellationById(
      {required BuildContext context,
      required String appellationId,
      bool listen = true}) {
    Appellation? appellation = getAppellationById(
        context: context, appellationId: appellationId, listen: listen);

    if (appellation == null) return null;

    Map<String, dynamic> enhancedAppellation = appellation.toJsonWithBool();

    Map<String, dynamic>? enhancedRegion = getEnhancedRegionById(
      context: context,
      regionId: enhancedAppellation["region"],
      listen: listen,
    );

    if (enhancedRegion == null) return null;

    enhancedAppellation["region"] = enhancedRegion;

    return enhancedAppellation;
  }

  static List<Region> getRegions(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Region>>(context, listen: listen);
  }

  // static List<Region> getUsedRegions(
  //     {required BuildContext context, bool listen = true}) {
  //   List<Region> listUsedRegions = [];
  //   List<Wine> listWines = MyDatabase.getWines(context: context, listen: false)
  //       .where((element) => element.size > 0)
  //       .toList();

  //   listWines.forEach((wine) {
  //     Appellation? appellation = MyDatabase.getAppellationById(
  //         context: context, appellationId: wine.appellation);
  //     if (appellation == null) return;
  //     Region? region = MyDatabase.getRegionById(
  //         context: context, regionId: appellation.region);
  //     if (region == null) return;
  //     listUsedRegions.add(region);
  //   });
  //   return List<Region>.from(
  //       MyDatabase.getOnce(context: context, dataList: listUsedRegions));
  // }

  static List<Region> getRegionsWithStock(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Region>>(context, listen: listen)
        .where((r) => getQuantityOfRegion(context: context, regionId: r.id) > 0)
        .toList();
  }

  static Region? getRegionById(
      {required BuildContext context,
      required String regionId,
      bool listen = true}) {
    return Provider.of<List<Region>>(context, listen: listen)
        .firstWhereOrNull((region) => region.id == regionId);
  }

  static Map<String, dynamic>? getEnhancedRegionById(
      {required BuildContext context,
      required String regionId,
      bool listen = true}) {
    Region? region =
        getRegionById(context: context, regionId: regionId, listen: listen);

    if (region == null) return null;

    Map<String, dynamic> enhancedRegion = region.toJsonWithBool();

    Country? country = getCountryById(
      context: context,
      countryId: enhancedRegion["country"],
      listen: listen,
    );

    if (country == null) return null;

    enhancedRegion["country"] = country;

    return enhancedRegion;
  }

  static List<Country> getCountries(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Country>>(context, listen: listen);
  }

  static List<Country> getCountriesWithStock(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Country>>(context, listen: listen)
        .where(
            (c) => getQuantityOfCountry(context: context, countryId: c.id) > 0)
        .toList();
  }

  static Country? getCountryById(
      {required BuildContext context,
      required String countryId,
      bool listen = true}) {
    return Provider.of<List<Country>>(context, listen: listen)
        .firstWhereOrNull((country) => country.id == countryId);
  }

  static List<Domain> getDomains(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Domain>>(context, listen: listen);
  }

  // static List<Domain> getUsedDomains(
  //     {required BuildContext context, bool listen = true}) {
  //   List<Domain> listUsedDomains = [];
  //   List<Wine> listWines = MyDatabase.getWines(context: context, listen: false)
  //       .where((element) => element.size > 0)
  //       .toList();

  //   listWines.forEach((wine) {
  //     Domain? domain =
  //         MyDatabase.getDomainById(context: context, domainId: wine.domain);
  //     if (domain == null) return;
  //     listUsedDomains.add(domain);
  //   });
  //   return List<Domain>.from(
  //       MyDatabase.getOnce(context: context, dataList: listUsedDomains));
  // }

  static List<Domain> getDomainsWithStock(
      {required BuildContext context, bool listen = true}) {
    return Provider.of<List<Domain>>(context, listen: listen)
        .where((d) => getQuantityOfDomain(context: context, domainId: d.id) > 0)
        .toList();
  }

  static Domain? getDomainById(
      {required BuildContext context,
      required String domainId,
      bool listen = true}) {
    return Provider.of<List<Domain>>(context, listen: listen)
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
    listOfFreeWines.sort((a, b) {
      Wine aWine = a["wine"] as Wine;
      Wine bWine = b["wine"] as Wine;
      return bWine.createdAt.compareTo(aWine.createdAt);
    });
    return listOfFreeWines;
  }

  static int countWines(
      {required BuildContext context,
      required List<Map<String, Object>> listWines}) {
    int totalFreeWines = 0;
    listWines.forEach((map) => totalFreeWines += map["freeQuantity"] as int);
    return totalFreeWines;
  }

  static int countFreeWineById(
      {required BuildContext context,
      bool listen = true,
      required String wineId}) {
    Wine? wine = getWineById(context: context, listen: listen, wineId: wineId);
    List<Position> positions = getPositions(context: context, listen: listen);

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

  static List<ColorBottle> getColorsWithStock({
    required BuildContext context,
  }) {
    List<ColorBottle> listUsedColors = [];
    List<Wine> listWines = MyDatabase.getWines(context: context, listen: false)
        .where((element) => element.size > 0)
        .toList();

    listWines.forEach((wine) {
      String? colorIndex = MyDatabase.getAppellationById(
                  context: context, appellationId: wine.appellation)
              ?.color ??
          null;
      if (colorIndex == null) return;
      listUsedColors.add(ColorBottle(
          name: CustomMethods.getColorByIndex(colorIndex)["name"],
          value: colorIndex));
    });
    return List<ColorBottle>.from(
        MyDatabase.getOnce(context: context, dataList: listUsedColors));
  }

  static List<SizeBottle> getSizesWithStock({
    required BuildContext context,
  }) {
    List<SizeBottle> listUsedSizes = [];
    List<Wine> listWines = MyDatabase.getWines(context: context, listen: false)
        .where((element) => element.size > 0)
        .toList();

    listWines.forEach((wine) {
      String sizeIndex = wine.size.toString();

      listUsedSizes.add(SizeBottle(
          name: CustomMethods.getColorByIndex(sizeIndex)["name"],
          value: int.parse(sizeIndex)));
    });
    return List<SizeBottle>.from(
        MyDatabase.getOnce(context: context, dataList: listUsedSizes));
  }
}
