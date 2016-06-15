;(function ($) {
  var githubCacheFilePath = [];
  var githubCacheSha = [];

  var fnSuccess =
  function (data, startLineNum, endLineNum, callback) {
    if (data.data.content && data.data.encoding === "base64") {
      var contentArray =
      window
      .atob(data.data.content.replace(/\n/g, ""))
      .split("\n");

      endLineNum = endLineNum || contentArray.length;

      callback(contentArray.slice(startLineNum - 1, endLineNum).join("\n"));
    }
  };

  $.getGithubFileByFilePath =
  function(user, repo, filePath, callback, startLineNum, endLineNum) {
    if(githubCacheFilePath[filePath]){
      $.getGithubFile(user, repo, githubCacheFilePath[filePath], callback, startLineNum, endLineNum)
    }else{
      $.ajax({
        type: "GET"
        ,url: "https://api.github.com/repos/" + user + "/" + repo + "/contents/"+filePath
        ,dataType: "jsonp"
        ,success: function(data){
          githubCacheFilePath[filePath] = data.data.sha;
          $.getGithubFile(user, repo, githubCacheFilePath[filePath], callback, startLineNum, endLineNum)
        }
      });
    }
  };

  $.getGithubFile =
  function(user, repo, sha, callback, startLineNum, endLineNum) {
    if(githubCacheSha[sha]){
      fnSuccess(githubCacheSha[sha], +startLineNum || 1, +endLineNum || 0, callback);
    }else{
      $.ajax({
        type: "GET"
        ,url: "https://api.github.com/repos/" + user + "/" + repo + "/git/blobs/" + sha
        ,dataType: "jsonp"
        ,success: function(data) {
          githubCacheSha[sha] = data
          fnSuccess(githubCacheSha[sha], +startLineNum || 1, +endLineNum || 0, callback);
        }
      });
    }
  };

  $.getGithubFileByFilePath2 =
  function(filePath, callback, startLineNum, endLineNum) {
    if(githubCacheFilePath[filePath]){
      fnSuccess(githubCacheFilePath[filePath], +startLineNum || 1, +endLineNum || 0, callback);
    }else{
      $.ajax({
        type: "GET"
        ,url: "https://api.github.com/repos/" + filePath
        ,dataType: "jsonp"
        ,success: function(data){
          githubCacheFilePath[filePath] = data;
          fnSuccess(data, +startLineNum || 1, +endLineNum || 0, callback);
        }
      });
    }
  };

  $.embedFileFromAPI = function(){
    $("code[class*=embedfile]").each(function(i, code){
      code = $(code);

      var filePath = /github.com\/(.*)/i.exec(code.attr('class'))[1];
      var fileName = /blob\/[^/]*\/(.*)/.exec(filePath)[1];
      var linkToGithubFile = $("<p><a target='_blank' href='" + "https://github.com/" + filePath + "'>" + fileName + "</a></p>");
      filePath = filePath.replace(/\/blob\/[^/]*\//,'/contents/');

      $.getGithubFileByFilePath2(filePath, function(contents) {
        linkToGithubFile.insertBefore(code.parent());
        code.text(contents);
        if(window.Prism) Prism.highlightElement(code[0]);
      });
    });
  }

  $.embedFileFromRaw = function(){
    $("code[class*=embedfile]").each(function(i, code){
      code = $(code);

      var filePath = /github.com\/(.*)/i.exec(code.attr('class'))[1];
      var fileName = /blob\/[^/]*\/(.*)/.exec(filePath)[1];
      var linkToGithubFile = $("<p><a target='_blank' href='" + "https://github.com/" + filePath + "'>" + fileName + "</a></p>");

      var fullFilePath = /embedfile-(.*)/i.exec(code.attr('class'))[1];
      var rawFilePath = fullFilePath.replace(/\/github.com\//,'/raw.githubusercontent.com/').replace(/\/blob\//,'/');

      $.get(rawFilePath, null, function(contents) {
        linkToGithubFile.insertBefore(code.parent());
        code.text(contents);
        if(window.Prism) Prism.highlightElement(code[0]);
      });
    });
  }

  $.embedFileFromRaw();
}(jQuery));