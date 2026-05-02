module Main where

import Etna.Result    (PropertyResult(..))
import Etna.Witnesses
  ( witness_integer_trie_round_trip_case_neg_one
  , witness_integer_trie_round_trip_case_neg_three
  , witness_integer_trie_round_trip_case_neg_hundred
  )
import System.Exit    (exitFailure, exitSuccess)

main :: IO ()
main = do
  let cases =
        [ ( "witness_integer_trie_round_trip_case_neg_one"
          , witness_integer_trie_round_trip_case_neg_one )
        , ( "witness_integer_trie_round_trip_case_neg_three"
          , witness_integer_trie_round_trip_case_neg_three )
        , ( "witness_integer_trie_round_trip_case_neg_hundred"
          , witness_integer_trie_round_trip_case_neg_hundred )
        ]
  let failures =
        [ (n, msg)     | (n, Fail msg) <- cases ] ++
        [ (n, "discard") | (n, Discard) <- cases ]
  if null failures
    then exitSuccess
    else do
      mapM_ (\(n, m) -> putStrLn (n ++ ": " ++ m)) failures
      exitFailure
