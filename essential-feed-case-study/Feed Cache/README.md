#  Use Cases

## Load Feed From Cache Use Case

### Primary course:
    1. Execute "Load Image Feed" command with above data.
    2. System retrieves feed data from cache.
    3. System validates cache is less than seven days old.
    4. System creates image feed from cached data.
    5. System delivers image feed.
    
### Retrieval error course (sad path):
    1. System delivers error.
    
### Expired cache course (sad path):
    1. System delivers no feed images.
    
### Empty cache course (sad path):
    1. System delivers no feed images.
    
## Validate Feed Cache Use Case

### Primary course:
    1. Execute "Validate Cache" command with above data.
    2. System retrieves feed data from cache.
    3. System validates cache is less than seven days old.
    
### Retrieval error course (sad path):
    1. System deletes cache.
    
### Expired cache course (sad path):
    1. System deletes cache.
    
## Cache Feed Use Case

Data:
- Image Feed

### Primary course (happy path):
    1. Execute "Save Image Feed" command with above data.
    2. System deletes old cache data.
    3. System encodes image feed.
    4. System timestamps the new cache.
    5. System saves new cache data.
    6. System delivers success message.

### Deleting error course (sad path):
    1. System delivers error.
    
### Saving error course (sad path):
    1. System delivers error.
  
## FeedStore implementation Inbox (checklist inbox). 
Created and used by the developers (iOS developers)

[x] Retrieve
    [x] Empty cache returns empty
    [x] Empty cache twice returns empty (no side-effects)
    [x] Non-empty cache returns data
    [x] Non-empty cache twice returns same data (no side-effects)
    [x] Error returns error (if applicable, e.g., invalid data)
    [x] Error twice returns same error (if applicable, e.g., invalid data)
[x] Insert
    [x] To empty cache stores data
    [x] To non-empty cache overrides previous data with new data
    [x] Error (if applicable, e.g., no write permission)
[x] Delete
    [x] Empty cache does nothing (cache stays empty and does not fail)
    [x] Non-empty cache leaves cache empty
    [x] Error (if applicable, e.g., no delete permission)
[x] Side-effects must run serially to avoid race-conditions
    
