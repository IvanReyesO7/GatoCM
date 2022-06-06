// Get the modal
let modalImage = document.getElementById("myModalImage");

// Get the button that opens the modal
let btn = document.getElementById("create-image-card");

// Get the <span> element that closes the modal
let span = document.getElementsByClassName("close-image")[0];

// When the user clicks the button, open the modal 
btn.onclick = function() {
  modalImage.style.display = "block";
}

// When the user clicks on <span> (x), close the modalImage
span.onclick = function() {
  modalImage.style.display = "none";
}

// When the user clicks anywhere outside of the modalImage, close it
window.onclick = function(event) {
  if (event.target == modalImage) {
    modalImage.style.display = "none";
  }
}