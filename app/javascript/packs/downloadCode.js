const downloadCode = () => {
  const code = document.querySelector('.code-data');
  const downloadBtn = document.querySelector('.download-btn');
  downloadBtn.addEventListener('click', downloadFile);
  function downloadFile(e) {
    const codeObject = JSON.parse(code.dataset['code']);
    const pom = document.createElement('a');
    // Create the file
    const content = codeObject['content'];

    pom.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(content));
    pom.setAttribute('download', `${codeObject['title']}`);

    if (document.createEvent) {
      const event = document.createEvent('MouseEvents');
      event.initEvent('click', true, true);
      pom.dispatchEvent(event);
    }
    else {
      pom.click();
    }
  }
}
  
downloadCode();