init: clean get generate

clean:
	echo "Cleaning the project.." ; \
	flutter clean ; \

get:
	echo "Getting dependencies.." ; \
	flutter pub get ; \

generate:
	echo "Generating needed codes.." ; \
	dart run build_runner build --delete-conflicting-outputs ; \

generate-watch:
	echo "Generating needed codes.." ; \
	dart run build_runner watch --delete-conflicting-outputs ; \

lint:
	echo "Linting the project.." ; \
	dart run custom_lint ; \