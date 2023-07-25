import {
  _getProvider,
  getApp as e,
  _registerComponent as t,
  registerVersion as r,
} from "./firebase/firebase-app.js";
const n = {
  byteToCharMap_: null,
  charToByteMap_: null,
  byteToCharMapWebSafe_: null,
  charToByteMapWebSafe_: null,
  ENCODED_VALS_BASE:
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
  get ENCODED_VALS() {
    return this.ENCODED_VALS_BASE + "+/=";
  },
  get ENCODED_VALS_WEBSAFE() {
    return this.ENCODED_VALS_BASE + "-_.";
  },
  HAS_NATIVE_SUPPORT: "function" == typeof atob,
  encodeByteArray(e, t) {
    if (!Array.isArray(e))
      throw Error("encodeByteArray takes an array as a parameter");
    this.init_();
    const r = t ? this.byteToCharMapWebSafe_ : this.byteToCharMap_,
      n = [];
    for (let t = 0; t < e.length; t += 3) {
      const o = e[t],
        i = t + 1 < e.length,
        a = i ? e[t + 1] : 0,
        s = t + 2 < e.length,
        c = s ? e[t + 2] : 0,
        h = o >> 2,
        l = ((3 & o) << 4) | (a >> 4);
      let u = ((15 & a) << 2) | (c >> 6),
        d = 63 & c;
      s || ((d = 64), i || (u = 64)), n.push(r[h], r[l], r[u], r[d]);
    }
    return n.join("");
  },
  encodeString(e, t) {
    return this.HAS_NATIVE_SUPPORT && !t
      ? btoa(e)
      : this.encodeByteArray(
          (function (e) {
            const t = [];
            let r = 0;
            for (let n = 0; n < e.length; n++) {
              let o = e.charCodeAt(n);
              o < 128
                ? (t[r++] = o)
                : o < 2048
                ? ((t[r++] = (o >> 6) | 192), (t[r++] = (63 & o) | 128))
                : 55296 == (64512 & o) &&
                  n + 1 < e.length &&
                  56320 == (64512 & e.charCodeAt(n + 1))
                ? ((o =
                    65536 + ((1023 & o) << 10) + (1023 & e.charCodeAt(++n))),
                  (t[r++] = (o >> 18) | 240),
                  (t[r++] = ((o >> 12) & 63) | 128),
                  (t[r++] = ((o >> 6) & 63) | 128),
                  (t[r++] = (63 & o) | 128))
                : ((t[r++] = (o >> 12) | 224),
                  (t[r++] = ((o >> 6) & 63) | 128),
                  (t[r++] = (63 & o) | 128));
            }
            return t;
          })(e),
          t
        );
  },
  decodeString(e, t) {
    return this.HAS_NATIVE_SUPPORT && !t
      ? atob(e)
      : (function (e) {
          const t = [];
          let r = 0,
            n = 0;
          for (; r < e.length; ) {
            const o = e[r++];
            if (o < 128) t[n++] = String.fromCharCode(o);
            else if (o > 191 && o < 224) {
              const i = e[r++];
              t[n++] = String.fromCharCode(((31 & o) << 6) | (63 & i));
            } else if (o > 239 && o < 365) {
              const i =
                (((7 & o) << 18) |
                  ((63 & e[r++]) << 12) |
                  ((63 & e[r++]) << 6) |
                  (63 & e[r++])) -
                65536;
              (t[n++] = String.fromCharCode(55296 + (i >> 10))),
                (t[n++] = String.fromCharCode(56320 + (1023 & i)));
            } else {
              const i = e[r++],
                a = e[r++];
              t[n++] = String.fromCharCode(
                ((15 & o) << 12) | ((63 & i) << 6) | (63 & a)
              );
            }
          }
          return t.join("");
        })(this.decodeStringToByteArray(e, t));
  },
  decodeStringToByteArray(e, t) {
    this.init_();
    const r = t ? this.charToByteMapWebSafe_ : this.charToByteMap_,
      n = [];
    for (let t = 0; t < e.length; ) {
      const o = r[e.charAt(t++)],
        i = t < e.length ? r[e.charAt(t)] : 0;
      ++t;
      const a = t < e.length ? r[e.charAt(t)] : 64;
      ++t;
      const s = t < e.length ? r[e.charAt(t)] : 64;
      if ((++t, null == o || null == i || null == a || null == s))
        throw new DecodeBase64StringError();
      const c = (o << 2) | (i >> 4);
      if ((n.push(c), 64 !== a)) {
        const e = ((i << 4) & 240) | (a >> 2);
        if ((n.push(e), 64 !== s)) {
          const e = ((a << 6) & 192) | s;
          n.push(e);
        }
      }
    }
    return n;
  },
  init_() {
    if (!this.byteToCharMap_) {
      (this.byteToCharMap_ = {}),
        (this.charToByteMap_ = {}),
        (this.byteToCharMapWebSafe_ = {}),
        (this.charToByteMapWebSafe_ = {});
      for (let e = 0; e < this.ENCODED_VALS.length; e++)
        (this.byteToCharMap_[e] = this.ENCODED_VALS.charAt(e)),
          (this.charToByteMap_[this.byteToCharMap_[e]] = e),
          (this.byteToCharMapWebSafe_[e] = this.ENCODED_VALS_WEBSAFE.charAt(e)),
          (this.charToByteMapWebSafe_[this.byteToCharMapWebSafe_[e]] = e),
          e >= this.ENCODED_VALS_BASE.length &&
            ((this.charToByteMap_[this.ENCODED_VALS_WEBSAFE.charAt(e)] = e),
            (this.charToByteMapWebSafe_[this.ENCODED_VALS.charAt(e)] = e));
    }
  },
};
class DecodeBase64StringError extends Error {
  constructor() {
    super(...arguments), (this.name = "DecodeBase64StringError");
  }
}
const base64Decode = function (e) {
  try {
    return n.decodeString(e, !0);
  } catch (e) {
    console.error("base64Decode failed: ", e);
  }
  return null;
};
class Deferred {
  constructor() {
    (this.reject = () => {}),
      (this.resolve = () => {}),
      (this.promise = new Promise((e, t) => {
        (this.resolve = e), (this.reject = t);
      }));
  }
  wrapCallback(e) {
    return (t, r) => {
      t ? this.reject(t) : this.resolve(r),
        "function" == typeof e &&
          (this.promise.catch(() => {}), 1 === e.length ? e(t) : e(t, r));
    };
  }
}
function isIndexedDBAvailable() {
  try {
    return "object" == typeof indexedDB;
  } catch (e) {
    return !1;
  }
}
class FirebaseError extends Error {
  constructor(e, t, r) {
    super(t),
      (this.code = e),
      (this.customData = r),
      (this.name = "FirebaseError"),
      Object.setPrototypeOf(this, FirebaseError.prototype),
      Error.captureStackTrace &&
        Error.captureStackTrace(this, ErrorFactory.prototype.create);
  }
}
class ErrorFactory {
  constructor(e, t, r) {
    (this.service = e), (this.serviceName = t), (this.errors = r);
  }
  create(e, ...t) {
    const r = t[0] || {},
      n = `${this.service}/${e}`,
      i = this.errors[e],
      a = i
        ? (function replaceTemplate(e, t) {
            return e.replace(o, (e, r) => {
              const n = t[r];
              return null != n ? String(n) : `<${r}?>`;
            });
          })(i, r)
        : "Error",
      s = `${this.serviceName}: ${a} (${n}).`;
    return new FirebaseError(n, s, r);
  }
}
const o = /\{\$([^}]+)}/g;
function jsonEval(e) {
  return JSON.parse(e);
}
const issuedAtTime = function (e) {
  const t = (function (e) {
    let t = {},
      r = {},
      n = {},
      o = "";
    try {
      const i = e.split(".");
      (t = jsonEval(base64Decode(i[0]) || "")),
        (r = jsonEval(base64Decode(i[1]) || "")),
        (o = i[2]),
        (n = r.d || {}),
        delete r.d;
    } catch (e) {}
    return { header: t, claims: r, data: n, signature: o };
  })(e).claims;
  return "object" == typeof t && t.hasOwnProperty("iat") ? t.iat : null;
};
class Component {
  constructor(e, t, r) {
    (this.name = e),
      (this.instanceFactory = t),
      (this.type = r),
      (this.multipleInstances = !1),
      (this.serviceProps = {}),
      (this.instantiationMode = "LAZY"),
      (this.onInstanceCreated = null);
  }
  setInstantiationMode(e) {
    return (this.instantiationMode = e), this;
  }
  setMultipleInstances(e) {
    return (this.multipleInstances = e), this;
  }
  setServiceProps(e) {
    return (this.serviceProps = e), this;
  }
  setInstanceCreatedCallback(e) {
    return (this.onInstanceCreated = e), this;
  }
}
var i;
!(function (e) {
  (e[(e.DEBUG = 0)] = "DEBUG"),
    (e[(e.VERBOSE = 1)] = "VERBOSE"),
    (e[(e.INFO = 2)] = "INFO"),
    (e[(e.WARN = 3)] = "WARN"),
    (e[(e.ERROR = 4)] = "ERROR"),
    (e[(e.SILENT = 5)] = "SILENT");
})(i || (i = {}));
const a = {
    debug: i.DEBUG,
    verbose: i.VERBOSE,
    info: i.INFO,
    warn: i.WARN,
    error: i.ERROR,
    silent: i.SILENT,
  },
  s = i.INFO,
  c = {
    [i.DEBUG]: "log",
    [i.VERBOSE]: "log",
    [i.INFO]: "info",
    [i.WARN]: "warn",
    [i.ERROR]: "error",
  },
  defaultLogHandler = (e, t, ...r) => {
    if (t < e.logLevel) return;
    const n = new Date().toISOString(),
      o = c[t];
    if (!o)
      throw new Error(
        `Attempted to log a message with an invalid logType (value: ${t})`
      );
    console[o](`[${n}]  ${e.name}:`, ...r);
  };
