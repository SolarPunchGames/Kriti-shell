// httpRequest.js

function sendRequest(url, callback) {
  let request = new XMLHttpRequest();

  request.onreadystatechange = function() {
    if (request.readyState === XMLHttpRequest.DONE) {
      let response = {
        status : request.status,
        headers : request.getAllResponseHeaders(),
        contentType : request.responseType,
        content : request.response
      };

      callback(response);
    }
  }

  request.open("GET", url);
  request.send();
}