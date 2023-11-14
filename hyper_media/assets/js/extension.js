class Element {
  constructor(content, selector) {
    this.content = content;
    this.selector = selector || "";
  }

  async querySelector(selector) {
    return new Element(await this.excute(), selector);
  }

  async excute(fun) {
    return await sendMessage(
      "querySelector",
      JSON.stringify([this.content, this.selector, fun])
    );
  }

  async removeSelector(selector) {
    this.content = await sendMessage(
      "removeSelector",
      JSON.stringify([await this.outerHTML, selector])
    );
    return this;
  }

  async getAttributeText(attr) {
    return await sendMessage(
      "getAttributeText",
      JSON.stringify([await this.outerHTML, this.selector, attr])
    );
  }

  get text() {
    return this.excute("text");
  }

  get outerHTML() {
    return this.excute("outerHTML");
  }

  get innerHTML() {
    return this.excute("innerHTML");
  }
}
class XPathNode {
  constructor(content, selector) {
    this.content = content;
    this.selector = selector;
  }

  async excute(fun) {
    return await sendMessage(
      "queryXPath",
      JSON.stringify([this.content, this.selector, fun])
    );
  }

  get attr() {
    return this.excute("attr");
  }

  get attrs() {
    return this.excute("attrs");
  }

  get text() {
    return this.excute("text");
  }

  get allHTML() {
    return this.excute("allHTML");
  }

  get outerHTML() {
    return this.excute("outerHTML");
  }
}

class Extension {
  static async request(url, options) {
    options = options || {};
    options.headers = options.headers || {};
    options.method = options.method || "get";
    const res = await sendMessage("request", JSON.stringify([url, options]));
    try {
      return JSON.parse(res);
    } catch (e) {
      return res;
    }
  }
  static querySelector(content, selector) {
    return new Element(content, selector);
  }
  static queryXPath(content, selector) {
    return new XPathNode(content, selector);
  }
  static async querySelectorAll(content, selector) {
    try {
      let elements = [];
      JSON.parse(
        await sendMessage(
          "querySelectorAll",
          JSON.stringify([content, selector])
        )
      ).forEach((e) => {
        elements.push(new Element(e, selector));
      });
      return elements;
    } catch (e) {
      return [];
    }
  }

  static async getElementsByClassName(content, selector) {
    try {
      let elements = [];
      JSON.parse(
        await sendMessage(
          "getElementsByClassName",
          JSON.stringify([content, selector])
        )
      ).forEach((e) => {
        elements.push(new Element(e, selector));
      });
      return elements;
    } catch (e) {
      return [];
    }
  }

  static async getElementById(content, selector, attr) {
    return await sendMessage(
      "getElementById",
      JSON.stringify([content, selector, attr])
    );
  }

  static async getAttributeText(content, selector, attr) {
    return await sendMessage(
      "getAttributeText",
      JSON.stringify([content, selector, attr])
    );
  }

  // base64("value","decode|encode")
  static async base64(content, type) {
    return await sendMessage("base64", JSON.stringify([content, type]));
  }
}

class Browser {
  static async launchFetchBlock(url, regex, timeout) {
    return await sendMessage(
      "launchFetchBlock",
      JSON.stringify([url, regex, timeout])
    );
  }

  static async launchXhrBlock(url, regex, timeout) {
    return await sendMessage(
      "launchXhrBlock",
      JSON.stringify([url, regex, timeout])
    );
  }

  static async launch(url, timeout) {
    return await sendMessage("launch", JSON.stringify([url, timeout]));
  }

  static async callJs(source, timeout) {
    return await sendMessage("callJs", JSON.stringify([source, timeout]));
  }

  static async waitUrl(url, timeout) {
    return await sendMessage("waitUrl", JSON.stringify([url, timeout]));
  }

  static async waitUrlAjaxResponse(url, timeout) {
    return await sendMessage(
      "waitUrlAjaxResponse",
      JSON.stringify([url, timeout])
    );
  }

  static async getHtml() {
    return await sendMessage("getHtml", JSON.stringify([]));
  }

  static async setUserAgent(userAgent) {
    return await sendMessage("setUserAgent", JSON.stringify([userAgent]));
  }
  static async close() {
    return await sendMessage("disposeBrowser", JSON.stringify([]));
  }
}

class Response {
  static success(data) {
    return {
      type: "success",
      data: data,
    };
  }
  static error(data) {
    return {
      type: "error",
      data: data,
    };
  }
}

console.log = function (message) {
  if (typeof message === "object") {
    message = JSON.stringify(message);
  }
  sendMessage("log", JSON.stringify([message.toString()]));
};

async function stringify(callback) {
  const data = await callback();
  return typeof data === "object" ? JSON.stringify(data) : data;
}

async function runFn(callback) {
  const data = await callback();
  return typeof data === "object" ? JSON.stringify(data) : data;
}
