class SprintAuthorizer < SprinterAuthorizer
  protected

  def sprint_id
    resource.id
  end
end
