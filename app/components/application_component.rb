class ApplicationComponent < ViewComponent::Base
  delegate_missing_to :helpers
end
