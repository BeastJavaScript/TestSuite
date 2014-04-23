node_modules/coffee-stir/bin/cli.js -wo src/Application.coffee src/TestCase.coffee &

node_modules/coffee-script/bin/coffee -wc -o bin -j beast.testsuite.js src/Application.coffee &

#compile the test for the application
node_modules/coffee-script/bin/coffee -wc test/test.coffee &

#minify the application
node node_modules/minify/bin/minify bin/beast.testsuite.js bin/beast.testsuite.min.js

#Generate documentation
node_modules/codo/bin/codo -o ./doc src/