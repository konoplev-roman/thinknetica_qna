# frozen_string_literal: true

module QuestionHelper
  def question_header(question)
    if question.new_record?
      t('helpers.question.header.create')
    else
      t('helpers.question.header.edit')
    end
  end

  def question_form_options(question)
    default_options = {}

    # By default form submits are remote and unobtrusive XHRs.
    # Disable remote submits with local: true
    default_options.merge!(local: true) if question.new_record?

    default_options
  end
end
