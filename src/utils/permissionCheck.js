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
    "ALL_LOAN_APPLICATIONS",
    "BRANCH_LOAN_APPLICATIONS",
    "ALL_INSTALLMENTS",
  ],
  branch_manager: [
    "ALL_USERS",
    "ADD_EMPLOYEE",
    "ALL_CUSTOMERS",
    "ALL_TRANSACTIONS",
    "ADD_EMPLOYEE",
    "ADD_CUSTOMER",
    "ADD_TRANSACTION",
    "ALL_ACCOUNTS",
    "ALL_FD",
    "ALL_LOANS",
    "ALL_BRANCHES",
    "BRANCH_LOAN_APPLICATIONS",
    "APPROVE_LOAN_APPLICATIONS",
    "ALL_INSTALLMENTS",
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
    "BRANCH_LOAN_APPLICATIONS",
    "ALL_INSTALLMENTS",
  ],
  customer: ["MY_TRANSACTIONS", "MY_LOANS", "MY_INSTALLMENTS"],
};

const permissionCheck = (access, user) => {
  if (!user || !user.Role) return false;
  return permissions[user.Role].includes(access);
};

module.exports = permissionCheck;
