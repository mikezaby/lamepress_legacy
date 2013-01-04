class Setting < ActiveRecord::Base

  def self.current_issue
    issue_id = where(meta_key: "current_issue").map(&:meta_value).first.to_i
    Issue.find_by_id(issue_id)
  end

  def self.block_placements
    where(meta_key: "block_placement").map(&:meta_value)
  end

  def self.navigator_blocks
    where(meta_key: "navigator_block").map(&:meta_value).collect {|block_id| Block.find_by_id(block_id)}
  end
end
