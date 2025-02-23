# pvi_api.api.DefaultApi

## Load the API package
```dart
import 'package:pvi_api/api.dart';
```

All URIs are relative to *https://backend-preven-ia-production.up.railway.app/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authenticationLoginPost**](DefaultApi.md#authenticationloginpost) | **POST** /authentication/login | 
[**authenticationRegisterPost**](DefaultApi.md#authenticationregisterpost) | **POST** /authentication/register | 
[**fileExtractContentPost**](DefaultApi.md#fileextractcontentpost) | **POST** /file/extract-content | 
[**fileIdGet**](DefaultApi.md#fileidget) | **GET** /file/{id} | 


# **authenticationLoginPost**
> authenticationLoginPost(body)



### Example
```dart
import 'package:pvi_api/api.dart';

final api = PviApi().getDefaultApi();
final AuthenticationLoginPostRequest body = ; // AuthenticationLoginPostRequest | 

try {
    api.authenticationLoginPost(body);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->authenticationLoginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**AuthenticationLoginPostRequest**](AuthenticationLoginPostRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authenticationRegisterPost**
> authenticationRegisterPost(body)



### Example
```dart
import 'package:pvi_api/api.dart';

final api = PviApi().getDefaultApi();
final AuthenticationRegisterPostRequest body = ; // AuthenticationRegisterPostRequest | 

try {
    api.authenticationRegisterPost(body);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->authenticationRegisterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**AuthenticationRegisterPostRequest**](AuthenticationRegisterPostRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **fileExtractContentPost**
> fileExtractContentPost(body)



### Example
```dart
import 'package:pvi_api/api.dart';

final api = PviApi().getDefaultApi();
final FileExtractContentPostRequest body = ; // FileExtractContentPostRequest | 

try {
    api.fileExtractContentPost(body);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->fileExtractContentPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**FileExtractContentPostRequest**](FileExtractContentPostRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **fileIdGet**
> fileIdGet(id)



### Example
```dart
import 'package:pvi_api/api.dart';

final api = PviApi().getDefaultApi();
final String id = id_example; // String | 

try {
    api.fileIdGet(id);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->fileIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

