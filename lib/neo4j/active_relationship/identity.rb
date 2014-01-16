module Neo4j::ActiveRelationship
  module Identity

    def ==(o)
      o.class == self.class && o.id == id
    end
    alias_method :eql?, :==

    # Returns an Enumerable of all (primary) key attributes
    # or nil if model.persisted? is false
    def to_key
      persisted? ? [id] : nil
    end

    # @return [Fixnum, nil] the neo4j id of the node if persisted or nil
    def neo_id
      _persisted_relationship ? _persisted_relationship.neo_id : nil
    end

    # @return [String, nil] same as #neo_id
    def id
      persisted? ? neo_id.to_s : nil
    end


  end

end
