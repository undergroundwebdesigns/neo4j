class Neo4j::Node

  module Wrapper

    # this is a plugin in the neo4j-core so that the Ruby wrapper will be wrapped around the Neo4j::Node objects
    def wrapper
      wrappers = _class_wrappers
      if wrappers.empty?
        self
      else
        found = wrappers.sort.first
        wrapped_node = Neo4j::ActiveNode::Labels._wrapped_labels[found].new
        wrapped_node.init_on_load(self, self.props)
        wrapped_node
      end
    end

    def _class_wrappers
      labels.find_all do |label_name|
        Neo4j::ActiveNode::Labels._wrapped_labels[label_name].class == Class
      end
    end
  end

end

class Neo4j::Relationship
  module Wrapper
    def wrapper
      data = load_resource.symbolize_keys

      wrapper = _class_wrapper(data)
      if wrapper
        wrapped_relationship = wrapper.new
        wrapped_relationship.init_on_load(self, data[:data])
        wrapped_relationship
      else
        self
      end
    end

    def _class_wrapper(data)
      type = data[:type]

      if type =~ /#/
        type, _ = type.split("#")
      end

      Neo4j::ActiveRelationship::Types._wrapped_types[type.to_sym]
    end
  end
end
