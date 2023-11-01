// import "@configs/db.config";
const mySql = require("mysql2");

const getOffset = (currentPage = 1, listPerPage) => {
  return (currentPage - 1) * [listPerPage];
};

const getPaginationString = (pagination) => {
  let str = " ";
  if (pagination.pageSize) {
    str = str + " LIMIT " + pagination.pageSize;
  }
  if (pagination.current) {
    str =
      str +
      " OFFSET " +
      mySql.escape(getOffset(pagination.current, pagination.pageSize));
  }
  return str;
};

const getFilterString = (filters) => {
  let str = " WHERE ";
  if (filters) {
    Object.keys(filters).forEach((element) => {
      if (filters[element] !== "") {
        const fields = filters[element];
        let fieldText = "";
        for (let text of fields) {
          fieldText += mySql.escape(text) + ",";
        }
        fieldText = fieldText.substring(0, fieldText.length - 1);

        str = str + `${element} in ( ${fieldText} ) AND `;
      }
    });
  }
  if (str === " WHERE ") {
    return "";
  }
  str = str.substring(0, str.length - 4);
  return str;
};

const getSortString = (order, field) => {
  if (order && field) {
    const type = order === "ascend" ? " ASC " : " DESC ";
    return " ORDER BY " + field + " " + type;
  }
};

const modifySQL = (baseSQL, data) => {
  if (data.filters) {
    baseSQL = baseSQL + getFilterString(data.filters);
  }
  if (data.order && data.field) {
    baseSQL = baseSQL + getSortString(data.order, data.field);
  }
  if (data.pagination) {
    baseSQL = baseSQL + getPaginationString(data.pagination);
  }
  return baseSQL;
};

const emptyOrRows = (rows) => {
  if (!rows) {
    return [];
  }
  return rows;
};

module.exports = {
  getOffset,
  emptyOrRows,
  modifySQL,
};
