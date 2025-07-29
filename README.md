# Counter::counter Module

A simple Move smart contract module on the Sui blockchain that provides global and personal counter functionalities. It supports creation, manipulation, and deletion of counters, along with event emission for off-chain tracking.

## 🔧 Features

- **Global counter** (shared across all users)
- **Personal counter** (owned by individual users)
- Increment, decrement, reset operations
- Event emission for all state-changing actions
- Safe object creation and transfer mechanisms

## 📁 Module Structure


This module is declared under the `counter` package. 

## 📦 Structs

### 🔢 GlobalCounter

A globally shared counter.


### 🙋‍♂️ PersonalCounter

A counter owned by an individual user.


## 📣 Events

Events are emitted for off-chain indexing, analytics, and user notifications.

| Event Struct               | Trigger Event                        |
|----------------------------|-------------------------------------|
| GlobalCounterCreated       | When global counter is initialized  |
| GlobalCounterIncremented   | When global counter is incremented  |
| GlobalCounterDecremented   | When global counter is decremented  |
| PersonalCounterCreated     | When personal counter is created    |
| PersonalCounterIncremented | When personal counter is incremented|
| PersonalCounterDecremented | When personal counter is decremented|
| PersonalCounterReset       | When personal counter is reset to 0 |


## 🛠️ Functions

- **init(ctx: &mut TxContext)**  
  Creates and shares a global counter object.  
  Emits: `GlobalCounterCreated`  
  Shared via: `transfer::share_object`

- **increment_global_counter(global_counter: &mut GlobalCounter, ctx: &mut TxContext)**  
  Increments the shared global counter by 1.  
  Emits: `GlobalCounterIncremented`

- **decrement_global_counter(global_counter: &mut GlobalCounter, ctx: &mut TxContext)**  
  Decrements the shared global counter by 1.  
  Emits: `GlobalCounterDecremented`

- **create_personal_counter(ctx: &mut TxContext)**  
  Creates a `PersonalCounter` for the transaction sender.  
  Ownership: Transferred using `transfer::public_transfer`  
  Emits: `PersonalCounterCreated`

- **increment_personal_counter(personal_counter: &mut PersonalCounter, ctx: &mut TxContext)**  
  Increments the value of a personal counter by 1.  
  Emits: `PersonalCounterIncremented`

- **decrement_personal_counter(personal_counter: &mut PersonalCounter, ctx: &mut TxContext)**  
  Decrements the value of a personal counter by 1.  
  Emits: `PersonalCounterDecremented`

- **reset_personal_counter(personal_counter: &mut PersonalCounter, ctx: &mut TxContext)**  
  Resets the personal counter value to 0.  
  Emits: `PersonalCounterReset`

- **delete_personal_counter(personal_counter: PersonalCounter, ctx: &mut TxContext)**  
  Deletes a personal counter and consumes its UID.  
  ⚠️ This action is irreversible. Only deletes personal counters, not global.


## 🧪 Usage Flow

1. **Initialize Global Counter** (during deployment)  
2. **Create Personal Counter** (user)  
3. **Perform actions:**  
   - `increment_global_counter`  
   - `decrement_global_counter`  
   - `increment_personal_counter`  
   - `decrement_personal_counter`  
   - `reset_personal_counter`  
   - Delete personal counter if needed





