require 'rails_helper'

RSpec.describe Project, type: :model do
  # 所有者、名前があれば有効な状態であること
  it "is valid with owner, name" do
    project = FactoryBot.build(:project)

    expect(project).to be_valid
  end

  # 名前がなければ無効な状態であること
  it "is invalid without a name" do
    project = FactoryBot.build(:project, name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    project = FactoryBot.create(:project, name: "Test Project")
    new_project = project.owner.projects.build(name: "Test Project")

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do
    project = FactoryBot.create(:project, name: "Test Project")
    other_project = FactoryBot.build(:project, name: "Test Project")

    expect(other_project).to be_valid
  end

  # たくさんのメモが付いていること
  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  describe "late status" do
#    # 継承を使う場合
#    # 締切日が過ぎていれば遅延していること
#    it "is late when the due date is past today" do
#      project = FactoryBot.create(:project_due_yesterday)
#      expect(project).to be_late
#    end
#  
#    # 締切日が今日ならスケジュールどおりであること
#    it "is on time when the due date is today" do
#      project = FactoryBot.create(:project_due_today)
#      expect(project).to_not be_late
#    end
#  
#    # 締切日が未来ならスケジュールどおりであること
#    it "is on time when the due date is in the future" do
#      project = FactoryBot.create(:project_due_tomorrow)
#      expect(project).to_not be_late
#    end

    # traitを使う場合
    # 締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    # 締切日が今日ならスケジュールどおりであること
    it "is on time when the due date is today" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    # 締切日が未来ならスケジュールどおりであること
    it "is on time when the due date is in the future" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
