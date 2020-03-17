# frozen_string_literal: true

module QuestionHelper
  def question_header(question)
    if question.new_record?
      t('helpers.question.header.create')
    else
      t('helpers.question.header.edit')
    end
  end
end
