{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE MultiParamTypeClasses #-}
module Etna.Gens.SmallCheck (series_integer_trie_round_trip) where

import qualified Test.SmallCheck.Series as SC

import Etna.Properties (Args(..))

-- | SmallCheck's built-in `Serial m Integer` enumerates
--   @0, 1, -1, 2, -2, 3, -3, ...@ in order, so depth 5 already covers
--   the bug-triggering negatives.
series_integer_trie_round_trip :: Monad m => SC.Series m Args
series_integer_trie_round_trip = Args <$> SC.series
