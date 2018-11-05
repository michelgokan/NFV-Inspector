let knex = require('knex');

module.exports = knex({
	client: 'mysql',

	connection: {
		user: '',
		password: '',
		database: '',
		host: 'localhost',
		filename: '', // Only used for SQLite
		dateStrings: true
	}
});
