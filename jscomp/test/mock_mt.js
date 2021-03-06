'use strict';

var List = require("../../lib/js/list.js");
var Curry = require("../../lib/js/curry.js");

function from_pair_suites(name, suites) {
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

exports.from_pair_suites = from_pair_suites;
/* No side effect */
