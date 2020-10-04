# lua-callbag

Lightweight observables and iterables for Lua based on [Callbag Spec](https://github.com/callbag/callbag). 

## Source Factories

| Implemented   | Name                                                   |
|---------------|--------------------------------------------------------|
| Yes           | create                                                 |
| Yes           | empty                                                  |
| Yes           | fromEvent                                              |
| Yes           | fromIPairs                                             |
| No            | fromPromise                                            |
| No            | interval                                               |
| Yes           | lazy                                                   |
| Yes           | never                                                  |
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
| Yes           | debounceTime                                           |
| No            | delay                                                  |
| Yes           | distinctUntilChanged                                   |
| Yes           | filter                                                 |
| No            | flatten                                                |
| No            | group                                                  |
| Yes           | map                                                    |
| No            | materialize                                            |
| Yes           | merge                                                  |
| No            | scan                                                   |
| Yes           | switchMap                                              |
| No            | take                                                   |
| Yes           | takeUntil                                              |
| No            | takeWhile                                              |
| Yes           | tap                                                    |
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
