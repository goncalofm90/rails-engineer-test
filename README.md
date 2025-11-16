# Rails engineer test

We'll be using this test to assess your skill level as Rails engineer. This test is designed to covered a wide variety of skills that are needed in the day-to-day job of a Rails engineer at [Beequip](https://www.beequip.nl/). We expect you to spend a maximum of four hours on this test. You can use Google and Stack Overflow, just like you would normally do. Don't worry when you run out of time though, we would still like to see what you came up with!

## Objectives and requirements

Create a Rails web application that provides an search interface for companies, with the following functional requirements taking into account:

- Admins should have a page to import companies by uploading a CSV-file (you can find the CSV-file in `config/data/companies.csv`)
- Users should be presented with a search field when they visit the root
- Users should be able to see search results when using the name, city or registry number of a company
- Users should see the search results progressively e.g. when they type 'Be' they should see all companies that have 'Be' in their name, city or registry number

Have a look at the [search page of KvK](https://www.kvk.nl/zoeken/) as an inspiration.

Furthermore you should take the following technical requirements into account:

- Companies have a unique CoC-number, in case of duplicates you keep the last result
- Search queries need to be performed using SQL on the backend, no in-memory filtering with Ruby is allowed
- There's no authentication required, it's a public page
- There's no user logic or authorization required regarding the admin interface
- Use the pre-installed Bootstrap and Stimulus.JS libraries to implement the user stories
- Remember you have a limited time, prefer functionality over web design

During your technical interview you'll also be asked how to implement changing requirements.

## Getting started

Make sure that you can run Ruby 3.1.x, Rails 7.0.x, Bundler 2.3.x and Yarn 1.22.x on your laptop and get started using:

```
bin/bundle install
yarn install
bin/rails db:setup
bin/rails s
```

## Deliverables

Send us a link to the hosted repository with your code. It can be hosted anywhere e.g. Github, Gitlab as long as you provide us access. Include all the code and instructions that are necessary to run the application.

## Questions

In case you have questions about the test you can contact Jan van der Pas (`jan.vanderpas@beequip.nl`) or Marthyn Olthof (`marthyn.olthof@beequip.nl`).
