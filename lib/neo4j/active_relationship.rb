module Neo4j

  # Makes Neo4j relationships representable in a way similar to
  # active record objects.
  # By including this module in your class, you can reference
  # it on a has_n or has_one relationship in a Neo4j::ActiveNode
  # class so that relationships  of the given type will be wrapped
  # in an instance of your relatioship class, allowing you to store
  # properties on the relationship and work with it directly.
  #
  module ActiveRelationship
    extend ActiveSupport::Concern
    extend ActiveModel::Naming

    include ActiveModel::Conversion
    include ActiveModel::Serializers::Xml
    include ActiveModel::Serializers::JSON
    include Neo4j::ActiveRelationship::Initialize
    include Neo4j::ActiveRelationship::Identity
    include Neo4j::ActiveRelationship::Persistence
    include Neo4j::ActiveNode::Property
    include Neo4j::ActiveRelationship::Types

    include Neo4j::ActiveRelationship::Callbacks
    include Neo4j::ActiveNode::Validations

    def wrapper
      self
    end

    def neo4j_obj
      _persisted_relationship || raise("Tried to access native neo4j object on a none persisted object")
    end

    module ClassMethods
      def neo4j_session_name (name)
        @neo4j_session_name = name
      end

      def neo4j_session
        if @neo4j_session_name
          Neo4j::Session.named(@neo4j_session_name) || raise("#{self.name} is configured to use a neo4j session named #{@neo4j_session_name}, but no such session is registered with Neo4j::Session")
        else
          Neo4j::Session.current
        end
      end
    end

    included do
      def self.inherited(other)
        attributes.each_pair do |k,v|
          other.attributes[k] = v
        end
        Neo4j::ActiveRelationship::Types.add_wrapped_class(other)
        super
      end
    end
  end
end
