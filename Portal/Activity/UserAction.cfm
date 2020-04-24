
<cf_screentop height="100%" scroll="Yes" html="No" jQuery="yes">

<cf_PresentationScript>
<cf_dialogStaffing>
<cfparam name="URL.View" default="Hide">
<cfparam name="URL.Group" default="LastName">

<cfajaximport>

<cfoutput>
<script language="JavaScript">

function reloadForm(view,sort) {
  ptoken.location("UserAction.cfm?time=#now()#&view="+view+"&group="+sort)
}  

function portal() {
	ptoken.location("../Portal.cfm");
}   

function listing(row,act,id1,id2,id3) {
	if ($('##d'+row).is(':visible')) {
		$('##d'+row).hide();
	 } else {	 	     
		$('##d'+row).show();
		ptoken.navigate('UserActionDetail.cfm?account='+id1+'&HostName='+id2+'&HostSessionNo='+id3+'&row=' + row,'i'+row);
	 } 		
  }

function refresh() {
    Prosis.busy('yes')
	history.go()
}  

function clearno() { document.getElementById("find").value = "" }

function search() {

	se = document.getElementById("find")
	 
	 if (window.event.keyCode == "13")
		{	document.getElementById("locate").click() }
						
    }
	
</script>

</cfoutput>

<cfif getAdministrator("*") eq "1">

	<cfset Drill.recordcount = "1">
	
<cfelse>

	<cfquery name="Drill" 
	datasource="AppsOrganization">
		SELECT  *
		FROM    OrganizationAuthorization
		WHERE   UserAccount = '#SESSION.acc#'
		AND     Role = 'AdminUser'
	</cfquery>

</cfif>

<cfset diff = DateAdd("n", "-1440", "#now()#")>	

<cfquery name="Logon" 
datasource="AppsSystem">
	DELETE  FROM  UserStatus  
	WHERE   ActionTimeStamp < #diff#
</cfquery>		

<cfset diff = DateAdd("n", "-#CLIENT.Timeout#", "#now()#")>

<table width="98%" align="right" height="100%">

<tr><td style="padding:5px" height="10">
   
	<cfinclude template="UserActionSummary.cfm">
	
</td></tr>

<tr><td style="height:10">
  
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr>
	
	<cfoutput>
	
	<td width="100" valign="top">
	
		<cfparam name="url.search" default="">
		
		<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		
		 <td style="padding-left:10px">	
		 
		 	<table border="0" cellspacing="0" bgcolor="white" cellpadding="0" class="formpadding">
			<tr><td>
		 		<cfinvoke component = "Service.Presentation.TableFilter"  
					   method           = "tablefilterfield" 
					   filtermode       = "direct"
					   name             = "filtersearch"
					   style            = "font:14px;height:25;width:120"
					   rowclass         = "clsFilterRow"
					   rowfields        = "ccontent">
			</td>
			</tr></table>  
			 
		  </td> 	   			      
		</tr>
		</table>
	
	</td>
			
	<td width="90%" cstyle="padding-left:10px">
	
		<table>
		<tr class="labelit">
		<td><input type="radio" id="order" class="Radiol" name="order" value="LastName" checked onclick="document.getElementById('orderselect').value='LastName';ptoken.navigate('UserActionLastName.cfm?view='+document.getElementById('view').value+'&find=','detail')"></td>
		<td style="padding-left:4px"><cf_tl id="Name"></td>
		<td style="padding-left:4px"><input type="radio" id="order" class="Radiol" name="order" value="Entity" onclick="document.getElementById('orderselect').value='Entity';ptoken.navigate('UserActionEntity.cfm?view='+document.getElementById('view').value+'&find=','detail')"></td>
		<td style="padding-left:4px"><cf_tl id="Entity"></td>
		<td style="padding-left:4px"><input type="radio" id="order" class="Radiol" name="order" value="Server" onclick="document.getElementById('orderselect').value='Server';ptoken.navigate('UserActionServer.cfm?view='+document.getElementById('view').value+'&find=','detail')"></td>
		<td style="padding-left:4px"><cf_tl id="Server"></td>
		<td style="padding-left:4px"><input type="radio" id="order" class="Radiol" name="order" value="Directory" onclick="document.getElementById('orderselect').value='Directory';ptoken.navigate('UserActionDirectory.cfm?view='+document.getElementById('view').value+'&find=','detail')"></td>
		<td style="padding-left:4px"><cf_tl id="Module"></td>
		<td style="padding-left:4px"><input type="radio" id="order" class="Radiol" name="order" value="Ip" onclick="document.getElementById('orderselect').value='IP';ptoken.navigate('UserActionIP.cfm?view='+document.getElementById('view').value+'&find=','detail')"></td>
		<td style="padding-left:4px"><cf_tl id="IP"></td>
		</tr>
		</table>
	
	<input type="hidden" id="orderselect" name="orderselect" value="LastName">
	<input type="hidden" id="view" name="view" value="#url.view#">
	
	</cfoutput>
		
	</td>
	
	<td width="200" align="right" style="padding-left:9px;padding-right:20px">
	    <cf_space spaces="100">
		<table><tr><td>
			<input type="radio" name="view" id="current" class="Radiol" name="Toggle" id="Toggle" value="hide" checked onClick="document.getElementById('view').value='hide';ptoken.navigate('UserAction'+document.getElementById('orderselect').value+'.cfm?view=hide&find=','detail')">
			</td>
			<td style="padding-left:3px" class="labelmedium"><cf_tl id="Current"></td>
			<td style="padding-left:8px">
		    <input type="radio" name="view" id="etmaal" class="Radiol" name="Toggle" id="Toggle" value="show" onClick="document.getElementById('view').value='show';ptoken.navigate('UserAction'+document.getElementById('orderselect').value+'.cfm?view=show&find=','detail')">
			</td><td style="padding-left:3px" class="labelmedium">Last 24h</td></tr>
		</table>
		
	</td>
	
	</tr>
	
</table>
</td>
</tr>

<tr><td height="100%" valign="top">
	   
	   <cf_divscroll id="detail" style="width:99%">
	 
	    <cfset url.view = "hide">
		<cfset url.order = "lastname">
		<cfinclude template="UserActionLastName.cfm">	
	  
	   </cf_divscroll>
	   
	</td></tr>
	
</table>

<cf_screenbottom html="No">

