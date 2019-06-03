## [0.4.0] - Add immutable state getter, explicit state unregister

- `EasyStatefulBuilder.getState('identifier')` returns the current state
    - You can access the current state using `returnedValue.currentState`
    - You can not change the current state
- `EasyStatefulBuilder.dispose('identifier')` explicitly unregister the state
    - Currently, the disposing order of this method and the actual widget should be considered. 

## [0.3.0] - Add keepAlive parameter

- Set state not to be disposed when `keepAlive` is true

## [0.2.2] - Add korean description

- Add more example
- Add korean description
- Fix typo

## [0.2.1] - Add examples and README

## [0.1.1] - Modify example and add description

## [0.1.0] - First release

- First release

## [0.0.1] - TODO: Add release date.
* TODO: Describe initial release.
