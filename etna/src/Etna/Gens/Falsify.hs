module Etna.Gens.Falsify (gen_integer_trie_round_trip) where

import qualified Test.Falsify.Generator as F
import qualified Test.Falsify.Range     as FR

import Etna.Properties (Args(..))

-- | Falsify's `Range` requires `FiniteBits`, so generate via Int and
--   widen to Integer.  The range covers negatives (where the bogus
--   instance fails) and a small positive corridor.
gen_integer_trie_round_trip :: F.Gen Args
gen_integer_trie_round_trip =
  (Args . toInteger) <$>
    F.inRange (FR.between ((-1000 :: Int), 1000))
