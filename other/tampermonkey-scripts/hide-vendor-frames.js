// ==UserScript==
// @name         Hide Vendor Frames
// @namespace    http://github.com/
// @version      2023-12-18.1
// @description  try to take over the world!
// @author       offbyone
// @match        https://github.sentry.io/issues/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=sentry.io
// @grant        none
// @sandbox      raw
// ==/UserScript==

(function () {
  "use strict";

  function getFilenames(parentElement) {
    const spans = parentElement.querySelectorAll(
      'code[data-test-id="filename"]',
    );
    const filenames = Array.from(spans).flatMap((span) =>
      Array.from(span.getElementsByTagName("span")).map(
        (subspan) => subspan.textContent,
      ),
    );
    return filenames;
  }
  function getFilename(li) {
    return getFilenames(li)
      .filter((s) => s.startsWith("vendor"))
      .shift();
  }

  function getButtonSpan() {
    return [...document.querySelectorAll("#exception button span")].find(
      (span) => span.textContent.trim() === "Newest",
    );
  }
  function getButtonLocation() {
    return getButtonSpan().parentElement;
  }

  function getButtonWrapperSpanClass() {
    return [...getButtonSpan().classList].find((cls) => cls.startsWith("app-"));
  }

  function getButtonClass(button) {
    return [...button.classList].find((cls) => cls.startsWith("app-"));
  }

  function getDivClass(button) {
    return [...button.parentElement.classList].find((cls) =>
      cls.startsWith("app-"),
    );
  }

  function getInitialToggleAction() {
    return localStorage["toggle-sentry-vendor-frames-initial-action"] || "hide";
  }

  function setInitialToggleAction(action) {
    localStorage["toggle-sentry-vendor-frames-initial-action"] = action;
  }

  function buttonUpdates() {
    var button = document.getElementById("toggle-vendor-frames");
    var actionSpan = document.getElementById("toggle-vendor-frames-text");
    var action = button.getAttribute("data-toggle-vendor-action");

    if (action == "hide") {
      button.setAttribute("aria-label", "Hide Vendor Frames");
      button.style.removeProperty("background-color");
      actionSpan.textContent = "Hide Vendor";
    } else {
      button.setAttribute("aria-label", "Show Vendor Frames");
      button.style.setProperty("background-color", "red");
      actionSpan.textContent = "Show Vendor";
    }
  }

  function makeButton(buttonClass, wrapperClass) {
    const template = document.createElement("template");

    const initialAction = getInitialToggleAction();
    template.innerHTML = `<button aria-label="Not Yet Set" aria-disabled="false"
                             id="toggle-vendor-frames" type="button"
                             data-element="StyledButton" data-toggle-vendor-action="${initialAction}"
                             class="${buttonClass}" role="button">
        <span role="presentation"></span>
                <span class="${wrapperClass} e16hd6vm0">
                    <span id="toggle-vendor-frames-text">Pending...</span>
                </span>
    </button>`;

    let button = template.content.children[0];
    return button;
  }

  function getToggleButtonDiv(divClass, buttonClass, wrapperClass) {
    let div = document.createElement("div");
    div.classList.add(divClass);
    div.appendChild(makeButton(buttonClass, wrapperClass));
    return div;
  }

  function addButton() {
    let button = getButtonLocation();
    let insertSite = button.parentElement.nextSibling;
    let insertDiv = button.parentElement.parentNode;

    let buttonClass = getButtonClass(button);
    let divClass = getDivClass(button);
    let wrapperClass = getButtonWrapperSpanClass();
    insertDiv.insertBefore(
      getToggleButtonDiv(divClass, buttonClass, wrapperClass),
      insertSite,
    );

    buttonUpdates();

    return button;
  }

  function waitForElm(selector) {
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

  function updateVendorFrames(action) {
    var vendorFrames = document.querySelectorAll(".vendor-gem-frame");
    if (action == "hide") {
      vendorFrames.forEach((frame) => {
        frame.style.display = "none";
      });
    } else {
      vendorFrames.forEach((frame) => {
        frame.style.display = "";
      });
    }
  }

  function toggleVendorFrames() {
    const button = document.getElementById("toggle-vendor-frames");
    const actionSpan = document.getElementById("toggle-vendor-frames-text");
    let action = button.getAttribute("data-toggle-vendor-action");

    updateVendorFrames(action);
    if (action == "hide") {
      button.setAttribute("data-toggle-vendor-action", "show");
    } else {
      button.setAttribute("data-toggle-vendor-action", "hide");
    }
    setInitialToggleAction(button.getAttribute("data-toggle-vendor-action"));
    buttonUpdates();
  }

  waitForElm("#exception button span").then((_) => {
    addButton();
    document
      .getElementById("toggle-vendor-frames")
      .addEventListener("click", toggleVendorFrames);
  });

  waitForElm(".exception .traceback").then((_) => {
    document.querySelectorAll('[data-test-id="line"]').forEach((li) => {
      var filename = getFilename(li);
      if (filename && filename.match(/vendor\/gems\//)) {
        li.classList.add("vendor-gem-frame");
      }
    });

    // at the start, we are updating to match the NEXT action
    updateVendorFrames(getInitialToggleAction() == "hide" ? "show" : "hide");
  });
})();
