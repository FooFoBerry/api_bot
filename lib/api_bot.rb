require 'faraday'
require 'json'

class ApiBot

  def make_commit_and_event
    make_commit
    sleep(rand(5))
    make_tracker_event
    sleep(rand(5))
  end

  def make_commit
    response = post('commits', sample_commit_data.to_json)
  end

  def make_tracker_event
    response = post('tracker_events', sample_tracker_event_data.to_json)
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
    Faraday::Connection.new "http://162.243.206.48/api/v1/"
  end

  def sample_commit_data(repo_id = 16033562)
    {
      :commit_id => commit_hashes.sample,
      :timestamp => "2014-01-13T18:45:47-08:00",
      :message => "add readme boom!",
      :repository => {
        :id  => "#{repo_id}",
        :url => "https://github.com/thewatts/testing-callbacks"
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

  def sample_tracker_event_data(pt_project_id = 1)
    author_name = authors.sample[:name]
    expected_data = { :tracker_event =>
      {
        :story_url => "http://www.pivotaltracker.com/story/show/64265964",
        :message   => "#{author_name} added this feature",
        :kind      => "story_create_activity",
        :user_name => author_name,
        :story_id  => 64265964,
        :change_type => "create",
        :story_title => "This is a test story",
        :user_initials => "TL",
        :pt_project_id => pt_project_id
      }
    }
  end

end
