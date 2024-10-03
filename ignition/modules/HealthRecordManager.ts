import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const HealthRecordManagerModule = buildModule("HealthRecordManagerModule", (m) => {

  const HealthRecordManager = m.contract("HealthRecordManager");

  return { HealthRecordManager };
});

export default HealthRecordManagerModule;
