import consumer from "./consumer"

document.addEventListener('turbolinks:load', function(){
  let userId = document.getElementById('broadcast_id').innerHTML;
  consumer.subscriptions.create("BroadcastChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
      // alert('hello');
      console.log(consumer)
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      if (data.includes(userId)) {
        alert('公車即將到站');
      };
    }
  });
});

