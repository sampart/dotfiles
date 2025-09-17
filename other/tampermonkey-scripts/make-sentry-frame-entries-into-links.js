// ==UserScript==
// @name         Make Sentry frame entries into links
// @namespace    http://tampermonkey.net/
// @version      2024-09-16
// @description  Make Sentry frame entries into links
// @author       sampart
// @match        https://github.sentry.io/issues/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=sentry.io
// @grant        none
// ==/UserScript==

// Sentry can sometimes do this for you, I think, but if that's not configured,
// then try this script.

(function() {
  'use strict';

  function waitForElem(selector) {
    return new Promise((resolve) => {
      if (document.querySelector(selector)) {
        return resolve(document.querySelector(selector));
      }

      const observer = new MutationObserver((mutations) => {
        if (document.querySelector(selector)) {
          observer.disconnect();
          resolve(document.querySelector(selector));
        }
      });

      observer.observe(document.body, {
        childList: true,
        subtree: true,
      });
    });
  }

  function getProject() {
    let label = null
    document.querySelectorAll("[data-sentry-element=\"TreeSearchKey\"").forEach((e) =>
      { if (e.textContent == "gh.exception.project") { label = e }
    })

    const parent = label?.closest("[data-test-id=\"tag-tree-row\"]")
    const project = parent?.querySelector("[data-sentry-element=\"TreeValue\"]")?.textContent

    return project || "github"
  }

  function getSha() {
    let label = null
    document.querySelectorAll("td.key").forEach((e) =>
      { if (e.textContent == "gh.deployment.sha") { label = e }
    })

    const parent = label?.closest("tr")
    const sha = parent?.querySelector("td.val")?.textContent

    return sha || "master"
  }

  function addFrameLinks() {
    // TODO This doesn't work where file paths are truncated before displaying
    document.querySelectorAll("[data-test-id=\"frames\"] li").forEach((liElem) => {
        const filenameElem = liElem.querySelector("[data-test-id=\"filename\"] > span > span")
        const lineNoElem = liElem.querySelector(".lineno")

        if (filenameElem.textContent.startsWith("vendor/gems")) {
          return
        }

        const src = `https://github.com/github/${getProject()}/blob/${getSha()}/${filenameElem.textContent}#L${lineNoElem?.textContent || ''}`
        const link = document.createElement("a")
        link.href = src
        filenameElem.parentElement.insertBefore(link, filenameElem)
        link.appendChild(filenameElem)
    })
  }

  waitForElem("[data-test-id=\"frames\"]").then(() => {
    addFrameLinks()
  });

})();
