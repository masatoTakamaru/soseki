document.querySelector('.search-postal-code').addEventListener('click', () => {
  const postalCode = document.querySelector("#student_postal_code");
  fetch("/search/"+postalCode.value)
    .then((data) => data.json())
    .then((obj) => {
      if(obj === null) {
        const elem = document.querySelector(".search-postal-code-error");
        elem.innerHTML = "該当する住所が見つかりません。";
      } else {
        const address = document.querySelector("#student_address");
        address.value = obj.prefecture + obj.city + obj.town;
        const error = document.querySelector(".search-postal-code-error");
        error.innerHTML = "";
      }
    });
});


