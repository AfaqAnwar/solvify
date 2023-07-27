window.setStateOfExtension = (customKey, customValue) => {
  chrome.storage.sync.set({ customKey: customValue }, function () {
    console.log("Value is set to " + customValue);
  });
};

window.getStateOfExtension = (customKey) => {
  chrome.storage.sync.get([customKey], function (result) {
    console.log("Value currently is " + result.customKey);
  });
};
