function btnDisable(){ //①
  var n = document.getElementsByClassName("favorite_action");
  for(var i=0;i<n.length;i++){
     n[i].disabled = true;
   }
}

function disable(){ //① + ②
  statusDis  = setTimeout(btnDisable , 1); //ボタンを押した直後に①を呼び出し
}
