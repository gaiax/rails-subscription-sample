// https://stripe.com/docs/billing/subscriptions/cards
document.addEventListener('DOMContentLoaded', function () {
    var stripe = Stripe(process.env['STRIPE_KEY_PUBLIC']);
    var elements = stripe.elements();
    var cardElement = elements.create("card", { hidePostalCode: true });
    cardElement.mount("#card-element");

    // バリデーション
    cardElement.addEventListener('change', function (event) {
        var displayError = document.getElementById('card-errors');
        if (event.error) {
            displayError.textContent = event.error.message;
        } else {
            displayError.textContent = '';
        }
    });

    const stripePaymentMethodHandler = async (result) => {
        if (result.error) {
            // TODO: エラーハンドリング
            return;
        }

        const res = await fetch('/api/payments', {
            method: 'post',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector("meta[name=csrf-token]").content,
            },
            body: JSON.stringify({
                payment_method_id: result.paymentMethod.id
            }),
        });

        // The customer has been created
        const customer = await res.json();
    }

    const form = document.getElementById('subscription-form');
    form.addEventListener('submit', async (event) => {
        // We don't want to let default form submission happen here,
        // which would refresh the page.
        event.preventDefault();

        const result = await stripe.createPaymentMethod({
            type: 'card',
            card: cardElement,
            billing_details: {
                email: 'taro.subscription@example.com',
            },
        })

        stripePaymentMethodHandler(result);
    });
});
