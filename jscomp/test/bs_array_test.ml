
let suites :  Mt.pair_suites ref  = ref []
let test_id = ref 0
let eq loc x y = Mt.eq_suites loc x y ~test_id ~suites
let b loc x  = Mt.bool_suites loc x ~test_id ~suites
let neq loc x y = 
  incr test_id ; 
  suites := 
    (loc ^" id " ^ (string_of_int !test_id), (fun _ -> Mt.Neq(x,y))) :: !suites

module A = Bs.Array 
module L = Bs.List 
type 'a t = 'a Js.Array.t
let () =
  [| 1; 2; 3; 4 |]
  |> Js.Array.filter (fun  x -> x > 2)
  |> Js.Array.mapi (fun  x i -> x + i)
  |> Js.Array.reduce (fun  x y -> x + y) 0 
  |> Js.log



let id x = 
  eq __LOC__ 
   (Js.Vector.toList @@ Js.List.toVector x ) x 

let () =
  eq __LOC__ (Js.List.toVector [1;2;3]) [|1;2;3|];
  eq  __LOC__ 
  ( Js.Vector.map (fun [@bs] x -> x + 1) [|1;2;3|] )
  [|2;3;4|];
  eq __LOC__  (Js.Vector.make 5 3)
    [|3;3;3;3;3|];
  eq __LOC__ 
  ( let a = Js.Vector.init 5  (fun [@bs] i -> i + 1) in 
    Js.Vector.filterInPlace (fun [@bs] j -> j mod 2 = 0) a ; 
    a 
  )
  [|2;4|];

  eq __LOC__ 
  ( let a = Js.Vector.init 5  (fun [@bs] i -> i + 1) in 
    Js.Vector.filterInPlace (fun [@bs] j -> j mod 2 <> 0) a ; 
    a 
  )
  [|1;3;5|];

  eq __LOC__  
    (Js.List.toVector [1;2;3] ) [|1;2;3|];
  eq __LOC__
    (Js.List.toVector [1])   [|1|];
  id []  ;
  id [1];
  id [1;2;3;4;5];
  id (Js.Vector.(toList @@ init 100 (fun [@bs] i -> i  ) ))

let add = fun  x y -> x + y
let () = 
  let v = A.makeBy 3000 (fun i -> i) in 
  let u = A.shuffle v  in 
  neq __LOC__ u  v (* unlikely*);
  let sum x = A.reduce x 0 add in 
  eq __LOC__ ( sum u) (sum v)


let () =
  let open A in 
  b __LOC__ (range 0 3 =  [|0;1;2;3|]);
  b __LOC__ (range 3 0 =  [||] );
  b __LOC__ (range 3 3 = [|3|]);

  b __LOC__ (rangeBy 0 10 ~step:3 = [|0;3;6;9|]);
  b __LOC__ (rangeBy 0 12 ~step:3 = [|0;3;6;9;12|]);
  b __LOC__ (rangeBy 33 0 ~step:1 =  [||]);
  b __LOC__ (rangeBy 33 0 ~step:(-1) = [||]);
  b __LOC__ (rangeBy 3 12 ~step:(-1) = [||]);
  b __LOC__ (rangeBy 3 3 ~step:0 = [||] );     
  b __LOC__ (rangeBy 3 3 ~step:(1) = [|3|])



let () = 
  eq __LOC__ (A.reduceReverse [||] 100 (-)) 100;
  eq __LOC__ (A.reduceReverse [|1;2|] 100 (-)) 97;
  eq __LOC__ (A.reduceReverse [|1;2;3;4|] 100 (-) ) 90
let addone = fun [@bs] x -> x + 1

let makeMatrixExn sx sy init =
  let open A in 
  [%assert sx >=0 && sy >=0 ];
  let res = makeUninitializedUnsafe sx in 
  for x = 0 to  sx - 1 do
    let initY = makeUninitializedUnsafe sy in 
    for y = 0 to sy - 1 do 
      setUnsafe initY y init 
    done ;
    setUnsafe res x initY
  done;
  res

