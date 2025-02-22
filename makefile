# Variables to configure the environment
FLUTTER?=flutter
ENV_DIR?=environments
DART?=dart



run:
	@echo "Running the application"
	$(FLUTTER) run


#  Generate the auto-generated files for the project using the build_runner
gen-code:
	@echo "Generating codes"
	$(DART) run build_runner build --delete-conflicting-outputs

# Define variables and ensure they are set only for the generate target
gen-api: openapi-generator-cli.jar
	@echo "Replacing string in file"
	@sh ../infra-gateway-api/file_type_replacer.sh
	@echo "Generating API client"
	@java -jar openapi-generator-cli.jar generate -i ../infra-gateway-api/api_gateway_sk.yml -g dart-dio -o api/sk-api --additional-properties=pubName=sk_api
	@echo "API client generated"
	@echo "Generating Autogeneraated Files"
	cd api/sk-api && $(DART) run build_runner build --delete-conflicting-outputs


# Target to download the OpenAPI Generator CLI JAR file for Mac
download-openapi-generator-cli-mac:
	wget https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/7.7.0/openapi-generator-cli-7.7.0.jar -O openapi-generator-cli.jar