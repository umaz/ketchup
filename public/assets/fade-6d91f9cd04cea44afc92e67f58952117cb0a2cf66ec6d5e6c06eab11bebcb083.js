function execute() {
  document.getElementById("word").className = "fadeout";
}
setTimeout(execute,8500);


/*
テスト環境で2度読みこまれてしまうため削除
現在はindex.html.erbに直接書いている
function new_project() {
  $.ajax({
    url: 'index',
    type: 'GET',
    dataType: 'script'
    });
  setTimeout(execute,8500);
  }

setTimeout(new_project, 3000);
*/
