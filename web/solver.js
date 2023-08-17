let botEnabled = null;
let responseMap = {};

let API_ENDPOINT =
  "https://k59op4dxx4.execute-api.us-west-1" +
  ".amazonaws.com" +
  "/" +
  "questions";

window.botEnabled = botEnabled;

function updateMapData(question, answers, storeAPI) {
  return new Promise((resolve) => {
    if (!(question in responseMap)) {
      if (storeAPI) {
        storeQuestionToAPI(question, answers);
      }
      chrome.storage.local.get("responseMap", (result) => {
        const tempResponseMap = result.responseMap || {};
        tempResponseMap[question] = answers;
        chrome.storage.local.set({ responseMap: tempResponseMap }, () => {
          responseMap = tempResponseMap; // Update the responseMap in the content script
          resolve();
        });
      });
    } else {
      resolve();
    }
  });
}

// given the question and answers, store it
async function storeQuestionToAPI(question, answers) {
  console.log("Storing question", question, "to API");
  try {
    // Create fetch options
    const fetchOptions = {
      method: "POST",
      body: JSON.stringify({
        question: question,
        answer: answers,
      }),
    };

    // Make request
    const response = await fetch(
      API_ENDPOINT + "/store-question",
      fetchOptions
    );
    console.log("STORING RESPONSE:", response.json());
    if (!response.ok) {
      console.log("Error storing during fetch");
      return null;
    }
  } catch (error) {
    console.error("storeQuestionToAPI error:", error);
  }
}

