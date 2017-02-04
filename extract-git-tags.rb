#!/usr/bin/env ruby

require "rugged"

if ARGV.length < 1
    puts "Usage: extract-git-tags.rb <git-repos>..."
    exit 1
end

class RepoTag
    def initialize(repo_name, tag)
        @repo_name = repo_name
        @tag = tag
    end

    def time
        @tag.tagger[:time]
    end

    def color
        case @repo_name
            when "backend" then "blue"
            when "webclient" then "green"
            when "android" then "brown"
            when "ios" then "darkred"
        end
    end

    def to_s
        s = "===== #{@repo_name}: #{@tag.name} =====\n"
        s += "== #{self.time} ==\n"
        s += @tag.message.split("\n").map{|l| "  #{l}"}.join("\n")
        return s
    end
end

all_tags = ARGV.map { |arg|
    repo_name = File.split(arg)[-1]
    repo = Rugged::Repository.new(arg)

    repo.tags.map { |tag|
        atag = repo.lookup(tag.target_id)
        atag.is_a?(Rugged::Tag::Annotation) ? RepoTag.new(repo_name, atag) : nil
    }.find_all { |t| not t.nil? }
}.flatten

all_tags.sort_by { |t| t.time }.reverse.each do |tag|
    puts tag
    puts
end