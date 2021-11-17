
<cf_screentop height="100%" scroll="Yes" html="No" jQuery="Yes" blockevent="rightclick">
   
<cfoutput>
<script language="JavaScript">
 
function load(site) {
   Prosis.busy('yes')
   ptoken.location("ParameterEdit.cfm?idmenu=#URL.IdMenu#&host="+site)
 }
 
function del(site) {
   Prosis.busy('yes')
   ptoken.location("ParameterEdit.cfm?idmenu=#URL.IdMenu#&delete="+site)
 } 

var isNN = (navigator.appName.indexOf("Netscape")!=-1);

function autoTab(input,len, e) {
	var keyCode = (isNN) ? e.which : e.keyCode; 
	var filter = (isNN) ? [0,8,9] : [0,8,9,16,17,18,37,38,39,40,46];
	if(input.value.length >= len && !containsElement(filter,keyCode)) {
	input.value = input.value.slice(0, len);
	input.form[(getIndex(input)+1) % input.form.length].focus();
	}
	function containsElement(arr, ele) {
	var found = false, index = 0;
	while(!found && index < arr.length)
	if(arr[index] == ele)
	found = true;
	else
	index++;
	return found;
	}
	function getIndex(input) {
	var index = -1, i = 0, found = false;
	while (i < input.form.length && index == -1)
	if (input.form[i] == input)index = i;
	else i++;
	return index;
	}
	return true;
}


</script>
</cfoutput>

<cfparam name="URL.delete" default="">

<cfif url.delete neq "">
	
	<cfquery name="delete" 
	datasource="AppsInit">
		DELETE FROM Parameter 
		WHERE  HostName = '#url.delete#' 
	</cfquery>

</cfif>

<cfparam name="URL.host" default="#CGI.HTTP_HOST#">

<cfajaximport tags="cfform,cfdiv,cfinput-datefield">

<cfquery name="List" 
datasource="AppsInit">
	SELECT *  
	FROM Parameter 
</cfquery>
 
<cfquery name="Get" 
datasource="AppsInit">
	SELECT * 
	FROM Parameter 
	WHERE HostName = '#URL.host#' 
</cfquery>

<cfset Page         = "0">
<cfset add          = "0"> 
<cfset back         = "0"> 
<cfset option       = "">
<cfinclude template="HeaderParameter.cfm">

<cfoutput>
	<script>
	function validate(itm) {
		document.editform.onsubmit() 
		if( _CF_error_messages.length == 0 ) {	  
		    _cf_loadingtexthtml='';	
			Prosis.busy('yes')          
			ptoken.navigate('ParameterSubmit.cfm?host=#url.host#&idmenu=#URL.IdMenu#&item='+itm,'contentbox1','','','POST','editform')
		 }   
	}	 
	</script>
</cfoutput>

<table width="99%" align="center">

<tr>
  <td class="labelmedium" style="height:20px;padding-left:20px">
  <font color="808080">The following application instances have been enabled on this server:</b></font>
  </td>
</tr>

<tr><td>

<!--- Entry form --->

	<table width="100%" border="0" align="center">
	
	<tr>
	<td colspan="2">
	
		<table width="98%" align="center" class="navigation_table">
		
		<tr class="labelmedium line fixlengthlist" style="height:10px">
		 
		        <td class=""></td>
		  		<td><cf_tl id="Hostname"></td>
				<td><cf_tl id="Server"></td>
			    <td><cf_tl id="Root"></td>
				<td><cf_tl id="Manager"></td>
				<td></td>
		</tr>   
		
		<cfoutput query="List">
		<tr bgcolor="<cfif URL.host eq HostName>ffffcf</cfif>" class="line navigation_row labelmedium fixlengthlist">
		   <td height="20" align="center">
		   <cfif URL.Host neq HostName>
		      <cf_img icon="select" navigation="Yes" onClick="load('#HostName#')"> 	   
		   </cfif>
		   </td>
		   <td>#HostName#</td>
		   <td>#ApplicationServer#</td>
		   <td>#List.ApplicationRoot#</td>
		   <td>#List.SystemContact#</td>
		   <td>
		   <cfif CGI.HTTP_HOST neq HostName>
			   <img src="#SESSION.root#/Images/delete5.gif" 
			        onclick="javascript:del('#HostName#')" 			
					width="13" 
					height="13" 
					border="0">
		   </cfif>	
		   </td>
		   
		</tr>
		
		</cfoutput>
		</table>
	
	</td></tr>
	
	<tr><td valign="top">
	
		<table width="98%" align="center">
			
			<tr><td>
			
				<cfoutput>
			
					<table height="100%" class="formpadding">	
					<!--- <tr><td align="center" class="labelmedium"><b>Disclaimer:</td></tr> --->
					<tr><td style="font-weight:300px" class="labelmedium"><font size="6" color="808080">#get.HostName#</font><br>Application parameters are stored on a local Database called db.Parameter. There may be different Parameter database instances each serving a different set of application server.
					</td></tr>
					
					</table>
				
				</cfoutput>
			
			</td></tr>
			
			<cf_menuscript>
						
			<tr><td valign="top" height="30" style="padding-left:20px">
			
			<cfset ht = "48">
			<cfset wd = "48">
			
			<table height="100%">
			
			<tr>
								
					<cf_menutab item       = "1" 
				        iconsrc    = "Connection.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						targetitem = "1"
						name       = "Connection Settings"
						source     = "ParameterEditConnection.cfm?host=#url.host#">			
									
					<cf_menutab item       = "2" 
				        iconsrc    = "Logos/System/Log.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						targetitem = "1"
						name       = "Exception Log Settings"
						source     = "ParameterEditOwner.cfm?host=#url.host#">		
						
					<cf_menutab item       = "3" 
				        iconsrc    = "Logos/System/Maintain.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						targetitem = "1"
						name       = "Settings and Branding"
						source     = "ParameterEditSettings.cfm?host=#url.host#">					
						
					<cf_menutab item       = "4" 
				        iconsrc    = "Folder.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						targetitem = "1"
						name       = "Application and File Location"
						source     = "ParameterEditLocation.cfm?host=#url.host#">					
									
					<cf_menutab item       = "5" 
				        iconsrc    = "Logos/System/Secure.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						targetitem = "1"
						name       = "Security Settings"
						source     = "ParameterEditSecurity.cfm?host=#url.host#">				
			
			<td style="width:5%"></td>
				
			</tr>
			
			</table>
			
			</td>
			
			</tr>
						
			<tr class="line"><td height="100%">
				
				<table height="100%" width="100%">			
					<cf_menucontainer item="1" class="regular">		
				</table>
			
			</td></tr>
			
			<tr><td class="labelit"><font color="C10000">Parameters should <b>only</b> be changed if you are absolutely certain of their effect on the system.</font>
					<font color="808080">Changes to any of the Parameter <b>ARE</b> logged in an Audit Trail. In case you have any doubt always consult your assignated focal point.</td></tr>
		</table>
	
	</td></tr>
	</table>
	
	</td></tr>
	</table>

<cfoutput>

	<script>
	    document.getElementById('menu1').click()
	</script>
	
</cfoutput>
