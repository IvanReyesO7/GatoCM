function slideToTheLeft(element) {
  $(element).animate({"left": "-100%"}, 500);
}
$('.flash-alert-live').toArray().forEach((flash, index) => {
  setTimeout(() => {
    setTimeout(()=> {
      slideToTheLeft(flash);
    }, (index * 100));
  }, 5000);
});
