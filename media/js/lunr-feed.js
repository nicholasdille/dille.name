---

---
// collect documents
var documents = [{% for post in site.posts %}{
  "title": {{ post.title | jsonify }},
  "link": {{ post.url | jsonify }},
  "date": {{ post.date | date: '%B %-d, %Y' | jsonify }},
  "excerpt": {{ post.excerpt | strip_html | jsonify }}
}{% unless forloop.last %},{% endunless %}{% endfor %}];

// builds index
var index = lunr(function () {
  this.field('title')
  this.field('content', {boost: 10})
  this.field('tags')
  this.ref('id')

  documents.forEach(function (doc) {
    this.add(doc)
  }, this)
});

// builds search
$(document).ready(function() {
  $('input#search').on('keyup', function () {
    var resultdiv = $('#results');
    // Get query
    var query = $(this).val();
    // Search for it
    var result = index.search(query);
    // Show results
    resultdiv.empty();
    // Add status
    resultdiv.prepend('<p class="">Found '+result.length+' result(s)</p>');
    // Loop through, match, and add results
    for (var item in result) {
      var ref = result[item].ref;
      var searchitem = '<div class="post"><h1 class="post-title"><a href="'+store[ref].link+'">'+store[ref].title+'</a></h1><span class="post-date">'+store[ref].date+'</span>'+store[ref].excerpt+'</div>';
      resultdiv.append(searchitem);
    }
  });
});