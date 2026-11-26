# Contributing

Thanks for helping improve rails-settings-cached. Bug reports, questions and
pull requests are all welcome.

## Reporting bugs

Open an issue at https://github.com/huacnlee/rails-settings-cached/issues with:

- the gem, Ruby and Rails versions you are using
- the relevant part of your `Setting` model (the `field` definitions)
- what you expected and what happened, with a backtrace if there is one

## Development setup

Requires Ruby 3.2+ and Rails 7.0+.

```sh
git clone https://github.com/huacnlee/rails-settings-cached.git
cd rails-settings-cached
bundle install
bundle exec rails test
```

The test suite uses an in-memory SQLite database, so no database service is
needed. The dummy Rails app lives in `test/dummy`.

Each test run writes a SimpleCov report to `coverage/index.html` and prints a
line/branch coverage summary.

### Testing against other Rails versions

The `gemfiles/` directory has one Gemfile per supported Rails version:

```sh
BUNDLE_GEMFILE=gemfiles/Gemfile-7-2 bundle install
BUNDLE_GEMFILE=gemfiles/Gemfile-7-2 bundle exec rails test
```

CI runs the full matrix (see `.github/workflows/build.yml`).

### Running tests with Docker

```sh
docker compose build
docker compose run --rm test                                    # Ruby 3.4, root Gemfile
GEMFILE=gemfiles/Gemfile-7-2 docker compose run --rm test       # another Rails version
RUBY_VERSION=3.2 GEMFILE=gemfiles/Gemfile-7-1 docker compose run --rm --build test
docker compose run --rm test bundle exec rails test test/base_test.rb
docker compose run --rm test bundle exec rubocop
docker compose run --rm test bash                               # shell
```

Gems are kept in a Docker volume per Ruby version (`rails-settings-cached-bundle-<version>`),
and missing gems are installed automatically when the container starts. After changing
`RUBY_VERSION`, pass `--build` (or run `docker compose build`) so the matching image exists.

To refresh the root lockfile: `docker compose run --rm test bundle lock --update`.

## Submitting a pull request

1. Fork the repository and create a branch from `main`.
2. Add or update tests for your change. Behaviour changes need a test; new
   `field` types or options should be covered in `test/base_test.rb`.
3. Make sure `bundle exec rails test` passes.
4. Update `README.md` if you add or change a public option.
5. Keep the PR focused. Unrelated refactoring is easier to review on its own.
6. Open the PR against `main` and describe what changed and why. CI runs the
   Ruby/Rails matrix and uploads coverage to Codecov.

Do not bump `lib/rails-settings/version.rb` in a PR; releases are cut by the
maintainer.

## Releasing (maintainers)

1. Change `lib/rails-settings/version.rb` to the new version number.
2. Run `bundle install` so `Gemfile.lock` reflects the new version.
3. Commit with `Version vX.Y.Z` and push to `main`.
4. Push a tag: `git tag vX.Y.Z && git push origin vX.Y.Z`. The `Release`
   workflow (`.github/workflows/release.yml`) checks the tag against
   `version.rb`, builds the gem and publishes it to RubyGems via trusted
   publishing.
5. Write the release notes on the GitHub release for the tag.
