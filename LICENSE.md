fitplans-pro/
├─ server.rb
├─ Gemfile
├─ public/
│  ├─ style.css
│  ├─ checkout.html
│  ├─ success.html
│  └─ cancel.html
source 'https://rubygems.org'

gem 'sinatra'
gem 'stripe'
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
      price: '$20', # <- Replace with your Stripe Price ID
      quantity: 1
    }],
    mode: 'payment',
    success_url: "#{request.base_url}/success.html",
    cancel_url: "#{request.base_url}/cancel.html"
  )

  { id: session.id }.to_json
end
body {
  font-family: Arial, sans-serif;
  background: #f2f2f2;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  margin: 0;
}

h1, h2 {
  color: #242d60;
}

button {
  height: 36px;
  background: #556cd6;
  color: white;
  width: 200px;
  font-size: 14px;
  border: none;
  font-weight: 500;
  cursor: pointer;
  border-radius: 6px;
  transition: all 0.2s ease;
  box-shadow: 0px 4px 5.5px rgba(0,0,0,0.07);
}

button:hover {
  opacity: 0.8;
}
<!DOCTYPE html>
<html>
<head>
  <title>Buy FitPlans Pro</title>
  <link rel="stylesheet" href="style.css">
  <script src="https://js.stripe.com/v3/"></script>
</head>
<body>
  <h1>FitPlans Pro</h1>
  <h2>Get access to all fitness plans</h2>
  <button id="checkout-button">Checkout</button>

  <script>
    const stripe = Stripe('pk_live_51QgO8S2Nc8YUIAmMq5kaOyszbHDneh2gTckQcQYmmgC3FXbqxFT9P80rMqkKTJUaWm7jZS6pOMShVPxL2aUdKpg300cnpTBpyz');

    const checkoutButton = document.getElementById('checkout-button');
    checkoutButton.addEventListener('click', () => {
      fetch('/create-checkout-session', { method: 'POST' })
        .then(res => res.json())
        .then(data => stripe.redirectToCheckout({ sessionId: data.id }))
        .catch(err => console.error(err));
    });
  </script>
</body>
</html>
<!DOCTYPE html>
<html>
<head>
  <title>Thank You!</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>Thank you for your order!</h1>
  <p>Your payment was successful. Enjoy your fitness plans!</p>
</body>
</html>
<!DOCTYPE html>
<html>
<head>
  <title>Payment Cancelled</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>Payment Cancelled</h1>
  <p>Your payment was cancelled. You can try again anytime.</p>
</body>
</html>
