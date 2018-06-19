const program = require('commander');

const { init, addExperiment } = require('./logic');

program
   .version('1.0.0')
   .description('A benchmark tool for Open5GCore-OpenStack-ELKStack testbed integration');


program
   .command('init')
   .alias('i')
   .description('Initialize 5gbench')
   .action(function(){ init() });

program
	.command('startExperiment <name>')
	.alias('s')
	.description('Start an experiment')
	.action((name, start) => {
		addExperiment(name);
	});

program
	.command('addExperiment <name> <start> <end>')
	.alias('a')
	.description('Add an experiment with end date/time')
	.action((name, start, end) => {
		addExperiment(name, start, end);
	});

program.parse(process.argv);
