const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const dotenv = require('dotenv')

dotenv.config({ path: '.env', silent: true })

environment.plugins.prepend('Environment',
    new webpack.EnvironmentPlugin(
        JSON.parse(JSON.stringify(process.env))
    )
)

environment.plugins.prepend(
    'Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        Popper: ['popper.js', 'default']
    })
)

module.exports = environment
