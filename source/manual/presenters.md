# Presenters

## Concept

Talking about presenters we are talking about a layer between controllers and views. Presenters are plain old ruby objects which provide specific data api for a specific view. As a result rendering is decoupled from the DAL of Rails provided it is using only the presenters' api.

![re_present.svg](https://cdn.rawgit.com/zhdk/madek/ef9d4e4035c22b21610a5eaf1e8006b633a49081/doc/diagrams/ui_ux/re_present.png)

## Example

Taking a look into `PeopleController#show` action, we see that we instantiate the corresponding presenter `Presenters::People::PersonShow` with the fetched person (* and current user) and save it into the `@get` variable. This name is our convention which should be followed accross all controllers. The `PersonShow` presenter defines then the required api methods and their logic so that the `app/views/people/show` view gets all the data it needs.

There are no hard rules about the structure and granurality of the presenters, but experience has shown that it is good to define and use a overall presenter for the specific view (like in our example `PersonShow`). Within this presenter other more granular presenters can be used, which are potentially shared among and used also at other places.

* NOTE: instantiating a presenter passing to it also the current user is common in Madek. A specific view contains often only data the current user is allowed to see.

## presenter.rb

This is the root presenter each other one is inheriting from. It defines some helper methods, which are convenient especially from the development point of view, like e.g.:
* `#api` -> returns all the data api methods (public) of the presenter
* `#dump` -> evaluates recursively all the method calls and returns a (nested) hash with all the data
* and other methods, like #inspect for the repl, etc.

## Tests

`spec/presenters/`

Presenters can be tested normally with rspec. Each presenter test should at least contain the dump test (see `spec/presenters/shared/dump.rb`). This test ensures that all the data can be dumped successfully without any errors or does not contain any active record values.

## Rails integration

`app/presenters/`
