require 'swagger_helper'

RSpec.describe 'api/v1/tabs', type: :request do
  path '/api/v1/tabs' do
    get('List all tabs') do
      tags 'Tabs'
      produces 'application/json'
      parameter name: :region, in: :query, type: :string, description: 'Filter by region'
      parameter name: :active, in: :query, type: :string, description: 'Filter active tabs (true/false)'
      
      response(200, 'Tabs retrieved successfully') do
        schema type: :array, items: { '$ref' => '#/components/schemas/Tab' }
        run_test!
      end
    end
    
    post('Create a new tab') do
      tags 'Tabs'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :tab, in: :body, schema: {
        type: :object,
        properties: {
          tab: {
            type: :object,
            properties: {
              title: { type: :string },
              start_date: { type: :string, format: :date },
              end_date: { type: :string, format: :date },
              regions: { type: :array, items: { type: :string } }
            },
            required: %w[title start_date end_date regions]
          }
        }
      }
      
      response(201, 'Tab created successfully') do
        schema '$ref' => '#/components/schemas/Tab'
        run_test!
      end
      
      response(422, 'Invalid parameters') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
  end
  
  path '/api/v1/tabs/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Tab ID'
    
    get('Get a specific tab') do
      tags 'Tabs'
      produces 'application/json'
      
      response(200, 'Tab retrieved successfully') do
        schema '$ref' => '#/components/schemas/Tab'
        run_test!
      end
      
      response(404, 'Tab not found') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
    
    put('Update a tab') do
      tags 'Tabs'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :tab, in: :body, schema: {
        type: :object,
        properties: {
          tab: {
            type: :object,
            properties: {
              title: { type: :string },
              start_date: { type: :string, format: :date },
              end_date: { type: :string, format: :date },
              regions: { type: :array, items: { type: :string } }
            }
          }
        }
      }
      
      response(200, 'Tab updated successfully') do
        schema '$ref' => '#/components/schemas/Tab'
        run_test!
      end
      
      response(404, 'Tab not found') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
      
      response(422, 'Invalid parameters') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
    
    delete('Delete a tab') do
      tags 'Tabs'
      
      response(204, 'Tab deleted successfully') do
        run_test!
      end
      
      response(404, 'Tab not found') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end
  end
end