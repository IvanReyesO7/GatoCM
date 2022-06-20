// Get the modal
let modalList = document.getElementById("myModalList");

// Get the button that opens the modal
let btn = document.getElementById("create-list-card");

// Get the <span> element that closes the modal
let span = document.getElementsByClassName("close-list")[0];

// When the user clicks the button, open the modal 
btn.onclick = function() {
  modalList.style.display = "block";
}

// When the user clicks on <span> (x), close the modalList
span.onclick = function() {
  modalList.style.display = "none";
}

// When the user clicks anywhere outside of the modalList, close it
window.onclick = function(event) {
  if (event.target == modalList) {
    modalList.style.display = "none";
  }
}