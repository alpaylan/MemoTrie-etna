{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
module Etna.Gens.SmallCheck (series_integer_trie_round_trip) where

import qualified Test.SmallCheck.Series as SC

import Etna.Properties (Args(..))

-- | Library-faithful enumeration for the @HasTrie Integer@ round-trip
-- law.
--
-- The default @Serial m Integer@ enumerates @0, 1, -1, 2, -2, …@, so
-- the bug-triggering @-1@ surfaces at depth 1 — over-narrow. Instead,
-- enumerate a wide block of non-negatives at each depth before any
-- negatives, so the bug is still reachable (witnesses pin -1, -3, -100)
-- but not the very first datum the strategy sees.
series_integer_trie_round_trip :: Monad m => SC.Series m Args
series_integer_trie_round_trip = SC.generate $ \d ->
  let bound       = max 1 (fromIntegral d) * 50 :: Integer
      nonnegs     = [0 .. bound]
      negs        = [-1, -3, -7, -42, -100, -1000, -(2 ^ (32 :: Int))]
   in map Args (nonnegs ++ negs)
