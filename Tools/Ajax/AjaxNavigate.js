// ===================================================================
// Author: Hanno van Pelt
// WWW: http://www.promisan.com/
//
// NOTICE: You may use this code for any purpose, commercial or
// private, without any further permission from the author. You may
// remove this notice from your final code if you wish, however it is
// appreciated by the author if at least my web site address is kept.
//
// You may *NOT* re-distribute this code in any way except through its
// use. That means, you can include it in your product, or your web
// site, or any other form where the code is actually being used. You
// may not put the plain javascript up on your site for download or
// include it in your javascript libraries for download. 
// If you wish to share this code with others, please just point them
// to the URL instead.
// Please DO NOT link directly to my .js files from your site. Copy
// the files to your server and use them there. Thank you.
// =======================================================


//
//	<input type="hidden" name="row"    value="0">
//	<input type="hidden" name="total"  value="#resultListing.recordcount#">
//	<input type="hidden" name="topic"  value="#resultListing.objectid#" onclick="process(this.value)">


// <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffff'))#" 
//	style       = "cursor : hand;"
//	id          = "r#currentrow#" 
//   class       = "regular"
//	onKeyUp     = "javascript:navigate()"
//	onclick     = "selectact('#currentrow#','#ObjectId#')"
//	onmouseover = "if (this.className=='regular') {this.className='highlight1'}"
//	onmouseout  = "if (this.className=='highlight1') {this.className='regular'}"
//	ondblclick  = "javascript:process('#ObjectId#')">



function clearsearch() { 
   document.getElementById("find").value = "" 
   }

function search() {

	try {      
	 if (window.event.keyCode == "13")
		{	document.getElementById("refresh").click() }
	} catch(e) {}
			
    }
	
function navigate()	{
		
		try { 
			
		rowno  = document.getElementById("row").value
		tpc    = document.getElementById("topic")
					 
		if (window.event.keyCode == "13") {	
		    try { 
		   if (tpc.value != "") { 		  
		   document.getElementById("topic").click()
		   } } 
		   catch(e) {}
		    		
		}	
		 
		if (window.event.keyCode == "40") {	
		   try
		   { 
		   r = rowno-1+2
		   document.getElementById("r"+r).click()
		   }
		   catch(e) {}
		   
		 }
		 				 
		if (window.event.keyCode == "38") {	
		   try
		   { 
		   r = rowno-1
		   se  = document.getElementById("r"+r).click()
		   }
		   catch(e) {}
		   
		 } 
		 
		 if (window.event.keyCode == "33") {	
		   try
		   { 
		   p = document.getElementById("page").value
		   r = p-1
		   if (r != 0){
		   document.getElementById("page").value = r
		   document.getElementById("refresh").click()}
		   }
		   catch(e) {}
		   
		 }
		 
		 if (window.event.keyCode == "34") {	
		   try
		   { 
		   p = document.getElementById("page").value
		   pgs = document.getElementById("pages").value
		   r = p-1+2
		   if (r <= pgs){
		   document.getElementById("page").value = r
		   document.getElementById("refresh").click()
		   }
		   }
		   catch(e) {}
		   
		 }
		 
		 } catch(e) {}
		
		}
			   
	function selectact(rowno,tpc) {
			   	
		   document.getElementById("row").value   = rowno	   
		   document.getElementById("topic").value = tpc
		   count = 0
		   tot   = document.getElementById("total").value
				 				 	   
		   while (count <= tot) {
			   try { 
				   rw = document.getElementById("r"+count)
				   rw.className = "regular"
			   	   } catch(e) {}
				   count++ 
			   }
			   rw = document.getElementById("r"+rowno)
			   rw.className = "highlight2"
			  	   	   
		   }