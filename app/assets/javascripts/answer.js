$(document).on('turbolinks:load', function() {
    $('.answers').on('click', '.edit-answer-link', function(event) {
        event.preventDefault();

        var answerId = $(this).data('answerId');

        $('#answer-' + answerId + ' .answer').addClass('d-none');
        $('#answer-' + answerId + ' .edit-answer').removeClass('d-none');
    })
});
