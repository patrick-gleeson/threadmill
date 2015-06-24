# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

User.create! [{name: 'Bill', email: 'bill@example.com', password: 'topsecret', password_confirmation: 'topsecret'},
              {name: 'Mary', email: 'mary@example.com', password: 'moresecret', password_confirmation: 'moresecret'}]
              

Item.create! [{name: 'Espresso', price_cents: 145},
              {name: 'Cappuccino', price_cents: 250},
              {name: 'Decaf', price_cents: 155}]