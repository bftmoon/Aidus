import '../models/fix_info.dart';
import '../models/id-name-pair.dart';
import '../models/issue.dart';
import '../models/issue_for_list.dart';
import '../models/story_item.dart';
import 'webservice.dart';

class ApiClient {
//  static const String URL = 'http://10.0.3.2:5000'; // Genymotion
  static const String URL = 'http://192.168.0.104:8000/api'; // In local network

  static Future<Issue> getIssue(String id) {
    return WebService.send(Method.GET, URL + '/issue/' + id, parser: (json) => Issue.fromJson(json));
  }

  static Future<List<IssueForList>> getIssues(int start, int limit, [String status]) {
    return WebService.send(
        Method.GET, URL + '/issues?start=$start&limit=$limit' + (status == null ? '' : '&status=$status'),
        parser: (json) {
      return (json as Iterable).map((model) => IssueForList.fromJson(model)).toList();
    });
  }

  static Future<List<IdNamePair>> getGroups() {
    return WebService.send(Method.GET, URL + '/groups', parser: (json) {
      return (json as Iterable).map((model) => IdNamePair.fromJson(model)).toList();
    });
  }

  static Future<List<IdNamePair>> getWorkers(String groupId) {
    return WebService.send(Method.GET, URL + '/workers' + (groupId == null ? '' : '?groupId=' + groupId),
        parser: (json) {
      return (json as Iterable).map((model) => IdNamePair.fromJson(model)).toList();
    });
  }

  static Future<void> postRedirect(String id, String userId) {
    return WebService.send(Method.POST, URL + '/redirect', body: {'id': id, 'userId': userId});
  }

  static Future<List<FixInfo>> getFixes(String serviceId, String parentUrl) {
    return WebService.send(Method.GET, 'http://' + parentUrl + '/api/fixes?serviceId=' + serviceId,
        parser: (json) => (json as Iterable).map((model) => FixInfo.fromJson(model)).toList());
  }

  static Future<List<StoryItem>> getStory(String issueId) {
    return WebService.send(Method.GET, URL + '/story?issueId=' + issueId,
        parser: (json) => (json as Iterable).map((model) => StoryItem.fromJson(model)).toList());
  }

  static Future<dynamic> postFix(String fixId, String issueId, String parentUrl) {
    return WebService.send(Method.POST, 'http://' + parentUrl + '/api/fix', body: {'fixId': fixId, 'issueId': issueId});
  }

  static Future<void> closeIssue(String issueId, String description) {
    return WebService.send(Method.POST, URL + '/close',
        body: description == null ? {'id': issueId} : {'id': issueId, 'description': description});
  }

  static Future<void> answerRedirect(String issueId, String description, bool isAccepted) {
    return WebService.send(Method.POST, URL + '/redirect/answer',
        body: description == null
            ? {'id': issueId, 'accept': isAccepted}
            : {'id': issueId, 'accept': isAccepted, 'description': description});
  }

  static Future<void> acceptIssue(String issueId) {
    return WebService.send(Method.POST, URL + '/accept', body: {'id': issueId});
  }
}
