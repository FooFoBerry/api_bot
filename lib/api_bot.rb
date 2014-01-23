require 'faraday'
require 'json'
require 'pusher'

class ApiBot

  attr_reader :env

  def initialize(desired_env = :prod)
    @commit_count = 0
    @env = desired_env
    Pusher.app_id = '57501'
    Pusher.key = '3568c8046d9171a5f8ee'
    Pusher.secret = '780e1174f5e7438514f6'
  end

  def make_commit_and_event
    2.times do
      notification = [:make_commit, :make_tracker_event].sample
      puts "=============================> #{notification}"
      send(notification)
      sleep(rand(6))
    end
  end

  def make_commit
    response = post('commits', sample_commit_data.to_json)
    make_climate
    @commit_count += 1
    if @commit_count % 7 == 0
      fail_build
    else
      pass_build
    end
  end

  def pass_build
    data = { :status => "passing" }
    Pusher['project_15'].trigger('travis_notification', :data => data)
    Pusher['project_18'].trigger('travis_notification', :data => data)
  end

  def fail_build
    data = { :status => "failing" }
    Pusher['project_15'].trigger('travis_notification', :data => data)
    Pusher['project_18'].trigger('travis_notification', :data => data)
  end

  def make_tracker_event
    response = post('tracker_events', sample_tracker_event_data.to_json)
  end

  def make_climate
    gpa = rand(3.3..4.0).round(2)
    difference = 4.0 - gpa
    data = [
      { :stat => "current", :gpa => gpa },
      { :stat => "difference", :gpa => difference }
    ]
    Pusher['project_15'].trigger('climate_notification', :data => data)
    Pusher['project_18'].trigger('climate_notification', :data => data)
  end

  private

  def post(path, body)
    connection.post do |req|
      req.url path
      req.headers['Content-Type'] = 'application/json'
      req.body = body
    end
  end

  def connection
    if env == :dev
      @connection ||= Faraday::Connection.new "http://localhost:8080/api/v1/"
    else
      Faraday::Connection.new "http://162.243.206.48/api/v1/"
    end
  end

  def sample_commit_data(repo_id = 16033562)
    message = github_messages.sample.downcase
    {
      :commit_id => commit_hashes.sample,
      :timestamp => "2014-01-13T18:45:47-08:00",
      :message => message,
      :repository => {
        :id  => "#{repo_id}",
        :url => "https://github.com/foofoberry/github_notification_dummy_app"
      },
      :author => authors.sample
    }
  end

  def commit_hashes
    [
      "682a7045b390a6dad249f2495562769d06749d45",
      "b94b44fb51261332ea07233342f9cdf8fe81596a",
      "e62558b5b2bb1dd881532c16c5bfe8ec27246ba3",
      "d99c9fb56f17087545461938999589a7ad4a5c62",
      "cec7f4c3ebce960ae3aec683749bbe0eae0f6975",
      "0a8de7d6fcab5eded2d2d38f8f42ba6fd14f4cac",
      "d312ab67ed17bfce172847c60d88a522f5a81bdc",
      "16bd7d454bdb8d22d0156dc4f71d3f56949cd877",
      "75c685b1e5783830518db1bf90b449ab5abe92f3",
      "b4f785742d9d1b2d6260919fc3c63b5fdf751859",
      "babac99720a6919b648c2f2c7804dbd397766d32"
    ]
  end

  def github_messages
    [
      "Update Readme file",
      "Clean Specs for Project Model",
      "Generate ProjectsController",
      "Clean Routes",
      "Add VCR",
      "Remove VCR",
      "Increase test Coverage to 99%",
      "Remove scaffolding Code",
      "Refactor Tractor for Project Model",
      "Add Comments Model and Association",
    ]
  end

  def authors
    [
      {
        :name     => "Nathaniel Watts",
        :email    => "reg@nathanielwatts.com",
        :username => "thewatts"
      },
      {
        :name     => "Simon Taranto",
        :email    => "Simon.Taranto@gmail.com",
        :username => "srt32"
      },
      {
        :name     => "Tyler Long",
        :email    => "tyler.stephen.long@gmail.com",
        :username => "Teapane"
      },
      {
        :name     => "Kevin Powell",
        :email    => "kevin.m.powell04@gmail.com",
        :username => "x46672"
      }
    ]
  end

  def kinds
    %w( story bug chore )
  end

  def author_initials
    {
      "Kevin Powell"    => "KP",
      "Tyler Long"      => "TL",
      "Simon Taranto"   => "ST",
      "Nathaniel Watts" => "NW",
    }
  end


  def tracker_story_title(type)
    {
      "story" => [
        "User logs in on homepage",
        "User creates account",
        "User can logout",
        "User creates a project"
      ],
      "bug" => [
        "Poor performance for admin users",
        "Home page caching issue",
        "Assets not compiling",
        "Omniauth callback failing"
      ],
      "chore" => [
        "Setup follower database",
        "Flesh out design styles",
        "Optimize Database",
        "Run migrations on Production"
      ]
    }[type].sample
  end

  def types
    %w( create finish start )
  end

  def sample_tracker_event_data(pt_project_id = 1)
    author_name = authors.sample[:name]
    initials = author_initials[author_name]
    kind = kinds.sample
    title = tracker_story_title(kind)
    type = types.sample
    id = rand(6 ** 10)
    expected_data = { :tracker_event =>
      {
        :story_url     => "http://www.pivotaltracker.com/story/show/#{id}",
        :message       => "#{author_name} added this feature",
        :kind          => kind,
        :user_name     => author_name,
        :story_id      => id,
        :change_type   => type,
        :story_title   => title,
        :user_initials => initials,
        :pt_project_id => pt_project_id
      }
    }
  end

end
