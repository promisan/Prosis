
<!--- trial --->

<cf_screentop html="yes" layout="webapp" jquery="Yes">

<style>

table{
  table-layout: fixed;
  td, th{
    overflow: hidden;
    white-space: nowrap;
    -moz-text-overflow: ellipsis;        
       -ms-text-overflow: ellipsis;
        -o-text-overflow: ellipsis;
           text-overflow: ellipsis;
  }
}

</style>

<script>

//var tables = document.getElementsByClassName('flexiCol');
var tables = document.getElementsByTagName('table');
for (var i=0; i<tables.length;i++){
 resizableGrid(tables[i]);
}

function resizableGrid(table) {
 var row = table.getElementsByTagName('tr')[0],
 cols = row ? row.children : undefined;
 if (!cols) return;
 
 table.style.overflow = 'hidden';
 
 var tableHeight = table.offsetHeight;
 
 for (var i=0;i<cols.length;i++){
  var div = createDiv(tableHeight);
  cols[i].appendChild(div);
  cols[i].style.position = 'relative';
  setListeners(div);
 }

 function setListeners(div){
  var pageX,curCol,nxtCol,curColWidth,nxtColWidth;

  div.addEventListener('mousedown', function (e) {
   curCol = e.target.parentElement;
   nxtCol = curCol.nextElementSibling;
   pageX = e.pageX; 
 
   var padding = paddingDiff(curCol);
 
   curColWidth = curCol.offsetWidth - padding;
   if (nxtCol)
    nxtColWidth = nxtCol.offsetWidth - padding;
  });

  div.addEventListener('mouseover', function (e) {
   e.target.style.borderRight = '2px solid #0000ff';
  })

  div.addEventListener('mouseout', function (e) {
   e.target.style.borderRight = '';
  })

  document.addEventListener('mousemove', function (e) {
   if (curCol) {
    var diffX = e.pageX - pageX;
 
    if (nxtCol)
     nxtCol.style.width = (nxtColWidth - (diffX))+'px';

    curCol.style.width = (curColWidth + diffX)+'px';
   }
  });

  document.addEventListener('mouseup', function (e) { 
   curCol = undefined;
   nxtCol = undefined;
   pageX = undefined;
   nxtColWidth = undefined;
   curColWidth = undefined
  });
 }
 
 function createDiv(height){
  var div = document.createElement('div');
  div.style.top = 0;
  div.style.right = 0;
  div.style.width = '5px';
  div.style.position = 'absolute';
  div.style.cursor = 'col-resize';
  div.style.userSelect = 'none';
  div.style.height = height + 'px';
  return div;
 }
 
 function paddingDiff(col){
 
  if (getStyleVal(col,'box-sizing') == 'border-box'){
   return 0;
  }
 
  var padLeft = getStyleVal(col,'padding-left');
  var padRight = getStyleVal(col,'padding-right');
  return (parseInt(padLeft) + parseInt(padRight));

 }

 function getStyleVal(elm,css){
  return (window.getComputedStyle(elm, null).getPropertyValue(css))
 }
};

</script>

<div class="container">
  <h2>Resizable Columns</h2>
  <table class="table table-bordered" style="width:100%" border="1" data-resizable-columns-id="demo-table-v2">
    <thead>
      <tr>
        <th data-resizable-column-id="nr">#</th>
        <th data-resizable-column-id="first_name">First Name</th>
        <th data-resizable-column-id="nickname">Nickname</th>
        <th data-resizable-column-id="last_name">Last Name</th>
        <th data-resizable-column-id="username" id="username-column">Username</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>1</td>
        <td>Mark</td>
        <td>Dude Meister</td>
        <td>Otto</td>
        <td>@mdo</td>
      </tr>
      <tr>
        <td>2</td>
        <td>Jacob</td>
        <td>Barney von Matterhorn</td>
        <td>Thornton</td>
        <td>@fat</td>
      </tr>
      <tr>
        <td>3</td>
        <td colspan="2">Larry the Bird</td>
        <td>What</td>
        <td>@twitter</td>
      </tr>
    </tbody>
  </table>
  </div>