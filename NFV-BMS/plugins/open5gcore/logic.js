var elasticsearch = require('elasticsearch'),
 	 fs = require('fs'),
	 moment = require('moment'),
    chalk = require('chalk');

const assert = require('assert');

var log = (message, success=0) => {
   if(success)
      console.log(chalk.green(message));
   else
      console.log(chalk.red(message));
}

var logInfo = (message) => {
   console.log(chalk.magenta(message));
}

var config = JSON.parse(fs.readFileSync('config.json', 'utf8'));

var esClient = new elasticsearch.Client({
     host: config.elasticsearchHost + ':' + config.elasticsearchPort,
     log: 'trace'
	}, function(error){
		if (error) {
			log('Error connecting Elasticsearch cluster! Check config.js file!');
			process.exit(1);
		} else {
			log('Connected to Elasticsearch cluster', 1);
		}
	}
);

const errorHandler = function(error){
	log(error);
}

const ping = () => {
   return new Promise(function(resolv, reject){
      esClient.ping({
         requestTimeout: 3000
      }, function (error) {
         if (error) {
            log('elasticsearch cluster is down!');
            console.log(error);
            process.exit(1);
         } else {
            console.log('All is well. Able to Ping elasticsearch server at ' + config.elasticsearchHost + ':' + config.elasticsearchPort);
            resolv(true);
         }
      });
   });
}

const validateSystem = () => {
   return new Promise(function(resolve, reject){	
		 ping().then(function(){
         esClient.indices.exists({
			   index: config.indexName
         }, function(error, response, status){
            if (error){
               log('Error checking index ' + config.indexName + '!');
               console.log(error);
               process.exit(1);
            } else {
               logInfo('Index ' + config.indexName + ' checked!');

               if(!response){
                  log('No ' + config.indexName + ' index found');
                  resolve(false);
               } else {
                  log('Index ' + config.indexName + ' exists...', 1);
                  resolve(true);
               }
            }
         });
      });
   });
};

const setupIndex = () => {
   return new Promise(function(resolve, reject){
      validateSystem().then(function(result){	
         if( !result ){
            logInfo("Creating index with name \"" + config.indexName + "\"!");
         
            esClient.indices.create({
               index: config.indexName,
               body: {
                  "mappings": {
                     "doc": {
                        "properties": {
                           start: { type: 'date' },
                           end: { type: 'date' }
                        }
                     }
                  }
               }
            }, function(error, response, status){
               if(error){
                  log('Error creating index ' + config.indexName + '!');
                  console.log(error);
                  process.exit(1);
               } else{
                  if(response){
                     log('Index ' + config.indexName + ' successfully created!', 1);
                     resolve(true);
                  } else{
                     log('Can\'t create index ' + config.indexName + '! Something went wrong...');
                     console.log(response);
                     process.exit(1);
                  }
               }
            });
         } else{
            resolve(true);
         }
      });
   })
};

const init = () => {
   return new Promise(function(resolve, reject){
      setupIndex().then(function(state){
         if(state){
            resolve(true);
         }
      });
   });
};

function validateDate(myDate){
	var formats = ["YYYY-MM-DDTHH:mm:ss.SSSZ"];
	logInfo("Validating date: "+myDate);
	return moment(myDate, formats, true).isValid();
}


const addExperiment = (experimentName, experimentStart=moment().format('YYYY-MM-DDTHH:mm:ss.SSSZ'), experimentEnd="") => {
	
	if( !validateDate(experimentStart) || (experimentEnd !== "" && !validateDate(experimentEnd))){
		console.log('Error: Invalid date/time format! It should be in form yyyyMMdd\'T\'HHmmss.SSSZ');
		process.exit(1);
	}
  
   if(experimentEnd !== ""){
      var documentBody = {
         start: experimentStart,
         end: experimentEnd
      };
   } else{
      var documentBody = {
         start: experimentStart
      };
   }

   init().then(function(){
      esClient.create({
         index: config.indexName,
         type: 'doc',
         id: experimentName,
         body: documentBody
      }, function (error, response) {
         if(error){
            log('Error adding experiment with name \"' + experimentName + '\"!');
            console.log(error);
            process.exit(1);
         } else{
            if(response){
               log('Experiment \"' + experimentName + '\" successfully added!', 1);
            } else{
               log('Can\'t create experiment \"' + experimentName  + '\"! Something went wrong...');
               console.log(response);
               process.exit(1);
            }
         }
      });
   });
};

module.exports = {init, addExperiment};
