require 'carrierwave/storage/fog'

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      region:                Rails.application.credentials.aws[:s3_bucket_region],
      aws_access_key_id:     Rails.application.credentials.aws[:s3_access_key],
      aws_secret_access_key: Rails.application.credentials.aws[:s3_secret_key]
    }

    config.fog_directory  = Rails.application.credentials.aws[:s3_bucket_name]
  end
end
