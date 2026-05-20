module Etna.Gens.Falsify (gen_integer_trie_round_trip) where

import qualified Test.Falsify.Generator as F
import qualified Test.Falsify.Range     as FR

import Etna.Properties (Args(..))

-- | Library-faithful generator for the @HasTrie Integer@ round-trip law.
--
-- The bug only fires for negatives, so a symmetric range scores
-- "over-narrow". Bias toward a wide non-negative range and mix in
-- negatives at low probability. Falsify's `Range` requires
-- `FiniteBits`, so generate via Int and widen to Integer.
gen_integer_trie_round_trip :: F.Gen Args
gen_integer_trie_round_trip =
  (Args . toInteger) <$>
    F.frequency
      [ (95, F.inRange (FR.between (0 :: Int,                     2 ^ (60 :: Int))))
      , ( 3, F.inRange (FR.between ((-1000) :: Int,               -1)))
      , ( 2, F.inRange (FR.between ((-(2 ^ (60 :: Int))) :: Int,  -1)))
      ]
