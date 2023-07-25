import {
  registerVersion as e,
  _registerComponent as t,
  _getProvider,
  getApp as r,
  SDK_VERSION as n,
} from "./firebase/firebase-app.js";
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
      s = this.errors[e],
      i = s
        ? (function replaceTemplate(e, t) {
            return e.replace(a, (e, r) => {
              const n = t[r];
              return null != n ? String(n) : `<${r}?>`;
            });
          })(s, r)
        : "Error",
      o = `${this.serviceName}: ${i} (${n}).`;
    return new FirebaseError(n, o, r);
  }
}
const a = /\{\$([^}]+)}/g;
function calculateBackoffMillis(e, t = 1e3, r = 2) {
  const n = t * Math.pow(r, e),
    a = Math.round(0.5 * n * (Math.random() - 0.5) * 2);
  return Math.min(144e5, n + a);
}
function getModularInstance(e) {
  return e && e._delegate ? e._delegate : e;
}
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
var s;
!(function (e) {
  (e[(e.DEBUG = 0)] = "DEBUG"),
    (e[(e.VERBOSE = 1)] = "VERBOSE"),
    (e[(e.INFO = 2)] = "INFO"),
    (e[(e.WARN = 3)] = "WARN"),
    (e[(e.ERROR = 4)] = "ERROR"),
    (e[(e.SILENT = 5)] = "SILENT");
})(s || (s = {}));
const i = {
    debug: s.DEBUG,
    verbose: s.VERBOSE,
    info: s.INFO,
    warn: s.WARN,
    error: s.ERROR,
    silent: s.SILENT,
  },
  o = s.INFO,
  c = {
    [s.DEBUG]: "log",
    [s.VERBOSE]: "log",
    [s.INFO]: "info",
    [s.WARN]: "warn",
    [s.ERROR]: "error",
  },
  defaultLogHandler = (e, t, ...r) => {
    if (t < e.logLevel) return;
    const n = new Date().toISOString(),
      a = c[t];
    if (!a)
      throw new Error(
        `Attempted to log a message with an invalid logType (value: ${t})`
      );
    console[a](`[${n}]  ${e.name}:`, ...r);
  };
class Logger {
  constructor(e) {
    (this.name = e),
      (this._logLevel = o),
      (this._logHandler = defaultLogHandler),
      (this._userLogHandler = null);
  }
  get logLevel() {
    return this._logLevel;
  }
  set logLevel(e) {
    if (!(e in s))
      throw new TypeError(`Invalid value "${e}" assigned to \`logLevel\``);
    this._logLevel = e;
  }
  setLogLevel(e) {
    this._logLevel = "string" == typeof e ? i[e] : e;
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
    this._userLogHandler && this._userLogHandler(this, s.DEBUG, ...e),
      this._logHandler(this, s.DEBUG, ...e);
  }
  log(...e) {
    this._userLogHandler && this._userLogHandler(this, s.VERBOSE, ...e),
      this._logHandler(this, s.VERBOSE, ...e);
  }
  info(...e) {
    this._userLogHandler && this._userLogHandler(this, s.INFO, ...e),
      this._logHandler(this, s.INFO, ...e);
  }
  warn(...e) {
    this._userLogHandler && this._userLogHandler(this, s.WARN, ...e),
      this._logHandler(this, s.WARN, ...e);
  }
  error(...e) {
    this._userLogHandler && this._userLogHandler(this, s.ERROR, ...e),
      this._logHandler(this, s.ERROR, ...e);
  }
}
let l, u;
const g = new WeakMap(),
  h = new WeakMap(),
  d = new WeakMap(),
  f = new WeakMap(),
  p = new WeakMap();
