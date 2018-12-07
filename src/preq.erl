-module(preq).

-type request() :: {Tag::atom(), mfargs()}.
-type mfargs() :: {Mod::module(), Fun::atom, Args::[term()]}.
-type result() :: {Tag::atom(), Res::term()}.

-spec execute(PreqPid::pid(), [request()]) -> {ok, [result()]}
                                             | {error, Reason::any()}.