function sendMessage(message) {
  chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
    if (tabs.length > 0) {
      chrome.tabs.sendMessage(tabs[0].id, {
        type: "notifications",
        data: message,
      });
    } else {
      console.error("No active tab found");
    }
  });
}

chrome.tabs.onUpdated.addListener(function (tabId, changeInfo, tab) {
  if (changeInfo.status === "complete") {
    chrome.runtime.onMessage.addListener(async function (
      message,
      sender,
      sendResponse
    ) {
      if (message.type === "bot") {
        sendMessage(message.data);
      }
    });
  }
});
