$(document).on('turbolinks:load', function() {
    $('.answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();

        var answerId = $(this).data('answerId');

        $('#answer-' + answerId + ' .answer').addClass('d-none');
        $('#answer-' + answerId + ' .edit-answer').removeClass('d-none');
    })
});
