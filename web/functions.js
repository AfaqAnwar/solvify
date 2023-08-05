window.clientVariables = {
  html: "",
};

window.scrapeHTML = async () => {
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
  } catch (e) {
    console.log(e);
    return false;
  }

  window.clientVariables.html = result;
  return true;
};
