const webpack = require('webpack');

module.exports={
  plugins: [
    new webpack.DefinePlugin({
      $ENV : {
          PROXY_SERVER : JSON.stringify(process.env.REMOTE_HOST)
      }
    })
  ]
}
