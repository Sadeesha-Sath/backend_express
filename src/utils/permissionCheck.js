// TODO - Add more permissions

const permissions = {
  admin: [
    "ALL_USERS",
    "ALL_EMPLOYEES",
    "ALL_CUSTOMERS",
    "ALL_TRANSACTIONS",
    "ADD_EMPLOYEE",
    "ADD_CUSTOMER",
    "ADD_TRANSACTION",
    "ALL_ACCOUNTS",
    "ALL_FD",
    "ALL_LOANS",
    "ALL_BRANCHES",
    "ALL_INTERESTS"
  ],
  employee: [
    "ALL_CUSTOMERS",
    "ALL_TRANSACTIONS",
    "ADD_CUSTOMER",
    "ADD_TRANSACTION",
    "ALL_ACCOUNTS",
    "ALL_FD",
    "ALL_LOANS",
    "ALL_BRANCHES",
    "ALL_INTERESTS"
  ],
  branch_manager: [
    "ALL_USERS",
    "ALL_EMPLOYEES",
    "ALL_CUSTOMERS",
    "ALL_TRANSACTIONS",
    "ADD_EMPLOYEE",
    "ADD_CUSTOMER",
    "ADD_TRANSACTION",
    "ALL_ACCOUNTS",
    "ALL_FD",
    "ALL_LOANS",
    "ALL_BRANCHES",
    "ALL_INTERESTS"
  ],
  customer: ["MY_TRANSACTIONS", "MY_LOANS","ALL_INTERESTS"],
};

const permissionCheck = (access, user) => {
  if (!user || !user.Role) return false;
  return permissions[user.Role].includes(access);
};

module.exports = permissionCheck;
