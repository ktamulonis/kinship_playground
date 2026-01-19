# config/initializers/kinship.rb

Rails.application.config.to_prepare do
  next unless ActiveRecord::Base.connection_pool.connected?

  begin
    KINSHIP = Kinship.build(
      models: ApplicationRecord.descendants,
      attribute_provider: ->(model) { model.column_names }
    )
  rescue ActiveRecord::StatementInvalid
    # Database may not be ready (db:prepare, db:migrate, etc)
    # Kinship will be built later when models are accessed
  end
end

