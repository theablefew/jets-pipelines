### segment_1
```mermaid
sequenceDiagram
    participant job_1 as Job 1
participant job_2 as Job 2
participant job_2 as Job 2
participant end_of_queue as End Of Queue
    job_1->>job_2: {}
job_2->>end_of_queue: {}

```

### segment_2
```mermaid
sequenceDiagram
    participant api as Api
participant job_3 as Job 3
participant job_3 as Job 3
participant end_of_queue as End Of Queue
    api->>job_3: {}
job_3->>end_of_queue: {}

```

---
## Money Out
### incoming_cash_settlement
```mermaid
sequenceDiagram
    participant parse_cash_settlement_file as Parse Cash Settlement File
participant process_cash_settlement as Process Cash Settlement
participant process_cash_settlement as Process Cash Settlement
participant move_cold_to_hot as Move Cold To Hot
    parse_cash_settlement_file->>process_cash_settlement: {}
process_cash_settlement->>move_cold_to_hot: {}

```

### cold_to_hot
```mermaid
sequenceDiagram
    participant move_cold_to_hot as Move Cold To Hot
participant end_of_queue as End Of Queue
    move_cold_to_hot->>end_of_queue: {}

```

### incoming_cash_settlement
```mermaid
sequenceDiagram
    participant parse_cash_settlement_file as Parse Cash Settlement File
participant process_cash_settlement as Process Cash Settlement
participant process_cash_settlement as Process Cash Settlement
participant move_cold_to_hot as Move Cold To Hot
    parse_cash_settlement_file->>process_cash_settlement: {}
process_cash_settlement->>move_cold_to_hot: {}

```

### cold_to_hot
```mermaid
sequenceDiagram
    participant move_cold_to_hot as Move Cold To Hot
participant end_of_queue as End Of Queue
    move_cold_to_hot->>end_of_queue: {}

```

### wire_out
```mermaid
sequenceDiagram
    participant coinbase_exchange_deposits as Coinbase Exchange Deposits
participant convert_currency as Convert Currency
participant convert_currency as Convert Currency
participant send_wire as Send Wire
participant send_wire as Send Wire
participant end_of_queue as End Of Queue
    coinbase_exchange_deposits->>convert_currency: {}
convert_currency->>send_wire: {}
send_wire->>end_of_queue: {}
