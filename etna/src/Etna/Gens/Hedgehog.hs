module Etna.Gens.Hedgehog (gen_integer_trie_round_trip) where

import qualified Hedgehog       as HH
import qualified Hedgehog.Gen   as Gen
import qualified Hedgehog.Range as Range

import Etna.Properties (Args(..))

gen_integer_trie_round_trip :: HH.Gen Args
gen_integer_trie_round_trip =
  Args <$> Gen.integral (Range.linearFrom 0 (-1000) 1000)
