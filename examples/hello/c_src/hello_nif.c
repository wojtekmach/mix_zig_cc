// Based on https://erlang.org/doc/tutorial/nif.html

#include <erl_nif.h>

static ERL_NIF_TERM hello(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  return enif_make_atom(env, "world");
}

static ErlNifFunc nif_funcs[] = {
  {"hello", 0, hello}
};

ERL_NIF_INIT(Elixir.HelloNIF, nif_funcs, NULL, NULL, NULL, NULL);
