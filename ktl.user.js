// Save this script in a file named "ktl.user.js"
// and load it into Chrome to install.
// Visiting a kasi-time lyrics page will then show you just
// the lyrics, which you can copy/paste.

// ==UserScript==
// @name Kasi-time Lyrics
// @description Redirect Kasi-time lyric pages 
// @match http://www.kasi-time.com/*
// ==/UserScript==

if (window.location.pathname.match(/item-[0-9]+\.html/)) {
    window.location.replace(window.location.toString().replace(/item-([0-9]+)\.html/, "item_js.php?no=$1"));
}