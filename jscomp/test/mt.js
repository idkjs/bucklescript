'use strict';

var List = require("../../lib/js/list.js");
var Path = require("path");
var $$Array = require("../../lib/js/array.js");
var Block = require("../../lib/js/block.js");
var Curry = require("../../lib/js/curry.js");
var Assert = require("assert");
var Process = require("process");

function assert_fail(msg) {
  Assert.fail(undefined, undefined, msg, "");
  
}

function is_mocha(param) {
  var match = $$Array.to_list(Process.argv);
  if (!match) {
    return false;
  }
  var match$1 = match[1];
  if (!match$1) {
    return false;
  }
  var exec = Path.basename(match$1[0]);
  if (exec === "mocha") {
    return true;
  } else {
    return exec === "_mocha";
  }
}

function from_suites(name, suite) {
  var match = $$Array.to_list(Process.argv);
  if (match && is_mocha(undefined)) {
    describe(name, (function () {
            return List.iter((function (param) {
                          var partial_arg = param[1];
                          it(param[0], (function () {
                                  return Curry._1(partial_arg, undefined);
                                }));
                          
                        }), suite);
          }));
    return ;
  }
  
}

function close_enough(thresholdOpt, a, b) {
  var threshold = thresholdOpt !== undefined ? thresholdOpt : 0.0000001;
  return Math.abs(a - b) < threshold;
}

function handleCode(spec) {
  switch (spec.tag | 0) {
    case /* Eq */0 :
        Assert.deepEqual(spec[0], spec[1]);
        return ;
    case /* Neq */1 :
        Assert.notDeepEqual(spec[0], spec[1]);
        return ;
    case /* StrictEq */2 :
        Assert.strictEqual(spec[0], spec[1]);
        return ;
    case /* StrictNeq */3 :
        Assert.notStrictEqual(spec[0], spec[1]);
        return ;
    case /* Ok */4 :
        Assert.ok(spec[0]);
        return ;
    case /* Approx */5 :
        var b = spec[1];
        var a = spec[0];
        if (!close_enough(undefined, a, b)) {
          Assert.deepEqual(a, b);
          return ;
        } else {
          return ;
        }
    case /* ApproxThreshold */6 :
        var b$1 = spec[2];
        var a$1 = spec[1];
        if (!close_enough(spec[0], a$1, b$1)) {
          Assert.deepEqual(a$1, b$1);
          return ;
        } else {
          return ;
        }
    case /* ThrowAny */7 :
        Assert.throws(spec[0]);
        return ;
    case /* Fail */8 :
        return assert_fail("failed");
    case /* FailWith */9 :
        return assert_fail(spec[0]);
    
  }
}

function from_pair_suites(name, suites) {
  var match = $$Array.to_list(Process.argv);
  if (match) {
    if (is_mocha(undefined)) {
      describe(name, (function () {
              return List.iter((function (param) {
                            var code = param[1];
                            it(param[0], (function () {
                                    return handleCode(Curry._1(code, undefined));
                                  }));
                            
                          }), suites);
            }));
      return ;
    } else {
      console.log(/* tuple */[
            name,
            "testing"
          ]);
      return List.iter((function (param) {
                    var name = param[0];
                    var fn = Curry._1(param[1], undefined);
                    switch (fn.tag | 0) {
                      case /* Eq */0 :
                          console.log(/* tuple */[
                                name,
                                fn[0],
                                "eq?",
                                fn[1]
                              ]);
                          return ;
                      case /* Neq */1 :
                          console.log(/* tuple */[
                                name,
                                fn[0],
                                "neq?",
                                fn[1]
                              ]);
                          return ;
                      case /* StrictEq */2 :
                          console.log(/* tuple */[
                                name,
                                fn[0],
                                "strict_eq?",
                                fn[1]
                              ]);
                          return ;
                      case /* StrictNeq */3 :
                          console.log(/* tuple */[
                                name,
                                fn[0],
                                "strict_neq?",
                                fn[1]
                              ]);
                          return ;
                      case /* Ok */4 :
                          console.log(/* tuple */[
                                name,
                                fn[0],
                                "ok?"
                              ]);
                          return ;
                      case /* Approx */5 :
                          console.log(/* tuple */[
                                name,
                                fn[0],
                                "~",
                                fn[1]
                              ]);
                          return ;
                      case /* ApproxThreshold */6 :
                          console.log(/* tuple */[
                                name,
                                fn[1],
                                "~",
                                fn[2],
                                " (",
                                fn[0],
                                ")"
                              ]);
                          return ;
                      case /* ThrowAny */7 :
                          return ;
                      case /* Fail */8 :
                          console.log("failed");
                          return ;
                      case /* FailWith */9 :
                          console.log("failed: " + fn[0]);
                          return ;
                      
                    }
                  }), suites);
    }
  }
  
}

var val_unit = Promise.resolve(undefined);

function from_promise_suites(name, suites) {
  var match = $$Array.to_list(Process.argv);
  if (match) {
    if (is_mocha(undefined)) {
      describe(name, (function () {
              return List.iter((function (param) {
                            var code = param[1];
                            it(param[0], (function () {
                                    return code.then((function (x) {
                                                  handleCode(x);
                                                  return val_unit;
                                                }));
                                  }));
                            
                          }), suites);
            }));
      return ;
    } else {
      console.log("promise suites");
      return ;
    }
  }
  
}

function eq_suites(test_id, suites, loc, x, y) {
  test_id.contents = test_id.contents + 1 | 0;
  suites.contents = /* :: */[
    /* tuple */[
      loc + (" id " + String(test_id.contents)),
      (function (param) {
          return /* Eq */Block.__(0, [
                    x,
                    y
                  ]);
        })
    ],
    suites.contents
  ];
  
}

function bool_suites(test_id, suites, loc, x) {
  test_id.contents = test_id.contents + 1 | 0;
  suites.contents = /* :: */[
    /* tuple */[
      loc + (" id " + String(test_id.contents)),
      (function (param) {
          return /* Ok */Block.__(4, [x]);
        })
    ],
    suites.contents
  ];
  
}

function throw_suites(test_id, suites, loc, x) {
  test_id.contents = test_id.contents + 1 | 0;
  suites.contents = /* :: */[
    /* tuple */[
      loc + (" id " + String(test_id.contents)),
      (function (param) {
          return /* ThrowAny */Block.__(7, [x]);
        })
    ],
    suites.contents
  ];
  
}

exports.from_suites = from_suites;
exports.from_pair_suites = from_pair_suites;
exports.from_promise_suites = from_promise_suites;
exports.eq_suites = eq_suites;
exports.bool_suites = bool_suites;
exports.throw_suites = throw_suites;
/* val_unit Not a pure module */