const h = new Map(),
  l = { activated: !1, tokenObservers: [] },
  u = { initialized: !1, enabled: !1 };
function getStateReference(e) {
  return h.get(e) || Object.assign({}, l);
}
function getDebugState() {
  return u;
}
const d = "https://content-firebaseappcheck.googleapis.com/v1",
  p = 3e4,
  g = 96e4;
class Refresher {
  constructor(e, t, r, n, o) {
    if (
      ((this.operation = e),
      (this.retryPolicy = t),
      (this.getWaitDuration = r),
      (this.lowerBound = n),
      (this.upperBound = o),
      (this.pending = null),
      (this.nextErrorWaitInterval = n),
      n > o)
    )
      throw new Error(
        "Proactive refresh lower bound greater than upper bound!"
      );
  }
  start() {
    (this.nextErrorWaitInterval = this.lowerBound),
      this.process(!0).catch(() => {});
  }
  stop() {
    this.pending && (this.pending.reject("cancelled"), (this.pending = null));
  }
  isRunning() {
    return !!this.pending;
  }
  async process(e) {
    this.stop();
    try {
      (this.pending = new Deferred()),
        await (function sleep(e) {
          return new Promise((t) => {
            setTimeout(t, e);
          });
        })(this.getNextRun(e)),
        this.pending.resolve(),
        await this.pending.promise,
        (this.pending = new Deferred()),
        await this.operation(),
        this.pending.resolve(),
        await this.pending.promise,
        this.process(!0).catch(() => {});
    } catch (e) {
      this.retryPolicy(e) ? this.process(!1).catch(() => {}) : this.stop();
    }
  }
  getNextRun(e) {
    if (e)
      return (
        (this.nextErrorWaitInterval = this.lowerBound), this.getWaitDuration()
      );
    {
      const e = this.nextErrorWaitInterval;
      return (
        (this.nextErrorWaitInterval *= 2),
        this.nextErrorWaitInterval > this.upperBound &&
          (this.nextErrorWaitInterval = this.upperBound),
        e
      );
    }
  }
}
const f = new ErrorFactory("appCheck", "AppCheck", {
  "already-initialized":
    "You have already called initializeAppCheck() for FirebaseApp {$appName} with different options. To avoid this error, call initializeAppCheck() with the same options as when it was originally called. This will return the already initialized instance.",
  "use-before-activation":
    "App Check is being used before initializeAppCheck() is called for FirebaseApp {$appName}. Call initializeAppCheck() before instantiating other Firebase services.",
  "fetch-network-error":
    "Fetch failed to connect to a network. Check Internet connection. Original error: {$originalErrorMessage}.",
  "fetch-parse-error":
    "Fetch client could not parse response. Original error: {$originalErrorMessage}.",
  "fetch-status-error":
    "Fetch server returned an HTTP error status. HTTP status: {$httpStatus}.",
  "storage-open":
    "Error thrown when opening storage. Original error: {$originalErrorMessage}.",
  "storage-get":
    "Error thrown when reading from storage. Original error: {$originalErrorMessage}.",
  "storage-set":
    "Error thrown when writing to storage. Original error: {$originalErrorMessage}.",
  "recaptcha-error": "ReCAPTCHA error.",
  throttled:
    "Requests throttled due to {$httpStatus} error. Attempts allowed again after {$time}",
});
function getRecaptcha(e = !1) {
  var t;
  return e
    ? null === (t = self.grecaptcha) || void 0 === t
      ? void 0
      : t.enterprise
    : self.grecaptcha;
}
function ensureActivated(e) {
  if (!getStateReference(e).activated)
    throw f.create("use-before-activation", { appName: e.name });
}
function getDurationString(e) {
  const t = Math.round(e / 1e3),
    r = Math.floor(t / 86400),
    n = Math.floor((t - 3600 * r * 24) / 3600),
    o = Math.floor((t - 3600 * r * 24 - 3600 * n) / 60),
    i = t - 3600 * r * 24 - 3600 * n - 60 * o;
  let a = "";
  return (
    r && (a += pad(r) + "d:"),
    n && (a += pad(n) + "h:"),
    (a += pad(o) + "m:" + pad(i) + "s"),
    a
  );
}
function pad(e) {
  return 0 === e ? "00" : e >= 10 ? e.toString() : "0" + e;
}
async function exchangeToken({ url: e, body: t }, r) {
  const n = { "Content-Type": "application/json" },
    o = r.getImmediate({ optional: !0 });
  if (o) {
    const e = await o.getHeartbeatsHeader();
    e && (n["X-Firebase-Client"] = e);
  }
  const i = { method: "POST", body: JSON.stringify(t), headers: n };
  let a, s;
  try {
    a = await fetch(e, i);
  } catch (e) {
    throw f.create("fetch-network-error", {
      originalErrorMessage: null == e ? void 0 : e.message,
    });
  }
  if (200 !== a.status)
    throw f.create("fetch-status-error", { httpStatus: a.status });
  try {
    s = await a.json();
  } catch (e) {
    throw f.create("fetch-parse-error", {
      originalErrorMessage: null == e ? void 0 : e.message,
    });
  }
  const c = s.ttl.match(/^([\d.]+)(s)$/);
  if (!c || !c[2] || isNaN(Number(c[1])))
    throw f.create("fetch-parse-error", {
      originalErrorMessage: `ttl field (timeToLive) is not in standard Protobuf Duration format: ${s.ttl}`,
    });
  const h = 1e3 * Number(c[1]),
    l = Date.now();
  return { token: s.token, expireTimeMillis: l + h, issuedAtTimeMillis: l };
}
function getExchangeDebugTokenRequest(e, t) {
  const { projectId: r, appId: n, apiKey: o } = e.options;
  return {
    url: `${d}/projects/${r}/apps/${n}:exchangeDebugToken?key=${o}`,
    body: { debug_token: t },
  };
}
const k = "firebase-app-check-store";
let T = null;
function getDBPromise() {
  return (
    T ||
    ((T = new Promise((e, t) => {
      try {
        const r = indexedDB.open("firebase-app-check-database", 1);
        (r.onsuccess = (t) => {
          e(t.target.result);
        }),
          (r.onerror = (e) => {
            var r;
            t(
              f.create("storage-open", {
                originalErrorMessage:
                  null === (r = e.target.error) || void 0 === r
                    ? void 0
                    : r.message,
              })
            );
          }),
          (r.onupgradeneeded = (e) => {
            const t = e.target.result;
            if (0 === e.oldVersion)
              t.createObjectStore(k, { keyPath: "compositeKey" });
          });
      } catch (e) {
        t(
          f.create("storage-open", {
            originalErrorMessage: null == e ? void 0 : e.message,
          })
        );
      }
    })),
    T)
  );
}
async function write(e, t) {
  const r = (await getDBPromise()).transaction(k, "readwrite"),
    n = r.objectStore(k).put({ compositeKey: e, value: t });
  return new Promise((e, t) => {
    (n.onsuccess = (t) => {
      e();
    }),
      (r.onerror = (e) => {
        var r;
        t(
          f.create("storage-set", {
            originalErrorMessage:
              null === (r = e.target.error) || void 0 === r
                ? void 0
                : r.message,
          })
        );
      });
  });
}
async function read(e) {
  const t = (await getDBPromise()).transaction(k, "readonly"),
    r = t.objectStore(k).get(e);
  return new Promise((e, n) => {
    (r.onsuccess = (t) => {
      const r = t.target.result;
      e(r ? r.value : void 0);
    }),
      (t.onerror = (e) => {
        var t;
        n(
          f.create("storage-get", {
            originalErrorMessage:
              null === (t = e.target.error) || void 0 === t
                ? void 0
                : t.message,
          })
        );
      });
  });
}
function computeKey(e) {
  return `${e.options.appId}-${e.name}`;
}
const E = new (class Logger {
  constructor(e) {
    (this.name = e),
      (this._logLevel = s),
      (this._logHandler = defaultLogHandler),
      (this._userLogHandler = null);
  }
  get logLevel() {
    return this._logLevel;
  }
  set logLevel(e) {
    if (!(e in i))
      throw new TypeError(`Invalid value "${e}" assigned to \`logLevel\``);
    this._logLevel = e;
  }
  setLogLevel(e) {
    this._logLevel = "string" == typeof e ? a[e] : e;
  }
  get logHandler() {
    return this._logHandler;
  }
  set logHandler(e) {
    if ("function" != typeof e)
      throw new TypeError("Value assigned to `logHandler` must be a function");
    this._logHandler = e;
  }
  get userLogHandler() {
    return this._userLogHandler;
  }
  set userLogHandler(e) {
    this._userLogHandler = e;
  }
  debug(...e) {
    this._userLogHandler && this._userLogHandler(this, i.DEBUG, ...e),
      this._logHandler(this, i.DEBUG, ...e);
  }
  log(...e) {
    this._userLogHandler && this._userLogHandler(this, i.VERBOSE, ...e),
      this._logHandler(this, i.VERBOSE, ...e);
  }
  info(...e) {
    this._userLogHandler && this._userLogHandler(this, i.INFO, ...e),
      this._logHandler(this, i.INFO, ...e);
  }
  warn(...e) {
    this._userLogHandler && this._userLogHandler(this, i.WARN, ...e),
      this._logHandler(this, i.WARN, ...e);
  }
  error(...e) {
    this._userLogHandler && this._userLogHandler(this, i.ERROR, ...e),
      this._logHandler(this, i.ERROR, ...e);
  }
})("@firebase/app-check");
async function readTokenFromStorage(e) {
  if (isIndexedDBAvailable()) {
    let t;
    try {
      t = await (function readTokenFromIndexedDB(e) {
        return read(computeKey(e));
      })(e);
    } catch (e) {
      E.warn(`Failed to read token from IndexedDB. Error: ${e}`);
    }
    return t;
  }
}
function writeTokenToStorage(e, t) {
  return isIndexedDBAvailable()
    ? (function writeTokenToIndexedDB(e, t) {
        return write(computeKey(e), t);
      })(e, t).catch((e) => {
        E.warn(`Failed to write token to IndexedDB. Error: ${e}`);
      })
    : Promise.resolve();
}
async function readOrCreateDebugTokenFromStorage() {
  let e;
  try {
    e = await (function readDebugTokenFromIndexedDB() {
      return read("debug-token");
    })();
  } catch (e) {}
  if (e) return e;
  {
    const e = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, (e) => {
      const t = (16 * Math.random()) | 0;
      return ("x" === e ? t : (3 & t) | 8).toString(16);
    });
    return (
      (function writeDebugTokenToIndexedDB(e) {
        return write("debug-token", e);
      })(e).catch((e) =>
        E.warn(`Failed to persist debug token to IndexedDB. Error: ${e}`)
      ),
      e
    );
  }
}
function isDebugMode() {
  return getDebugState().enabled;
}
async function getDebugToken() {
  const e = getDebugState();
  if (e.enabled && e.token) return e.token.promise;
  throw Error(
    "\n            Can't get debug token in production mode.\n        "
  );
}
function initializeDebugMode() {
  const e = (function getGlobal() {
      if ("undefined" != typeof self) return self;
      if ("undefined" != typeof window) return window;
      if ("undefined" != typeof global) return global;
      throw new Error("Unable to locate global object.");
    })(),
    t = getDebugState();
  if (
    ((t.initialized = !0),
    "string" != typeof e.FIREBASE_APPCHECK_DEBUG_TOKEN &&
      !0 !== e.FIREBASE_APPCHECK_DEBUG_TOKEN)
  )
    return;
  t.enabled = !0;
  const r = new Deferred();
  (t.token = r),
    "string" == typeof e.FIREBASE_APPCHECK_DEBUG_TOKEN
      ? r.resolve(e.FIREBASE_APPCHECK_DEBUG_TOKEN)
      : r.resolve(readOrCreateDebugTokenFromStorage());
}
const m = { error: "UNKNOWN_ERROR" };
async function getToken$2(e, t = !1) {
  const r = e.app;
  ensureActivated(r);
  const n = getStateReference(r);
  let o,
    i = n.token;
  if ((i && !isValid(i) && ((n.token = void 0), (i = void 0)), !i)) {
    const e = await n.cachedTokenPromise;
    e && (isValid(e) ? (i = e) : await writeTokenToStorage(r, void 0));
  }
  if (!t && i && isValid(i)) return { token: i.token };
  let a,
    s = !1;
  if (isDebugMode()) {
    n.exchangeTokenPromise ||
      ((n.exchangeTokenPromise = exchangeToken(
        getExchangeDebugTokenRequest(r, await getDebugToken()),
        e.heartbeatServiceProvider
      ).finally(() => {
        n.exchangeTokenPromise = void 0;
      })),
      (s = !0));
    const t = await n.exchangeTokenPromise;
    return await writeTokenToStorage(r, t), (n.token = t), { token: t.token };
  }
  try {
    n.exchangeTokenPromise ||
      ((n.exchangeTokenPromise = n.provider.getToken().finally(() => {
        n.exchangeTokenPromise = void 0;
      })),
      (s = !0)),
      (i = await getStateReference(r).exchangeTokenPromise);
  } catch (e) {
    "appCheck/throttled" === e.code ? E.warn(e.message) : E.error(e), (o = e);
  }
  return (
    i
      ? o
        ? (a = isValid(i)
            ? { token: i.token, internalError: o }
            : makeDummyTokenResult(o))
        : ((a = { token: i.token }),
          (n.token = i),
          await writeTokenToStorage(r, i))
      : (a = makeDummyTokenResult(o)),
    s && notifyTokenListeners(r, a),
    a
  );
}
async function getLimitedUseToken$1(e) {
  const t = e.app;
  ensureActivated(t);
  const { provider: r } = getStateReference(t);
  if (isDebugMode()) {
    const r = await getDebugToken(),
      { token: n } = await exchangeToken(
        getExchangeDebugTokenRequest(t, r),
        e.heartbeatServiceProvider
      );
    return { token: n };
  }
  {
    const { token: e } = await r.getToken();
    return { token: e };
  }
}
function addTokenListener(e, t, r, n) {
  const { app: o } = e,
    i = getStateReference(o),
    a = { next: r, error: n, type: t };
  if (
    ((i.tokenObservers = [...i.tokenObservers, a]), i.token && isValid(i.token))
  ) {
    const t = i.token;
    Promise.resolve()
      .then(() => {
        r({ token: t.token }), initTokenRefresher(e);
      })
      .catch(() => {});
  }
  i.cachedTokenPromise.then(() => initTokenRefresher(e));
}
function removeTokenListener(e, t) {
  const r = getStateReference(e),
    n = r.tokenObservers.filter((e) => e.next !== t);
  0 === n.length &&
    r.tokenRefresher &&
    r.tokenRefresher.isRunning() &&
    r.tokenRefresher.stop(),
    (r.tokenObservers = n);
}
function initTokenRefresher(e) {
  const { app: t } = e,
    r = getStateReference(t);
  let n = r.tokenRefresher;
  n ||
    ((n = (function createTokenRefresher(e) {
      const { app: t } = e;
      return new Refresher(
        async () => {
          let r;
          if (
            ((r = getStateReference(t).token
              ? await getToken$2(e, !0)
              : await getToken$2(e)),
            r.error)
          )
            throw r.error;
          if (r.internalError) throw r.internalError;
        },
        () => !0,
        () => {
          const e = getStateReference(t);
          if (e.token) {
            let t =
              e.token.issuedAtTimeMillis +
              0.5 * (e.token.expireTimeMillis - e.token.issuedAtTimeMillis) +
              3e5;
            const r = e.token.expireTimeMillis - 3e5;
            return (t = Math.min(t, r)), Math.max(0, t - Date.now());
          }
          return 0;
        },
        p,
        g
      );
    })(e)),
    (r.tokenRefresher = n)),
    !n.isRunning() && r.isTokenAutoRefreshEnabled && n.start();
}
function notifyTokenListeners(e, t) {
  const r = getStateReference(e).tokenObservers;
  for (const e of r)
    try {
      "EXTERNAL" === e.type && null != t.error ? e.error(t.error) : e.next(t);
    } catch (e) {}
}
function isValid(e) {
  return e.expireTimeMillis - Date.now() > 0;
}
function makeDummyTokenResult(e) {
  return { token: ((t = m), n.encodeString(JSON.stringify(t), !1)), error: e };
}
class AppCheckService {
  constructor(e, t) {
    (this.app = e), (this.heartbeatServiceProvider = t);
  }
  _delete() {
    const { tokenObservers: e } = getStateReference(this.app);
    for (const t of e) removeTokenListener(this.app, t.next);
    return Promise.resolve();
  }
}
function initializeV3(e, t) {
  const r = new Deferred();
  getStateReference(e).reCAPTCHAState = { initialized: r };
  const n = makeDiv(e),
    o = getRecaptcha(!1);
  return (
    o
      ? queueWidgetRender(e, t, o, n, r)
      : (function loadReCAPTCHAV3Script(e) {
          const t = document.createElement("script");
          (t.src = "https://www.google.com/recaptcha/api.js"),
            (t.onload = e),
            document.head.appendChild(t);
        })(() => {
          const o = getRecaptcha(!1);
          if (!o) throw new Error("no recaptcha");
          queueWidgetRender(e, t, o, n, r);
        }),
    r.promise
  );
}
function initializeEnterprise(e, t) {
  const r = new Deferred();
  getStateReference(e).reCAPTCHAState = { initialized: r };
  const n = makeDiv(e),
    o = getRecaptcha(!0);
  return (
    o
      ? queueWidgetRender(e, t, o, n, r)
      : (function loadReCAPTCHAEnterpriseScript(e) {
          const t = document.createElement("script");
          (t.src = "https://www.google.com/recaptcha/enterprise.js"),
            (t.onload = e),
            document.head.appendChild(t);
        })(() => {
          const o = getRecaptcha(!0);
          if (!o) throw new Error("no recaptcha");
          queueWidgetRender(e, t, o, n, r);
        }),
    r.promise
  );
}
function queueWidgetRender(e, t, r, n, o) {
  r.ready(() => {
    !(function renderInvisibleWidget(e, t, r, n) {
      const o = r.render(n, {
          sitekey: t,
          size: "invisible",
          callback: () => {
            getStateReference(e).reCAPTCHAState.succeeded = !0;
          },
          "error-callback": () => {
            getStateReference(e).reCAPTCHAState.succeeded = !1;
          },
        }),
        i = getStateReference(e);
      i.reCAPTCHAState = Object.assign(Object.assign({}, i.reCAPTCHAState), {
        widgetId: o,
      });
    })(e, t, r, n),
      o.resolve(r);
  });
}
function makeDiv(e) {
  const t = `fire_app_check_${e.name}`,
    r = document.createElement("div");
  return (
    (r.id = t), (r.style.display = "none"), document.body.appendChild(r), t
  );
}
async function getToken$1(e) {
  ensureActivated(e);
  const t = getStateReference(e).reCAPTCHAState,
    r = await t.initialized.promise;
  return new Promise((t, n) => {
    const o = getStateReference(e).reCAPTCHAState;
    r.ready(() => {
      t(r.execute(o.widgetId, { action: "fire_app_check" }));
    });
  });
}
class ReCaptchaV3Provider {
  constructor(e) {
    (this._siteKey = e), (this._throttleData = null);
  }
  async getToken() {
    var e, t, r;
    throwIfThrottled(this._throttleData);
    const n = await getToken$1(this._app).catch((e) => {
      throw f.create("recaptcha-error");
    });
    if (
      !(null === (e = getStateReference(this._app).reCAPTCHAState) ||
      void 0 === e
        ? void 0
        : e.succeeded)
    )
      throw f.create("recaptcha-error");
    let o;
    try {
      o = await exchangeToken(
        (function getExchangeRecaptchaV3TokenRequest(e, t) {
          const { projectId: r, appId: n, apiKey: o } = e.options;
          return {
            url: `${d}/projects/${r}/apps/${n}:exchangeRecaptchaV3Token?key=${o}`,
            body: { recaptcha_v3_token: t },
          };
        })(this._app, n),
        this._heartbeatServiceProvider
      );
    } catch (e) {
      throw (
        null === (t = e.code) || void 0 === t
          ? void 0
          : t.includes("fetch-status-error")
      )
        ? ((this._throttleData = setBackoff(
            Number(
              null === (r = e.customData) || void 0 === r
                ? void 0
                : r.httpStatus
            ),
            this._throttleData
          )),
          f.create("throttled", {
            time: getDurationString(
              this._throttleData.allowRequestsAfter - Date.now()
            ),
            httpStatus: this._throttleData.httpStatus,
          }))
        : e;
    }
    return (this._throttleData = null), o;
  }
  initialize(e) {
    (this._app = e),
      (this._heartbeatServiceProvider = _getProvider(e, "heartbeat")),
      initializeV3(e, this._siteKey).catch(() => {});
  }
  isEqual(e) {
    return e instanceof ReCaptchaV3Provider && this._siteKey === e._siteKey;
  }
}
class ReCaptchaEnterpriseProvider {
  constructor(e) {
    (this._siteKey = e), (this._throttleData = null);
  }
  async getToken() {
    var e, t, r;
    throwIfThrottled(this._throttleData);
    const n = await getToken$1(this._app).catch((e) => {
      throw f.create("recaptcha-error");
    });
    if (
      !(null === (e = getStateReference(this._app).reCAPTCHAState) ||
      void 0 === e
        ? void 0
        : e.succeeded)
    )
      throw f.create("recaptcha-error");
    let o;
    try {
      o = await exchangeToken(
        (function getExchangeRecaptchaEnterpriseTokenRequest(e, t) {
          const { projectId: r, appId: n, apiKey: o } = e.options;
          return {
            url: `${d}/projects/${r}/apps/${n}:exchangeRecaptchaEnterpriseToken?key=${o}`,
            body: { recaptcha_enterprise_token: t },
          };
        })(this._app, n),
        this._heartbeatServiceProvider
      );
    } catch (e) {
      throw (
        null === (t = e.code) || void 0 === t
          ? void 0
          : t.includes("fetch-status-error")
      )
        ? ((this._throttleData = setBackoff(
            Number(
              null === (r = e.customData) || void 0 === r
                ? void 0
                : r.httpStatus
            ),
            this._throttleData
          )),
          f.create("throttled", {
            time: getDurationString(
              this._throttleData.allowRequestsAfter - Date.now()
            ),
            httpStatus: this._throttleData.httpStatus,
          }))
        : e;
    }
    return (this._throttleData = null), o;
  }
  initialize(e) {
    (this._app = e),
      (this._heartbeatServiceProvider = _getProvider(e, "heartbeat")),
      initializeEnterprise(e, this._siteKey).catch(() => {});
  }
  isEqual(e) {
    return (
      e instanceof ReCaptchaEnterpriseProvider && this._siteKey === e._siteKey
    );
  }
}
class CustomProvider {
  constructor(e) {
    this._customProviderOptions = e;
  }
  async getToken() {
    const e = await this._customProviderOptions.getToken(),
      t = issuedAtTime(e.token),
      r = null !== t && t < Date.now() && t > 0 ? 1e3 * t : Date.now();
    return Object.assign(Object.assign({}, e), { issuedAtTimeMillis: r });
  }
  initialize(e) {
    this._app = e;
  }
  isEqual(e) {
    return (
      e instanceof CustomProvider &&
      this._customProviderOptions.getToken.toString() ===
        e._customProviderOptions.getToken.toString()
    );
  }
}
function setBackoff(e, t) {
  if (404 === e || 403 === e)
    return {
      backoffCount: 1,
      allowRequestsAfter: Date.now() + 864e5,
      httpStatus: e,
    };
  {
    const r = t ? t.backoffCount : 0,
      n = (function calculateBackoffMillis(e, t = 1e3, r = 2) {
        const n = t * Math.pow(r, e),
          o = Math.round(0.5 * n * (Math.random() - 0.5) * 2);
        return Math.min(144e5, n + o);
      })(r, 1e3, 2);
    return {
      backoffCount: r + 1,
      allowRequestsAfter: Date.now() + n,
      httpStatus: e,
    };
  }
}
function throwIfThrottled(e) {
  if (e && Date.now() - e.allowRequestsAfter <= 0)
    throw f.create("throttled", {
      time: getDurationString(e.allowRequestsAfter - Date.now()),
      httpStatus: e.httpStatus,
    });
}
function initializeAppCheck(t = e(), r) {
  t = (function getModularInstance(e) {
    return e && e._delegate ? e._delegate : e;
  })(t);
  const n = _getProvider(t, "app-check");
  if (
    (getDebugState().initialized || initializeDebugMode(),
    isDebugMode() &&
      getDebugToken().then((e) =>
        console.log(
          `App Check debug token: ${e}. You will need to add it to your app's App Check settings in the Firebase console for it to work.`
        )
      ),
    n.isInitialized())
  ) {
    const e = n.getImmediate(),
      o = n.getOptions();
    if (
      o.isTokenAutoRefreshEnabled === r.isTokenAutoRefreshEnabled &&
      o.provider.isEqual(r.provider)
    )
      return e;
    throw f.create("already-initialized", { appName: t.name });
  }
  const o = n.initialize({ options: r });
  return (
    (function _activate(e, t, r) {
      const n = (function setInitialState(e, t) {
        return h.set(e, t), h.get(e);
      })(e, Object.assign({}, l));
      (n.activated = !0),
        (n.provider = t),
        (n.cachedTokenPromise = readTokenFromStorage(e).then(
          (t) => (
            t &&
              isValid(t) &&
              ((n.token = t), notifyTokenListeners(e, { token: t.token })),
            t
          )
        )),
        (n.isTokenAutoRefreshEnabled =
          void 0 === r ? e.automaticDataCollectionEnabled : r),
        n.provider.initialize(e);
    })(t, r.provider, r.isTokenAutoRefreshEnabled),
    getStateReference(t).isTokenAutoRefreshEnabled &&
      addTokenListener(o, "INTERNAL", () => {}),
    o
  );
}
function setTokenAutoRefreshEnabled(e, t) {
  const r = getStateReference(e.app);
  r.tokenRefresher &&
    (!0 === t ? r.tokenRefresher.start() : r.tokenRefresher.stop()),
    (r.isTokenAutoRefreshEnabled = t);
}
async function getToken(e, t) {
  const r = await getToken$2(e, t);
  if (r.error) throw r.error;
  return { token: r.token };
}
function getLimitedUseToken(e) {
  return getLimitedUseToken$1(e);
}
function onTokenChanged(e, t, r, n) {
  let nextFn = () => {},
    errorFn = () => {};
  return (
    (nextFn = null != t.next ? t.next.bind(t) : t),
    null != t.error ? (errorFn = t.error.bind(t)) : r && (errorFn = r),
    addTokenListener(e, "EXTERNAL", nextFn, errorFn),
    () => removeTokenListener(e.app, nextFn)
  );
}
!(function registerAppCheck() {
  t(
    new Component(
      "app-check",
      (e) =>
        (function factory(e, t) {
          return new AppCheckService(e, t);
        })(e.getProvider("app").getImmediate(), e.getProvider("heartbeat")),
      "PUBLIC"
    )
      .setInstantiationMode("EXPLICIT")
      .setInstanceCreatedCallback((e, t, r) => {
        e.getProvider("app-check-internal").initialize();
      })
  ),
    t(
      new Component(
        "app-check-internal",
        (e) =>
          (function internalFactory(e) {
            return {
              getToken: (t) => getToken$2(e, t),
              getLimitedUseToken: () => getLimitedUseToken$1(e),
              addTokenListener: (t) => addTokenListener(e, "INTERNAL", t),
              removeTokenListener: (t) => removeTokenListener(e.app, t),
            };
          })(e.getProvider("app-check").getImmediate()),
        "PUBLIC"
      ).setInstantiationMode("EXPLICIT")
    ),
    r("@firebase/app-check", "0.8.0");
})();
export {
  CustomProvider,
  ReCaptchaEnterpriseProvider,
  ReCaptchaV3Provider,
  getLimitedUseToken,
  getToken,
  initializeAppCheck,
  onTokenChanged,
  setTokenAutoRefreshEnabled,
};

//# sourceMappingURL=firebase-app-check.js.map
