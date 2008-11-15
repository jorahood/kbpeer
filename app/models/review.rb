class Review < Article

  has_finder :of, lambda { |editor| 
        raise "missing an 'editor' parameter" unless editor
    {:conditions => {:root_editor_id => editor[:id]}}
  }

end
