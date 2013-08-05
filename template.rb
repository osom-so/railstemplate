run 'rm README.rdoc'
run 'touch README.md'
run 'rm app/assets/javascripts/application.js'
run 'rm app/assets/stylesheets/application.css'
run 'echo "#= require jquery\n#= require_self" > app/assets/javascripts/application.js.coffee'
run 'echo "//= require_self" > app/assets/stylesheets/application.css.scss'
run 'touch app/assets/stylesheets/ie.css.scss'
run 'rm -f public/*'
run 'rm app/views/layouts/application.html.erb'

initializer '_env.rb', <<-CODE
unless Rails.env.production?
  ENV['GOOGLE_ANALYTICS'] = ""

  ENV['S3_KEY'] = ""
  ENV['S3_SECRET'] = ""  
end
CODE

file 'app/views/base/_analytics.html.haml', <<-CODE
:javascript
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', '\#{ENV['GOOGLE_ANALYTICS']}']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
CODE

file 'app/views/layouts/application.html.haml', <<-LAYOUT
!!! 5
:plain
  <!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
  <!--[if IE 7]> <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
  <!--[if IE 8]> <html class="no-js lt-ie9"> <![endif]-->
  <!--[if gt IE 8]><!--> <html class="no-js modernbrowser"> <!--<![endif]-->
%head
  %meta{ :charset => "utf-8" }
  %meta{ :'http-equiv' => "X-UA-Compatible", :content => "IE=edge,chrome=1" }
  %title=yield(:title)
  %meta{ :name => "description", :content => "" }
  %meta{ :name => "viewport", :content => "width=device-width, user-scalable=no" }
  = stylesheet_link_tag "application", :media => "all"
  = javascript_include_tag "modernizr"
  = csrf_meta_tags
  -# Don't forget to add modernizr.js and ie.css to config.assets.precompile in production.rb
  -#:plain
  -#  <!--[if lt IE 8]>\#{stylesheet_link_tag "ie"}<![endif]-->

%body
  %header#encabezado
    %h1
      %a{ :href => "/" }
        %span
          New App
    %nav#menu
      %ul
        %li
          %a{ :href => '/' }>
            Menu Element
        %li
          %a{ :href => '/' }>
            Menu Element
        %li
          %a{ :href => '/' }>
            Menu Element
  %main#main{ :role => "main " }
    = yield

  %footer#pie
  = javascript_include_tag "application"
  = yield :javascripts if content_for? :javascripts
  = render 'base/analytics' unless (ENV['GOOGLE_ANALYTICS'] || "").empty?
LAYOUT

gem 'sass'
gem 'osom-normalizr', :git => 'git://github.com/osom-so/normalizr.git'
gem 'haml'

gem_group :assets do
  gem 'compass-rails'
  gem 'jquery-ui-rails'
  gem 'modernizr-rails'
end
