# MemoTrie ETNA workload

This directory is the upstream `conal/MemoTrie` clone wrapped as an ETNA
benchmark workload.  The base tree is the upstream HEAD
(`dd3f6a2290d00872178ed304be3e061a1a5a8183`); each variant lives as a
patch under `patches/` that, when reverse-applied with
`git apply -R`, re-introduces a historical bug.

The runner package lives under `etna/` and exposes a single executable
`etna-runner <tool> <property>` that emits one JSON line on stdout and
exits 0 except on an argv-parse error.  Four backends are wired up
verbatim from the run-haskell.md template: QuickCheck, Hedgehog,
Falsify, SmallCheck, plus the witness-replay backend `etna`.

## Layout

```
MemoTrie/
  src/Data/MemoTrie.hs           # upstream — DO NOT EDIT
  MemoTrie.cabal                 # upstream — DO NOT EDIT
  cabal.project                  # ours — pins packages: . etna/
  etna.toml                      # ours — single source of truth
  patches/
    integer_instance_word_overflow_1d65a86_1.patch
  etna/
    etna-runner.cabal
    src/Etna/{Result,Properties,Witnesses}.hs
    src/Etna/Gens/{QuickCheck,Hedgehog,Falsify,SmallCheck}.hs
    app/Main.hs                  # runner CLI
    test/Witnesses.hs            # cabal test-suite for base witnesses
  BUGS.md                        # generated
  TASKS.md                       # generated
  progress.jsonl                 # per-run log (gitignored)
```

## Variant: `integer_instance_word_overflow_1d65a86_1`

* Upstream commit: [`1d65a86`](https://github.com/conal/MemoTrie/commit/1d65a863579b91ee7c0d06cf1c2eb1b8ed9a44da) — "fixed Integer instance".
* Bug: the bogus `HasTrie Integer` instance encoded the trie as
  `Word :->: a` and routed every `Integer` through `fromIntegral`. For
  negative inputs that conversion wraps modulo `2 ^ 64`, so
  `untrie (trie f) n` evaluates `f` at a huge positive Word index
  instead of `n`. The fix encodes the value as `(sign, bits abs)` via
  the helpers `bitsZ` / `unbitsZ`, which is total over `Integer`.
* Property: `IntegerTrieRoundTrip` —
  `untrie (trie id) n == n` for every `Integer n`.
* Witnesses: `n ∈ {-1, -3, -100}`. Each fails on the buggy tree because
  the result is a 19-digit positive integer rather than the negative
  input.
* All four backends discover the bug well within their default budgets
  (the SmallCheck depth-5 series enumerates `[0, 1, -1, 2, -2, ...]`,
  hitting `-1` on the third value).

## Running

```sh
cd workloads/Haskell/MemoTrie

# 1. Base witnesses must all pass.
cabal test etna-witnesses

# 2. Per-backend dispatch (single property in this workload).
cd etna
cabal run etna-runner -- etna       IntegerTrieRoundTrip
cabal run etna-runner -- quickcheck IntegerTrieRoundTrip
cabal run etna-runner -- hedgehog   IntegerTrieRoundTrip
cabal run etna-runner -- falsify    IntegerTrieRoundTrip
cabal run etna-runner -- smallcheck IntegerTrieRoundTrip

# 3. Install the bug, repeat, restore.
git -C .. apply -R --whitespace=nowarn ../patches/integer_instance_word_overflow_1d65a86_1.patch
cabal run etna-runner -- quickcheck IntegerTrieRoundTrip   # status: failed
git -C .. apply    --whitespace=nowarn ../patches/integer_instance_word_overflow_1d65a86_1.patch
```

## GHC pin

The runner expects GHC 9.6.6 (Falsify ≥ 0.2 needs base ≥ 4.18). The
toolchain is pinned through `cabal.project`'s `with-compiler:` field;
edit it if you install a newer 9.6.x patch release.
