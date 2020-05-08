module DriversHelper
  def available(driver)
    "availavle" if driver.available
    # ", completed at #{task.completed_at}" unless task.completed_at.nil?
  end
end
