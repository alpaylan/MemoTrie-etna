module Etna.Witnesses
  ( witness_integer_trie_round_trip_case_neg_one
  , witness_integer_trie_round_trip_case_neg_three
  , witness_integer_trie_round_trip_case_neg_hundred
  ) where

import Etna.Properties (Args(..), property_integer_trie_round_trip)
import Etna.Result     (PropertyResult)

witness_integer_trie_round_trip_case_neg_one :: PropertyResult
witness_integer_trie_round_trip_case_neg_one =
  property_integer_trie_round_trip (Args (-1))

witness_integer_trie_round_trip_case_neg_three :: PropertyResult
witness_integer_trie_round_trip_case_neg_three =
  property_integer_trie_round_trip (Args (-3))

witness_integer_trie_round_trip_case_neg_hundred :: PropertyResult
witness_integer_trie_round_trip_case_neg_hundred =
  property_integer_trie_round_trip (Args (-100))
