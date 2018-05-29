%% @author seyi akadri
%% @doc @todo Add description to crypto_thots.


-module(crypto_thots).

%% ====================================================================
%% API functions
%% ====================================================================
-export([split/1,test_split/1,is_composite/1,
		 prime_factorization/1,pf2/1,pf3/1,
		 hd_fac_is_prime/1,test_prime_facts/1,test_perfect_square/1,
		 generate/2,test_generate/2,
		 test_search/3,inner_search_helper/3,search/3,
		 test_perfect_powers/2,is_perfect_power/1]).
-record(crypto_system,{type}).
-record(intractable_cpu_problems,{factoring,rsap,qrp,sqroot,
								  dlp,gdlp,dhp,gdhp,subset_sum}).



%% ====================================================================
%% Internal functions
%% ====================================================================
solve(Computational_problem) ->
	error("Not yet Unimplemented").
determine_intractibility(Computational_problem) ->
	case solve(Computational_problem) of
		{ok,polytime} -> easy;
		{ok,exponential_time} -> intractable
	end.


algorithm_solution(Computation_problem) ->
	error("Not yet implemented").
poly_time_reduce(A,B) ->
	case algorithm_solution(A) of
		{ok,uses_b_subroutine,runs_in_polytime} -> true;
		{_,_,_} -> false
	end.

is_intractable(B,A) ->
	case poly_time_reduce(A,B) of
		true -> true;
		false -> false
	end.
%%def 3.2.
computational_equivalent(A,B) ->
	case (poly_time_reduce(A,B)) and (poly_time_reduce(B,A))  of
		true -> {ok,true};
			
		false ->{ok,false}
    end.


find_prime_factorization(Number) ->
	error("Not yet implemented").
	
%%Def 3.3. given a positive integer, n, find it's prime factorization,
%% that is write n = psub1expe1 ... psubkexpk where the psubiare pairwise,
%%distinct primes and each expi >= 1
%% remark 3.4 (primality versus factoring) ...beforeattempting to factor
%% an integer N, the integer should be tested to make sure that it is
%% indeed composite
integer_factorization_problem(N) ->
	Primes = find_prime_factorization(N).
	
%%Remark 3.5..Non trivial factorization of N of the from
%% n = ab , where 1 < a < n and a < b < n;
%% a and b are said to be no-trivial factors of n.
%% Here a and b are not necessariliy prime

split(N) ->
	NRoot = round(math:sqrt(N)),
	split(N,NRoot,2,[]).
		

split(N, Nroot,Countup,Acc) when (Countup  =< Nroot) and (Countup > 1) ->
	case (N rem Countup =:= 0) of
		true ->
			%%{A,B} = Countup
			split(N,Nroot,Countup+1,[{Countup,round(N/Countup)} | Acc]);
		false -> 
			split(N,Nroot,Countup+1,Acc)
	end;
split(_,_,_,Acc) ->
	lists:reverse(Acc).

test_split(N) ->
  [ (io:format("~p~p ~n" ,[X,split(X)])) || X <- lists:seq(1,N) ].

is_composite(N) ->
	case split(N) of 
		[] -> false;
	     _ -> true
   end.	

% [ {case crypto_thots:is_composite(X) of true -> crypto_thots:split(X); false -> X end ,case crypto_thots:is_composite(Y) of true -> crypto_thots:split(Y); false -> Y end}  ||  {X,Y}  <- crypto_thots:split(54) ]. 
prime_factorization(N) ->
	%Trivial_factors = split(N),
	prime_factorization(N,[]).
prime_factorization([{X,Y}] = TfacHead,Acc) when length(TfacHead) > 0 ->
  	%{X,Y} = hd(TfacHead),
	%% hd(split(Y))
	%io:format("args passed ~p~n",[TfacHead]),
	case is_composite(Y) of
		true ->
			%io:format("~p is composite ~n",[Y]),
			%io:format("~p is not composite ~n",[X]),
			%io:format("~p TfacHead ~n",[[{X,Y}]]),
             {X1,Y1} = hd(split(Y)),
			 %Acc1 = [X | Acc];
			%is_composite;
		    prime_factorization([hd(split(Y))],[X | Acc])  ;
			%io:format("~p current accumulator value ~n",[Acc1]);
			%[X | prime_factorization(hd(split(Y)),Acc) ] ;
		false ->
			%io:format("false occured at ~p ~p~n",[X,Y]),
			[X | prime_factorization([(split(Y))],[Y | Acc])];
			
		_ ->
			io:format("shouldnt get here?"),
			shouldnt_get_here
	end;


prime_factorization(T,Acc) -> 
	%io:format("end of loop when T is ~p~n",[T]),
							  lists:reverse(Acc).

