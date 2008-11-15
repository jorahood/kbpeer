class StatsController < ApplicationController
  before_filter :setup_stats

  protected

  def setup_stats
    process_params if params['timespan']
    @editors = Editor.find_all_current
    @subdivisions = Timespan.subdivisions
    @timespan = Timespan.new(
      :start => @start, 
      :finish => @finish, 
      :subdivision => @subdivision,
      :editor_id => @editor_id)
    @timespan.calc_stats
  end
  
  def process_params
    @start = build_date_from_params("start", params['timespan'])
    @finish = build_date_from_params("finish", params['timespan'])
    @subdivision = params['timespan']['subdivision']
    @editor_id = params['timespan']['editor_id']  
  end

  def build_date_from_params(field_name, p_hash)
    return unless p_hash and p_hash["#{field_name.to_s}(1i)"] and 
      p_hash["#{field_name.to_s}(2i)"] and p_hash["#{field_name.to_s}(3i)"]
    Date.new(p_hash["#{field_name.to_s}(1i)"].to_i, 
      p_hash["#{field_name.to_s}(2i)"].to_i, 
      p_hash["#{field_name.to_s}(3i)"].to_i)
  end

end