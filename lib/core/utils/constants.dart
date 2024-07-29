// Define top-up limits
int getBeneficiaryLimit(bool isVerified) {
  return isVerified ? 1000 : 500;
}

const totalMonthlyLimit = 3000;
const transactionCharge = 1.0;