let () =   
  eq __LOC__ (A.makeBy 0 begin fun _ ->1 end ) [||];
  eq __LOC__ (A.makeBy 3 begin fun i -> i end) [|0;1;2|];
  eq __LOC__ (makeMatrixExn 3 4 1 
    
  ) [| [|1;1;1;1|]; [|1;1;1;1|]; [|1;1;1;1|]|];
  eq __LOC__ (makeMatrixExn 3 0 0 ) [| [||] ; [||]; [||] |];
  eq __LOC__ (makeMatrixExn  0 3 1 ) [||];
  eq __LOC__ (makeMatrixExn 1 1 1) [| [|1 |] |];
  eq __LOC__ (A.copy [||]) [||];
  eq __LOC__ (A.map [||] succ) [||];
  eq __LOC__ (A.mapWithIndex [||] add) [||];
  eq __LOC__ (A.mapWithIndex [|1;2;3|] add) [|1;3;5|];
  eq __LOC__ (L.ofArray [||]) [];
  eq __LOC__ (L.ofArray [|1|]) [1];
  eq __LOC__ (L.ofArray [|1;2;3|]) [1;2;3];
  eq __LOC__ (A.map [|1;2;3|] succ) [|2;3;4|];
  eq __LOC__ (L.toArray []) [||];
  eq __LOC__ (L.toArray [1]) [|1|];
  eq __LOC__ (L.toArray [1;2]) [|1;2|];
  eq __LOC__ (L.toArray [1;2;3]) [|1;2;3|]

let () = 
  let v = A.makeBy 10 (fun i -> i ) in 
  let v0 = A.keep v (fun x -> x mod 2 = 0) in 
  let v1 = A.keep v (fun x -> x mod 3 = 0) in 
  let v2 = A.keepMap v (fun x -> if x mod 2 = 0 then Some (x + 1) else None ) in 
  eq __LOC__ v0 [|0;2;4;6;8|];
  eq __LOC__ v1 [|0;3;6;9|];
  eq __LOC__ v2 [|1;3;5;7;9|]

let () =   
  let a = [|1;2;3;4;5|] in 
  eq __LOC__ (A.slice a ~offset:0 ~len:2) [|1;2|];
  eq __LOC__ (A.slice a ~offset:0 ~len:5) [|1;2;3;4;5|];
  eq __LOC__ (A.slice a ~offset:0 ~len:15) [|1;2;3;4;5|];
  eq __LOC__ (A.slice a ~offset:5 ~len:1) [||];
  eq __LOC__ (A.slice a ~offset:4 ~len:1) [|5|];
  eq __LOC__ (A.slice a ~offset:(-1) ~len:1) [|5|];
  eq __LOC__ (A.slice a ~offset:(-1) ~len:2) [|5|];
  eq __LOC__ (A.slice a ~offset:(-2) ~len:1) [|4|];
  eq __LOC__ (A.slice a ~offset:(-2) ~len:2) [|4;5|];
  eq __LOC__ (A.slice a ~offset:(-2) ~len:3) [|4;5|];
  eq __LOC__ (A.slice a ~offset:(-10) ~len:3) [|1;2;3|];
  eq __LOC__ (A.slice a ~offset:(-10) ~len:4) [|1;2;3;4|];
  eq __LOC__ (A.slice a ~offset:(-10) ~len:5) [|1;2;3;4;5|];
  eq __LOC__ (A.slice a ~offset:(-10) ~len:6) [|1;2;3;4;5|];
  eq __LOC__ (A.slice a ~offset:0 ~len:0) [||];
  eq __LOC__ (A.slice a ~offset:0 ~len:(-1)) [||]

let () =   
  let a = A.makeBy 10 (fun x -> x) in 
  A.fill a ~offset:0 ~len:3 0 ;
  eq  __LOC__ (A.copy a) [|0;0;0;3;4;5;6;7;8;9|];
  A.fill a ~offset:2 ~len:8 1 ;
  eq __LOC__ (A.copy a)  [|0;0;1;1;1;1;1;1;1;1|];
  A.fill a ~offset:8 ~len:1 9;
  eq __LOC__ (A.copy a)  [|0;0;1;1;1;1;1;1;9;1|];
  A.fill a ~offset:8 ~len:2 9;
  eq __LOC__ (A.copy a)  [|0;0;1;1;1;1;1;1;9;9|];
  A.fill a ~offset:8 ~len:3 12;
  eq __LOC__ (A.copy a)  [|0;0;1;1;1;1;1;1;12;12|];
  A.fill a ~offset:(-2) ~len:3 11;
  eq __LOC__ (A.copy a)  [|0;0;1;1;1;1;1;1;11;11|];
  A.fill a ~offset:(-3) ~len:3 10;
  eq __LOC__ (A.copy a)  [|0;0;1;1;1;1;1;10;10;10|];
  A.fill a ~offset:(-3) ~len:1 7;
  eq __LOC__ (A.copy a)  [|0;0;1;1;1;1;1;7;10;10|];
  A.fill a ~offset:(-13) ~len:1 7;
  eq __LOC__ (A.copy a)  [|7;0;1;1;1;1;1;7;10;10|];
  A.fill a ~offset:(-13) ~len:12 7;
  eq __LOC__ (A.copy a)  (A.make 10 7);
  A.fill a ~offset:0 ~len:(-1) 2 ;
  eq __LOC__ (A.copy a) (A.make 10 7)

