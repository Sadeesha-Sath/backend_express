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
  ],
  employee: [
    "ALL_CUSTOMERS",
    "ALL_TRANSACTIONS",
    "ADD_CUSTOMER",
    "ADD_TRANSACTION",
  ],
  branch_manager: [
    "ALL_USERS",
    "ALL_EMPLOYEES",
    "ALL_CUSTOMERS",
    "ALL_TRANSACTIONS",
    "ADD_EMPLOYEE",
    "ADD_CUSTOMER",
    "ADD_TRANSACTION",
  ],
  customer: [],
};

const permissionCheck = (access, user) => {
  if (!user || !user.role) return false;
  return permissions[user.role].includes(access);
};

module.exports = permissionCheck;
