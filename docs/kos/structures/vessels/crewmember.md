> Source: https://ksp-kos.github.io/KOS/structures/vessels/crewmember.html (mirrored offline copy for local reference)

# CrewMember

Represents a single crew member of a vessel.

## structure CrewMember

| Suffix | Type | Description |
|--------|------|-------------|
| `NAME` | `String` | crew member's name |
| `GENDER` | `String` | "Male" or "Female" |
| `EXPERIENCE` | `Scalar` | experience level (number of stars) |
| `TRAIT` | `String` | "Pilot", "Engineer" or "Scientist" |
| `TOURIST` | `Boolean` | true if this crew member is a tourist |
| `PART` | `Part` | part in which the crew member is located |

### CrewMember:NAME

**Type:** `String`

**Access:** Get only

The crew member's name.

### CrewMember:GENDER

**Type:** `String`

**Access:** Get only

Returns "Male" or "Female".

### CrewMember:EXPERIENCE

**Type:** `Scalar`

**Access:** Get only

The experience level, measured in number of stars.

### CrewMember:TRAIT

**Type:** `String`

**Access:** Get only

The crew member's trait or specialization, such as "Pilot".

### CrewMember:TOURIST

**Type:** `Boolean`

**Access:** Get only

Returns true if this crew member is a tourist.

### CrewMember:PART

**Type:** `Part`

**Access:** Get only

The `Part` structure representing the location of this crew member.
