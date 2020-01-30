<html>
<head>
<cfparam name="URL.Dir" default="">


<script language="JavaScript">

	function Selected(vDirectory)  {
		
	  returnValue = vDirectory;
	  window.close()	
		
	  }
		
</script>

<title>
Document Server Browsing
</title>
</head>
<body>


<cfajaximport tags="cftree">

<cfform>
<cftree name="root"
   font="tahoma"
   fontsize="11"		
   bold="No"   
   format="html"    
   required="No">  
   	
    	 <cftreeitem 
			  bind="cfc:Service.ServerDocument.Document.getNodes({cftreeitemvalue},{cftreeitempath},'#URL.DIR#','No')">  		 
 
 </cftree> 

 </cfform>

 
 </body>
 
 </html>