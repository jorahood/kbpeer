class Review < Article

  named_scope :of, lambda { |editor|
        raise "missing an 'editor' parameter" unless editor
    {:conditions => {:root_editor_id => editor[:id]}}
  }

end