let m = {
  get(e, t, r) {
    if (e instanceof IDBTransaction) {
      if ("done" === t) return h.get(e);
      if ("objectStoreNames" === t) return e.objectStoreNames || d.get(e);
      if ("store" === t)
        return r.objectStoreNames[1]
          ? void 0
          : r.objectStore(r.objectStoreNames[0]);
    }
    return wrap(e[t]);
  },
  set: (e, t, r) => ((e[t] = r), !0),
  has: (e, t) =>
    (e instanceof IDBTransaction && ("done" === t || "store" === t)) || t in e,
};
function wrapFunction(e) {
  return e !== IDBDatabase.prototype.transaction ||
    "objectStoreNames" in IDBTransaction.prototype
    ? (function getCursorAdvanceMethods() {
        return (
          u ||
          (u = [
            IDBCursor.prototype.advance,
            IDBCursor.prototype.continue,
            IDBCursor.prototype.continuePrimaryKey,
          ])
        );
      })().includes(e)
      ? function (...t) {
          return e.apply(unwrap(this), t), wrap(g.get(this));
        }
      : function (...t) {
          return wrap(e.apply(unwrap(this), t));
        }
    : function (t, ...r) {
        const n = e.call(unwrap(this), t, ...r);
        return d.set(n, t.sort ? t.sort() : [t]), wrap(n);
      };
}
function transformCachableValue(e) {
  return "function" == typeof e
    ? wrapFunction(e)
    : (e instanceof IDBTransaction &&
        (function cacheDonePromiseForTransaction(e) {
          if (h.has(e)) return;
          const t = new Promise((t, r) => {
            const unlisten = () => {
                e.removeEventListener("complete", complete),
                  e.removeEventListener("error", error),
                  e.removeEventListener("abort", error);
              },
              complete = () => {
                t(), unlisten();
              },
              error = () => {
                r(e.error || new DOMException("AbortError", "AbortError")),
                  unlisten();
              };
            e.addEventListener("complete", complete),
              e.addEventListener("error", error),
              e.addEventListener("abort", error);
          });
          h.set(e, t);
        })(e),
      (t = e),
      (function getIdbProxyableTypes() {
        return (
          l ||
          (l = [
            IDBDatabase,
            IDBObjectStore,
            IDBIndex,
            IDBCursor,
            IDBTransaction,
          ])
        );
      })().some((e) => t instanceof e)
        ? new Proxy(e, m)
        : e);
  var t;
}
function wrap(e) {
  if (e instanceof IDBRequest)
    return (function promisifyRequest(e) {
      const t = new Promise((t, r) => {
        const unlisten = () => {
            e.removeEventListener("success", success),
              e.removeEventListener("error", error);
          },
          success = () => {
            t(wrap(e.result)), unlisten();
          },
          error = () => {
            r(e.error), unlisten();
          };
        e.addEventListener("success", success),
          e.addEventListener("error", error);
      });
      return (
        t
          .then((t) => {
            t instanceof IDBCursor && g.set(t, e);
          })
          .catch(() => {}),
        p.set(t, e),
        t
      );
    })(e);
  if (f.has(e)) return f.get(e);
  const t = transformCachableValue(e);
  return t !== e && (f.set(e, t), p.set(t, e)), t;
}
const unwrap = (e) => p.get(e);
const w = ["get", "getKey", "getAll", "getAllKeys", "count"],
  v = ["put", "add", "delete", "clear"],
  E = new Map();
function getMethod(e, t) {
  if (!(e instanceof IDBDatabase) || t in e || "string" != typeof t) return;
  if (E.get(t)) return E.get(t);
  const r = t.replace(/FromIndex$/, ""),
    n = t !== r,
    a = v.includes(r);
  if (
    !(r in (n ? IDBIndex : IDBObjectStore).prototype) ||
    (!a && !w.includes(r))
  )
    return;
  const method = async function (e, ...t) {
    const s = this.transaction(e, a ? "readwrite" : "readonly");
    let i = s.store;
    return (
      n && (i = i.index(t.shift())),
      (await Promise.all([i[r](...t), a && s.done]))[0]
    );
  };
  return E.set(t, method), method;
}
!(function replaceTraps(e) {
  m = e(m);
})((e) => ({
  ...e,
  get: (t, r, n) => getMethod(t, r) || e.get(t, r, n),
  has: (t, r) => !!getMethod(t, r) || e.has(t, r),
}));
const y = "@firebase/installations",
  I = new ErrorFactory("installations", "Installations", {
    "missing-app-config-values":
      'Missing App configuration value: "{$valueName}"',
    "not-registered": "Firebase Installation is not registered.",
    "installation-not-found": "Firebase Installation not found.",
    "request-failed":
      '{$requestName} request failed with error "{$serverCode} {$serverStatus}: {$serverMessage}"',
    "app-offline": "Could not process request. Application offline.",
    "delete-pending-registration":
      "Can't delete installation while there is a pending registration request.",
  });
