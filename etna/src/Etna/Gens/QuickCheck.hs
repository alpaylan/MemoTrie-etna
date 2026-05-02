module Etna.Gens.QuickCheck (gen_integer_trie_round_trip) where

import qualified Test.QuickCheck as QC

import Etna.Properties (Args(..))

-- | Sample Integer values from a small symmetric range so the generator
--   reliably hits negatives (where the bogus instance fails) without
--   blowing up the trie depth on huge positives.
gen_integer_trie_round_trip :: QC.Gen Args
gen_integer_trie_round_trip =
  Args <$> QC.choose ((-1000), 1000)
