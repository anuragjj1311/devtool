require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Dev Tool Management API V1',
        version: 'v1',
        description: 'Dev TOOL, Toggles, and Link Generators'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Development server'
        }
      ],
      components: {
        schemas: {
          Tab: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              start_date: { type: :string, format: :date },
              end_date: { type: :string, format: :date },
              regions: { type: :array, items: { type: :string } },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            },
            required: %w[title start_date end_date regions]
          },
          Toggle: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              type: { type: :string, enum: %w[Shop Category] },
              image_url: { type: :string },
              landing_url: { type: :string },
              start_date: { type: :string, format: :date },
              end_date: { type: :string, format: :date },
              regions: { type: :array, items: { type: :string } },
              deleted_at: { type: :string, format: :datetime, nullable: true },
              tab_id: { type: :integer },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            },
            required: %w[title type start_date end_date]
          },
          LinkGenerator: {
            type: :object,
            properties: {
              id: { type: :integer },
              type: { type: :string, enum: %w[DirectLink ActivityLink] },
              url: { 
                oneOf: [
                  { type: :string },
                  { type: :object }
                ]
              },
              linkable_type: { type: :string },
              linkable_id: { type: :integer },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            },
            required: %w[type url]
          },
          Error: {
            type: :object,
            properties: {
              error: { type: :string }
            }
          },
          Success: {
            type: :object,
            properties: {
              message: { type: :string },
              data: { type: :object }
            }
          }
        }
      }
    }
  }
end