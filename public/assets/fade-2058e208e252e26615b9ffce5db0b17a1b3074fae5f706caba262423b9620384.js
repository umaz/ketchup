function execute() {
  document.getElementById("word").className = "fadeout";
}

function new_project() {
  $.ajax({
    url: 'index',
    type: 'GET',
    dataType: 'script'
  });
}

setTimeout(new_project, 3000);

if (typeof localStorage !== 'undefined') {
  // Web Storageに関する処理を記述
  function fav() {
    var link = "<a href=\"detail/" + gon.project_name +"\">" + gon.project_name + "</a>"
    localStorage.setItem(gon.project_name, link);
    alert(gon.project_name + "をお気に入り登録しました。");
  }
  //保存されているデータをリスト表示する
  function list() {
    var result = "";
    if (localStorage.length !== 0) {
    //保存されているデータの数だけループ
      for(var i=0; i<localStorage.length; i++){
        //i番目のキーを取得
        var k = localStorage.key(i);
        //キーと値をコロン（：）区切りのテキストにする
        result += localStorage.getItem(k) + "<br>";
      }
      //上のループで作成されたテキストを表示する
      document.getElementById("show_result").innerHTML = result;
    } else {
      document.getElementById("show_result").innerHTML = "";
    }
  }

  function clearall() {
    localStorage.clear();
    list();
  }
} else {
  window.alert("本ブラウザではWeb Storageが使えません");
}
