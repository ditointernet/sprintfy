class SprinterAuthorizer < ApplicationAuthorizer
  def self.default(adjective, user)
    user.has_role?(:sprinter) || user.has_role?(:admin)
  end

  def readable_by?(user)
    user.has_role?(:admin) || in_user_sprint?(user)
  end

  def updatable_by?(user)
    user.has_role?(:admin) || (user.has_role?(:sprinter) && in_user_sprint?(user))
  end

  protected

  def sprint_id
    resource.sprint_id
  end

  private

  def in_user_sprint?(user)
    SprintsUser.where(sprint_id: sprint_id, user_id: user.id).present?
  end
end
