module Etna.Gens.QuickCheck (gen_integer_trie_round_trip) where

import qualified Test.QuickCheck as QC

import Etna.Properties (Args(..))

-- | Library-faithful generator for the @HasTrie Integer@ round-trip law.
--
-- The bug only fires for /negative/ integers (the bogus instance encodes
-- @Integer@ as @Word :->: a@, so any negative is sent through
-- @fromIntegral@'s wrap-modulo-2^64). A naïve symmetric range hands the
-- bug to the strategy on the very first sample, scoring "over-narrow".
--
-- Instead, draw from a wide non-negative range most of the time and mix
-- in negatives at low probability so the bug is reachable but does not
-- saturate every input.
gen_integer_trie_round_trip :: QC.Gen Args
gen_integer_trie_round_trip =
  Args <$> QC.frequency
    [ (95, QC.choose (0,                   2 ^ (62 :: Int)))
    , ( 3, QC.choose (-1000,               -1))
    , ( 2, QC.choose (-(2 ^ (62 :: Int)),  -1))
    ]
