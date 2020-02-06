# frozen_string_literal: true

SimpleCov.start :rails do
  enable_coverage :branch

  add_filter 'application_cable'
  add_filter 'jobs'
  add_filter 'mailers'
end
