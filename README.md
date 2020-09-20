# lua-callbag

Lightweight observables and iterables for Lua based on [Callbag Spec](https://github.com/callbag/callbag). 

## Source Factories

| Implemented   | Name                                                   |
|---------------|--------------------------------------------------------|
| No            | create                                                 |
| No            | empty                                                  |
| No            | fromEvent                                              |
| Yes           | fromIPairs                                             |
| No            | fromPromise                                            |
| No            | interval                                               |
| No            | lazy                                                   |
| No            | never                                                  |
| No            | of                                                     |
| No            | throwError                                             |

## Sink Factories

| Implemented   | Name                                                   |
|---------------|--------------------------------------------------------|
| Yes           | forEach                                                |
| Yes           | subscribe                                              |
| No            | toList                                                 |

## Multicasting

| Implemented   | Name                                                   |
|---------------|--------------------------------------------------------|
| No            | makeSubject                                            |
| No            | share                                                  |

## Operators

| Implemented   | Name                                                   |
|---------------|--------------------------------------------------------|
| No            | combine                                                |
| No            | concat                                                 |
| No            | debounceTime                                           |
| No            | delay                                                  |
| No            | distinctUntilChanged                                   |
| Yes           | filter                                                 |
| No            | flatten                                                |
| No            | group                                                  |
| Yes           | map                                                    |
| No            | materialize                                            |
| No            | merge                                                  |
| No            | scan                                                   |
| No            | switchMap                                              |
| No            | take                                                   |
| No            | takeUntil                                              |
| No            | takeWhile                                              |
| No            | tap                                                    |
| No            | dematerialize                                          |
| No            | concatWith                                             |
| No            | mergeWith                                              |
| No            | rescue                                                 |
| No            | retry                                                  |
| No            | skip                                                   |
| No            | throttle                                               |
| No            | timeout                                                |

## Utils

| Implemented   | Name                                                   |
|---------------|--------------------------------------------------------|
| No            | operate                                                |
| Yes           | pipe                                                   |

`pipe()`'s first argument should be a source factory.
`operate()` doesn't requires first function to be the source.

## License

MIT

## Author

Prabir Shrestha
