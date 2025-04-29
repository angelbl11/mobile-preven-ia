# Variables to configure the environment
FLUTTER?=flutter
ENV_DIR?=environments
DART?=dart
ENV_FILE?=env.json



run-dev:
	@echo "Running the application"
	$(FLUTTER) run --dart-define-from-file=$(ENV_DIR)/env.json

run-prod:
	@echo "Running the application"
	$(FLUTTER) run --dart-define-from-file=$(ENV_DIR)/env.prod.json

build-debug:
	@echo "Building Flutter app for debug"
	$(FLUTTER) build apk --dart-define-from-file=$(ENV_DIR)/$(ENV_FILE) --debug


build-release:
	@echo "Building Flutter app for release"
	$(FLUTTER) build apk --dart-define-from-file=$(ENV_DIR)/$(ENV_FILE) --release



build-aab:
	@echo "Building Flutter app bundle"
	$(FLUTTER) build appbundle --dart-define-from-file=$(ENV_DIR)/$(ENV_FILE) --release


#  Generate the auto-generated files for the project using the build_runner
gen-code:
	@echo "Generating codes"
	$(DART) run build_runner build --delete-conflicting-outputs

update-version:
	@echo "Updating version"
	sh update_version.sh
