
<cfquery name="Base" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT     TOP 1 *
	 FROM  		Ref_ReportControlCriteria R
	 WHERE  	ControlId     = '#URL.ControlId#' 
	  AND    	CriteriaName  = '#URL.par#'  
</cfquery>


<HTML><HEAD>
    <TITLE><cfoutput>Search: #Base.CriteriaDescription#</cfoutput></TITLE>
   <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>"> 
</HEAD>

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onLoad="window.value.focus()">
	 
<cfoutput>
	 
<script>

 	function hl(itm,fld)
			
	 {
	
	 ie = document.all?1:0
	 ns4 = document.layers?1:0

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
			 	 	 		 	
	 if (fld == "1")
	      {itm.className = "highLight2";}
	 else 
	      {itm.className = "regular";}
	 }
	 
	function reset()
	
	{
	document.getElementById("value").value = "" 
	}

       
	function selected(key,display)

		{
		
		self.returnValue = key+";"+display
		self.close();

		}
				
		function search(pg) {
		 
		 document.getElementById("searching").className = "regular";
		 document.getElementById("result").className = "hide";
		 
		 val = document.getElementById("value")
		 adv = document.getElementById("variant")
		 if (adv.checked)
			{v = 1}
		 else
			{v = 0}
			
		 url = "FormHTMLComboSingleResult.cfm?ts="+new Date().getTime()+"&controlid=#url.controlId#&par=#URL.Par#"+
			   "&cur=#URL.val#&val="+val.value+"&adv="+v+"&page="+pg;
			  						 
		 AjaxRequest.get(
		    {
	      'url':url,
		  'onSuccess':function(req){ 
		  
			    document.getElementById("searching").className = "hide";
				document.getElementById("result").innerHTML = req.responseText;
				document.getElementById("result").className = "regular";
				},
				
		  'onError':function(req) { 
		      
			  	 alert('Error!\nStatusText='+req.statusText+'\nContents='+req.responseText);
				 }	
		    }
		   );
		  }  	
		   
</script>
<cf_ajaxRequest>
</cfoutput>	

<table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0" align="center">

 <tr>
  
   <td bgcolor="f4f4f4">&nbsp;&nbsp;<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/search.gif" alt="" border="0" align="absmiddle">
   &nbsp;<font face="Verdana"><b>Search:</b>
   <input type="text" value="" name="value" id="value" size="36" onclick="reset()" onKeyUp="search('1')">
   <input type="checkbox" name="variant" id="variant" value="1" onClick="search('1')">advanced</td>
   </td>
   
   <td align="right" height="28" bgcolor="f4f4f4">
   <input class="buttonFlat" type="button" style="width:80" name"Submit" id="Submit" value="Search" onclick="search('1')">&nbsp;
   </td></tr> 	

<tr><td colspan="2" valign="top">

    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<cfif #Base.CriteriaHelp# neq "">
	<tr><td colspan="3" bgcolor="ffffef" style="border: 1px solid #silver;">: <cfoutput query="Base">#CriteriaHelp#</cfoutput></td></tr>	
	</cfif>
		
	<tr id="searching" class="hide">
		<td align="center" bgcolor="ffffbf" colspan="3"><b>Searching ..</td>
	</tr>
	<TR>
	<td height="200" colspan="3" id="result"></td></TR>
	
	</table>
	
	</td>
	</tr>
	
	<tr><td colspan="2" align="right" height="27" bgcolor="f4f4f4">
		<input type="button" style="width:100"  class="buttonFlat" name="TestReturn" id="TestReturn" onclick="selected('blank','blank')" value="Undo selection">
		<input type="button" style="width:100"  class="buttonFlat" name="TestReturn" id="TestReturn" onclick="window.close()" value="Close">&nbsp;
	</td></tr>
		

</table>	

	<script language="JavaScript">
	 search('1')
	</script>
	

</BODY></HTML>


</body>
</html>
