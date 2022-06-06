// Get the modal
let modalCode = document.getElementById("myModalCode");

// Get the button that opens the modal
let btn = document.getElementById("create-file-card");

// Get the <span> element that closes the modal
let span = document.getElementsByClassName("close-code")[0];

// When the user clicks the button, open the modal 
btn.onclick = function() {
  modalCode.style.display = "block";
}

// When the user clicks on <span> (x), close the modalCode
span.onclick = function() {
  modalCode.style.display = "none";
}

// When the user clicks anywhere outside of the modalCode, close it
window.onclick = function(event) {
  if (event.target == modalCode) {
    modalCode.style.display = "none";
  }
}