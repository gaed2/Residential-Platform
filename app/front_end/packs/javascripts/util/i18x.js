const DEFAULT = 'en';
const LANGUAGE_CONSTANT = 'lang';

let I18x = function() {
  // constructure
}

I18x.prototype = {
  _UserCurrentLanguage: function() {
    return localStorage.getItem(LANGUAGE_CONSTANT) || DEFAULT;
  },

  _allLocale: function() {
    let locale;
    try {
      locale = require(`../locale/${this._UserCurrentLanguage()}.js`);
    } catch (err) {
      locale = require(`../locale/${DEFAULT}.js`);
    }
    return locale;
  },

  all: function(){
    return this._allLocale();
  },

  moduleItems: function (moduleName) {
    const all = this._allLocale();
    return all.LOCALE[moduleName.toUpperCase()] || {};
  },

  T: function (string, values = {}) {
    let newString = string;
    if (Object.keys(values)) {
      Object.keys(values).forEach((key) => {
        newString = newString.replace(new RegExp(`%{${key}}`, 'g'), values[key]);
      });
    }
    return newString;
  },
};

export default new I18x;
