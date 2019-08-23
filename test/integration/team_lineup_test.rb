require 'test_helper'

class TeamLineupTest < ActionDispatch::IntegrationTest

  def setup
    @team1 = team_employees(:one)
    @employee = employees(:michael)
    @employee_noteam = employees(:archer)
  end

  test "should be lineup in homepage" do
    log_in_as(@employee)
    get root_path
    assert_select 'h1.teamname'
    assert_select 'a[href=?]', employee_path(@employee)
    assert_select 'a[href=?]', employee_path(@employee_noteam), count: 0
  end
end
