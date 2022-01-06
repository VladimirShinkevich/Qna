import consumer from "./consumer"

$(document).on('turbolinks:load', function () {


  if ($('.question').length) {
    consumer.subscriptions.create({ channel: "AnswersChannel",id: $('.question').data('id')},  {
      connected() {
        console.log('Connected to answers stream!')
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        this.appendLine(data)
      },
    
      appendLine(data) {
        const html = this.createLine(data)
        $('.other-answers').append(html)
      },
    
      createLine(data) {
        return data.html
      }
      
    });
  }
})