function isServerError(e) {
  return e instanceof FirebaseError && e.code.includes("request-failed");
}
function getInstallationsEndpoint({ projectId: e }) {
  return `https://firebaseinstallations.googleapis.com/v1/projects/${e}/installations`;
}
function extractAuthTokenInfoFromResponse(e) {
  return {
    token: e.token,
    requestStatus: 2,
    expiresIn: ((t = e.expiresIn), Number(t.replace("s", "000"))),
    creationTime: Date.now(),
  };
  var t;
}
async function getErrorFromResponse(e, t) {
  const r = (await t.json()).error;
  return I.create("request-failed", {
    requestName: e,
    serverCode: r.code,
    serverMessage: r.message,
    serverStatus: r.status,
  });
}
function getHeaders({ apiKey: e }) {
  return new Headers({
    "Content-Type": "application/json",
    Accept: "application/json",
    "x-goog-api-key": e,
  });
}
function getHeadersWithAuth(e, { refreshToken: t }) {
  const r = getHeaders(e);
  return (
    r.append(
      "Authorization",
      (function getAuthorizationHeader(e) {
        return `FIS_v2 ${e}`;
      })(t)
    ),
    r
  );
}
async function retryIfServerError(e) {
  const t = await e();
  return t.status >= 500 && t.status < 600 ? e() : t;
}
function sleep(e) {
  return new Promise((t) => {
    setTimeout(t, e);
  });
}
const b = /^[cdef][\w-]{21}$/;
function generateFid() {
  try {
    const e = new Uint8Array(17);
    (self.crypto || self.msCrypto).getRandomValues(e),
      (e[0] = 112 + (e[0] % 16));
    const t = (function encode(e) {
      return (function bufferToBase64UrlSafe(e) {
        return btoa(String.fromCharCode(...e))
          .replace(/\+/g, "-")
          .replace(/\//g, "_");
      })(e).substr(0, 22);
    })(e);
    return b.test(t) ? t : "";
  } catch (e) {
    return "";
  }
}
function getKey(e) {
  return `${e.appName}!${e.appId}`;
}
const C = new Map();
function fidChanged(e, t) {
  const r = getKey(e);
  callFidChangeCallbacks(r, t),
    (function broadcastFidChange(e, t) {
      const r = (function getBroadcastChannel() {
        !S &&
          "BroadcastChannel" in self &&
          ((S = new BroadcastChannel("[Firebase] FID Change")),
          (S.onmessage = (e) => {
            callFidChangeCallbacks(e.data.key, e.data.fid);
          }));
        return S;
      })();
      r && r.postMessage({ key: e, fid: t });
      !(function closeBroadcastChannel() {
        0 === C.size && S && (S.close(), (S = null));
      })();
    })(r, t);
}
function callFidChangeCallbacks(e, t) {
  const r = C.get(e);
  if (r) for (const e of r) e(t);
}
let S = null;
const T = "firebase-installations-store";
let _ = null;
function getDbPromise() {
  return (
    _ ||
      (_ = (function openDB(
        e,
        t,
        { blocked: r, upgrade: n, blocking: a, terminated: s } = {}
      ) {
        const i = indexedDB.open(e, t),
          o = wrap(i);
        return (
          n &&
            i.addEventListener("upgradeneeded", (e) => {
              n(
                wrap(i.result),
                e.oldVersion,
                e.newVersion,
                wrap(i.transaction),
                e
              );
            }),
          r &&
            i.addEventListener("blocked", (e) =>
              r(e.oldVersion, e.newVersion, e)
            ),
          o
            .then((e) => {
              s && e.addEventListener("close", () => s()),
                a &&
                  e.addEventListener("versionchange", (e) =>
                    a(e.oldVersion, e.newVersion, e)
                  );
            })
            .catch(() => {}),
          o
        );
      })("firebase-installations-database", 1, {
        upgrade: (e, t) => {
          if (0 === t) e.createObjectStore(T);
        },
      })),
    _
  );
}
async function set(e, t) {
  const r = getKey(e),
    n = (await getDbPromise()).transaction(T, "readwrite"),
    a = n.objectStore(T),
    s = await a.get(r);
  return (
    await a.put(t, r),
    await n.done,
    (s && s.fid === t.fid) || fidChanged(e, t.fid),
    t
  );
}
async function remove(e) {
  const t = getKey(e),
    r = (await getDbPromise()).transaction(T, "readwrite");
  await r.objectStore(T).delete(t), await r.done;
}
async function update(e, t) {
  const r = getKey(e),
    n = (await getDbPromise()).transaction(T, "readwrite"),
    a = n.objectStore(T),
    s = await a.get(r),
    i = t(s);
  return (
    void 0 === i ? await a.delete(r) : await a.put(i, r),
    await n.done,
    !i || (s && s.fid === i.fid) || fidChanged(e, i.fid),
    i
  );
}
async function getInstallationEntry(e) {
  let t;
  const r = await update(e.appConfig, (r) => {
    const n = (function updateOrCreateInstallationEntry(e) {
        return clearTimedOutRequest(
          e || { fid: generateFid(), registrationStatus: 0 }
        );
      })(r),
      a = (function triggerRegistrationIfNecessary(e, t) {
        if (0 === t.registrationStatus) {
          if (!navigator.onLine) {
            return {
              installationEntry: t,
              registrationPromise: Promise.reject(I.create("app-offline")),
            };
          }
          const r = {
              fid: t.fid,
              registrationStatus: 1,
              registrationTime: Date.now(),
            },
            n = (async function registerInstallation(e, t) {
              try {
                const r = await (async function createInstallationRequest(
                  { appConfig: e, heartbeatServiceProvider: t },
                  { fid: r }
                ) {
                  const n = getInstallationsEndpoint(e),
                    a = getHeaders(e),
                    s = t.getImmediate({ optional: !0 });
                  if (s) {
                    const e = await s.getHeartbeatsHeader();
                    e && a.append("x-firebase-client", e);
                  }
                  const i = {
                      fid: r,
                      authVersion: "FIS_v2",
                      appId: e.appId,
                      sdkVersion: "w:0.6.4",
                    },
                    o = { method: "POST", headers: a, body: JSON.stringify(i) },
                    c = await retryIfServerError(() => fetch(n, o));
                  if (c.ok) {
                    const e = await c.json();
                    return {
                      fid: e.fid || r,
                      registrationStatus: 2,
                      refreshToken: e.refreshToken,
                      authToken: extractAuthTokenInfoFromResponse(e.authToken),
                    };
                  }
                  throw await getErrorFromResponse("Create Installation", c);
                })(e, t);
                return set(e.appConfig, r);
              } catch (r) {
                throw (
                  (isServerError(r) && 409 === r.customData.serverCode
                    ? await remove(e.appConfig)
                    : await set(e.appConfig, {
                        fid: t.fid,
                        registrationStatus: 0,
                      }),
                  r)
                );
              }
            })(e, r);
          return { installationEntry: r, registrationPromise: n };
        }
        return 1 === t.registrationStatus
          ? {
              installationEntry: t,
              registrationPromise: waitUntilFidRegistration(e),
            }
          : { installationEntry: t };
      })(e, n);
    return (t = a.registrationPromise), a.installationEntry;
  });
  return "" === r.fid
    ? { installationEntry: await t }
    : { installationEntry: r, registrationPromise: t };
}
async function waitUntilFidRegistration(e) {
  let t = await updateInstallationRequest(e.appConfig);
  for (; 1 === t.registrationStatus; )
    await sleep(100), (t = await updateInstallationRequest(e.appConfig));
  if (0 === t.registrationStatus) {
    const { installationEntry: t, registrationPromise: r } =
      await getInstallationEntry(e);
    return r || t;
  }
  return t;
}
function updateInstallationRequest(e) {
  return update(e, (e) => {
    if (!e) throw I.create("installation-not-found");
    return clearTimedOutRequest(e);
  });
}
function clearTimedOutRequest(e) {
  return (function hasInstallationRequestTimedOut(e) {
    return 1 === e.registrationStatus && e.registrationTime + 1e4 < Date.now();
  })(e)
    ? { fid: e.fid, registrationStatus: 0 }
    : e;
}
async function generateAuthTokenRequest(
  { appConfig: e, heartbeatServiceProvider: t },
  r
) {
  const n = (function getGenerateAuthTokenEndpoint(e, { fid: t }) {
      return `${getInstallationsEndpoint(e)}/${t}/authTokens:generate`;
    })(e, r),
    a = getHeadersWithAuth(e, r),
    s = t.getImmediate({ optional: !0 });
  if (s) {
    const e = await s.getHeartbeatsHeader();
    e && a.append("x-firebase-client", e);
  }
  const i = { installation: { sdkVersion: "w:0.6.4", appId: e.appId } },
    o = { method: "POST", headers: a, body: JSON.stringify(i) },
    c = await retryIfServerError(() => fetch(n, o));
  if (c.ok) {
    return extractAuthTokenInfoFromResponse(await c.json());
  }
  throw await getErrorFromResponse("Generate Auth Token", c);
}
async function refreshAuthToken(e, t = !1) {
  let r;
  const n = await update(e.appConfig, (n) => {
    if (!isEntryRegistered(n)) throw I.create("not-registered");
    const a = n.authToken;
    if (
      !t &&
      (function isAuthTokenValid(e) {
        return (
          2 === e.requestStatus &&
          !(function isAuthTokenExpired(e) {
            const t = Date.now();
            return (
              t < e.creationTime || e.creationTime + e.expiresIn < t + 36e5
            );
          })(e)
        );
      })(a)
    )
      return n;
    if (1 === a.requestStatus)
      return (
        (r = (async function waitUntilAuthTokenRequest(e, t) {
          let r = await updateAuthTokenRequest(e.appConfig);
          for (; 1 === r.authToken.requestStatus; )
            await sleep(100), (r = await updateAuthTokenRequest(e.appConfig));
          const n = r.authToken;
          return 0 === n.requestStatus ? refreshAuthToken(e, t) : n;
        })(e, t)),
        n
      );
    {
      if (!navigator.onLine) throw I.create("app-offline");
      const t = (function makeAuthTokenRequestInProgressEntry(e) {
        const t = { requestStatus: 1, requestTime: Date.now() };
        return Object.assign(Object.assign({}, e), { authToken: t });
      })(n);
      return (
        (r = (async function fetchAuthTokenFromServer(e, t) {
          try {
            const r = await generateAuthTokenRequest(e, t),
              n = Object.assign(Object.assign({}, t), { authToken: r });
            return await set(e.appConfig, n), r;
          } catch (r) {
            if (
              !isServerError(r) ||
              (401 !== r.customData.serverCode &&
                404 !== r.customData.serverCode)
            ) {
              const r = Object.assign(Object.assign({}, t), {
                authToken: { requestStatus: 0 },
              });
              await set(e.appConfig, r);
            } else await remove(e.appConfig);
            throw r;
          }
        })(e, t)),
        t
      );
    }
  });
  return r ? await r : n.authToken;
}
function updateAuthTokenRequest(e) {
  return update(e, (e) => {
    if (!isEntryRegistered(e)) throw I.create("not-registered");
    return (function hasAuthTokenRequestTimedOut(e) {
      return 1 === e.requestStatus && e.requestTime + 1e4 < Date.now();
    })(e.authToken)
      ? Object.assign(Object.assign({}, e), { authToken: { requestStatus: 0 } })
      : e;
  });
}
function isEntryRegistered(e) {
  return void 0 !== e && 2 === e.registrationStatus;
}
async function getToken(e, t = !1) {
  const r = e;
  await (async function completeInstallationRegistration(e) {
    const { registrationPromise: t } = await getInstallationEntry(e);
    t && (await t);
  })(r);
  return (await refreshAuthToken(r, t)).token;
}
function getMissingValueError(e) {
  return I.create("missing-app-config-values", { valueName: e });
}
const publicFactory = (e) => {
    const t = e.getProvider("app").getImmediate(),
      r = (function extractAppConfig(e) {
        if (!e || !e.options) throw getMissingValueError("App Configuration");
        if (!e.name) throw getMissingValueError("App Name");
        const t = ["projectId", "apiKey", "appId"];
        for (const r of t) if (!e.options[r]) throw getMissingValueError(r);
        return {
          appName: e.name,
          projectId: e.options.projectId,
          apiKey: e.options.apiKey,
          appId: e.options.appId,
        };
      })(t);
    return {
      app: t,
      appConfig: r,
      heartbeatServiceProvider: _getProvider(t, "heartbeat"),
      _delete: () => Promise.resolve(),
    };
  },
  internalFactory = (e) => {
    const t = e.getProvider("app").getImmediate(),
      r = _getProvider(t, "installations").getImmediate();
    return {
      getId: () =>
        (async function getId(e) {
          const t = e,
            { installationEntry: r, registrationPromise: n } =
              await getInstallationEntry(t);
          return (
            n
              ? n.catch(console.error)
              : refreshAuthToken(t).catch(console.error),
            r.fid
          );
        })(r),
      getToken: (e) => getToken(r, e),
    };
  };
!(function registerInstallations() {
  t(new Component("installations", publicFactory, "PUBLIC")),
    t(new Component("installations-internal", internalFactory, "PRIVATE"));
})(),
  e(y, "0.6.4"),
  e(y, "0.6.4", "esm2017");
const F = "@firebase/remote-config";
class RemoteConfigAbortSignal {
  constructor() {
    this.listeners = [];
  }
  addEventListener(e) {
    this.listeners.push(e);
  }
  abort() {
    this.listeners.forEach((e) => e());
  }
}
const M = new ErrorFactory("remoteconfig", "Remote Config", {
  "registration-window":
    "Undefined window object. This SDK only supports usage in a browser environment.",
  "registration-project-id":
    "Undefined project identifier. Check Firebase app initialization.",
  "registration-api-key":
    "Undefined API key. Check Firebase app initialization.",
  "registration-app-id":
    "Undefined app identifier. Check Firebase app initialization.",
  "storage-open":
    "Error thrown when opening storage. Original error: {$originalErrorMessage}.",
  "storage-get":
    "Error thrown when reading from storage. Original error: {$originalErrorMessage}.",
  "storage-set":
    "Error thrown when writing to storage. Original error: {$originalErrorMessage}.",
  "storage-delete":
    "Error thrown when deleting from storage. Original error: {$originalErrorMessage}.",
  "fetch-client-network":
    "Fetch client failed to connect to a network. Check Internet connection. Original error: {$originalErrorMessage}.",
  "fetch-timeout":
    'The config fetch request timed out.  Configure timeout using "fetchTimeoutMillis" SDK setting.',
  "fetch-throttle":
    'The config fetch request timed out while in an exponential backoff state. Configure timeout using "fetchTimeoutMillis" SDK setting. Unix timestamp in milliseconds when fetch request throttling ends: {$throttleEndTimeMillis}.',
  "fetch-client-parse":
    "Fetch client could not parse response. Original error: {$originalErrorMessage}.",
  "fetch-status":
    "Fetch server returned an HTTP error status. HTTP status: {$httpStatus}.",
  "indexed-db-unavailable": "Indexed DB is not supported by current browser",
});
const k = ["1", "true", "t", "yes", "y", "on"];
class Value {
  constructor(e, t = "") {
    (this._source = e), (this._value = t);
  }
  asString() {
    return this._value;
  }
  asBoolean() {
    return (
      "static" !== this._source && k.indexOf(this._value.toLowerCase()) >= 0
    );
  }
  asNumber() {
    if ("static" === this._source) return 0;
    let e = Number(this._value);
    return isNaN(e) && (e = 0), e;
  }
  getSource() {
    return this._source;
  }
}
function getRemoteConfig(e = r()) {
  e = getModularInstance(e);
  return _getProvider(e, "remote-config").getImmediate();
}
async function activate(e) {
  const t = getModularInstance(e),
    [r, n] = await Promise.all([
      t._storage.getLastSuccessfulFetchResponse(),
      t._storage.getActiveConfigEtag(),
    ]);
  return (
    !!(r && r.config && r.eTag && r.eTag !== n) &&
    (await Promise.all([
      t._storageCache.setActiveConfig(r.config),
      t._storage.setActiveConfigEtag(r.eTag),
    ]),
    !0)
  );
}
function ensureInitialized(e) {
  const t = getModularInstance(e);
  return (
    t._initializePromise ||
      (t._initializePromise = t._storageCache.loadFromStorage().then(() => {
        t._isInitializationComplete = !0;
      })),
    t._initializePromise
  );
}
async function fetchConfig(e) {
  const t = getModularInstance(e),
    r = new RemoteConfigAbortSignal();
  setTimeout(async () => {
    r.abort();
  }, t.settings.fetchTimeoutMillis);
  try {
    await t._client.fetch({
      cacheMaxAgeMillis: t.settings.minimumFetchIntervalMillis,
      signal: r,
    }),
      await t._storageCache.setLastFetchStatus("success");
  } catch (e) {
    const r = (function hasErrorCode(e, t) {
      return e instanceof FirebaseError && -1 !== e.code.indexOf(t);
    })(e, "fetch-throttle")
      ? "throttle"
      : "failure";
    throw (await t._storageCache.setLastFetchStatus(r), e);
  }
}
function getAll(e) {
  const t = getModularInstance(e);
  return (function getAllKeys(e = {}, t = {}) {
    return Object.keys(Object.assign(Object.assign({}, e), t));
  })(t._storageCache.getActiveConfig(), t.defaultConfig).reduce(
    (t, r) => ((t[r] = getValue(e, r)), t),
    {}
  );
}
function getBoolean(e, t) {
  return getValue(getModularInstance(e), t).asBoolean();
}
function getNumber(e, t) {
  return getValue(getModularInstance(e), t).asNumber();
}
function getString(e, t) {
  return getValue(getModularInstance(e), t).asString();
}
function getValue(e, t) {
  const r = getModularInstance(e);
  r._isInitializationComplete ||
    r._logger.debug(
      `A value was requested for key "${t}" before SDK initialization completed. Await on ensureInitialized if the intent was to get a previously activated value.`
    );
  const n = r._storageCache.getActiveConfig();
  return n && void 0 !== n[t]
    ? new Value("remote", n[t])
    : r.defaultConfig && void 0 !== r.defaultConfig[t]
    ? new Value("default", String(r.defaultConfig[t]))
    : (r._logger.debug(
        `Returning static value for key "${t}". Define a default or remote value if this is unintentional.`
      ),
      new Value("static"));
}
function setLogLevel(e, t) {
  const r = getModularInstance(e);
  switch (t) {
    case "debug":
      r._logger.logLevel = s.DEBUG;
      break;
    case "silent":
      r._logger.logLevel = s.SILENT;
      break;
    default:
      r._logger.logLevel = s.ERROR;
  }
}
class CachingClient {
  constructor(e, t, r, n) {
    (this.client = e),
      (this.storage = t),
      (this.storageCache = r),
      (this.logger = n);
  }
  isCachedDataFresh(e, t) {
    if (!t)
      return (
        this.logger.debug("Config fetch cache check. Cache unpopulated."), !1
      );
    const r = Date.now() - t,
      n = r <= e;
    return (
      this.logger.debug(
        `Config fetch cache check. Cache age millis: ${r}. Cache max age millis (minimumFetchIntervalMillis setting): ${e}. Is cache hit: ${n}.`
      ),
      n
    );
  }
  async fetch(e) {
    const [t, r] = await Promise.all([
      this.storage.getLastSuccessfulFetchTimestampMillis(),
      this.storage.getLastSuccessfulFetchResponse(),
    ]);
    if (r && this.isCachedDataFresh(e.cacheMaxAgeMillis, t)) return r;
    e.eTag = r && r.eTag;
    const n = await this.client.fetch(e),
      a = [this.storageCache.setLastSuccessfulFetchTimestampMillis(Date.now())];
    return (
      200 === n.status &&
        a.push(this.storage.setLastSuccessfulFetchResponse(n)),
      await Promise.all(a),
      n
    );
  }
}
function getUserLanguage(e = navigator) {
  return (e.languages && e.languages[0]) || e.language;
}
class RestClient {
  constructor(e, t, r, n, a, s) {
    (this.firebaseInstallations = e),
      (this.sdkVersion = t),
      (this.namespace = r),
      (this.projectId = n),
      (this.apiKey = a),
      (this.appId = s);
  }
  async fetch(e) {
    const [t, r] = await Promise.all([
        this.firebaseInstallations.getId(),
        this.firebaseInstallations.getToken(),
      ]),
      n = `${
        window.FIREBASE_REMOTE_CONFIG_URL_BASE ||
        "https://firebaseremoteconfig.googleapis.com"
      }/v1/projects/${this.projectId}/namespaces/${this.namespace}:fetch?key=${
        this.apiKey
      }`,
      a = {
        "Content-Type": "application/json",
        "Content-Encoding": "gzip",
        "If-None-Match": e.eTag || "*",
      },
      s = {
        sdk_version: this.sdkVersion,
        app_instance_id: t,
        app_instance_id_token: r,
        app_id: this.appId,
        language_code: getUserLanguage(),
      },
      i = { method: "POST", headers: a, body: JSON.stringify(s) },
      o = fetch(n, i),
      c = new Promise((t, r) => {
        e.signal.addEventListener(() => {
          const e = new Error("The operation was aborted.");
          (e.name = "AbortError"), r(e);
        });
      });
    let l;
    try {
      await Promise.race([o, c]), (l = await o);
    } catch (e) {
      let t = "fetch-client-network";
      throw (
        ("AbortError" === (null == e ? void 0 : e.name) &&
          (t = "fetch-timeout"),
        M.create(t, { originalErrorMessage: null == e ? void 0 : e.message }))
      );
    }
    let u = l.status;
    const g = l.headers.get("ETag") || void 0;
    let h, d;
    if (200 === l.status) {
      let e;
      try {
        e = await l.json();
      } catch (e) {
        throw M.create("fetch-client-parse", {
          originalErrorMessage: null == e ? void 0 : e.message,
        });
      }
      (h = e.entries), (d = e.state);
    }
    if (
      ("INSTANCE_STATE_UNSPECIFIED" === d
        ? (u = 500)
        : "NO_CHANGE" === d
        ? (u = 304)
        : ("NO_TEMPLATE" !== d && "EMPTY_CONFIG" !== d) || (h = {}),
      304 !== u && 200 !== u)
    )
      throw M.create("fetch-status", { httpStatus: u });
    return { status: u, eTag: g, config: h };
  }
}
class RetryingClient {
  constructor(e, t) {
    (this.client = e), (this.storage = t);
  }
  async fetch(e) {
    const t = (await this.storage.getThrottleMetadata()) || {
      backoffCount: 0,
      throttleEndTimeMillis: Date.now(),
    };
    return this.attemptFetch(e, t);
  }
  async attemptFetch(e, { throttleEndTimeMillis: t, backoffCount: r }) {
    await (function setAbortableTimeout(e, t) {
      return new Promise((r, n) => {
        const a = Math.max(t - Date.now(), 0),
          s = setTimeout(r, a);
        e.addEventListener(() => {
          clearTimeout(s),
            n(M.create("fetch-throttle", { throttleEndTimeMillis: t }));
        });
      });
    })(e.signal, t);
    try {
      const t = await this.client.fetch(e);
      return await this.storage.deleteThrottleMetadata(), t;
    } catch (t) {
      if (
        !(function isRetriableError(e) {
          if (!(e instanceof FirebaseError && e.customData)) return !1;
          const t = Number(e.customData.httpStatus);
          return 429 === t || 500 === t || 503 === t || 504 === t;
        })(t)
      )
        throw t;
      const n = {
        throttleEndTimeMillis: Date.now() + calculateBackoffMillis(r),
        backoffCount: r + 1,
      };
      return await this.storage.setThrottleMetadata(n), this.attemptFetch(e, n);
    }
  }
}
class RemoteConfig {
  constructor(e, t, r, n, a) {
    (this.app = e),
      (this._client = t),
      (this._storageCache = r),
      (this._storage = n),
      (this._logger = a),
      (this._isInitializationComplete = !1),
      (this.settings = {
        fetchTimeoutMillis: 6e4,
        minimumFetchIntervalMillis: 432e5,
      }),
      (this.defaultConfig = {});
  }
  get fetchTimeMillis() {
    return this._storageCache.getLastSuccessfulFetchTimestampMillis() || -1;
  }
  get lastFetchStatus() {
    return this._storageCache.getLastFetchStatus() || "no-fetch-yet";
  }
}
function toFirebaseError(e, t) {
  const r = e.target.error || void 0;
  return M.create(t, {
    originalErrorMessage: r && (null == r ? void 0 : r.message),
  });
}
class Storage {
  constructor(
    e,
    t,
    r,
    n = (function openDatabase() {
      return new Promise((e, t) => {
        try {
          const r = indexedDB.open("firebase_remote_config", 1);
          (r.onerror = (e) => {
            t(toFirebaseError(e, "storage-open"));
          }),
            (r.onsuccess = (t) => {
              e(t.target.result);
            }),
            (r.onupgradeneeded = (e) => {
              const t = e.target.result;
              0 === e.oldVersion &&
                t.createObjectStore("app_namespace_store", {
                  keyPath: "compositeKey",
                });
            });
        } catch (e) {
          t(
            M.create("storage-open", {
              originalErrorMessage: null == e ? void 0 : e.message,
            })
          );
        }
      });
    })()
  ) {
    (this.appId = e),
      (this.appName = t),
      (this.namespace = r),
      (this.openDbPromise = n);
  }
  getLastFetchStatus() {
    return this.get("last_fetch_status");
  }
  setLastFetchStatus(e) {
    return this.set("last_fetch_status", e);
  }
  getLastSuccessfulFetchTimestampMillis() {
    return this.get("last_successful_fetch_timestamp_millis");
  }
  setLastSuccessfulFetchTimestampMillis(e) {
    return this.set("last_successful_fetch_timestamp_millis", e);
  }
  getLastSuccessfulFetchResponse() {
    return this.get("last_successful_fetch_response");
  }
  setLastSuccessfulFetchResponse(e) {
    return this.set("last_successful_fetch_response", e);
  }
  getActiveConfig() {
    return this.get("active_config");
  }
  setActiveConfig(e) {
    return this.set("active_config", e);
  }
  getActiveConfigEtag() {
    return this.get("active_config_etag");
  }
  setActiveConfigEtag(e) {
    return this.set("active_config_etag", e);
  }
  getThrottleMetadata() {
    return this.get("throttle_metadata");
  }
  setThrottleMetadata(e) {
    return this.set("throttle_metadata", e);
  }
  deleteThrottleMetadata() {
    return this.delete("throttle_metadata");
  }
  async get(e) {
    const t = await this.openDbPromise;
    return new Promise((r, n) => {
      const a = t
          .transaction(["app_namespace_store"], "readonly")
          .objectStore("app_namespace_store"),
        s = this.createCompositeKey(e);
      try {
        const e = a.get(s);
        (e.onerror = (e) => {
          n(toFirebaseError(e, "storage-get"));
        }),
          (e.onsuccess = (e) => {
            const t = e.target.result;
            r(t ? t.value : void 0);
          });
      } catch (e) {
        n(
          M.create("storage-get", {
            originalErrorMessage: null == e ? void 0 : e.message,
          })
        );
      }
    });
  }
  async set(e, t) {
    const r = await this.openDbPromise;
    return new Promise((n, a) => {
      const s = r
          .transaction(["app_namespace_store"], "readwrite")
          .objectStore("app_namespace_store"),
        i = this.createCompositeKey(e);
      try {
        const e = s.put({ compositeKey: i, value: t });
        (e.onerror = (e) => {
          a(toFirebaseError(e, "storage-set"));
        }),
          (e.onsuccess = () => {
            n();
          });
      } catch (e) {
        a(
          M.create("storage-set", {
            originalErrorMessage: null == e ? void 0 : e.message,
          })
        );
      }
    });
  }
  async delete(e) {
    const t = await this.openDbPromise;
    return new Promise((r, n) => {
      const a = t
          .transaction(["app_namespace_store"], "readwrite")
          .objectStore("app_namespace_store"),
        s = this.createCompositeKey(e);
      try {
        const e = a.delete(s);
        (e.onerror = (e) => {
          n(toFirebaseError(e, "storage-delete"));
        }),
          (e.onsuccess = () => {
            r();
          });
      } catch (e) {
        n(
          M.create("storage-delete", {
            originalErrorMessage: null == e ? void 0 : e.message,
          })
        );
      }
    });
  }
  createCompositeKey(e) {
    return [this.appId, this.appName, this.namespace, e].join();
  }
}
class StorageCache {
  constructor(e) {
    this.storage = e;
  }
  getLastFetchStatus() {
    return this.lastFetchStatus;
  }
  getLastSuccessfulFetchTimestampMillis() {
    return this.lastSuccessfulFetchTimestampMillis;
  }
  getActiveConfig() {
    return this.activeConfig;
  }
  async loadFromStorage() {
    const e = this.storage.getLastFetchStatus(),
      t = this.storage.getLastSuccessfulFetchTimestampMillis(),
      r = this.storage.getActiveConfig(),
      n = await e;
    n && (this.lastFetchStatus = n);
    const a = await t;
    a && (this.lastSuccessfulFetchTimestampMillis = a);
    const s = await r;
    s && (this.activeConfig = s);
  }
  setLastFetchStatus(e) {
    return (this.lastFetchStatus = e), this.storage.setLastFetchStatus(e);
  }
  setLastSuccessfulFetchTimestampMillis(e) {
    return (
      (this.lastSuccessfulFetchTimestampMillis = e),
      this.storage.setLastSuccessfulFetchTimestampMillis(e)
    );
  }
  setActiveConfig(e) {
    return (this.activeConfig = e), this.storage.setActiveConfig(e);
  }
}
async function fetchAndActivate(e) {
  return (e = getModularInstance(e)), await fetchConfig(e), activate(e);
}
async function isSupported() {
  if (!isIndexedDBAvailable()) return !1;
  try {
    return await (function validateIndexedDBOpenable() {
      return new Promise((e, t) => {
        try {
          let r = !0;
          const n = "validate-browser-context-for-indexeddb-analytics-module",
            a = self.indexedDB.open(n);
          (a.onsuccess = () => {
            a.result.close(), r || self.indexedDB.deleteDatabase(n), e(!0);
          }),
            (a.onupgradeneeded = () => {
              r = !1;
            }),
            (a.onerror = () => {
              var e;
              t(
                (null === (e = a.error) || void 0 === e ? void 0 : e.message) ||
                  ""
              );
            });
        } catch (e) {
          t(e);
        }
      });
    })();
  } catch (e) {
    return !1;
  }
}
!(function registerRemoteConfig() {
  t(
    new Component(
      "remote-config",
      function remoteConfigFactory(e, { instanceIdentifier: t }) {
        const r = e.getProvider("app").getImmediate(),
          a = e.getProvider("installations-internal").getImmediate();
        if ("undefined" == typeof window) throw M.create("registration-window");
        if (!isIndexedDBAvailable()) throw M.create("indexed-db-unavailable");
        const { projectId: i, apiKey: o, appId: c } = r.options;
        if (!i) throw M.create("registration-project-id");
        if (!o) throw M.create("registration-api-key");
        if (!c) throw M.create("registration-app-id");
        t = t || "firebase";
        const l = new Storage(c, r.name, t),
          u = new StorageCache(l),
          g = new Logger(F);
        g.logLevel = s.ERROR;
        const h = new RestClient(a, n, t, i, o, c),
          d = new RetryingClient(h, l),
          f = new CachingClient(d, l, u, g),
          p = new RemoteConfig(r, f, u, l, g);
        return ensureInitialized(p), p;
      },
      "PUBLIC"
    ).setMultipleInstances(!0)
  ),
    e(F, "0.4.4"),
    e(F, "0.4.4", "esm2017");
})();
export {
  activate,
  ensureInitialized,
  fetchAndActivate,
  fetchConfig,
  getAll,
  getBoolean,
  getNumber,
  getRemoteConfig,
  getString,
  getValue,
  isSupported,
  setLogLevel,
};

//# sourceMappingURL=firebase-remote-config.js.map
