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
  ],
  employee: [
    "ALL_CUSTOMERS",
    "ALL_TRANSACTIONS",
    "ADD_CUSTOMER",
    "ADD_TRANSACTION",
    "ALL_ACCOUNTS",
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
  ],
  customer: [],
};

const permissionCheck = (access, user) => {
  if (!user || !user.Role) return false;
  return permissions[user.Role].includes(access);
};

module.exports = permissionCheck;
