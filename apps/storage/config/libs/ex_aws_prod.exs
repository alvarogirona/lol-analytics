import Config

config :ex_aws,
  # "EX_AWS_SECRET_KEY",
  # EX_AWS_ACCESS_KEY
  access_key_id: System.get_env("EX_AWS_ACCESS_KEY"),
  secret_access_key: System.get_env("EX_AWS_SECRET_KEY"),
  s3: [
    scheme: "http://",
    host: System.get_env("EX_AWS_ENDPOINT"),
    port: System.get_env("EX_AWS_PORT")
  ]
