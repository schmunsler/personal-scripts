// Save this script in a file named "avatar.animate.user.js"
// and drag'n'drop on chrome://extensions/ to install.
// (for Firefox use Greasemonkey)
// Released under WTFPL (http://www.wtfpl.net/txt/copying/)

// ==UserScript==
// @name G+ Animated Avatars
// @description Animate avatars on Google+
// @match http://plus.google.com/*
// @match https://plus.google.com/*
// ==/UserScript==

window.addEventListener('load', function() {
   var images = document.getElementsByTagName('img');
   for(i=0; i<images.length; i++) {
      images[i].src = images[i].src.replace(/googleusercontent\.com(.*)s(48|32|24)-c-k/, "googleusercontent\.com$1s$2-c");
   }
}, false);