# MemoTrie — ETNA Tasks

Total tasks: 4

## Task Index

| Task | Variant | Framework | Property | Witness |
|------|---------|-----------|----------|---------|
| 001 | `integer_instance_word_overflow_1d65a86_1` | quickcheck | `IntegerTrieRoundTrip` | `witness_integer_trie_round_trip_case_neg_one` |
| 002 | `integer_instance_word_overflow_1d65a86_1` | hedgehog | `IntegerTrieRoundTrip` | `witness_integer_trie_round_trip_case_neg_one` |
| 003 | `integer_instance_word_overflow_1d65a86_1` | falsify | `IntegerTrieRoundTrip` | `witness_integer_trie_round_trip_case_neg_one` |
| 004 | `integer_instance_word_overflow_1d65a86_1` | smallcheck | `IntegerTrieRoundTrip` | `witness_integer_trie_round_trip_case_neg_one` |

## Witness Catalog

- `witness_integer_trie_round_trip_case_neg_one` — untrie (trie id) (-1) must equal -1
- `witness_integer_trie_round_trip_case_neg_three` — untrie (trie id) (-3) must equal -3
- `witness_integer_trie_round_trip_case_neg_hundred` — untrie (trie id) (-100) must equal -100
