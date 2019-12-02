let httpRequest = function() {
  // constructor
}
httpRequest.prototype = {
  config: function(endPoint, httpType) {
    return  {
      url: endPoint,
      type: httpType,
      cache:false,
      contentType: false,
      processData: false,
      async: false,
      beforeSend: function (xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      }
    };
  },

  post: function (endPoint, postData={}, options={}) {
    let config = this.config(endPoint, 'POST');
    config.data = postData;
    config = Object.assign(config, options);
    return $.ajax(config);
  },
  delete: function (endPoint, postData={}, options={}) {
    let config = this.config(endPoint, 'DELETE');
    config.data = postData;
    config = Object.assign(config, options);
    return $.ajax(config);
  },
  get: function(endPoint, options={}) {
    let config = this.config(endPoint, 'GET');
    config = Object.assign(config, options);
    return $.ajax(config);
  },
  put: function (endPoint, postData={}, options={}) {
    let config = this.config(endPoint, 'PUT');
    config.data = postData;
    config = Object.assign(config, options);
    return $.ajax(config);
  },
  patch: function (endPoint, postData={}, options={}) {
    let config = this.config(endPoint, 'PATCH');
    config.data = postData;
    config = Object.assign(config, options);
    return $.ajax(config);
  }  
};

export default new httpRequest;