pf2(N) ->
	[ {case crypto_thots:is_composite(X) of
		   true -> crypto_thots:split(X); 
		   false -> X end ,
	   case crypto_thots:is_composite(Y) of 
		   true -> crypto_thots:split(Y); 
		   false -> Y end}  ||  {X,Y}  <- crypto_thots:split(N) ].

%% call to local/imported function is_composite/1 is illegal in guard
%% pf3(N) when is_composite(N) ->
%% 	is_composite;
%% pf3(_) ->
%% 	not_composite.
-type prime_nos() :: prime_nos().
-spec prime_nos() -> Number when
		  Number ::prime_nos().
prime_nos() ->
	error("Undefined function").
-type trivial_factors() :: [number()].

	

-spec pf3(N) -> [prime_nos()] when
		  N::[trivial_factors()]. 
		  
pf3(N) when length(N) > 0 ->
	{X,_} = hd(N);
	
pf3(_) ->
	composite.

%%  lists:foreach(fun(N) -> 
%%      io:format("~p is composite? ~p~n",[N,crypto_thots:pf3([ (X5) || X5<- crypto_thots:split(N) ] )]) end,lists:seq(1,100)) .

%% prove_that_first factor will be a prime
hd_fac_is_prime(N) ->
	lists:foreach(fun(N) -> 
      io:format("~p is composite? ~p~n",
				[N,crypto_thots:pf3([ (X5) || X5<- crypto_thots:split(N) ] )]) end,lists:seq(1,100)) .

test_prime_facts(N) ->
   [ io:format("At ~p pfac are ~p~n",[X,crypto_thots:prime_factorization([hd(crypto_thots:split(X))])]) || X <- lists:seq(1,N),crypto_thots:is_composite(X)].

%% 3.6 note Testing for perfect powers
%% if N >= 2 , testing for perfect power ie
%% N = (x)exp(k) for some integers x >= 2, k >= 2
%% for each p =< ln N   prime in range 2 to math:log2(N).    

%%, an integer approximation
%% x of {n}exp(1/p) is computed...
%% done by computing a binary search for x satisfying
%% n = {x}exp(p) in the interval 
%% [2, {2}exp((log N/P) +1)] math:pow(2,(math:log(64/2) ) + 1).

%%  math:pow(2,(math:log(64/2) ) + 1).
%% 22.09634588208995
%% 33> math:pow(2,(math:log(36/2) ) + 1).
%%14.829229737434863

is_perfect_power(N) when N >= 2 ->
	search(x_exp_prime,N,generate(primes_less_number_log_n,N));
is_perfect_power(_) ->
	error("bad argument").

%simple search, binary search will be more efficient of course
%search(x_exp_prime,N,X_Interval,Primes) ->
%	search(x_exp_prime,N,X_Interval,Primes);


search(x_exp_prime,N,[P|PT]) ->
	case inner_search_helper(generate(x_interval_for_prime,{N,P}
								),N,P) of
		{true,X,Exp} ->
			{true,X,Exp};
		not_found ->
			search(x_exp_prime,N,PT)
	end;
			
		

search(x_exp_prime,N,[]) -> 
	false.
test_search(x_exp_prime,N,Primes) ->
	search(x_exp_prime,N,Primes).

inner_search_helper([X|XT],N,P) ->
	case (floor(math:pow(X,P))  ) =:= N  of
		
		true -> {true,X,P};
		false -> inner_search_helper(XT,N,P)
	end;

inner_search_helper([],N,P) -> not_found.

test_inner_search_helper(N,P) ->
	crypto_thots:inner_search_helper(crypto_thots:generate(x_interval_for_prime,{N,P}),N,P).

test_perfect_powers(From,To) ->
	[ lists:map(fun(X) -> 
						case ( crypto_thots:search(x_exp_prime,X,crypto_thots:generate(primes_less_number_log_n,X))) of 
							   {Res,Base,Exp} -> io:format("~p is perfect power (~p raise to power ~p = ~p~n)",[X,Base,Exp,floor(math:pow(Base,Exp))]);
							   false -> ok end  end,[X]) || X<- lists:seq(From,To)  ].


	

	
% lists:seq(2,math:floor(Logn))
generate(primes_less_number_log_n,N) ->
	[X || X<- lists:seq(2,round(math:floor(math:log2(N)))),(not is_composite(X))];

generate(x_interval_for_prime,{N,P}) ->
	lists:seq(2,round(math:floor(math:pow(2,(math:log(N/P) ) + 1)))).	


test_generate(From,To) ->
	[io:format("N is ~p and primes less than logN are ~p~n",
			   [X,generate(primes_less_number_log_n,X)]) || X <-
	   lists:seq(From,To)].
	
test_perfect_square(N) ->
  [io:format("~p is a perfect square with root ~p~n",[X,(floor(math:sqrt(X)))]) || X <- lists:seq(1,N),
													  (math:sqrt(X) - (floor(math:sqrt(X)) + float(0.0001))) < float(0.0001),X > 1].

