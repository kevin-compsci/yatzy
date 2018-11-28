-module(yatzy_scoresheet).
-export([new/0, fill/3, get/2, upper_total/1, bonus/1, lower_total/1, total/1]).

-type t() :: map().
-spec new() -> t().
-spec fill(yatzy:slot(), yatzy:roll(), t()) -> {'ok', t()}
                                             | 'already_filled'
                                             | 'invalid_slot'.
-spec get(yatzy:slot(), t()) -> {'filled', non_neg_integer()}
                              | 'invalid_slot'
                              | 'empty'.
-spec upper_total(t()) -> non_neg_integer().
-spec bonus(t()) -> 0 | 50.
-spec lower_total(t()) -> non_neg_integer().
-spec total(t()) -> non_neg_integer().


new() -> 
	#{}.

fill(Slot, Roll, Sheet) ->
	case the_slot_type(Slot) of
		false -> 
			'invalid_slot';
		true ->
			case maps:get(Slot, Sheet, 'empty') of
				'empty' -> 
					Score = yatzy_score:calc(Slot, Roll),
					NewSheet = maps:put(Slot, Score, Sheet),
					{'ok', NewSheet};
				_ ->
					'already_filled'
			end
	end.

get(Slot, Sheet) ->
	case the_slot_type(Slot) of
		false ->
			'invalid_slot';
		true -> 
			case maps:get(Slot, Sheet, 'is_empty') of
				'is_empty' -> 
					'empty';
				_ ->
					{'filled', maps:get(Slot, Sheet)}
			end
	end.

upper_total(Sheet) ->
	Uppers = maps:with(['ones', 'twos', 'threes', 'fours', 'fives', 'sixes'], Sheet),
	lists:sum(maps:values(Uppers)).

bonus(Sheet) ->
	case (upper_total(Sheet) >= 63) of
		true ->
			50;
		false ->
			0
	end.

lower_total(Sheet) ->
	Lower = maps:with(['chance', 'one_pair', 'two_pairs', 'three_of_a_kind', 'four_of_a_kind', 'small_straight', 
						'large_straight', 'full_house', 'yatzy'], Sheet),
	lists:sum(maps:values(Lower)).

total(Sheet) ->
	upper_total(Sheet) + lower_total(Sheet) + bonus(Sheet).


the_slot_type(Slot) -> 
	lists:member(Slot, ['chance', 'ones', 'twos', 'threes', 'fours', 'fives', 'sixes', 'one_pair', 'two_pairs', 'three_of_a_kind', 'four_of_a_kind', 'small_straight', 'large_straight', 'full_house', 'yatzy']).
