> Source: https://ksp-kos.github.io/KOS/structures/misc/resource_transfer.html (mirrored offline copy for local reference)

# Resource Transfer

Usage is covered elsewhere in the resource transfer commands documentation.

## Structure

**structure** ResourceTransfer

### Members

| Suffix | Type | Access | Description |
|--------|------|--------|-------------|
| `STATUS` | String | Get only | The String status of the transfer (e.g., "Inactive", "Transferring", "Failed", "Finished") |
| `MESSAGE` | String | Get only | A message about the current status |
| `GOAL` | Scalar | Get only | The amount of resource that will be transferred |
| `TRANSFERRED` | Scalar | Get only | The amount of resource that has been transferred |
| `RESOURCE` | String | Get only | The name of the resource (e.g., oxidizer, liquidfuel) |
| `ACTIVE` | Boolean | Get / Set | Setting this value will start, pause, or restart a transfer. Default is false. |

### RESOURCETRANSFER:STATUS

**Access:** Get only  
**Type:** String

This enumerated type shows the transfer status. Possible values are:

- **Inactive** (default) — Transfer is stopped
- **Finished** — Transfer has reached its goal
- **Failed** — An error occurred; see `MESSAGE` for details
- **Transferring** — The transfer is in progress

### RESOURCETRANSFER:MESSAGE

**Access:** Get only  
**Type:** String

Shows detail related to the `STATUS` attribute.

### RESOURCETRANSFER:GOAL

**Access:** Get only  
**Type:** Scalar

If an amount was specified in the transfer request, it appears here. Otherwise, returns -1.

### RESOURCETRANSFER:TRANSFERRED

**Access:** Get only  
**Type:** Scalar

Returns the amount of the specified resource transferred by this operation.

### RESOURCETRANSFER:RESOURCE

**Access:** Get only  
**Type:** String

The name of the resource being transferred (e.g., oxidizer, liquidfuel).

### RESOURCETRANSFER:ACTIVE

**Access:** Get / Set  
**Type:** Boolean

When getting, this is a shortcut to check if `STATUS` is Transferring. Setting true changes status to Transferring; setting false changes it to Inactive.
</content>
