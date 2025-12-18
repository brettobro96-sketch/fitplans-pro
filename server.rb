require 'sinatra'
require 'stripe'

# Use environment variable for your secret key
Stripe.api_key = ENV['STRIPE_SECRET_KEY']

set :public_folder, 'public'

get '/' do
  redirect '/checkout.html'
end

post '/create-checkout-session' do
  content_type :json

  session = Stripe::Checkout::Session.create(
    payment_method_types: ['card'],
    line_items: [{
      price: '25', # <- Replace with your Stripe Price ID
      quantity: 1
    }],
    mode: 'payment',
    success_url: "#{request.base_url}/success.html",
    cancel_url: "#{request.base_url}/cancel.html"
  )

  { id: session.id }.to_json
end
