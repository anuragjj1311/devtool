require 'swagger_helper'

RSpec.describe 'api/v1/toggles', type: :request do
  path '/api/v1/tabs/{tab_id}/toggles' do
    parameter name: :tab_id, in: :path, type: :integer, description: 'Tab ID'
    
    get('List all toggles for a tab') do
      tags 'Toggles'
      produces 'application/json'
      parameter name: :current, in: :query, type: :string, description: 'Filter current toggles (true/false)'
      
      response(200, 'Toggles retrieved successfully') do
        schema type: :array, items: { '$ref' => '#/components/schemas/Toggle' }
        run_test!
      end
      
      response(404, 'Tab not found') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
    
    post('Create a new toggle') do
      tags 'Toggles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :toggle, in: :body, schema: {
        type: :object,
        properties: {
          toggle: {
            type: :object,
            properties: {
              title: { type: :string },
              type: { type: :string, enum: %w[Shop Category] },
              image_url: { type: :string },
              landing_url: { type: :string },
              start_date: { type: :string, format: :date },
              end_date: { type: :string, format: :date },
              regions: { type: :array, items: { type: :string } },
              route_info: {
                type: :object,
                properties: {
                  url: { 
                    oneOf: [
                      { type: :string },
                      { type: :object }
                    ]
                  },
                  type: { type: :string, enum: %w[DirectLink ActivityLink] }
                }
              }
            },
            required: %w[title type start_date end_date]
          }
        }
      }
      
      response(201, 'Toggle created successfully') do
        schema '$ref' => '#/components/schemas/Toggle'
        run_test!
      end
      
      response(422, 'Invalid parameters') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
  end
  
  path '/api/v1/tabs/{tab_id}/toggles/{id}' do
    parameter name: :tab_id, in: :path, type: :integer, description: 'Tab ID'
    parameter name: :id, in: :path, type: :integer, description: 'Toggle ID'
    
    get('Get a specific toggle') do
      tags 'Toggles'
      produces 'application/json'
      
      response(200, 'Toggle retrieved successfully') do
        schema '$ref' => '#/components/schemas/Toggle'
        run_test!
      end
      
      response(404, 'Toggle not found') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
    
    put('Update a toggle') do
      tags 'Toggles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :toggle, in: :body, schema: {
        type: :object,
        properties: {
          toggle: {
            type: :object,
            properties: {
              title: { type: :string },
              type: { type: :string, enum: %w[Shop Category] },
              image_url: { type: :string },
              landing_url: { type: :string },
              start_date: { type: :string, format: :date },
              end_date: { type: :string, format: :date },
              regions: { type: :array, items: { type: :string } },
              route_info: {
                type: :object,
                properties: {
                  url: { 
                    oneOf: [
                      { type: :string },
                      { type: :object }
                    ]
                  }
                }
              }
            }
          }
        }
      }
      
      response(200, 'Toggle updated successfully') do
        schema '$ref' => '#/components/schemas/Toggle'
        run_test!
      end
      
      response(404, 'Toggle not found') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
      
      response(422, 'Invalid parameters') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
    
    delete('Soft delete a toggle') do
      tags 'Toggles'
      produces 'application/json'
      
      response(200, 'Toggle soft deleted successfully') do
        schema '$ref' => '#/components/schemas/Success'
        run_test!
      end
      
      response(404, 'Toggle not found') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
  end
  
  path '/api/v1/tabs/{tab_id}/toggles/{id}/restore' do
    parameter name: :tab_id, in: :path, type: :integer, description: 'Tab ID'
    parameter name: :id, in: :path, type: :integer, description: 'Toggle ID'
    
    post('Restore a soft deleted toggle') do
      tags 'Toggles'
      produces 'application/json'
      
      response(200, 'Toggle restored successfully') do
        schema '$ref' => '#/components/schemas/Success'
        run_test!
      end
      
      response(404, 'Toggle not found') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
  end
  
  path '/api/v1/tabs/{tab_id}/toggles/{id}/reset' do
    parameter name: :tab_id, in: :path, type: :integer, description: 'Tab ID'
    parameter name: :id, in: :path, type: :integer, description: 'Toggle ID'
    
    post('Reset toggle to default values') do
      tags 'Toggles'
      produces 'application/json'
      
      response(200, 'Toggle reset successfully') do
        schema '$ref' => '#/components/schemas/Success'
        run_test!
      end
      
      response(404, 'Toggle not found') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
  end
end