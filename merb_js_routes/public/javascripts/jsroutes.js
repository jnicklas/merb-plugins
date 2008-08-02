var Url = function(name, params) {
  return Url.routes[name](params);
};

Url.routes = {};

Url.register = function(name, definition) {
  Url.routes[name] = definition;
};