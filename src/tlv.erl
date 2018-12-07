-module(tlv).

-export([encode/1, decode/1, test/1]).
-export([mEncode/2, mDecode/1]).

-define(INTEGER, 0).
-define(ATOM, 1).
-define(BINARY, 2).
-define(MAP, 3).

% Type
	% A binary code, often simply alphanumeric, which indicates the kind of field that this part of the message represents;
% Length
	%The size of the value field (typically in bytes);
% Value
	% Variable-sized series of bytes which contains data for this part of the message.

% > tlv:encode(<<"hi">>).
% <<32,1,6,134,9:4>>

% io:format("~p~n", [Len]),



%TESTING ONLY
test(MyMap) ->
	List = maps:to_list(MyMap),
	Bin = mEncode(List, <<>>),
	Len = bit_size(Bin),
	Encoding = <<3:4, Len:16, Bin/bitstring>>,
	Encoding.

%Decode: Integer, Atoms, Binary, and Maps
decode(<<?ATOM:4, L:16, V:L/bitstring, Rest/bitstring>>) ->
	{binary_to_atom(V, latin1), Rest};
decode(<<?BINARY:4, L:16, V:L/bitstring, Rest/bitstring>>) ->
	{V, Rest};
decode(<<?INTEGER:4, L:16, V:L, Rest/bitstring>>) ->
	{V, Rest};
decode(<<?MAP:4, L:16, V:L/bitstring, Rest/bitstring>>) -> % IDEA: V -> [KEY, VALUE, KEY2, VALUE2, ... , KEYn, VALUEn]
	%io:format("~p~n", [V]),
	% <<T1:4, L1:16, V1:L1/bitstring, Rest1/bitstring>> = V,
	KVList = mDecode(V),
	{maps:from_list(KVList), Rest}.

	
% decode(<<?MAP, Len:16, Encoded:Len>>) ->
% 	io:format("~p~n", [decode(Encoded)]),
% 	%get K:V binaries again from Encoded
% 	%call decode on each K and V pair
% 	%insert each item back into map
% 	example.

%Encode: Integer, Atoms, Binary, and Maps
encode(Num) when is_atom(Num) ->
	Bin = atom_to_binary(Num, latin1),
	Len = bit_size(Bin),
	<<?ATOM:4, Len:16, Bin/bitstring>>;
encode(Num) when is_binary(Num) ->
	Len = bit_size(Num),
	<<?BINARY:4, Len:16, Num/bitstring>>;
encode(Num) when is_integer(Num) -> 
	Len = 32,
	<<?INTEGER:4, Len:16, Num:Len>>.

%Map Encoding helper function (Tail Recursion)
mEncode([], Bin) ->
	Bin;
mEncode([{K,V}|Z], Bin) ->
	KeyBinary = encode(K),
	ValBinary = encode(V),
	NewBin = <<KeyBinary/bitstring, ValBinary/bitstring, Bin/bitstring>>,
	mEncode(Z, NewBin).

%Map Decode helper
mDecode(<<>>) ->
	[];
mDecode(KVBin) ->
	%io:format("~p~n", [decode(V)]),
	{Key, Rest} = decode(KVBin),
	{Value, Rest2} = decode(Rest),
	io:format("~p~n", [{Key, Value}]),
	[{Key, Value} | mDecode(Rest2)].


% size_of_input(Value) ->
% 	case Value =< (math:pow(2,8) - 1) of 
% 		true ->
% 			8;
% 		false ->
% 			case Value =< (math:pow(2,16) - 1) of
% 				true ->
% 					16;
% 				false ->
% 					case Value =< (math:pow(2,24) - 1) of
% 						true ->
% 							24;
% 						false ->
% 							32
% 					end 
% 			end 
% 	end.