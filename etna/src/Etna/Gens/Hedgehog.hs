module Etna.Gens.Hedgehog (gen_integer_trie_round_trip) where

import qualified Hedgehog       as HH
import qualified Hedgehog.Gen   as Gen
import qualified Hedgehog.Range as Range

import Etna.Properties (Args(..))

-- | Library-faithful generator for the @HasTrie Integer@ round-trip law.
--
-- The bug only fires for negatives, so a symmetric range scores
-- "over-narrow". Bias toward a wide non-negative range and mix in
-- negatives at low probability.
gen_integer_trie_round_trip :: HH.Gen Args
gen_integer_trie_round_trip =
  Args <$> Gen.frequency
    [ (95, Gen.integral (Range.linear 0 (2 ^ (62 :: Int))))
    , ( 3, Gen.integral (Range.linear (-1000) (-1)))
    , ( 2, Gen.integral (Range.linear (-(2 ^ (62 :: Int))) (-1)))
    ]
