> Source: https://ksp-kos.github.io/KOS/structures/vessels/alt.html (mirrored offline copy for local reference)

# ALT Structure Documentation

## ALT

"ALT is a special object that exists just to help you get the altitudes of interest for a vessel future. It is grandfathered in for the sake of backward compatibility, but this information is also available on the Vessel structure as well, which is the better new way to do it."

### Structure Definition

| Suffix | Type | Description |
|--------|------|-------------|
| `APOAPSIS` | Scalar (m) | "altitude in meters of SHIP's apoapsis. Same as SHIP:APOAPSIS." |
| `PERIAPSIS` | Scalar (m) | "altitude in meters of SHIP's periapsis. Same as SHIP:PERIAPSIS." |
| `RADAR` | Scalar (m) | "Altitude of SHIP above the ground terrain, rather than above sea level." |

---

**Note:** This structure represents legacy functionality. Modern implementations should reference altitude values directly through the Vessel structure instead.
