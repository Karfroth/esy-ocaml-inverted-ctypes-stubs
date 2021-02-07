let hello name = "Hello, " ^ name

let add a b = a + b

let fib n = 
	let rec aux i a b =
		if i = n then a
		else aux (i + 1) b (a + b) in 
	aux 0 0 1