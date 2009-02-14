namespace :Tag do
  desc "Reset common taggings - slow"
  task(:reset_common => :environment) do
    Work.find(:all).each do |w|
      print "." if w.id.modulo(100) == 0; STDOUT.flush
      w.update_common_tags
    end
    puts "Common tags reset."
  end
  desc "Reset tag count"
  task(:reset_count => :environment) do
    Tag.find(:all).each do |t|
      Tag.update_counters t.id, :taggings_count => -t.taggings_count
      Tag.update_counters t.id, :taggings_count => t.taggings.length
    end
    puts "Tag count reset."
  end
  desc "Reset tag parents (fandom and media)"
  task(:reset_parents => :environment) do
    ThinkingSphinx.deltas_enabled=false
    Tag.find(:all).each do |t|
      t.add_fandom(t.fandom.id) if t.fandom
      t.add_media(t.media.id) if t.media
    end
    ThinkingSphinx.deltas_enabled=true
    puts "Tag parents reset."
  end
  desc "Delete unused tags"
  task(:delete_unused => :environment) do
    Tag.all.each do |t|
      if t.taggings.length == 0 && !t.merger_id && t.children.length == 0
        t.destroy
      end
    end
  end
end
