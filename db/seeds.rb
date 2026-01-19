User.destroy_all

10.times do |u|
  user = User.create!(name: "User #{u}")

  5.times do |p|
    project = user.projects.create!(name: "Project #{p}")

    5.times do |t|
      task = project.tasks.create!(title: "Task #{t}")

      5.times do |c|
        comment = task.comments.create!(body: "Comment #{c}")

        3.times do |r|
          comment.reactions.create!(kind: %w[like laugh wow].sample)
        end
      end
    end
  end
end

