module Neo4j::ActiveRelationship::Initialize
  extend ActiveSupport::Concern

  attr_reader :_persisted_relationship

  # called when loading the relationship from the database
  # @param [Neo4j::Node] persisted_relationship the relationship this class wraps
  # @param [Hash] properties properties of the persisted relationship.
  def init_on_load(persisted_relationship, properties)
    @_persisted_relationship = persisted_relationship
    @changed_attributes && @changed_attributes.clear
    @attributes = attributes.merge(properties.stringify_keys)
  end

  # Implements the Neo4j::Node#wrapper and Neo4j::Relationship#wrapper method
  # so that we don't have to care if the relationship is wrapped or not.
  # @return self
  def wrapper
    self
  end

end


