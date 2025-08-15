// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _ReportApiService implements ReportApiService {
  _ReportApiService(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'http://10.0.2.2:8080/api/';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<void> sendReportWithImages(
    int ticketId,
    String? date,
    String? serviceType,
    String? checklistJson,
    String? dateTime,
    String? defectsFound,
    String? solutionsProvided,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (date != null) {
      _data.fields.add(MapEntry('date', date));
    }
    if (serviceType != null) {
      _data.fields.add(MapEntry('serviceType', serviceType));
    }
    if (checklistJson != null) {
      _data.fields.add(MapEntry('checklist', checklistJson));
    }
    if (dateTime != null) {
      _data.fields.add(MapEntry('dateTime', dateTime));
    }
    if (defectsFound != null) {
      _data.fields.add(MapEntry('defectsFound', defectsFound));
    }
    if (solutionsProvided != null) {
      _data.fields.add(MapEntry('solutionsProvided', solutionsProvided));
    }
    final _options = _setStreamType<void>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        contentType: 'multipart/form-data',
      )
          .compose(
            _dio.options,
            '/tickets/${ticketId}/reports',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
