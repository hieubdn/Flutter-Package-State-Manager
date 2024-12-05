# Flutter Package State Manager

A lightweight and easy-to-use state management package for Flutter applications. 

## Features
- Manage simple and complex state types.
- Support synchronous and asynchronous state updates.
- Observe and respond to state changes.

## Example

```dart
final manager = StateManager();

// Create state
manager.createState<int>('counter', 0);

// Update state
manager.updateState<int>('counter', 1);

// Reset state
manager.resetState<int>('counter', 0);

// Observe state changes
manager.observeState('counter', () {
  print("Counter updated: ${manager.getState<int>('counter')}");
});
#   F l u t t e r - P a c k a g e - S t a t e - M a n a g e r  
 