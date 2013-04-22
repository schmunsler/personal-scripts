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

function animate() {
    var images = document.getElementsByTagName('img');
    for(i=0; i<images.length; i++) {
        if (images[i].src.match(/googleusercontent\.com(.*)s(48|46|32|24)-c-k/) != null) {
            // the test keeps animations from restaring on each call
            images[i].src = images[i].src.replace(/googleusercontent\.com(.*)s(48|46|32|24)-c-k/, "googleusercontent\.com$1s$2-c");
        }
    }
}

window.addEventListener('load', animate, false);
document.getElementById('contentPane').addEventListener('DOMNodeInserted', animate, false);
