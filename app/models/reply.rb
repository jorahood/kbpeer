class Reply < Article

  has_finder :to, lambda { |editor| 
        raise "missing an 'editor' parameter" unless editor
    {:conditions => {:root_editor_id => editor[:id]}}
  }
end
