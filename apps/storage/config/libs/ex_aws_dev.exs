import Config

# config :ex_aws, :s3,
#   scheme: "http://",
#   host: System.get_env("EX_AWS_HOST"),
#   port: System.get_env("EX_AWS_PORT"),
#   access_key_id: System.get_env("EX_AWS_ACCESS_KEY"),
#   secret_access_key: System.get_env("EX_AWS_SECRET_KEY")

config :ex_aws,
  access_key_id: "3zwMWl4RPCs8CHzhKmIX",
  secret_access_key: "79B6LmryjJElkrIiHgDcfIxSpmvrLdVy75MyAJC2",
  s3: [
    scheme: "http://",
    host: "localhost",
    port: "9000"
  ]
