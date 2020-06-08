$(document).on('turbolinks:load', function() {
    $('.votes a').on('ajax:success', function(e) {
        var result = e.detail[0];

        var votes_control = $(this).parent();

        votes_control.find('.total').text(result['rating']);

        votes_control.find('.vote_up').toggleClass('d-none');
        votes_control.find('.vote_down').toggleClass('d-none');

        votes_control.find('.vote_cancel').toggleClass('d-none');

        $('#flash-messages').html('<div class=\'my-3 alert alert-success\' role=\'alert\'><p class=\'mb-0\'>' + result['message'] + '</div>');
    }).on('ajax:error', function(e) {
        var result = e.detail[0];

        var errors = $.makeArray(result['error']);

        var alerts = $.map(errors, function(message) {
            return '<p class=\'mb-0\'>' + message + '</p>'
        }).join('');

        $('#flash-messages').html('<div class=\'my-3 alert alert-danger\' role=\'alert\'>' + alerts + '</div>');
    });
});
