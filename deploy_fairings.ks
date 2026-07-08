local ModuleProceduralFairing to "ModuleProceduralFairing".
local DeployEvent to "deploy".

for p in ship:parts {
    if p:modules:contains(ModuleProceduralFairing) {
        local fairing to p:getmodule(ModuleProceduralFairing).
        print fairing.
        if (fairing:hasevent(DeployEvent)) {
            fairing:doevent(DeployEvent).
        }
    }
}
