<script language="javascript">

function uncheckList(field)
// unchecks an item from a list
{
document.getElementById(field).selectedIndex = -1
}

function highlightcheck(sel)
// bolds or unbolds a checkbox item depending on selectedIndex
{

ie = document.all?1:0
ns4 = document.layers?1:0

var top = sel

if (ie){
        while (top.tagName!="TD")
        {top=top.parentElement;}
   }else{
        while (top.tagName!="TD")
        {top=top.parentNode;}
   }

if (sel.checked) {
  top.style.fontWeight='bold'
  } else {
  top.style.fontWeight='normal'
  }

}

function uncheckRadio(field) {
  document.getElementById(field).checked = false
}

function ClearRow(field, fieldNum) {
  for (i = 1; i <= fieldNum; i++)	
  document.getElementById(field+i).style.fontWeight='normal'
 }
 
function highlightitem(Itm) {
document.getElementById(Itm).style.fontWeight='bold'
}

function unhighlightitem(Itm) {
document.getElementById(Itm).style.fontWeight='normal'
}
  
function HighlightGroupItem(groupName,groupNo,Itm) {
ClearRow(groupName,groupNo)
document.getElementById(groupName+Itm).style.fontWeight='bold'
} 

<!--- this function replace ClearRow above, requires less code on the template --->

function ClearRow2(cell) {
  se = document.getElementsByName(cell)	   
  count = 0  
  while (se[count]) {
     se[count].style.fontWeight='normal'
	 count++
  }
 
 }


function selectradio(cell,sel) {

  ClearRow2(cell) 
    
  ie = document.all?1:0
  ns4 = document.layers?1:0
      
  if (ie){
          while (sel.tagName!="TD")
          {sel=sel.parentElement;}
     }else{
          while (sel.tagName!="TD")
          {sel=sel.parentNode;}
     }
  
  sel.style.fontWeight='bold'
	    
 }

</script>
