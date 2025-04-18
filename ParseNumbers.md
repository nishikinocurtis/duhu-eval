# Extract Data from Raylet.out:

## Vanilla

- Push time: Pattern matching on 

```log
[state-dump] 	ObjectManager.Push - 576 total (0 active), Execution time: mean = 5.252 ms, total = 3.025 s, Queueing time: mean = 91.010 ms, max = 425.289 ms, min = 6.326 us, total = 52.422 s
```


## Duhu

```log
ObjectManager.SendKVSKey - 200 total (0 active), Execution time: mean = 85.214 us, total = 17.043 ms
```