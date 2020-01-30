
<cfoutput>

<cfparam name="controlid" default="">
<cfparam name="outputid" default="">
<cfparam name="url.header" default="0">

<cfif controlid neq "">
  <cfset id = controlid>
<cfelse>
  <cfset id = outputid>
</cfif>
		
<input type="hidden" name="criteriashow" id="criteriashow" value="1" onclick="toggle()">

<!---

<script language="JavaScript">

 function toggleme() {
 			
	 se = document.getElementById("criteriashow")	
	 alert("a")	 	 						 
	 if (se.value == "0") {			 	 
	     try {
	 	 ColdFusion.Layout.expandArea('olap', 'top');		
		 } catch(e) {} 
		 window.status = "expanded"	 		 
		 se.value = 1 
	 } else {	 	
		 ColdFusion.Layout.collapseArea('olap', 'top')
		 window.status = "collapsed"	
		 se.value = 0 
 	 } 
 }	
			 
</script>

--->

<cfquery name="get" 
	datasource="appsSystem">
	SELECT  *
    FROM     Ref_ReportControl	
    WHERE    ControlId = '#id#'
</cfquery>	
	
<table border="0" width="98%" align="center" height="100%">

<script language="JavaScript">

function olapexp(mode) {
     
  se = document.getElementById("olapbase")
     
  if (mode == "reg") {     
      se.style.minheight = 356  
	  se.style.height = 356   
		  
   } else {  
      se.style.minheight = 0   	
	  se.style.height = 0
	
	}   
}

</script>

<cfif CGI.HTTPS eq "off">
     <cfset protocol = "http">
<cfelse> 
  	 <cfset protocol = "https">
</cfif>

<cfset protocol = "http">

<tr class="xhide"><td height="0">
	<iframe name="flex2gateway" src="#protocol#://#CGI.HTTP_HOST#/flex2gateway" frameborder="0" scrolling="no" width="22" height="0"></iframe> 	
</td></tr>

<tr valign="top" style="border:0px solid silver">

   	 <td id="olapbase" valign="top" style="border:0px solid silver;height:356px">
		 <cfset url.id = id>
		 <cfinclude template="SelectSourceCriteria.cfm">
	 </td>
			
</tr>
				
<tr><td valign="top" style="height:100%;padding-top:4px;padding-bottom:8px">

	<table width="100%" height="100%" align="center">
			<tr><td style="padding-right:3px;height:100%">
			
			  		<iframe name="pivottable" 
					  id="pivottable" 
					  width="100%" 
					  height="100%" 					  
					  marginwidth="0" 
					  marginheight="0" 
					  scrolling="no" 
					  frameborder="0">	
					  </iframe>
					  
			</td></tr>		  
		</table>			  		
						
    </td>
</tr>	

</table>
	
</cfoutput>

<cfif url.header is "1">
<cf_screenbottom layout="webapp">
<cfelse>
<cf_screenbottom layout="innerbox">
</cfif>
	
