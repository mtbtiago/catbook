module Api
  module V1
    class CatsController < ApplicationController
      # http://www.ruby-doc.org/core-2.1.3/Array.html
      # http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Variables_and_Constants#Constants
      DEFAULT_FIELDS = %w{ name birthday followers_count followed_by_count links }

      def index
        offset = params[:offset] || 0
        limit  = params[:limit]  || 10

        order  = params[:order] || "id ASC"

        # Maybe the user wants to specify the set of fields is interested with in order to do a fastest request
        fields = params[:fields].try(:split, ",") || DEFAULT_FIELDS

        cats   = Cat.visible.order(order).limit(limit).offset(offset)

        result = cats.map do |cat|
          get_cat_by_fields(cat,fields)
        end


        # samples:
        # http://localhost:3000/api/v1/cats/2.xml
        # http://localhost:3000/api/v1/cats/2?format=xml

        # debugger

        respond_to do |format|
          format.json { render json: result }
          format.xml { render xml: result }
        end
      rescue
        render json: result
      end

      # samples:
      # http://localhost:3000/api/v1/cats?fields=name,birthday
      # http://localhost:3000/api/v1/cats/2?fields=name
      def show
        fields = params[:fields].try(:split, ",") || DEFAULT_FIELDS

        cat    = Cat.visible.find(params[:id])

        result = get_cat_by_fields(cat,fields)
        begin
          respond_to do |format|
            format.json { render json: result }
            format.xml { render xml: result }
          end
        rescue
          render json: result
        end
      rescue ActiveRecord::RecordNotFound
        # http://apidock.com/rails/ActionController/Base/render#254-List-of-status-codes-and-their-symbols
        head :not_found
      end

      private
      # http://www.ruby-doc.org/core-2.1.3/Array.html#method-i-map
      # http://ruby-doc.org/core-2.1.3/Object.html#method-i-tap
      # http://stackoverflow.com/questions/17493080/advantage-of-tap-method-in-ruby

      def get_cat_by_fields(cat, fields)
        result = {}.tap do |cat_hash|
          cat_hash[:name]              = cat.name                     if fields.include?("name") && cat.name
          cat_hash[:birthday]          = cat.birthday                 if fields.include?("birthday") && cat.email
          cat_hash[:followers_count]   = cat.follower_relations.count if fields.include?("followers_count")
          cat_hash[:followed_by_count] = cat.followed_relations.count if fields.include?("followed_by_count")

          if fields.include?("links")
            cat_hash[:links] = {
              public: cat_url(cat),
              api: api_v1_cat_url(cat)
            }
          end
        end
      end
    end
  end
end
