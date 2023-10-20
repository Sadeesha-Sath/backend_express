const generator = require("generate-password");
const bcrypt = require("bcrypt");

const generateRandomPass = () => {
  let password = generator.generate({
    length: 12,
    strict: true,
    excludeSimilarCharacters: true,
  });
  console.log("Password generated :" + password);
  return password;
};

const generateHash = async (password) => {
  const saltRounds = 10;
  const hash = bcrypt.hash(password, saltRounds);
  return hash;
};

const comparePasswords = async (userPass, storedPass) => {
  try {
    return await bcrypt.compare(userPass, storedPass);
  } catch (err) {
    console.error(err);
  }
};

module.exports = { generateRandomPass, generateHash, comparePasswords };
