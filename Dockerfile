FROM nicholasdille/jekyll

ADD _drafts   /site/_drafts
ADD _includes /site/_includes
ADD _layouts  /site/_layouts
ADD _posts    /site/_posts
ADD blog      /site/blog
ADD media     /site/media
ADD _config.yml 404.html CNAME index.html keybase.txt sitemap.xml /site/
