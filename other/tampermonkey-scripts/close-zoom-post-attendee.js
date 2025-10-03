// ==UserScript==
// @name         Close Zoom post-attendee tab
// @namespace    http://tampermonkey.net/
// @version      2025-10-03
// @description  Close Zoom post-attendee tab
// @author       @sampart
// @match        https://us02web.zoom.us/postattendee?mn=*
// @icon         https://zoom.us/favicon.ico
// @grant        window.close
// ==/UserScript==

(function() {
    'use strict';

    window.close()
})();