// given a question, it will attempt to get the answer from the API. if the answer is stored, it will return the answer text.
// will return null if there is any sort of error, or if it times out ()
async function getAnswerFromAPI(question) {
  try {
    // Promise that resolves after 2 seconds
    const timeout = new Promise((resolve) => setTimeout(resolve, 2500, null));

    // API call Promise
    const apiCall = fetch(API_ENDPOINT + "/get-answer", {
      method: "POST",
      body: JSON.stringify({
        question: question,
      }),
    }).then(async (response) => {
      if (!response.ok || response.status === 204) {
        console.log("Could not retrieve answer: " + response.status);
        return null;
      }
      // Check if the response has a body
      const responseBody = await response.text();
      if (!responseBody) {
        console.log("Response body is empty.");
        return null;
      }
      return JSON.parse(responseBody);
    });

    // Returns the promise that resolves first
    const result = await Promise.race([timeout, apiCall]);

    if (result === null) {
      console.log(
        "Fetching the answer from the API timed out or returned null."
      );
      return;
    }
    const answer = result?.answer || null;
    await updateMapData(question, answer, false);
    return;
  } catch (error) {
    console.log("Failed to fetch from API:", error);
    return;
  }
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// drag and drop section
async function simulateDragAndDrop(source, target) {
  const rect1 = source.getBoundingClientRect();
  const rect2 = target.getBoundingClientRect();

  const mousedown = new MouseEvent("mousedown", {
    bubbles: true,
    cancelable: true,
    view: window,
    clientX: rect1.left + rect1.width / 2,
    clientY: rect1.top + rect1.height / 2,
  });

  const mouseup = new MouseEvent("mouseup", {
    bubbles: true,
    cancelable: true,
    view: window,
    clientX: rect2.left + rect2.width / 2,
    clientY: rect2.top + rect2.height / 2,
  });

  source.dispatchEvent(mousedown);
  await sleep(800);

  for (let i = 1; i <= 50; i++) {
    const intermediateX =
      rect1.left + (rect2.left - rect1.left) * (i / 50) + rect1.width / 2;
    const intermediateY =
      rect1.top + (rect2.top - rect1.top) * (i / 50) + rect1.height / 2;

    const mousemove = new MouseEvent("mousemove", {
      bubbles: true,
      cancelable: true,
      view: window,
      clientX: intermediateX,
      clientY: intermediateY,
    });

    source.dispatchEvent(mousemove);
    await sleep(10);
  }
  const finalMouseMove = new MouseEvent("mousemove", {
    bubbles: true,
    cancelable: true,
    view: window,
    clientX: rect2.left + rect2.width / 2,
    clientY: rect2.top + rect2.height / 2,
  });
  source.dispatchEvent(finalMouseMove);
  await sleep(500);
  target.dispatchEvent(mouseup);
  await sleep(200);
}

// begin solver.js

function readQuestionAndResponses() {
  let question = "";
  let responses = [];

  // Find the question
  let questionElement = document.getElementsByClassName("prompt");
  if (questionElement) {
    const paragraphElement = questionElement[0].querySelector("p");
    const textNodes = [...paragraphElement.childNodes].filter(
      (node) => node.nodeType === Node.TEXT_NODE
    );
    question = textNodes.map((node) => node.textContent).join("_____");
  }

  // Find the potential responses
  let responseElements = document
    .getElementsByClassName("air-item-container")[0]
    .getElementsByClassName("choiceText rs_preserve");
  if (responseElements.length) {
    for (let i = 0; i < responseElements.length; i++) {
      responses.push(responseElements[i].textContent);
    }
  }

  return { question, responses, responseElements };
}

async function selectCorrectResponse(question, responses, responseElements) {
  await sleep(100);
  let checkIfNextButton = document.getElementsByClassName(
    "next-button-container"
  )[0];
  if (checkIfNextButton != null) {
    // if review concept button
    let nextButtonCheck = document
      .getElementsByClassName("next-button-container")[0]
      .getElementsByTagName("button")[0];
    let reviewConceptButtonCheck = document.getElementsByClassName(
      "btn btn-tertiary lr-tray-button"
    )[0];
    if (nextButtonCheck.hasAttribute("disabled")) {
      reviewConceptButtonCheck.click();
      await sleep(1000);
      let continueButton = document
        .getElementsByClassName("button-bar-wrapper")[0]
        .getElementsByTagName("button")[0];
      continueButton.click();
    }
    await sleep(1000);
    nextButtonCheck.click();

    document
      .getElementsByClassName("next-button-container")[0]
      .getElementsByTagName("button")[0]
      .click();
    return;
  }

  let answerButton = document
    .getElementsByClassName("confidence-buttons-container")[0]
    .getElementsByTagName("button")[0];

  // if answer not stored, try to fetch from api
  if (!responseMap[question]) {
    await getAnswerFromAPI(question);
  } else {
    console.log("Already stored locally");
  }

  // if answer is already stored
  if (responseMap[question]) {
    let correctResponse = responseMap[question];
    console.log("Answer found:", correctResponse);
    // if fill in the blank
    if (responseElements.length == 0) {
      let blanks = document.getElementsByClassName(
        "input-container span-to-div"
      );
      for (let x = 0; x < blanks.length; x++) {
        let inputTag = blanks[x].getElementsByTagName("input")[0];
        inputTag.focus();
        document.execCommand("insertText", false, correctResponse[x]);
      }
    }

    // if multiple choice
    let clicked = false;
    for (let i = 0; i < responses.length; i++) {
      if (correctResponse.includes(responses[i])) {
        responseElements[i].click();
        clicked = true;
      }
      if (!clicked) {
        responseElements[0].click();
      }
    }
    await sleep(Math.random() * 200 + 500);
    answerButton.click();

    // answer is not already stored -> guess
  } else {
    let isFillInBlankQuestion = false;
    let isDragAndDrop = false;

    // is fill in the blank question or drag and drop
    if (responseElements[0] == null) {
      // if drag and drop, end
      if (
        document.getElementsByClassName("match-single-response-wrapper")[0] !=
        null
      ) {
        //TODO: implement drag and drop
        isDragAndDrop = true;
        // console.log("Trying to solve drag and drop question")
        await sleep(500);
        let choices = document.querySelectorAll(
          ".choices-container .choice-item-wrapper .content p"
        );
        let drop = document.querySelectorAll(
          ".-placeholder.choice-item-wrapper"
        );
        let numDrops = 0;
        while (drop.length > 0) {
          console.log("Executing drag and drop: ", numDrops);
          await simulateDragAndDrop(choices[0], drop[0]);
          await sleep(1000);
          choices = document.querySelectorAll(
            ".choices-container .choice-item-wrapper .content p"
          );
          drop = document.querySelectorAll(".-placeholder.choice-item-wrapper");
          await sleep(2000);
          numDrops += 1;
          if (numDrops > 6) {
            console.log("Giving up drag and drop");
            return;
          }
        }
      } else {
        isFillInBlankQuestion = true;
        let blanks = document.getElementsByClassName(
          "input-container span-to-div"
        );
        for (let x = 0; x < blanks.length; x++) {
          let inputTag = blanks[x].getElementsByTagName("input")[0];
          inputTag.focus();
          document.execCommand("insertText", false, "IDK");
        }
      }
    } else {
      responseElements[0].click();
    }

    // submit answer
    await sleep(Math.random() * 200 + 500);
    document.querySelector("button.btn-confidence").removeAttribute("disabled");
    answerButton.click();

    await sleep(Math.random() * 100 + 800);
    // store the correct answer into the responseMap
    let answers = [];
    if (isFillInBlankQuestion) {
      let answerElements = document.getElementsByClassName("correct-answers");

      for (let x = 0; x < answerElements.length; x++) {
        answers.push(
          answerElements[x]
            .getElementsByClassName("correct-answer")[0]
            .textContent.replace(/,/g, "")
            .split(" ")[0]
        );
      }

      // not fill in the blank question
    } else {
      if (isDragAndDrop) {
        //TODO: store answers for drag and drop.
        return;
      }
      let answerElements = document
        .getElementsByClassName("answer-container")[0]
        .getElementsByClassName("choiceText rs_preserve");
      // if true/false
      if (answerElements.length == 0) {
        answerElements = document.getElementsByClassName("answer-container");
      }
      for (let i = 0; i < answerElements.length; i++) {
        answers.push(answerElements[i].textContent);
      }
    }
    // responseMap[question] = answers;
    updateMapData(question, answers, true);
  }

  // move on to next question
  await sleep(Math.random() * 200 + 600);
  let nextButton = document
    .getElementsByClassName("next-button-container")[0]
    .getElementsByTagName("button")[0];
  let reviewConceptButton = document.getElementsByClassName(
    "btn btn-tertiary lr-tray-button"
  )[0];
  if (nextButton.hasAttribute("disabled")) {
    reviewConceptButton.click();
    await sleep(1000);
    let continueButton = document
      .getElementsByClassName("button-bar-wrapper")[0]
      .getElementsByTagName("button")[0];
    continueButton.click();
  }
  await sleep(500);
  nextButton.click();
}

// Main function that reads the question and responses and selects the correct response
async function answerQuestion() {
  let { question, responses, responseElements } = readQuestionAndResponses();
  await selectCorrectResponse(question, responses, responseElements);
}

let answerQuestionRunning = false;
async function activateBot() {
  console.log("S: Activating Bot");
  if (botEnabled === null) {
    botEnabled = true;
    while (botEnabled) {
      if (!answerQuestionRunning) {
        answerQuestionRunning = true;
        try {
          await answerQuestion();
        } catch (error) {
          console.error("Error while answering question:", error);
        }
        answerQuestionRunning = false;
      }
      await sleep(Math.random() * 200 + 600);
    }
  }
}

function deactivateBot() {
  console.log("S: Deactivating Bot");
  botEnabled = null;
}

// listen for messages from the popup to enable/disable the bot
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  console.log("the request:", request, "done");
  if (request == "activate") {
  }
  if (request == "deactivate") {
    deactivateBot();
  }
});

chrome.runtime.onMessage.addListener(function (message, sender, sendResponse) {
  console.log("S: Received message:");
  if (message.type == "notifications") {
    if (message.data == "start") {
      activateBot();
    }
    if (message.data == "stop") {
      deactivateBot();
    }
  }
});

//listen for messages from highlighter.js to update responseMap
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === "updateMapData") {
    const receivedData = message.data;
    console.log("S: Received data from H:", receivedData);
  }
});
