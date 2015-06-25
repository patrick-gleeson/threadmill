# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

User.create! [
  {name: 'Bill', email: 'bill@example.com', password: 'topsecret', password_confirmation: 'topsecret'},
  {name: 'Mary', email: 'mary@example.com', password: 'moresecret', password_confirmation: 'moresecret'}
 ]
              
beans = Stock.create! name: 'Coffee beans', level: 5000, unit: "grams", estimate: false
decaf_beans = Stock.create! name: 'Decaf beans', level: 5000, unit: "grams", estimate:false
milk = Stock.create! name: 'Milk', level: 5000, unit: "ml", estimate:false


espresso = Item.create! name: 'Espresso', price_cents: 145
cappuccino = Item.create! name: 'Cappuccino', price_cents: 250
decaf = Item.create! name: 'Decaf', price_cents: 155
            

StockEffect.create! [
  {item_id: espresso.id, stock_id: beans.id, change: 25},
  {item_id: cappuccino.id, stock_id: beans.id, change: 25},
  {item_id: cappuccino.id, stock_id: milk.id, change: 100},
  {item_id: decaf.id, stock_id: decaf_beans.id, change: 25}
]
