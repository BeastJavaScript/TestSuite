node_modules/coffee-stir/bin/cli.js -o src/Application.coffee src/TestCase.coffee


node_modules/coffee-script/bin/coffee -c -o bin -j beast.testsuite.js src/Application.coffee


#compile the test for the application
node_modules/coffee-script/bin/coffee -c test/test.coffee

#minify the application
node node_modules/uglifyjs/index.js --source-map bin/beast.testsuite.min.map bin/beast.testsuite.js > bin/beast.testsuite.min.js

#Generate documentation
node_modules/codo/bin/codo -o ./doc src/


git add --all
git commit -am"automatic publish"
