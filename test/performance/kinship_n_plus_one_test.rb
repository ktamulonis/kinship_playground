require "test_helper"

class KinshipNPlusOneTest < ActiveSupport::TestCase
  def count_queries
    count = 0
    callback = ->(*args) do
      payload = args.last
      count += 1 unless payload[:name] =~ /SCHEMA|TRANSACTION/
    end

    ActiveSupport::Notifications.subscribed(
      callback,
      "sql.active_record"
    ) { yield }

    count
  end

  test "deep traversal causes N+1 without kinship" do
    queries = count_queries do
      User.all.each do |u|
        u.projects.each do |p|
          p.tasks.each do |t|
            t.comments.each do |c|
              c.reactions.each(&:kind)
            end
          end
        end
      end
    end

    puts "Queries executed: #{queries}"

    assert queries > 100, "Expected obvious N+1 explosion"
  end

  def test_deep_traversal_causes_n_plus_one
    query_count = count_queries do
      User.all.each do |user|
        # Break Rails’ ability to batch
        user.projects.map(&:id)

        user.projects.each do |project|
          project.tasks.each do |task|
            # Access through different paths
            task.comments.first&.reactions&.map(&:kind)
          end
        end
      end
    end

    puts "Queries executed: #{query_count}"
    assert query_count > 50, "Expected real N+1 explosion"
  end

end

