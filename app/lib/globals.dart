library globals;
// https://dart.dev/language/libraries
// https://stackoverflow.com/questions/29182581/global-variables-in-dart
// library essentially means that you don't have to use package: at the start of every import
// Seemed like a smart way to think of the future

String apiURL =
    "http://10.0.0.233"; // FIXME - Change to api.sambot.dev // NOTE - Your computers ip address, not localhost, see https://stackoverflow.com/questions/55785581/socketexception-os-error-connection-refused-errno-111-in-flutter-using-djan
String appVersion =
    "0.0.1-alpha"; //NOTE - Follows the Major Minor Path semantic versioning https://semver.org/