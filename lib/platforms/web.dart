part of package_rename;

void _setWebConfigurations(dynamic webConfig) {
  try {
    if (webConfig == null) return;
    if (webConfig is! Map) throw _PackageRenameErrors.invalidWebConfig;

    final webConfigMap = Map<String, dynamic>.from(webConfig);

    _setWebTitle(webConfigMap[_appNameKey]);
    _setPWAAppName(webConfigMap[_appNameKey]);
    _setWebDescription(webConfigMap[_descriptionKey]);
    _setPWADescription(webConfigMap[_descriptionKey]);
  } on _PackageRenameException catch (e) {
    _logger.e('${e.message}ERR Code: ${e.code}');
    _logger.e('Skipping Web configuration!!!');
  } catch (e) {
    _logger.w(e.toString());
    _logger.e('ERR Code: 255');
    _logger.e('Skipping Web configuration!!!');
  } finally {
    if (webConfig != null) _logger.i(_majorStepDoneLineBreak);
  }
}

void _setWebTitle(dynamic appName) {
  try {
    if (appName == null) return;
    if (appName is! String) throw _PackageRenameErrors.invalidAppName;

    final webIndexFile = File(_webIndexFilePath);
    if (!webIndexFile.existsSync()) {
      throw _PackageRenameErrors.webIndexNotFound;
    }

    final webIndexString = webIndexFile.readAsStringSync();
    final webIndexDocument = html.parse(webIndexString);
    webIndexDocument.querySelector('title')?.text = appName;
    webIndexDocument
        .querySelector('meta[name="apple-mobile-web-app-title"]')
        ?.attributes['content'] = appName;

    webIndexFile.writeAsStringSync(webIndexDocument.outerHtml);

    _logger.i('Web title set to: $appName (index.html)');
  } on _PackageRenameException catch (e) {
    _logger.e('${e.message}ERR Code: ${e.code}');
    _logger.e('Web Title change failed!!!');
  } catch (e) {
    _logger.w(e.toString());
    _logger.e('ERR Code: 255');
    _logger.e('Web Title change failed!!!');
  } finally {
    if (appName != null) _logger.i(_minorStepDoneLineBreak);
  }
}

void _setPWAAppName(dynamic appName) {
  try {
    if (appName == null) return;
    if (appName is! String) throw _PackageRenameErrors.invalidAppName;

    final webManifestFile = File(_webManifestFilePath);
    if (!webManifestFile.existsSync()) {
      _logger.w('Web manifest.json not found!!!');
      return;
    }

    final webManifestString = webManifestFile.readAsStringSync();
    final newAppNameWebManifestString = webManifestString
        .replaceAll(RegExp(r'"name": "(.*?)"'), '"name": "$appName"')
        .replaceAll(
          RegExp(r'"short_name": "(.*?)"'),
          '"short_name": "$appName"',
        );

    webManifestFile.writeAsStringSync(newAppNameWebManifestString);

    _logger.i('PWA name set to: $appName (manifest.json)');
  } catch (e) {
    _logger.w(e.toString());
    _logger.e('ERR Code: 255');
    _logger.e('PWA name change failed!!!');
  } finally {
    if (appName != null) _logger.i(_minorStepDoneLineBreak);
  }
}

void _setWebDescription(dynamic description) {
  try {
    if (description == null) return;
    if (description is! String) throw _PackageRenameErrors.invalidDescription;

    final webIndexFile = File(_webIndexFilePath);
    if (!webIndexFile.existsSync()) {
      throw _PackageRenameErrors.webIndexNotFound;
    }

    final webIndexString = webIndexFile.readAsStringSync();
    final webIndexDocument = html.parse(webIndexString);
    webIndexDocument
        .querySelector('meta[name="description"]')
        ?.attributes['content'] = description;

    webIndexFile.writeAsStringSync(webIndexDocument.outerHtml);

    _logger.i('Web description set to: $description (index.html)');
  } on _PackageRenameException catch (e) {
    _logger.e('${e.message}ERR Code: ${e.code}');
    _logger.e('Web Description change failed!!!');
  } catch (e) {
    _logger.w(e.toString());
    _logger.e('ERR Code: 255');
    _logger.e('Web Description change failed!!!');
  } finally {
    if (description != null) _logger.i(_minorStepDoneLineBreak);
  }
}

void _setPWADescription(dynamic description) {
  try {
    if (description == null) return;
    if (description is! String) throw _PackageRenameErrors.invalidDescription;

    final webManifestFile = File(_webManifestFilePath);
    if (!webManifestFile.existsSync()) {
      _logger.w('Web manifest.json not found!!!');
      return;
    }

    final webManifestString = webManifestFile.readAsStringSync();
    final newDescWebManifestString = webManifestString.replaceAll(
      RegExp(r'"description": "(.*?)"'),
      '"description": "$description"',
    );

    webManifestFile.writeAsStringSync(newDescWebManifestString);

    _logger.i('PWA description set to: $description (manifest.json)');
  } catch (e) {
    _logger.w(e.toString());
    _logger.e('ERR Code: 255');
    _logger.e('PWA Description change failed!!!');
  } finally {
    if (description != null) _logger.i(_minorStepDoneLineBreak);
  }
}
