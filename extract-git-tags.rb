#!/usr/bin/env ruby

require "rugged"

if ARGV.length < 1
    puts "Usage: extract-git-tags.rb <git-repo>"
    exit 1
end

repo = Rugged::Repository.new(ARGV[0])

repo.tags.sort_by{|t|t.name}.reverse.each do |tag|
    atag = repo.lookup(tag.target_id)

    if atag.is_a? Rugged::Tag::Annotation
        puts "## #{atag.name}"
        puts "*#{atag.tagger[:time]}*"
        puts atag.message.split("\n").map{|l| "  #{l}"}.join("\n")
        puts
    end
end
