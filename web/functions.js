window.clientVariables = {
  html: "",
  isValid: false,
  isValidMcgraw: false,
};

window.scrapeHTML = () => {
  return new Promise(async (resolve, reject) => {
    const [tab] = await chrome.tabs.query({
      active: true,
      currentWindow: true,
    });
    let result;

    try {
      [{ result }] = await chrome.scripting.executeScript({
        target: { tabId: tab.id },
        func: () => document.documentElement.innerText,
      });
      window.clientVariables.html = result;
      resolve(true);
    } catch (e) {
      console.log(e);
      resolve(false); // Resolve with false upon failure
    }
  });
};

window.checkCurrentTabURL = () => {
  return new Promise((resolve, reject) => {
    // Define a list of allowed URLs or URL patterns
    const allowedURLs = [
      "https://www.google.com/",
      "https://learning.mheducation.com/",
      // ... add other URLs or patterns as needed
    ];

    chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
      let currentTab = tabs[0]; // There should only be one in this array
      let currentURL = currentTab.url;

      // Check if the URL is in the list of allowed URLs
      let isValidURL = allowedURLs.some((allowedURL) =>
        currentURL.startsWith(allowedURL)
      );

      window.clientVariables.isValid = isValidURL;

      // Resolve the promise with the result
      resolve(isValidURL);
    });
  });
};

window.checkForMcGraw = () => {
  return new Promise((resolve, reject) => {
    // Define a list of allowed URLs or URL patterns
    const allowedURLs = [
      "https://learning.mheducation.com/",
      // ... add other URLs or patterns as needed
    ];

    chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
      let currentTab = tabs[0]; // There should only be one in this array
      let currentURL = currentTab.url;

      // Check if the URL is in the list of allowed URLs
      let isValidURL = allowedURLs.some((allowedURL) =>
        currentURL.startsWith(allowedURL)
      );

      window.clientVariables.isValidMcgraw = isValidURL;

      // Resolve the promise with the result
      resolve(isValidURL);
    });
  });
};