let () =   
  let a0 = A.makeBy 10 (fun x -> x ) in 
  let b0 = A.make 10 3 in 
  A.blit ~src:a0 ~srcOffset:1 ~dst:b0 ~dstOffset:2 ~len:5;
  eq __LOC__ (A.copy b0) 
    [|3;3;1;2;3;4;5;3;3;3|];
  A.blit ~src:a0 ~srcOffset:(-1) ~dst:b0 ~dstOffset:2 ~len:5;
  eq __LOC__ (A.copy b0) 
    [|3;3;9;2;3;4;5;3;3;3|];
  A.blit ~src:a0 ~srcOffset:(-1) ~dst:b0 ~dstOffset:(-2) ~len:5;  
  eq __LOC__ (A.copy b0) 
    [|3;3;9;2;3;4;5;3;9;3|];
  A.blit ~src:a0 ~srcOffset:(-2) ~dst:b0 ~dstOffset:(-2) ~len:2;    
  eq __LOC__ (A.copy b0) 
    [|3;3;9;2;3;4;5;3;8;9|]; 
  A.blit ~src:a0 ~srcOffset:(-11) ~dst:b0 ~dstOffset:(-11) ~len:100;      
  eq __LOC__ (A.copy b0)  a0;
  A.blit ~src:a0 ~srcOffset:(-11) ~dst:b0 ~dstOffset:(-11) ~len:2;      
  eq __LOC__ (A.copy b0)  a0;
  let aa = A.makeBy 10 (fun x -> x) in 
  A.blit ~src:aa ~srcOffset:(-1) ~dst:aa ~dstOffset:1 ~len:2 ;
  eq __LOC__ (A.copy aa) [|0;9;2;3;4;5;6;7;8;9|];
  A.blit ~src:aa ~srcOffset:(-2) ~dst:aa ~dstOffset:1 ~len:2 ;
  eq __LOC__ (A.copy aa) [|0;8;9;3;4;5;6;7;8;9|];
  A.blit ~src:aa ~srcOffset:(-5) ~dst:aa ~dstOffset:4 ~len:3 ;
  eq __LOC__ (A.copy aa) [|0;8;9;3;5;6;7;7;8;9|];
  A.blit ~src:aa ~srcOffset:4 ~dst:aa ~dstOffset:5 ~len:3 ;
  eq __LOC__ (A.copy aa) [|0;8;9;3;5;5;6;7;8;9|]

let id loc x = 
  eq __LOC__ 
  (A.reverse x)
  (let u = A.copy x in A.reverseInPlace u; u)

let ()  =    
  id __LOC__ [||];
  id __LOC__ [|1|];
  id __LOC__ [|1;2|];
  id __LOC__ [|1;2;3|];
  id __LOC__ [|1;2;3;4|]
;;    

let () = 
  let module N = struct 
    let every2 xs ys = 
      A.every2 (L.toArray xs ) (L.toArray ys)
    let some2 xs ys =   
      A.some2 (L.toArray xs) (L.toArray ys)
  end in 
  eq __LOC__ (N.every2 [] [1] (fun   x y -> x > y)) true;  
  eq __LOC__ (N.every2 [2;3] [1] (fun   x y -> x > y)) true;    
  eq __LOC__ (N.every2 [2] [1] (fun   x y -> x > y)) true;
  eq __LOC__ (N.every2 [2;3] [1;4] (fun   x y -> x > y)) false;
  eq __LOC__ (N.every2 [2;3] [1;0] (fun   x y -> x > y)) true;  
  eq __LOC__ (N.some2 [] [1] (fun   x y -> x > y)) false;
  eq __LOC__ (N.some2 [2;3] [1] (fun   x y -> x > y)) true;  
  eq __LOC__ (N.some2 [2;3] [1;4] (fun   x y -> x > y)) true;
  eq __LOC__ (N.some2 [0;3] [1;4] (fun   x y -> x > y)) false;
  eq __LOC__ (N.some2 [0;3] [3;2] (fun   x y -> x > y)) true



let () = 
  eq __LOC__ (A.concat [||] [|1;2;3|]) [|1;2;3|];
  eq __LOC__ (A.concat [||] [||]) [||];
  eq __LOC__ (A.concat [|3;2|] [|1;2;3|]) [|3;2;1;2;3|];
  eq __LOC__ (A.concatMany [|[|3;2|]; [|1;2;3|] |]) [|3;2;1;2;3|];
  eq __LOC__ (A.concatMany [|[|3;2|]; [|1;2;3|];[||];[|0|] |]) [|3;2;1;2;3;0|];
  eq __LOC__ (A.concatMany [| [||]; [|3;2|]; [|1;2;3|];[||];[|0|] |]) [|3;2;1;2;3;0|];
  eq __LOC__ (A.concatMany [| [||]; [||] |]) [||];

;; Mt.from_pair_suites __LOC__ !suites  
