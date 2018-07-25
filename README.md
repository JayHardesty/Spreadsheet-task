#  Spreadsheet Task
### Jay Hardesty

## Design Notes

A singleton `Spreadsheet` object reads text from a file URL, and builds an array of `Cell` objects, each of which includes a 'Calculation`. Since the row/column format has no functional meaning here, the cell array is 1D. 

A function to convert from cell name ("a1", "AC2", etc.) to array index was perhaps overkill in hindsight. I could have placed cells by name in a dictionary, but then it would have been a little more work to reassemble the rows and columns on output. 

`Cell` and `Calculation` objects are one-to-one and could have been a single class, but I used `Cell` to separate out the check for circularity.

The completion block for the `Spreadsheet` `read` function could have been omitted and a dedicated `printResult` function used instead, but the completion leaves control outside (e.g. for unit tests).

I haven't tested on sets yet (because time is up - by necessity this project was done over the course of a day interspersed with other tasks). The requirements mention "no need to cache" but that came for free with the lazy Swift var (though perhaps I'm missing a more elegant algorithm that wouldn't have permitted this caching).

Thanks for taking a look; I'm sure there's room for improvement.

