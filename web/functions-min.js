window.clientVariables = { html: "", isValid: !1 };
window.scrapeHTML = () =>
  new Promise(async (e, t) => {
    const [i] = await chrome.tabs.query({ active: !0, currentWindow: !0 });
    let n;
    try {
      [{ result: n }] = await chrome.scripting.executeScript({
        target: { tabId: i.id },
        func: () => document.documentElement.innerText,
      });
      window.clientVariables.html = n;
      console.log("html", n);
      e(!0);
    } catch (t) {
      e(!1);
    }
  });
window.checkCurrentTabURL = (e) =>
  new Promise((t, i) => {
    if (!e || 0 === e.length) return t(!1);
    chrome.tabs.query({ active: !0, currentWindow: !0 }, (i) => {
      if (!i || 0 === i.length) {
        return t(!1);
      }
      const n = i[0].url,
        r = e.some((e) => n.startsWith(e));
      window.clientVariables = window.clientVariables || {};
      window.clientVariables.isValid = r;
      t(r);
    });
  });
