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

  def sample_commit_data(repo_id = 1)
    {
      :commit_id => "96dd704dc8770624e5da9082498c531edf0aef4a",
      :timestamp => "2014-01-13T18:45:47-08:00",
      :message => "add readme boom!",
      :repository => {
        :id  => "#{repo_id}",
        :url => "https://github.com/thewatts/testing-callbacks"
      },
      :author => authors.sample
    }
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
    expected_data = { :tracker_event =>
      {
        :story_url => "http://www.pivotaltracker.com/story/show/64265964",
        :message   => "Tyler Long added this feature",
        :kind      => "story_create_activity",
        :user_name => "Tyler Long",
        :story_id  => 64265964,
        :change_type => "create",
        :story_title => "This is a test story",
        :user_initials => "TL",
        :pt_project_id => pt_project_id
      }
    }
  end

end
