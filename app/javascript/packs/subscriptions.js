// https://stripe.com/docs/billing/subscriptions/cards
$(document).ready(function () {
    $('#subscribe').click(function () {
        subscribe()
        return false
    })
    $('#unsubscribe').click(function () {
        unsubscribe()
        return false
    })
})

function getCsrfToken() {
    return $('meta[name="csrf-token"]').attr('content');
}

function subscribe() {
    let stripe = Stripe(process.env['STRIPE_KEY_PUBLIC']);
    $.ajax({
        type: 'POST',
        url: '/api/subscriptions',
        dataType: 'json',
        headers: {
            'X-CSRF-Token': getCsrfToken()
        },
        success: function (data) {
            stripe.redirectToCheckout({
                // Make the id field from the Checkout Session creation API response
                // available to this file, so you can provide it as parameter here
                // instead of the {{CHECKOUT_SESSION_ID}} placeholder.
                sessionId: data.session_id
            }).then(function (result) {
                // If `redirectToCheckout` fails due to a browser or network
                // error, display the localized error message to your customer
                // using `result.error.message`.
                console.log("result", result)
            });
        },
    })
}

function unsubscribe() {
    $.ajax({
        type: 'DELETE',
        url: '/api/subscriptions',
        dataType: 'json',
        headers: {
            'X-CSRF-Token': getCsrfToken()
        },
        success: function (data) {
            location.href = "/unsubscription/completed"
        },
    })
}
