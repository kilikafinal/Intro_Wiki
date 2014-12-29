import 'dart:io';
import 'dart:convert';

main() {

  String input;
  int validInput = 0;
  
  while (validInput == 0) {
    
    print("what would you like to do?");
    print("1. get info from wikipedia");
    print("2. exit");
    input = stdin.readLineSync();
    stdout.writeln('You typed: $input');
    
    switch (input) {
      
      case '0':
        break;
      case '1':
        validInput = 1;

        
        print("what article would you like to know about?");
        input = stdin.readLineSync();
        stdout.writeln('You typed: $input');
        String site = 'https://en.wikipedia.org/wiki/' + input;

        var url = Uri.parse(site);
        var httpClient = new HttpClient();
        int start = 0;
        int end = 0;
        
        httpClient.getUrl(url).then((HttpClientRequest request) {
          print('searching for requested article');
          return request.close();
          
        }).then((HttpClientResponse response) {
          print('Requested article has been found');
          response.transform(UTF8.decoder).toList().then((data) {
            var body = data.join('');
            String words = body.toString();
            if (words.contains('Wikipedia does not have an article with this exact name')) {
              print("invalid search. please try again");
            } else {
              start = words.indexOf('<p>');
              end = words.indexOf('div id="toc"');
              String subbody = words.substring(start + 3, end - 1);
              int left = 0,
                  right = 0;
              while ((left = subbody.indexOf('<')) > -1 && (right = subbody.indexOf('>')) > -1) {
                subbody = subbody.substring(0, left) + subbody.substring(right + 1);
              }
              while ((left = subbody.indexOf('(')) > -1 && (right = subbody.indexOf(')')) > -1) {
                subbody = subbody.substring(0, left) + subbody.substring(right + 1);
              }
              while ((left = subbody.indexOf('[')) > -1 && (right = subbody.indexOf(']')) > -1) {
                subbody = subbody.substring(0, left) + subbody.substring(right + 1);
              }
              print(subbody);
            }
            httpClient.close();
          });
          
        }).catchError((e) {
          print(e.toString());
        });
        break;
        
      case '2':
        exit(0);
        break;
        
      default:
        break;
    }
  }
}
