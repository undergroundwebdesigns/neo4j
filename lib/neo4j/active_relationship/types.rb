module Neo4j
  module ActiveRelationship


    # Provides a mapping between neo4j relationship types and Ruby classes
    module Types
      extend ActiveSupport::Concern

      WRAPPED_CLASSES = []

      def self.included(klass)
        add_wrapped_class(klass)
      end

      def self.add_wrapped_class(klass)
        _wrapped_classes << klass
        @_wrapped_types = nil
      end


      def self._wrapped_classes
        Neo4j::ActiveRelationship::Types::WRAPPED_CLASSES
      end

      protected

      # Only for testing purpose
      # @private
      def self._wrapped_types=(wl)
        @_wrapped_types=(wl)
      end

      def self._wrapped_types
        @_wrapped_types ||=  _wrapped_classes.inject({}) do |ack, clazz|
          ack.tap do |a|
            a[clazz.mapped_relationship_type.to_sym] = clazz if clazz.respond_to?(:mapped_relationship_type)
          end
        end
      end

      module ClassMethods

        # @return [Fixnum] number of nodes of this class
        def count(session = self.neo4j_session)
          q = session.query("MATCH (r:`#{mapped_relationship_type}`) RETURN count(r) AS count")
          q.to_a[0][:count]
        end

        # Destroy all nodes an connected relationships
        def destroy_all
          self.neo4j_session._query("MATCH (r:`#{mapped_relationship_type}`) DELETE r")
        end

        # @return [Symbol] the label that this class has which corresponds to a Ruby class
        def mapped_relationship_type
          @_type || self.to_s.to_sym
        end

        protected

        def find_by_hash(hash, session)
          # TODO: Needs work / testing.
          Neo4j::Relationship.query(mapped_relationship_type, {conditions: hash}, session)
        end

        def set_mapped_type(type)
          @_type = type.to_sym
        end

      end

    end

  end
end
