// Save this script in a file named "avatar.animate.user.js"
// and drag'n'drop on chrome://extensions/ to install.
// (for Firefox use Greasemonkey)
// Released under WTFPL (http://www.wtfpl.net/txt/copying/)

// Note that currently avatars in the chat sidebar and notification drop-down
// will not animate because iframes suck.

// ==UserScript==
// @name G+ Animated Avatars
// @description Animate avatars on Google+
// @match http://plus.google.com/*
// @match https://plus.google.com/*
// ==/UserScript==

// Change any of these to false to disable animation for their respective cases.
var animate48px = true; // normal posts
var animate46px = true; // profile floating banner
var animate32px = true; // comments and reshares
var animate24px = true; // post activity / "who +1'd this comment"

var sizes = [];
if (animate48px) { sizes.push("48"); }
if (animate46px) { sizes.push("46"); }
if (animate32px) { sizes.push("32"); }
if (animate24px) { sizes.push("24"); }

pattern = "googleusercontent\.com(.*)s(" + sizes.join('|') + ")-c-k";
var regex = new RegExp(pattern);

function animate() {
    var images = document.getElementsByTagName('img');
    for(i=0; i<images.length; i++) {
        if (images[i].src.match(regex) != null) {
            // the test keeps animations from restarting on each call
            images[i].src = images[i].src.replace(/s([0-9]+)-c-k/, "s$1-c");
        }
    }
}

window.addEventListener('load', animate, false);
document.getElementById('contentPane').addEventListener('DOMNodeInserted', animate, false);
