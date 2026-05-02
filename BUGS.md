# MemoTrie — Injected Bugs

Trie-based generic memoization library (conal/MemoTrie). Bug fixes mined from upstream history; modern HEAD is the base, each patch reverse-applies a fix to install the original bug.

Total mutations: 1

## Bug Index

| # | Variant | Name | Location | Injection | Fix Commit |
|---|---------|------|----------|-----------|------------|
| 1 | `integer_instance_word_overflow_1d65a86_1` | `integer_trie_breaks_for_negatives` | `src/Data/MemoTrie.hs:499` | `patch` | `1d65a863579b91ee7c0d06cf1c2eb1b8ed9a44da` |

## Property Mapping

| Variant | Property | Witness(es) |
|---------|----------|-------------|
| `integer_instance_word_overflow_1d65a86_1` | `IntegerTrieRoundTrip` | `witness_integer_trie_round_trip_case_neg_one`, `witness_integer_trie_round_trip_case_neg_three`, `witness_integer_trie_round_trip_case_neg_hundred` |

## Framework Coverage

| Property | quickcheck | hedgehog | falsify | smallcheck |
|----------|---------:|-------:|------:|---------:|
| `IntegerTrieRoundTrip` | ✓ | ✓ | ✓ | ✓ |

## Bug Details

### 1. integer_trie_breaks_for_negatives

- **Variant**: `integer_instance_word_overflow_1d65a86_1`
- **Location**: `src/Data/MemoTrie.hs:499` (inside `instance HasTrie Integer`)
- **Property**: `IntegerTrieRoundTrip`
- **Witness(es)**:
  - `witness_integer_trie_round_trip_case_neg_one` — untrie (trie id) (-1) must equal -1
  - `witness_integer_trie_round_trip_case_neg_three` — untrie (trie id) (-3) must equal -3
  - `witness_integer_trie_round_trip_case_neg_hundred` — untrie (trie id) (-100) must equal -100
- **Source**: internal — fixed Integer instance
  > The bogus Integer instance encoded the trie as `Word :->: a`, mapping every Integer through `fromIntegral :: Integer -> Word`. For negative inputs that conversion wraps modulo 2^64, so `untrie (trie f) n` evaluates `f` at a huge positive Word index instead of `n`. The fix encodes Integer as `(sign, bits abs)` via the helper pair `bitsZ`/`unbitsZ`, which is total over Integer and round-trips through the trie.
- **Fix commit**: `1d65a863579b91ee7c0d06cf1c2eb1b8ed9a44da` — fixed Integer instance
- **Invariant violated**: For every Integer n, `untrie (trie id) n == n`. Equivalently, the `HasTrie Integer` instance must round-trip every Integer including negatives — `untrie . trie == id`.
- **How the mutation triggers**: Reverse-applying the patch swaps the `(Bool,[Bool])`-based Integer trie back to the bogus `Word`-based form. Calling `untrie (trie id) (-1)` then returns `toInteger (maxBound :: Word)` (= 18446744073709551615 on a 64-bit machine) instead of `-1`.
