module Etna.Properties
  ( Args(..)
  , property_integer_trie_round_trip
  ) where

import Data.MemoTrie (trie, untrie)
import Etna.Result   (PropertyResult(..))

-- | Single-Integer argument shared by all four backends.
newtype Args = Args { getArg :: Integer }
  deriving (Show, Eq)

-- | The defining round-trip law of `HasTrie Integer`:
--   For every Integer @n@, @untrie (trie f) n == f n@.
--
--   We instantiate @f@ to the Integer-valued identity. With a sound
--   @HasTrie Integer@ this holds for all Integers including negatives.
--   With the bogus @Word :->: a@ encoding (mutation
--   @integer_instance_word_overflow_1d65a86_1@) the equality fails for
--   every negative input because @fromIntegral :: Integer -> Word@
--   wraps modulo @2 ^ 64@.
property_integer_trie_round_trip :: Args -> PropertyResult
property_integer_trie_round_trip (Args n) =
  let memoised = untrie (trie (id :: Integer -> Integer)) n
   in if memoised == n
        then Pass
        else Fail $
               "untrie (trie id) " ++ show n
               ++ " == " ++ show memoised ++ " /= " ++ show n
