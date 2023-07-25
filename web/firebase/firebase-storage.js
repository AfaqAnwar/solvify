import {
  _getProvider,
  getApp as e,
  _registerComponent as t,
  registerVersion as r,
  SDK_VERSION as n,
} from "./firebase/firebase-app.js";
const stringToByteArray$1 = function (e) {
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
        ? ((o = 65536 + ((1023 & o) << 10) + (1023 & e.charCodeAt(++n))),
          (t[r++] = (o >> 18) | 240),
          (t[r++] = ((o >> 12) & 63) | 128),
          (t[r++] = ((o >> 6) & 63) | 128),
          (t[r++] = (63 & o) | 128))
        : ((t[r++] = (o >> 12) | 224),
          (t[r++] = ((o >> 6) & 63) | 128),
          (t[r++] = (63 & o) | 128));
    }
    return t;
  },
  o = {
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
          s = t + 1 < e.length,
          i = s ? e[t + 1] : 0,
          a = t + 2 < e.length,
          l = a ? e[t + 2] : 0,
          c = o >> 2,
          u = ((3 & o) << 4) | (i >> 4);
        let h = ((15 & i) << 2) | (l >> 6),
          d = 63 & l;
        a || ((d = 64), s || (h = 64)), n.push(r[c], r[u], r[h], r[d]);
      }
      return n.join("");
    },
    encodeString(e, t) {
      return this.HAS_NATIVE_SUPPORT && !t
        ? btoa(e)
        : this.encodeByteArray(stringToByteArray$1(e), t);
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
                const s = e[r++];
                t[n++] = String.fromCharCode(((31 & o) << 6) | (63 & s));
              } else if (o > 239 && o < 365) {
                const s =
                  (((7 & o) << 18) |
                    ((63 & e[r++]) << 12) |
                    ((63 & e[r++]) << 6) |
                    (63 & e[r++])) -
                  65536;
                (t[n++] = String.fromCharCode(55296 + (s >> 10))),
                  (t[n++] = String.fromCharCode(56320 + (1023 & s)));
              } else {
                const s = e[r++],
                  i = e[r++];
                t[n++] = String.fromCharCode(
                  ((15 & o) << 12) | ((63 & s) << 6) | (63 & i)
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
          s = t < e.length ? r[e.charAt(t)] : 0;
        ++t;
        const i = t < e.length ? r[e.charAt(t)] : 64;
        ++t;
        const a = t < e.length ? r[e.charAt(t)] : 64;
        if ((++t, null == o || null == s || null == i || null == a))
          throw new DecodeBase64StringError();
        const l = (o << 2) | (s >> 4);
        if ((n.push(l), 64 !== i)) {
          const e = ((s << 4) & 240) | (i >> 2);
          if ((n.push(e), 64 !== a)) {
            const e = ((i << 6) & 192) | a;
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
            (this.byteToCharMapWebSafe_[e] =
              this.ENCODED_VALS_WEBSAFE.charAt(e)),
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
const base64urlEncodeWithoutPadding = function (e) {
  return (function (e) {
    const t = stringToByteArray$1(e);
    return o.encodeByteArray(t, !0);
  })(e).replace(/\./g, "");
};
const getDefaultsFromGlobal = () =>
    (function getGlobal() {
      if ("undefined" != typeof self) return self;
      if ("undefined" != typeof window) return window;
      if ("undefined" != typeof global) return global;
      throw new Error("Unable to locate global object.");
    })().__FIREBASE_DEFAULTS__,
  getDefaultsFromCookie = () => {
    if ("undefined" == typeof document) return;
    let e;
    try {
      e = document.cookie.match(/__FIREBASE_DEFAULTS__=([^;]+)/);
    } catch (e) {
      return;
    }
    const t =
      e &&
      (function (e) {
        try {
          return o.decodeString(e, !0);
        } catch (e) {
          console.error("base64Decode failed: ", e);
        }
        return null;
      })(e[1]);
    return t && JSON.parse(t);
  },
  getDefaults = () => {
    try {
      return (
        getDefaultsFromGlobal() ||
        (() => {
          if ("undefined" == typeof process || void 0 === process.env) return;
          const e = process.env.__FIREBASE_DEFAULTS__;
          return e ? JSON.parse(e) : void 0;
        })() ||
        getDefaultsFromCookie()
      );
    } catch (e) {
      return void console.info(
        `Unable to get __FIREBASE_DEFAULTS__ due to: ${e}`
      );
    }
  },
  getDefaultEmulatorHostnameAndPort = (e) => {
    const t = ((e) => {
      var t, r;
      return null ===
        (r =
          null === (t = getDefaults()) || void 0 === t
            ? void 0
            : t.emulatorHosts) || void 0 === r
        ? void 0
        : r[e];
    })(e);
    if (!t) return;
    const r = t.lastIndexOf(":");
    if (r <= 0 || r + 1 === t.length)
      throw new Error(`Invalid host ${t} with no separate hostname and port!`);
    const n = parseInt(t.substring(r + 1), 10);
    return "[" === t[0] ? [t.substring(1, r - 1), n] : [t.substring(0, r), n];
  };
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
      o = this.errors[e],
      i = o
        ? (function replaceTemplate(e, t) {
            return e.replace(s, (e, r) => {
              const n = t[r];
              return null != n ? String(n) : `<${r}?>`;
            });
          })(o, r)
        : "Error",
      a = `${this.serviceName}: ${i} (${n}).`;
    return new FirebaseError(n, a, r);
  }
}
const s = /\{\$([^}]+)}/g;
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
class StorageError extends FirebaseError {
  constructor(e, t, r = 0) {
    super(prependCode(e), `Firebase Storage: ${t} (${prependCode(e)})`),
      (this.status_ = r),
      (this.customData = { serverResponse: null }),
      (this._baseMessage = this.message),
      Object.setPrototypeOf(this, StorageError.prototype);
  }
  get status() {
    return this.status_;
  }
  set status(e) {
    this.status_ = e;
  }
  _codeEquals(e) {
    return prependCode(e) === this.code;
  }
  get serverResponse() {
    return this.customData.serverResponse;
  }
  set serverResponse(e) {
    (this.customData.serverResponse = e),
      this.customData.serverResponse
        ? (this.message = `${this._baseMessage}\n${this.customData.serverResponse}`)
        : (this.message = this._baseMessage);
  }
}
var i, a;
function prependCode(e) {
  return "storage/" + e;
}
function unknown() {
  return new StorageError(
    i.UNKNOWN,
    "An unknown error occurred, please check the error payload for server response."
  );
}
function retryLimitExceeded() {
  return new StorageError(
    i.RETRY_LIMIT_EXCEEDED,
    "Max retry time for operation exceeded, please try again."
  );
}
function canceled() {
  return new StorageError(i.CANCELED, "User canceled the upload/download.");
}
function cannotSliceBlob() {
  return new StorageError(
    i.CANNOT_SLICE_BLOB,
    "Cannot slice blob for upload. Please retry the upload."
  );
}
function invalidArgument(e) {
  return new StorageError(i.INVALID_ARGUMENT, e);
}
function appDeleted() {
  return new StorageError(i.APP_DELETED, "The Firebase app was deleted.");
}
function invalidRootOperation(e) {
  return new StorageError(
    i.INVALID_ROOT_OPERATION,
    "The operation '" +
      e +
      "' cannot be performed on a root reference, create a non-root reference using child, such as .child('file.png')."
  );
}
function invalidFormat(e, t) {
  return new StorageError(
    i.INVALID_FORMAT,
    "String does not match format '" + e + "': " + t
  );
}
function internalError(e) {
  throw new StorageError(i.INTERNAL_ERROR, "Internal error: " + e);
}
!(function (e) {
  (e.UNKNOWN = "unknown"),
    (e.OBJECT_NOT_FOUND = "object-not-found"),
    (e.BUCKET_NOT_FOUND = "bucket-not-found"),
    (e.PROJECT_NOT_FOUND = "project-not-found"),
    (e.QUOTA_EXCEEDED = "quota-exceeded"),
    (e.UNAUTHENTICATED = "unauthenticated"),
    (e.UNAUTHORIZED = "unauthorized"),
    (e.UNAUTHORIZED_APP = "unauthorized-app"),
    (e.RETRY_LIMIT_EXCEEDED = "retry-limit-exceeded"),
    (e.INVALID_CHECKSUM = "invalid-checksum"),
    (e.CANCELED = "canceled"),
    (e.INVALID_EVENT_NAME = "invalid-event-name"),
    (e.INVALID_URL = "invalid-url"),
    (e.INVALID_DEFAULT_BUCKET = "invalid-default-bucket"),
    (e.NO_DEFAULT_BUCKET = "no-default-bucket"),
    (e.CANNOT_SLICE_BLOB = "cannot-slice-blob"),
    (e.SERVER_FILE_WRONG_SIZE = "server-file-wrong-size"),
    (e.NO_DOWNLOAD_URL = "no-download-url"),
    (e.INVALID_ARGUMENT = "invalid-argument"),
    (e.INVALID_ARGUMENT_COUNT = "invalid-argument-count"),
    (e.APP_DELETED = "app-deleted"),
    (e.INVALID_ROOT_OPERATION = "invalid-root-operation"),
    (e.INVALID_FORMAT = "invalid-format"),
    (e.INTERNAL_ERROR = "internal-error"),
    (e.UNSUPPORTED_ENVIRONMENT = "unsupported-environment");
})(i || (i = {}));
class Location {
  constructor(e, t) {
    (this.bucket = e), (this.path_ = t);
  }
  get path() {
    return this.path_;
  }
  get isRoot() {
    return 0 === this.path.length;
  }
  fullServerUrl() {
    const e = encodeURIComponent;
    return "/b/" + e(this.bucket) + "/o/" + e(this.path);
  }
  bucketOnlyServerUrl() {
    return "/b/" + encodeURIComponent(this.bucket) + "/o";
  }
  static makeFromBucketSpec(e, t) {
    let r;
    try {
      r = Location.makeFromUrl(e, t);
    } catch (t) {
      return new Location(e, "");
    }
    if ("" === r.path) return r;
    throw (function invalidDefaultBucket(e) {
      return new StorageError(
        i.INVALID_DEFAULT_BUCKET,
        "Invalid default bucket '" + e + "'."
      );
    })(e);
  }
  static makeFromUrl(e, t) {
    let r = null;
    const n = "([A-Za-z0-9.\\-_]+)";
    const o = new RegExp("^gs://" + n + "(/(.*))?$", "i");
    function httpModify(e) {
      e.path_ = decodeURIComponent(e.path);
    }
    const s = t.replace(/[.]/g, "\\."),
      a = [
        {
          regex: o,
          indices: { bucket: 1, path: 3 },
          postModify: function gsModify(e) {
            "/" === e.path.charAt(e.path.length - 1) &&
              (e.path_ = e.path_.slice(0, -1));
          },
        },
        {
          regex: new RegExp(
            `^https?://${s}/v[A-Za-z0-9_]+/b/${n}/o(/([^?#]*).*)?$`,
            "i"
          ),
          indices: { bucket: 1, path: 3 },
          postModify: httpModify,
        },
        {
          regex: new RegExp(
            `^https?://${
              "firebasestorage.googleapis.com" === t
                ? "(?:storage.googleapis.com|storage.cloud.google.com)"
                : t
            }/${n}/([^?#]*)`,
            "i"
          ),
          indices: { bucket: 1, path: 2 },
          postModify: httpModify,
        },
      ];
    for (let t = 0; t < a.length; t++) {
      const n = a[t],
        o = n.regex.exec(e);
      if (o) {
        const e = o[n.indices.bucket];
        let t = o[n.indices.path];
        t || (t = ""), (r = new Location(e, t)), n.postModify(r);
        break;
      }
    }
    if (null == r)
      throw (function invalidUrl(e) {
        return new StorageError(i.INVALID_URL, "Invalid URL '" + e + "'.");
      })(e);
    return r;
  }
}
class FailRequest {
  constructor(e) {
    this.promise_ = Promise.reject(e);
  }
  getPromise() {
    return this.promise_;
  }
  cancel(e = !1) {}
}
function isString(e) {
  return "string" == typeof e || e instanceof String;
}
function isNativeBlob(e) {
  return isNativeBlobDefined() && e instanceof Blob;
}
function isNativeBlobDefined() {
  return (
    "undefined" != typeof Blob &&
    !(function isNode() {
      var e;
      const t =
        null === (e = getDefaults()) || void 0 === e
          ? void 0
          : e.forceEnvironment;
      if ("node" === t) return !0;
      if ("browser" === t) return !1;
      try {
        return (
          "[object process]" === Object.prototype.toString.call(global.process)
        );
      } catch (e) {
        return !1;
      }
    })()
  );
}
function validateNumber(e, t, r, n) {
  if (n < t)
    throw invalidArgument(
      `Invalid value for '${e}'. Expected ${t} or greater.`
    );
  if (n > r)
    throw invalidArgument(`Invalid value for '${e}'. Expected ${r} or less.`);
}
function makeUrl(e, t, r) {
  let n = t;
  return null == r && (n = `https://${t}`), `${r}://${n}/v0${e}`;
}
function makeQueryString(e) {
  const t = encodeURIComponent;
  let r = "?";
  for (const n in e)
    if (e.hasOwnProperty(n)) {
      r = r + (t(n) + "=" + t(e[n])) + "&";
    }
  return (r = r.slice(0, -1)), r;
}
function isRetryStatusCode(e, t) {
  const r = e >= 500 && e < 600,
    n = -1 !== [408, 429].indexOf(e),
    o = -1 !== t.indexOf(e);
  return r || n || o;
}
!(function (e) {
  (e[(e.NO_ERROR = 0)] = "NO_ERROR"),
    (e[(e.NETWORK_ERROR = 1)] = "NETWORK_ERROR"),
    (e[(e.ABORT = 2)] = "ABORT");
})(a || (a = {}));
class NetworkRequest {
  constructor(e, t, r, n, o, s, i, a, l, c, u, h = !0) {
    (this.url_ = e),
      (this.method_ = t),
      (this.headers_ = r),
      (this.body_ = n),
      (this.successCodes_ = o),
      (this.additionalRetryCodes_ = s),
      (this.callback_ = i),
      (this.errorCallback_ = a),
      (this.timeout_ = l),
      (this.progressCallback_ = c),
      (this.connectionFactory_ = u),
      (this.retry = h),
      (this.pendingConnection_ = null),
      (this.backoffId_ = null),
      (this.canceled_ = !1),
      (this.appDelete_ = !1),
      (this.promise_ = new Promise((e, t) => {
        (this.resolve_ = e), (this.reject_ = t), this.start_();
      }));
  }
  start_() {
    const doTheRequest = (e, t) => {
        if (t) return void e(!1, new RequestEndStatus(!1, null, !0));
        const r = this.connectionFactory_();
        this.pendingConnection_ = r;
        const progressListener = (e) => {
          const t = e.loaded,
            r = e.lengthComputable ? e.total : -1;
          null !== this.progressCallback_ && this.progressCallback_(t, r);
        };
        null !== this.progressCallback_ &&
          r.addUploadProgressListener(progressListener),
          r
            .send(this.url_, this.method_, this.body_, this.headers_)
            .then(() => {
              null !== this.progressCallback_ &&
                r.removeUploadProgressListener(progressListener),
                (this.pendingConnection_ = null);
              const t = r.getErrorCode() === a.NO_ERROR,
                n = r.getStatus();
              if (
                !t ||
                (isRetryStatusCode(n, this.additionalRetryCodes_) && this.retry)
              ) {
                const t = r.getErrorCode() === a.ABORT;
                return void e(!1, new RequestEndStatus(!1, null, t));
              }
              const o = -1 !== this.successCodes_.indexOf(n);
              e(!0, new RequestEndStatus(o, r));
            });
      },
      backoffDone = (e, t) => {
        const r = this.resolve_,
          n = this.reject_,
          o = t.connection;
        if (t.wasSuccessCode)
          try {
            const e = this.callback_(o, o.getResponse());
            !(function isJustDef(e) {
              return void 0 !== e;
            })(e)
              ? r()
              : r(e);
          } catch (e) {
            n(e);
          }
        else if (null !== o) {
          const e = unknown();
          (e.serverResponse = o.getErrorText()),
            this.errorCallback_ ? n(this.errorCallback_(o, e)) : n(e);
        } else if (t.canceled) {
          n(this.appDelete_ ? appDeleted() : canceled());
        } else {
          n(retryLimitExceeded());
        }
      };
    this.canceled_
      ? backoffDone(0, new RequestEndStatus(!1, null, !0))
      : (this.backoffId_ = (function start(e, t, r) {
          let n = 1,
            o = null,
            s = null,
            i = !1,
            a = 0;
          function canceled() {
            return 2 === a;
          }
          let l = !1;
          function triggerCallback(...e) {
            l || ((l = !0), t.apply(null, e));
          }
          function callWithDelay(t) {
            o = setTimeout(() => {
              (o = null), e(responseHandler, canceled());
            }, t);
          }
          function clearGlobalTimeout() {
            s && clearTimeout(s);
          }
          function responseHandler(e, ...t) {
            if (l) return void clearGlobalTimeout();
            if (e)
              return (
                clearGlobalTimeout(), void triggerCallback.call(null, e, ...t)
              );
            if (canceled() || i)
              return (
                clearGlobalTimeout(), void triggerCallback.call(null, e, ...t)
              );
            let r;
            n < 64 && (n *= 2),
              1 === a ? ((a = 2), (r = 0)) : (r = 1e3 * (n + Math.random())),
              callWithDelay(r);
          }
          let c = !1;
          function stop(e) {
            c ||
              ((c = !0),
              clearGlobalTimeout(),
              l ||
                (null !== o
                  ? (e || (a = 2), clearTimeout(o), callWithDelay(0))
                  : e || (a = 1)));
          }
          return (
            callWithDelay(0),
            (s = setTimeout(() => {
              (i = !0), stop(!0);
            }, r)),
            stop
          );
        })(doTheRequest, backoffDone, this.timeout_));
  }
  getPromise() {
    return this.promise_;
  }
  cancel(e) {
    (this.canceled_ = !0),
      (this.appDelete_ = e || !1),
      null !== this.backoffId_ &&
        (function stop(e) {
          e(!1);
        })(this.backoffId_),
      null !== this.pendingConnection_ && this.pendingConnection_.abort();
  }
}
class RequestEndStatus {
  constructor(e, t, r) {
    (this.wasSuccessCode = e), (this.connection = t), (this.canceled = !!r);
  }
}
function getBlobBuilder() {
  return "undefined" != typeof BlobBuilder
    ? BlobBuilder
    : "undefined" != typeof WebKitBlobBuilder
    ? WebKitBlobBuilder
    : void 0;
}
function getBlob$1(...e) {
  const t = getBlobBuilder();
  if (void 0 !== t) {
    const r = new t();
    for (let t = 0; t < e.length; t++) r.append(e[t]);
    return r.getBlob();
  }
  if (isNativeBlobDefined()) return new Blob(e);
  throw new StorageError(
    i.UNSUPPORTED_ENVIRONMENT,
    "This browser doesn't seem to support creating Blobs"
  );
}
function decodeBase64(e) {
  if ("undefined" == typeof atob)
    throw (function missingPolyFill(e) {
      return new StorageError(
        i.UNSUPPORTED_ENVIRONMENT,
        `${e} is missing. Make sure to install the required polyfills. See https://firebase.google.com/docs/web/environments-js-sdk#polyfills for more information.`
      );
    })("base-64");
  return atob(e);
}
const l = {
  RAW: "raw",
  BASE64: "base64",
  BASE64URL: "base64url",
  DATA_URL: "data_url",
};
class StringData {
  constructor(e, t) {
    (this.data = e), (this.contentType = t || null);
  }
}
function dataFromString(e, t) {
  switch (e) {
    case l.RAW:
      return new StringData(utf8Bytes_(t));
    case l.BASE64:
    case l.BASE64URL:
      return new StringData(base64Bytes_(e, t));
    case l.DATA_URL:
      return new StringData(
        (function dataURLBytes_(e) {
          const t = new DataURLParts(e);
          return t.base64
            ? base64Bytes_(l.BASE64, t.rest)
            : (function percentEncodedBytes_(e) {
                let t;
                try {
                  t = decodeURIComponent(e);
                } catch (e) {
                  throw invalidFormat(l.DATA_URL, "Malformed data URL.");
                }
                return utf8Bytes_(t);
              })(t.rest);
        })(t),
        (function dataURLContentType_(e) {
          return new DataURLParts(e).contentType;
        })(t)
      );
  }
  throw unknown();
}
function utf8Bytes_(e) {
  const t = [];
  for (let r = 0; r < e.length; r++) {
    let n = e.charCodeAt(r);
    if (n <= 127) t.push(n);
    else if (n <= 2047) t.push(192 | (n >> 6), 128 | (63 & n));
    else if (55296 == (64512 & n)) {
      if (r < e.length - 1 && 56320 == (64512 & e.charCodeAt(r + 1))) {
        (n = 65536 | ((1023 & n) << 10) | (1023 & e.charCodeAt(++r))),
          t.push(
            240 | (n >> 18),
            128 | ((n >> 12) & 63),
            128 | ((n >> 6) & 63),
            128 | (63 & n)
          );
      } else t.push(239, 191, 189);
    } else
      56320 == (64512 & n)
        ? t.push(239, 191, 189)
        : t.push(224 | (n >> 12), 128 | ((n >> 6) & 63), 128 | (63 & n));
  }
  return new Uint8Array(t);
}
function base64Bytes_(e, t) {
  switch (e) {
    case l.BASE64: {
      const r = -1 !== t.indexOf("-"),
        n = -1 !== t.indexOf("_");
      if (r || n) {
        throw invalidFormat(
          e,
          "Invalid character '" +
            (r ? "-" : "_") +
            "' found: is it base64url encoded?"
        );
      }
      break;
    }
    case l.BASE64URL: {
      const r = -1 !== t.indexOf("+"),
        n = -1 !== t.indexOf("/");
      if (r || n) {
        throw invalidFormat(
          e,
          "Invalid character '" +
            (r ? "+" : "/") +
            "' found: is it base64 encoded?"
        );
      }
      t = t.replace(/-/g, "+").replace(/_/g, "/");
      break;
    }
  }
  let r;
  try {
    r = decodeBase64(t);
  } catch (t) {
    if (t.message.includes("polyfill")) throw t;
    throw invalidFormat(e, "Invalid character found");
  }
  const n = new Uint8Array(r.length);
  for (let e = 0; e < r.length; e++) n[e] = r.charCodeAt(e);
  return n;
}
class DataURLParts {
  constructor(e) {
    (this.base64 = !1), (this.contentType = null);
    const t = e.match(/^data:([^,]+)?,/);
    if (null === t)
      throw invalidFormat(
        l.DATA_URL,
        "Must be formatted 'data:[<mediatype>][;base64],<data>"
      );
    const r = t[1] || null;
    null != r &&
      ((this.base64 = (function endsWith(e, t) {
        if (!(e.length >= t.length)) return !1;
        return e.substring(e.length - t.length) === t;
      })(r, ";base64")),
      (this.contentType = this.base64
        ? r.substring(0, r.length - ";base64".length)
        : r)),
      (this.rest = e.substring(e.indexOf(",") + 1));
  }
}
class FbsBlob {
  constructor(e, t) {
    let r = 0,
      n = "";
    isNativeBlob(e)
      ? ((this.data_ = e), (r = e.size), (n = e.type))
      : e instanceof ArrayBuffer
      ? (t
          ? (this.data_ = new Uint8Array(e))
          : ((this.data_ = new Uint8Array(e.byteLength)),
            this.data_.set(new Uint8Array(e))),
        (r = this.data_.length))
      : e instanceof Uint8Array &&
        (t
          ? (this.data_ = e)
          : ((this.data_ = new Uint8Array(e.length)), this.data_.set(e)),
        (r = e.length)),
      (this.size_ = r),
      (this.type_ = n);
  }
  size() {
    return this.size_;
  }
  type() {
    return this.type_;
  }
  slice(e, t) {
    if (isNativeBlob(this.data_)) {
      const r = (function sliceBlob(e, t, r) {
        return e.webkitSlice
          ? e.webkitSlice(t, r)
          : e.mozSlice
          ? e.mozSlice(t, r)
          : e.slice
          ? e.slice(t, r)
          : null;
      })(this.data_, e, t);
      return null === r ? null : new FbsBlob(r);
    }
    {
      const r = new Uint8Array(this.data_.buffer, e, t - e);
      return new FbsBlob(r, !0);
    }
  }
  static getBlob(...e) {
    if (isNativeBlobDefined()) {
      const t = e.map((e) => (e instanceof FbsBlob ? e.data_ : e));
      return new FbsBlob(getBlob$1.apply(null, t));
    }
    {
      const t = e.map((e) =>
        isString(e) ? dataFromString(l.RAW, e).data : e.data_
      );
      let r = 0;
      t.forEach((e) => {
        r += e.byteLength;
      });
      const n = new Uint8Array(r);
      let o = 0;
      return (
        t.forEach((e) => {
          for (let t = 0; t < e.length; t++) n[o++] = e[t];
        }),
        new FbsBlob(n, !0)
      );
    }
  }
  uploadData() {
    return this.data_;
  }
}
function jsonObjectOrNull(e) {
  let t;
  try {
    t = JSON.parse(e);
  } catch (e) {
    return null;
  }
  return (function isNonArrayObject(e) {
    return "object" == typeof e && !Array.isArray(e);
  })(t)
    ? t
    : null;
}
function lastComponent(e) {
  const t = e.lastIndexOf("/", e.length - 2);
  return -1 === t ? e : e.slice(t + 1);
}
function noXform_(e, t) {
  return t;
}
class Mapping {
  constructor(e, t, r, n) {
    (this.server = e),
      (this.local = t || e),
      (this.writable = !!r),
      (this.xform = n || noXform_);
  }
}
let c = null;
function getMappings() {
  if (c) return c;
  const e = [];
  e.push(new Mapping("bucket")),
    e.push(new Mapping("generation")),
    e.push(new Mapping("metageneration")),
    e.push(new Mapping("name", "fullPath", !0));
  const t = new Mapping("name");
  (t.xform = function mappingsXformPath(e, t) {
    return (function xformPath(e) {
      return !isString(e) || e.length < 2 ? e : lastComponent(e);
    })(t);
  }),
    e.push(t);
  const r = new Mapping("size");
  return (
    (r.xform = function xformSize(e, t) {
      return void 0 !== t ? Number(t) : t;
    }),
    e.push(r),
    e.push(new Mapping("timeCreated")),
    e.push(new Mapping("updated")),
    e.push(new Mapping("md5Hash", null, !0)),
    e.push(new Mapping("cacheControl", null, !0)),
    e.push(new Mapping("contentDisposition", null, !0)),
    e.push(new Mapping("contentEncoding", null, !0)),
    e.push(new Mapping("contentLanguage", null, !0)),
    e.push(new Mapping("contentType", null, !0)),
    e.push(new Mapping("metadata", "customMetadata", !0)),
    (c = e),
    c
  );
}
function fromResource(e, t, r) {
  const n = { type: "file" },
    o = r.length;
  for (let e = 0; e < o; e++) {
    const o = r[e];
    n[o.local] = o.xform(n, t[o.server]);
  }
  return (
    (function addRef(e, t) {
      Object.defineProperty(e, "ref", {
        get: function generateRef() {
          const r = e.bucket,
            n = e.fullPath,
            o = new Location(r, n);
          return t._makeStorageReference(o);
        },
      });
    })(n, e),
    n
  );
}
function fromResourceString(e, t, r) {
  const n = jsonObjectOrNull(t);
  if (null === n) return null;
  return fromResource(e, n, r);
}
function toResourceString(e, t) {
  const r = {},
    n = t.length;
  for (let o = 0; o < n; o++) {
    const n = t[o];
    n.writable && (r[n.server] = e[n.local]);
  }
  return JSON.stringify(r);
}
function fromResponseString(e, t, r) {
  const n = jsonObjectOrNull(r);
  if (null === n) return null;
  return (function fromBackendResponse(e, t, r) {
    const n = { prefixes: [], items: [], nextPageToken: r.nextPageToken };
    if (r.prefixes)
      for (const o of r.prefixes) {
        const r = o.replace(/\/$/, ""),
          s = e._makeStorageReference(new Location(t, r));
        n.prefixes.push(s);
      }
    if (r.items)
      for (const o of r.items) {
        const r = e._makeStorageReference(new Location(t, o.name));
        n.items.push(r);
      }
    return n;
  })(e, t, n);
}
class RequestInfo {
  constructor(e, t, r, n) {
    (this.url = e),
      (this.method = t),
      (this.handler = r),
      (this.timeout = n),
      (this.urlParams = {}),
      (this.headers = {}),
      (this.body = null),
      (this.errorHandler = null),
      (this.progressCallback = null),
      (this.successCodes = [200]),
      (this.additionalRetryCodes = []);
  }
}
function handlerCheck(e) {
  if (!e) throw unknown();
}
function metadataHandler(e, t) {
  return function handler(r, n) {
    const o = fromResourceString(e, n, t);
    return handlerCheck(null !== o), o;
  };
}
function downloadUrlHandler(e, t) {
  return function handler(r, n) {
    const o = fromResourceString(e, n, t);
    return (
      handlerCheck(null !== o),
      (function downloadUrlFromResourceString(e, t, r, n) {
        const o = jsonObjectOrNull(t);
        if (null === o) return null;
        if (!isString(o.downloadTokens)) return null;
        const s = o.downloadTokens;
        if (0 === s.length) return null;
        const i = encodeURIComponent;
        return s.split(",").map((t) => {
          const o = e.bucket,
            s = e.fullPath;
          return (
            makeUrl("/b/" + i(o) + "/o/" + i(s), r, n) +
            makeQueryString({ alt: "media", token: t })
          );
        })[0];
      })(o, n, e.host, e._protocol)
    );
  };
}
function sharedErrorHandler(e) {
  return function errorHandler(t, r) {
    let n;
    return (
      (n =
        401 === t.getStatus()
          ? t.getErrorText().includes("Firebase App Check token is invalid")
            ? (function unauthorizedApp() {
                return new StorageError(
                  i.UNAUTHORIZED_APP,
                  "This app does not have permission to access Firebase Storage on this project."
                );
              })()
            : (function unauthenticated() {
                return new StorageError(
                  i.UNAUTHENTICATED,
                  "User is not authenticated, please authenticate using Firebase Authentication and try again."
                );
              })()
          : 402 === t.getStatus()
          ? (function quotaExceeded(e) {
              return new StorageError(
                i.QUOTA_EXCEEDED,
                "Quota for bucket '" +
                  e +
                  "' exceeded, please view quota on https://firebase.google.com/pricing/."
              );
            })(e.bucket)
          : 403 === t.getStatus()
          ? (function unauthorized(e) {
              return new StorageError(
                i.UNAUTHORIZED,
                "User does not have permission to access '" + e + "'."
              );
            })(e.path)
          : r),
      (n.status = t.getStatus()),
      (n.serverResponse = r.serverResponse),
      n
    );
  };
}
function objectErrorHandler(e) {
  const t = sharedErrorHandler(e);
  return function errorHandler(r, n) {
    let o = t(r, n);
    return (
      404 === r.getStatus() &&
        (o = (function objectNotFound(e) {
          return new StorageError(
            i.OBJECT_NOT_FOUND,
            "Object '" + e + "' does not exist."
          );
        })(e.path)),
      (o.serverResponse = n.serverResponse),
      o
    );
  };
}
function getMetadata$2(e, t, r) {
  const n = makeUrl(t.fullServerUrl(), e.host, e._protocol),
    o = e.maxOperationRetryTime,
    s = new RequestInfo(n, "GET", metadataHandler(e, r), o);
  return (s.errorHandler = objectErrorHandler(t)), s;
}
function list$2(e, t, r, n, o) {
  const s = {};
  t.isRoot ? (s.prefix = "") : (s.prefix = t.path + "/"),
    r && r.length > 0 && (s.delimiter = r),
    n && (s.pageToken = n),
    o && (s.maxResults = o);
  const i = makeUrl(t.bucketOnlyServerUrl(), e.host, e._protocol),
    a = e.maxOperationRetryTime,
    l = new RequestInfo(
      i,
      "GET",
      (function listHandler(e, t) {
        return function handler(r, n) {
          const o = fromResponseString(e, t, n);
          return handlerCheck(null !== o), o;
        };
      })(e, t.bucket),
      a
    );
  return (l.urlParams = s), (l.errorHandler = sharedErrorHandler(t)), l;
}
function getBytes$1(e, t, r) {
  const n = makeUrl(t.fullServerUrl(), e.host, e._protocol) + "?alt=media",
    o = e.maxOperationRetryTime,
    s = new RequestInfo(n, "GET", (e, t) => t, o);
  return (
    (s.errorHandler = objectErrorHandler(t)),
    void 0 !== r &&
      ((s.headers.Range = `bytes=0-${r}`), (s.successCodes = [200, 206])),
    s
  );
}
function metadataForUpload_(e, t, r) {
  const n = Object.assign({}, r);
  return (
    (n.fullPath = e.path),
    (n.size = t.size()),
    n.contentType ||
      (n.contentType = (function determineContentType_(e, t) {
        return (
          (e && e.contentType) || (t && t.type()) || "application/octet-stream"
        );
      })(null, t)),
    n
  );
}
function multipartUpload(e, t, r, n, o) {
  const s = t.bucketOnlyServerUrl(),
    i = { "X-Goog-Upload-Protocol": "multipart" };
  const a = (function genBoundary() {
    let e = "";
    for (let t = 0; t < 2; t++) e += Math.random().toString().slice(2);
    return e;
  })();
  i["Content-Type"] = "multipart/related; boundary=" + a;
  const l = metadataForUpload_(t, n, o),
    c =
      "--" +
      a +
      "\r\nContent-Type: application/json; charset=utf-8\r\n\r\n" +
      toResourceString(l, r) +
      "\r\n--" +
      a +
      "\r\nContent-Type: " +
      l.contentType +
      "\r\n\r\n",
    u = "\r\n--" + a + "--",
    h = FbsBlob.getBlob(c, n, u);
  if (null === h) throw cannotSliceBlob();
  const d = { name: l.fullPath },
    p = makeUrl(s, e.host, e._protocol),
    _ = e.maxUploadRetryTime,
    f = new RequestInfo(p, "POST", metadataHandler(e, r), _);
  return (
    (f.urlParams = d),
    (f.headers = i),
    (f.body = h.uploadData()),
    (f.errorHandler = sharedErrorHandler(t)),
    f
  );
}
class ResumableUploadStatus {
  constructor(e, t, r, n) {
    (this.current = e),
      (this.total = t),
      (this.finalized = !!r),
      (this.metadata = n || null);
  }
}
function checkResumeHeader_(e, t) {
  let r = null;
  try {
    r = e.getResponseHeader("X-Goog-Upload-Status");
  } catch (e) {
    handlerCheck(!1);
  }
  return handlerCheck(!!r && -1 !== (t || ["active"]).indexOf(r)), r;
}
function continueResumableUpload(e, t, r, n, o, s, a, l) {
  const c = new ResumableUploadStatus(0, 0);
  if (
    (a
      ? ((c.current = a.current), (c.total = a.total))
      : ((c.current = 0), (c.total = n.size())),
    n.size() !== c.total)
  )
    throw (function serverFileWrongSize() {
      return new StorageError(
        i.SERVER_FILE_WRONG_SIZE,
        "Server recorded incorrect upload file size, please retry the upload."
      );
    })();
  const u = c.total - c.current;
  let h = u;
  o > 0 && (h = Math.min(h, o));
  const d = c.current,
    p = d + h;
  let _ = "";
  _ = 0 === h ? "finalize" : u === h ? "upload, finalize" : "upload";
  const f = {
      "X-Goog-Upload-Command": _,
      "X-Goog-Upload-Offset": `${c.current}`,
    },
    g = n.slice(d, p);
  if (null === g) throw cannotSliceBlob();
  const m = t.maxUploadRetryTime,
    b = new RequestInfo(
      r,
      "POST",
      function handler(e, r) {
        const o = checkResumeHeader_(e, ["active", "final"]),
          i = c.current + h,
          a = n.size();
        let l;
        return (
          (l = "final" === o ? metadataHandler(t, s)(e, r) : null),
          new ResumableUploadStatus(i, a, "final" === o, l)
        );
      },
      m
    );
  return (
    (b.headers = f),
    (b.body = g.uploadData()),
    (b.progressCallback = l || null),
    (b.errorHandler = sharedErrorHandler(e)),
    b
  );
}
const u = { STATE_CHANGED: "state_changed" },
  h = {
    RUNNING: "running",
    PAUSED: "paused",
    SUCCESS: "success",
    CANCELED: "canceled",
    ERROR: "error",
  };
function taskStateFromInternalTaskState(e) {
  switch (e) {
    case "running":
    case "pausing":
    case "canceling":
      return h.RUNNING;
    case "paused":
      return h.PAUSED;
    case "success":
      return h.SUCCESS;
    case "canceled":
      return h.CANCELED;
    default:
      return h.ERROR;
  }
}
class Observer {
  constructor(e, t, r) {
    if (
      (function isFunction(e) {
        return "function" == typeof e;
      })(e) ||
      null != t ||
      null != r
    )
      (this.next = e),
        (this.error = null != t ? t : void 0),
        (this.complete = null != r ? r : void 0);
    else {
      const t = e;
      (this.next = t.next),
        (this.error = t.error),
        (this.complete = t.complete);
    }
  }
}
function async(e) {
  return (...t) => {
    Promise.resolve().then(() => e(...t));
  };
}
class XhrConnection {
  constructor() {
    (this.sent_ = !1),
      (this.xhr_ = new XMLHttpRequest()),
      this.initXhr(),
      (this.errorCode_ = a.NO_ERROR),
      (this.sendPromise_ = new Promise((e) => {
        this.xhr_.addEventListener("abort", () => {
          (this.errorCode_ = a.ABORT), e();
        }),
          this.xhr_.addEventListener("error", () => {
            (this.errorCode_ = a.NETWORK_ERROR), e();
          }),
          this.xhr_.addEventListener("load", () => {
            e();
          });
      }));
  }
  send(e, t, r, n) {
    if (this.sent_) throw internalError("cannot .send() more than once");
    if (((this.sent_ = !0), this.xhr_.open(t, e, !0), void 0 !== n))
      for (const e in n)
        n.hasOwnProperty(e) && this.xhr_.setRequestHeader(e, n[e].toString());
    return (
      void 0 !== r ? this.xhr_.send(r) : this.xhr_.send(), this.sendPromise_
    );
  }
  getErrorCode() {
    if (!this.sent_)
      throw internalError("cannot .getErrorCode() before sending");
    return this.errorCode_;
  }
  getStatus() {
    if (!this.sent_) throw internalError("cannot .getStatus() before sending");
    try {
      return this.xhr_.status;
    } catch (e) {
      return -1;
    }
  }
  getResponse() {
    if (!this.sent_)
      throw internalError("cannot .getResponse() before sending");
    return this.xhr_.response;
  }
  getErrorText() {
    if (!this.sent_)
      throw internalError("cannot .getErrorText() before sending");
    return this.xhr_.statusText;
  }
  abort() {
    this.xhr_.abort();
  }
  getResponseHeader(e) {
    return this.xhr_.getResponseHeader(e);
  }
  addUploadProgressListener(e) {
    null != this.xhr_.upload &&
      this.xhr_.upload.addEventListener("progress", e);
  }
  removeUploadProgressListener(e) {
    null != this.xhr_.upload &&
      this.xhr_.upload.removeEventListener("progress", e);
  }
}
class XhrTextConnection extends XhrConnection {
  initXhr() {
    this.xhr_.responseType = "text";
  }
}
function newTextConnection() {
  return new XhrTextConnection();
}
class XhrBytesConnection extends XhrConnection {
  initXhr() {
    this.xhr_.responseType = "arraybuffer";
  }
}
function newBytesConnection() {
  return new XhrBytesConnection();
}
class XhrBlobConnection extends XhrConnection {
  initXhr() {
    this.xhr_.responseType = "blob";
  }
}
function newBlobConnection() {
  return new XhrBlobConnection();
}
class UploadTask {
  constructor(e, t, r = null) {
    (this._transferred = 0),
      (this._needToFetchStatus = !1),
      (this._needToFetchMetadata = !1),
      (this._observers = []),
      (this._error = void 0),
      (this._uploadUrl = void 0),
      (this._request = void 0),
      (this._chunkMultiplier = 1),
      (this._resolve = void 0),
      (this._reject = void 0),
      (this._ref = e),
      (this._blob = t),
      (this._metadata = r),
      (this._mappings = getMappings()),
      (this._resumable = this._shouldDoResumable(this._blob)),
      (this._state = "running"),
      (this._errorHandler = (e) => {
        if (
          ((this._request = void 0),
          (this._chunkMultiplier = 1),
          e._codeEquals(i.CANCELED))
        )
          (this._needToFetchStatus = !0), this.completeTransitions_();
        else {
          const t = this.isExponentialBackoffExpired();
          if (isRetryStatusCode(e.status, [])) {
            if (!t)
              return (
                (this.sleepTime = Math.max(2 * this.sleepTime, 1e3)),
                (this._needToFetchStatus = !0),
                void this.completeTransitions_()
              );
            e = retryLimitExceeded();
          }
          (this._error = e), this._transition("error");
        }
      }),
      (this._metadataErrorHandler = (e) => {
        (this._request = void 0),
          e._codeEquals(i.CANCELED)
            ? this.completeTransitions_()
            : ((this._error = e), this._transition("error"));
      }),
      (this.sleepTime = 0),
      (this.maxSleepTime = this._ref.storage.maxUploadRetryTime),
      (this._promise = new Promise((e, t) => {
        (this._resolve = e), (this._reject = t), this._start();
      })),
      this._promise.then(null, () => {});
  }
  isExponentialBackoffExpired() {
    return this.sleepTime > this.maxSleepTime;
  }
  _makeProgressCallback() {
    const e = this._transferred;
    return (t) => this._updateProgress(e + t);
  }
  _shouldDoResumable(e) {
    return e.size() > 262144;
  }
  _start() {
    "running" === this._state &&
      void 0 === this._request &&
      (this._resumable
        ? void 0 === this._uploadUrl
          ? this._createResumable()
          : this._needToFetchStatus
          ? this._fetchStatus()
          : this._needToFetchMetadata
          ? this._fetchMetadata()
          : (this.pendingTimeout = setTimeout(() => {
              (this.pendingTimeout = void 0), this._continueUpload();
            }, this.sleepTime))
        : this._oneShotUpload());
  }
  _resolveToken(e) {
    Promise.all([
      this._ref.storage._getAuthToken(),
      this._ref.storage._getAppCheckToken(),
    ]).then(([t, r]) => {
      switch (this._state) {
        case "running":
          e(t, r);
          break;
        case "canceling":
          this._transition("canceled");
          break;
        case "pausing":
          this._transition("paused");
      }
    });
  }
  _createResumable() {
    this._resolveToken((e, t) => {
      const r = (function createResumableUpload(e, t, r, n, o) {
          const s = t.bucketOnlyServerUrl(),
            i = metadataForUpload_(t, n, o),
            a = { name: i.fullPath },
            l = makeUrl(s, e.host, e._protocol),
            c = {
              "X-Goog-Upload-Protocol": "resumable",
              "X-Goog-Upload-Command": "start",
              "X-Goog-Upload-Header-Content-Length": `${n.size()}`,
              "X-Goog-Upload-Header-Content-Type": i.contentType,
              "Content-Type": "application/json; charset=utf-8",
            },
            u = toResourceString(i, r),
            h = e.maxUploadRetryTime,
            d = new RequestInfo(
              l,
              "POST",
              function handler(e) {
                let t;
                checkResumeHeader_(e);
                try {
                  t = e.getResponseHeader("X-Goog-Upload-URL");
                } catch (e) {
                  handlerCheck(!1);
                }
                return handlerCheck(isString(t)), t;
              },
              h
            );
          return (
            (d.urlParams = a),
            (d.headers = c),
            (d.body = u),
            (d.errorHandler = sharedErrorHandler(t)),
            d
          );
        })(
          this._ref.storage,
          this._ref._location,
          this._mappings,
          this._blob,
          this._metadata
        ),
        n = this._ref.storage._makeRequest(r, newTextConnection, e, t);
      (this._request = n),
        n.getPromise().then((e) => {
          (this._request = void 0),
            (this._uploadUrl = e),
            (this._needToFetchStatus = !1),
            this.completeTransitions_();
        }, this._errorHandler);
    });
  }
  _fetchStatus() {
    const e = this._uploadUrl;
    this._resolveToken((t, r) => {
      const n = (function getResumableUploadStatus(e, t, r, n) {
          const o = e.maxUploadRetryTime,
            s = new RequestInfo(
              r,
              "POST",
              function handler(e) {
                const t = checkResumeHeader_(e, ["active", "final"]);
                let r = null;
                try {
                  r = e.getResponseHeader("X-Goog-Upload-Size-Received");
                } catch (e) {
                  handlerCheck(!1);
                }
                r || handlerCheck(!1);
                const o = Number(r);
                return (
                  handlerCheck(!isNaN(o)),
                  new ResumableUploadStatus(o, n.size(), "final" === t)
                );
              },
              o
            );
          return (
            (s.headers = { "X-Goog-Upload-Command": "query" }),
            (s.errorHandler = sharedErrorHandler(t)),
            s
          );
        })(this._ref.storage, this._ref._location, e, this._blob),
        o = this._ref.storage._makeRequest(n, newTextConnection, t, r);
      (this._request = o),
        o.getPromise().then((e) => {
          (e = e),
            (this._request = void 0),
            this._updateProgress(e.current),
            (this._needToFetchStatus = !1),
            e.finalized && (this._needToFetchMetadata = !0),
            this.completeTransitions_();
        }, this._errorHandler);
    });
  }
  _continueUpload() {
    const e = 262144 * this._chunkMultiplier,
      t = new ResumableUploadStatus(this._transferred, this._blob.size()),
      r = this._uploadUrl;
    this._resolveToken((n, o) => {
      let s;
      try {
        s = continueResumableUpload(
          this._ref._location,
          this._ref.storage,
          r,
          this._blob,
          e,
          this._mappings,
          t,
          this._makeProgressCallback()
        );
      } catch (e) {
        return (this._error = e), void this._transition("error");
      }
      const i = this._ref.storage._makeRequest(s, newTextConnection, n, o, !1);
      (this._request = i),
        i.getPromise().then((e) => {
          this._increaseMultiplier(),
            (this._request = void 0),
            this._updateProgress(e.current),
            e.finalized
              ? ((this._metadata = e.metadata), this._transition("success"))
              : this.completeTransitions_();
        }, this._errorHandler);
    });
  }
  _increaseMultiplier() {
    2 * (262144 * this._chunkMultiplier) < 33554432 &&
      (this._chunkMultiplier *= 2);
  }
  _fetchMetadata() {
    this._resolveToken((e, t) => {
      const r = getMetadata$2(
          this._ref.storage,
          this._ref._location,
          this._mappings
        ),
        n = this._ref.storage._makeRequest(r, newTextConnection, e, t);
      (this._request = n),
        n.getPromise().then((e) => {
          (this._request = void 0),
            (this._metadata = e),
            this._transition("success");
        }, this._metadataErrorHandler);
    });
  }
  _oneShotUpload() {
    this._resolveToken((e, t) => {
      const r = multipartUpload(
          this._ref.storage,
          this._ref._location,
          this._mappings,
          this._blob,
          this._metadata
        ),
        n = this._ref.storage._makeRequest(r, newTextConnection, e, t);
      (this._request = n),
        n.getPromise().then((e) => {
          (this._request = void 0),
            (this._metadata = e),
            this._updateProgress(this._blob.size()),
            this._transition("success");
        }, this._errorHandler);
    });
  }
  _updateProgress(e) {
    const t = this._transferred;
    (this._transferred = e), this._transferred !== t && this._notifyObservers();
  }
  _transition(e) {
    if (this._state !== e)
      switch (e) {
        case "canceling":
        case "pausing":
          (this._state = e),
            void 0 !== this._request
              ? this._request.cancel()
              : this.pendingTimeout &&
                (clearTimeout(this.pendingTimeout),
                (this.pendingTimeout = void 0),
                this.completeTransitions_());
          break;
        case "running":
          const t = "paused" === this._state;
          (this._state = e), t && (this._notifyObservers(), this._start());
          break;
        case "paused":
        case "error":
        case "success":
          (this._state = e), this._notifyObservers();
          break;
        case "canceled":
          (this._error = canceled()),
            (this._state = e),
            this._notifyObservers();
      }
  }
  completeTransitions_() {
    switch (this._state) {
      case "pausing":
        this._transition("paused");
        break;
      case "canceling":
        this._transition("canceled");
        break;
      case "running":
        this._start();
    }
  }
  get snapshot() {
    const e = taskStateFromInternalTaskState(this._state);
    return {
      bytesTransferred: this._transferred,
      totalBytes: this._blob.size(),
      state: e,
      metadata: this._metadata,
      task: this,
      ref: this._ref,
    };
  }
  on(e, t, r, n) {
    const o = new Observer(t || void 0, r || void 0, n || void 0);
    return (
      this._addObserver(o),
      () => {
        this._removeObserver(o);
      }
    );
  }
  then(e, t) {
    return this._promise.then(e, t);
  }
  catch(e) {
    return this.then(null, e);
  }
  _addObserver(e) {
    this._observers.push(e), this._notifyObserver(e);
  }
  _removeObserver(e) {
    const t = this._observers.indexOf(e);
    -1 !== t && this._observers.splice(t, 1);
  }
  _notifyObservers() {
    this._finishPromise();
    this._observers.slice().forEach((e) => {
      this._notifyObserver(e);
    });
  }
  _finishPromise() {
    if (void 0 !== this._resolve) {
      let e = !0;
      switch (taskStateFromInternalTaskState(this._state)) {
        case h.SUCCESS:
          async(this._resolve.bind(null, this.snapshot))();
          break;
        case h.CANCELED:
        case h.ERROR:
          async(this._reject.bind(null, this._error))();
          break;
        default:
          e = !1;
      }
      e && ((this._resolve = void 0), (this._reject = void 0));
    }
  }
  _notifyObserver(e) {
    switch (taskStateFromInternalTaskState(this._state)) {
      case h.RUNNING:
      case h.PAUSED:
        e.next && async(e.next.bind(e, this.snapshot))();
        break;
      case h.SUCCESS:
        e.complete && async(e.complete.bind(e))();
        break;
      default:
        e.error && async(e.error.bind(e, this._error))();
    }
  }
  resume() {
    const e = "paused" === this._state || "pausing" === this._state;
    return e && this._transition("running"), e;
  }
  pause() {
    const e = "running" === this._state;
    return e && this._transition("pausing"), e;
  }
  cancel() {
    const e = "running" === this._state || "pausing" === this._state;
    return e && this._transition("canceling"), e;
  }
}
class Reference {
  constructor(e, t) {
    (this._service = e),
      (this._location =
        t instanceof Location ? t : Location.makeFromUrl(t, e.host));
  }
  toString() {
    return "gs://" + this._location.bucket + "/" + this._location.path;
  }
  _newRef(e, t) {
    return new Reference(e, t);
  }
  get root() {
    const e = new Location(this._location.bucket, "");
    return this._newRef(this._service, e);
  }
  get bucket() {
    return this._location.bucket;
  }
  get fullPath() {
    return this._location.path;
  }
  get name() {
    return lastComponent(this._location.path);
  }
  get storage() {
    return this._service;
  }
  get parent() {
    const e = (function parent(e) {
      if (0 === e.length) return null;
      const t = e.lastIndexOf("/");
      return -1 === t ? "" : e.slice(0, t);
    })(this._location.path);
    if (null === e) return null;
    const t = new Location(this._location.bucket, e);
    return new Reference(this._service, t);
  }
  _throwIfRoot(e) {
    if ("" === this._location.path) throw invalidRootOperation(e);
  }
}
function uploadBytes$1(e, t, r) {
  e._throwIfRoot("uploadBytes");
  const n = multipartUpload(
    e.storage,
    e._location,
    getMappings(),
    new FbsBlob(t, !0),
    r
  );
  return e.storage
    .makeRequestWithTokens(n, newTextConnection)
    .then((t) => ({ metadata: t, ref: e }));
}
function listAll$1(e) {
  const t = { prefixes: [], items: [] };
  return listAllHelper(e, t).then(() => t);
}
async function listAllHelper(e, t, r) {
  const n = { pageToken: r },
    o = await list$1(e, n);
  t.prefixes.push(...o.prefixes),
    t.items.push(...o.items),
    null != o.nextPageToken && (await listAllHelper(e, t, o.nextPageToken));
}
function list$1(e, t) {
  null != t &&
    "number" == typeof t.maxResults &&
    validateNumber("options.maxResults", 1, 1e3, t.maxResults);
  const r = t || {},
    n = list$2(e.storage, e._location, "/", r.pageToken, r.maxResults);
  return e.storage.makeRequestWithTokens(n, newTextConnection);
}
function updateMetadata$1(e, t) {
  e._throwIfRoot("updateMetadata");
  const r = (function updateMetadata$2(e, t, r, n) {
    const o = makeUrl(t.fullServerUrl(), e.host, e._protocol),
      s = toResourceString(r, n),
      i = e.maxOperationRetryTime,
      a = new RequestInfo(o, "PATCH", metadataHandler(e, n), i);
    return (
      (a.headers = { "Content-Type": "application/json; charset=utf-8" }),
      (a.body = s),
      (a.errorHandler = objectErrorHandler(t)),
      a
    );
  })(e.storage, e._location, t, getMappings());
  return e.storage.makeRequestWithTokens(r, newTextConnection);
}
function getDownloadURL$1(e) {
  e._throwIfRoot("getDownloadURL");
  const t = (function getDownloadUrl(e, t, r) {
    const n = makeUrl(t.fullServerUrl(), e.host, e._protocol),
      o = e.maxOperationRetryTime,
      s = new RequestInfo(n, "GET", downloadUrlHandler(e, r), o);
    return (s.errorHandler = objectErrorHandler(t)), s;
  })(e.storage, e._location, getMappings());
  return e.storage.makeRequestWithTokens(t, newTextConnection).then((e) => {
    if (null === e)
      throw (function noDownloadURL() {
        return new StorageError(
          i.NO_DOWNLOAD_URL,
          "The given file does not have any download URLs."
        );
      })();
    return e;
  });
}
function deleteObject$1(e) {
  e._throwIfRoot("deleteObject");
  const t = (function deleteObject$2(e, t) {
    const r = makeUrl(t.fullServerUrl(), e.host, e._protocol),
      n = e.maxOperationRetryTime,
      o = new RequestInfo(r, "DELETE", function handler(e, t) {}, n);
    return (
      (o.successCodes = [200, 204]), (o.errorHandler = objectErrorHandler(t)), o
    );
  })(e.storage, e._location);
  return e.storage.makeRequestWithTokens(t, newTextConnection);
}
function _getChild$1(e, t) {
  const r = (function child(e, t) {
      const r = t
        .split("/")
        .filter((e) => e.length > 0)
        .join("/");
      return 0 === e.length ? r : e + "/" + r;
    })(e._location.path, t),
    n = new Location(e._location.bucket, r);
  return new Reference(e.storage, n);
}
function refFromPath(e, t) {
  if (e instanceof FirebaseStorageImpl) {
    const r = e;
    if (null == r._bucket)
      throw (function noDefaultBucket() {
        return new StorageError(
          i.NO_DEFAULT_BUCKET,
          "No default bucket found. Did you set the 'storageBucket' property when initializing the app?"
        );
      })();
    const n = new Reference(r, r._bucket);
    return null != t ? refFromPath(n, t) : n;
  }
  return void 0 !== t ? _getChild$1(e, t) : e;
}
function ref$1(e, t) {
  if (
    t &&
    (function isUrl(e) {
      return /^[A-Za-z]+:\/\//.test(e);
    })(t)
  ) {
    if (e instanceof FirebaseStorageImpl)
      return (function refFromURL(e, t) {
        return new Reference(e, t);
      })(e, t);
    throw invalidArgument(
      "To use ref(service, url), the first argument must be a Storage instance."
    );
  }
  return refFromPath(e, t);
}
function extractBucket(e, t) {
  const r = null == t ? void 0 : t.storageBucket;
  return null == r ? null : Location.makeFromBucketSpec(r, e);
}
function connectStorageEmulator$1(e, t, r, n = {}) {
  (e.host = `${t}:${r}`), (e._protocol = "http");
  const { mockUserToken: o } = n;
  o &&
    (e._overrideAuthToken =
      "string" == typeof o
        ? o
        : (function createMockUserToken(e, t) {
            if (e.uid)
              throw new Error(
                'The "uid" field is no longer supported by mockUserToken. Please use "sub" instead for Firebase Auth User ID.'
              );
            const r = t || "demo-project",
              n = e.iat || 0,
              o = e.sub || e.user_id;
            if (!o)
              throw new Error(
                "mockUserToken must contain 'sub' or 'user_id' field!"
              );
            const s = Object.assign(
              {
                iss: `https://securetoken.google.com/${r}`,
                aud: r,
                iat: n,
                exp: n + 3600,
                auth_time: n,
                sub: o,
                user_id: o,
                firebase: { sign_in_provider: "custom", identities: {} },
              },
              e
            );
            return [
              base64urlEncodeWithoutPadding(
                JSON.stringify({ alg: "none", type: "JWT" })
              ),
              base64urlEncodeWithoutPadding(JSON.stringify(s)),
              "",
            ].join(".");
          })(o, e.app.options.projectId));
}
class FirebaseStorageImpl {
  constructor(e, t, r, n, o) {
    (this.app = e),
      (this._authProvider = t),
      (this._appCheckProvider = r),
      (this._url = n),
      (this._firebaseVersion = o),
      (this._bucket = null),
      (this._host = "firebasestorage.googleapis.com"),
      (this._protocol = "https"),
      (this._appId = null),
      (this._deleted = !1),
      (this._maxOperationRetryTime = 12e4),
      (this._maxUploadRetryTime = 6e5),
      (this._requests = new Set()),
      (this._bucket =
        null != n
          ? Location.makeFromBucketSpec(n, this._host)
          : extractBucket(this._host, this.app.options));
  }
  get host() {
    return this._host;
  }
  set host(e) {
    (this._host = e),
      null != this._url
        ? (this._bucket = Location.makeFromBucketSpec(this._url, e))
        : (this._bucket = extractBucket(e, this.app.options));
  }
  get maxUploadRetryTime() {
    return this._maxUploadRetryTime;
  }
  set maxUploadRetryTime(e) {
    validateNumber("time", 0, Number.POSITIVE_INFINITY, e),
      (this._maxUploadRetryTime = e);
  }
  get maxOperationRetryTime() {
    return this._maxOperationRetryTime;
  }
  set maxOperationRetryTime(e) {
    validateNumber("time", 0, Number.POSITIVE_INFINITY, e),
      (this._maxOperationRetryTime = e);
  }
  async _getAuthToken() {
    if (this._overrideAuthToken) return this._overrideAuthToken;
    const e = this._authProvider.getImmediate({ optional: !0 });
    if (e) {
      const t = await e.getToken();
      if (null !== t) return t.accessToken;
    }
    return null;
  }
  async _getAppCheckToken() {
    const e = this._appCheckProvider.getImmediate({ optional: !0 });
    if (e) {
      return (await e.getToken()).token;
    }
    return null;
  }
  _delete() {
    return (
      this._deleted ||
        ((this._deleted = !0),
        this._requests.forEach((e) => e.cancel()),
        this._requests.clear()),
      Promise.resolve()
    );
  }
  _makeStorageReference(e) {
    return new Reference(this, e);
  }
  _makeRequest(e, t, r, n, o = !0) {
    if (this._deleted) return new FailRequest(appDeleted());
    {
      const s = (function makeRequest(e, t, r, n, o, s, i = !0) {
        const a = makeQueryString(e.urlParams),
          l = e.url + a,
          c = Object.assign({}, e.headers);
        return (
          (function addGmpidHeader_(e, t) {
            t && (e["X-Firebase-GMPID"] = t);
          })(c, t),
          (function addAuthHeader_(e, t) {
            null !== t && t.length > 0 && (e.Authorization = "Firebase " + t);
          })(c, r),
          (function addVersionHeader_(e, t) {
            e["X-Firebase-Storage-Version"] =
              "webjs/" + (null != t ? t : "AppManager");
          })(c, s),
          (function addAppCheckHeader_(e, t) {
            null !== t && (e["X-Firebase-AppCheck"] = t);
          })(c, n),
          new NetworkRequest(
            l,
            e.method,
            c,
            e.body,
            e.successCodes,
            e.additionalRetryCodes,
            e.handler,
            e.errorHandler,
            e.timeout,
            e.progressCallback,
            o,
            i
          )
        );
      })(e, this._appId, r, n, t, this._firebaseVersion, o);
      return (
        this._requests.add(s),
        s.getPromise().then(
          () => this._requests.delete(s),
          () => this._requests.delete(s)
        ),
        s
      );
    }
  }
  async makeRequestWithTokens(e, t) {
    const [r, n] = await Promise.all([
      this._getAuthToken(),
      this._getAppCheckToken(),
    ]);
    return this._makeRequest(e, t, r, n).getPromise();
  }
}
const d = "@firebase/storage";
function getBytes(e, t) {
  return (function getBytesInternal(e, t) {
    e._throwIfRoot("getBytes");
    const r = getBytes$1(e.storage, e._location, t);
    return e.storage
      .makeRequestWithTokens(r, newBytesConnection)
      .then((e) => (void 0 !== t ? e.slice(0, t) : e));
  })((e = getModularInstance(e)), t);
}
function uploadBytes(e, t, r) {
  return uploadBytes$1((e = getModularInstance(e)), t, r);
}
function uploadString(e, t, r, n) {
  return (function uploadString$1(e, t, r = l.RAW, n) {
    e._throwIfRoot("uploadString");
    const o = dataFromString(r, t),
      s = Object.assign({}, n);
    return (
      null == s.contentType &&
        null != o.contentType &&
        (s.contentType = o.contentType),
      uploadBytes$1(e, o.data, s)
    );
  })((e = getModularInstance(e)), t, r, n);
}
function uploadBytesResumable(e, t, r) {
  return (function uploadBytesResumable$1(e, t, r) {
    return (
      e._throwIfRoot("uploadBytesResumable"),
      new UploadTask(e, new FbsBlob(t), r)
    );
  })((e = getModularInstance(e)), t, r);
}
function getMetadata(e) {
  return (function getMetadata$1(e) {
    e._throwIfRoot("getMetadata");
    const t = getMetadata$2(e.storage, e._location, getMappings());
    return e.storage.makeRequestWithTokens(t, newTextConnection);
  })((e = getModularInstance(e)));
}
function updateMetadata(e, t) {
  return updateMetadata$1((e = getModularInstance(e)), t);
}
function list(e, t) {
  return list$1((e = getModularInstance(e)), t);
}
function listAll(e) {
  return listAll$1((e = getModularInstance(e)));
}
function getDownloadURL(e) {
  return getDownloadURL$1((e = getModularInstance(e)));
}
function deleteObject(e) {
  return deleteObject$1((e = getModularInstance(e)));
}
function ref(e, t) {
  return ref$1((e = getModularInstance(e)), t);
}
function _getChild(e, t) {
  return _getChild$1(e, t);
}
function getStorage(t = e(), r) {
  t = getModularInstance(t);
  const n = _getProvider(t, "storage").getImmediate({ identifier: r }),
    o = getDefaultEmulatorHostnameAndPort("storage");
  return o && connectStorageEmulator(n, ...o), n;
}
function connectStorageEmulator(e, t, r, n = {}) {
  connectStorageEmulator$1(e, t, r, n);
}
function getBlob(e, t) {
  return (function getBlobInternal(e, t) {
    e._throwIfRoot("getBlob");
    const r = getBytes$1(e.storage, e._location, t);
    return e.storage
      .makeRequestWithTokens(r, newBlobConnection)
      .then((e) => (void 0 !== t ? e.slice(0, t) : e));
  })((e = getModularInstance(e)), t);
}
function getStream(e, t) {
  throw new Error("getStream() is only supported by NodeJS builds");
}
function factory(e, { instanceIdentifier: t }) {
  const r = e.getProvider("app").getImmediate(),
    o = e.getProvider("auth-internal"),
    s = e.getProvider("app-check-internal");
  return new FirebaseStorageImpl(r, o, s, t, n);
}
!(function registerStorage() {
  t(new Component("storage", factory, "PUBLIC").setMultipleInstances(!0)),
    r(d, "0.11.2", ""),
    r(d, "0.11.2", "esm2017");
})();
export {
  StorageError,
  i as StorageErrorCode,
  l as StringFormat,
  FbsBlob as _FbsBlob,
  Location as _Location,
  u as _TaskEvent,
  h as _TaskState,
  UploadTask as _UploadTask,
  dataFromString as _dataFromString,
  _getChild,
  invalidArgument as _invalidArgument,
  invalidRootOperation as _invalidRootOperation,
  connectStorageEmulator,
  deleteObject,
  getBlob,
  getBytes,
  getDownloadURL,
  getMetadata,
  getStorage,
  getStream,
  list,
  listAll,
  ref,
  updateMetadata,
  uploadBytes,
  uploadBytesResumable,
  uploadString,
};

//# sourceMappingURL=firebase-storage.js.map
