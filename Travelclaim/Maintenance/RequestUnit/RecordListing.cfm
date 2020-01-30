<!--- Create Criteria string for query from data entered thru search form --->
<body leftmargin="0" topmargin="2" rightmargin="0" bottommargin="0">

<HTML><HEAD><TITLE>Requesting Units</TITLE></HEAD>
<cf_dialogOrganization>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Parameter"
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Parameter
</cfquery>

<cfquery name="Mandate"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_Mandate
	WHERE    Mission = '#Parameter.TreeUnit#'
</cfquery>

<cfquery name="SearchResult"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Organization
	WHERE    Mission = '#Parameter.TreeUnit#'
	AND      (ParentOrgUnit is NULL or ParentOrgUnit = '')
	ORDER BY TreeOrder
</cfquery>

<cfset Header = "Travel Claim Requester">
<cfset page="0">
<cfset add="0">
<cfoutput>
<cfsavecontent variable="option">
	  <input type="button" value="Add" class="button10g" 
		onclick="javascript:recordAdd('#Mandate.Mission#','#Mandate.MandateNo#')">	
	   <input type="button" value="Users" class="button10g" 
		onclick="javascript:showtreerole('ssTravelClaim')">		
</cfsavecontent>
</cfoutput>


<cf_divscroll>

<cfinclude template="../HeaderTravelClaim.cfm"> 

<table width="100%" align="center" cellspacing="0" cellpadding="0">

<cf_ajaxRequest>	
<cfoutput>

<SCRIPT LANGUAGE = "JavaScript">

	function showtreerole(role) {	
		window.open("#SESSION.root#/System/Organization/Access/OrganizationRolesView.cfm?idmenu=#url.idmenu#&Mission=#Parameter.TreeUnit#&Class=" + role, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=no")	
	}
	
	function recordAdd(mission,mandate){
		window.open("#SESSION.root#/TravelClaim/Maintenance/RequestUnit/RecordAdd.cfm?idmenu=#url.idmenu#&mission=" + mission+"&mandateno="+mandate, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=no")			
	}
	
	function edit(code,box,unit,action) {
		if (action == "save") {				
		    mapsrc = document.getElementById("sourcegroup_"+code).value
			maporg = document.getElementById("sourcecode_"+code).value
			mapnme = document.getElementById("orgunitname_"+code).value		
		} else {
			mapsrc = ""
			maporg = ""
			mapnme = ""
		}
					
		url = "Mapping.cfm?ts="+new Date().getTime()+
		            "&box="+box+
		            "&mission=#Parameter.TreeUnit#"+
					"&orgunitcode="+code+
		            "&orgunit="+unit+
					"&action="+action+
					"&mapsrc="+mapsrc+
					"&maporg="+maporg+
					"&mapnme="+mapnme;
					
		if (action == "hide") {
		
			document.getElementById("b"+box).className = "hide"
			document.getElementById(box+"Exp").className = "regular"
			document.getElementById(box+"Col").className = "hide"
		} else {
		
		    document.getElementById("b"+box).className = "regular"
			document.getElementById(box+"Exp").className = "hide"
			document.getElementById(box+"Col").className = "regular"
		
			AjaxRequest.get({
	        'url':url,
	        'onSuccess':function(req){ 
			document.getElementById(box).innerHTML = req.responseText;},
						
	        'onError':function(req) { 
			document.getElementById(box).innerHTML = req.responseText;}			
	        });		
		  }			 
	}

</script>

</cfoutput>

<tr><td colspan="2">

<table width="97%" cellspacing="0" cellpadding="1" align="center">
	 
	<tr style="height:20px;">
	    <td width="4%" align="center"></td>
	    <td>Code</td>
		<td align="left">Name</td>
		<td>Effective</td>
		<td>Expiration</td>
		<td>Mapping</td>
		<td>Officer</td>
		<td>Entered</td>
	</tr>
	<tr><td colspan="8" class="linedotted"></td></tr>
	
		<cfoutput query="SearchResult"> 
		     
		    <tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f8f8f8'))#">
			<td height="15" width="4%" align="center" style="padding-top:3px;">
				 <cf_img icon="open" onclick="editOrgUnit('#OrgUnit#')">
			</td>
			<td width="10%"><a href="javascript:editOrgUnit('#OrgUnit#')">#OrgUnitCode#</a></td>
			<td width="20%"><a href="javascript:editOrgUnit('#OrgUnit#')">#OrgUnitName#</a></td>
			<td>#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
			<td>#dateformat(DateExpiration,CLIENT.DateFormatShow)#</td>
			<td>	
				<cfquery name="Mapping"
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   count(*) as Count
					FROM     Organization
					WHERE    Mission = '#Parameter.TreeUnit#'
					AND      ParentOrgUnit = '#OrgUnitCode#'			
				</cfquery>
				#Mapping.count#
						
				   <img src="#SESSION.root#/Images/icon_expand.gif" 
					alt="Show how this validation rule enforces intervention"  
					id="#orgunit#Exp" border="0" class="regular" 
					align="absmiddle" style="cursor: hand;" 
					onClick="edit('#orgunitcode#','#orgunit#','','list')">
						
					<img src="#SESSION.root#/Images/icon_collapse.gif" 
					id="#orgunit#Col" 
					alt="Hide"  border="0" 
					align="absmiddle" class="hide" style="cursor: hand;" 
					onClick="edit('#orgunitcode#','#orgunit#','','hide')">
			
			</td>
			<td>#OfficerLastName#, #OfficerFirstName#</td>
			<td>#dateformat(Created,CLIENT.DateFormatShow)#</td>
			</tr>
			<cfif #currentRow# neq "#SearchResult.recordcount#">
			<tr><td colspan="8" class="linedotted"></td></tr>
			</cfif>
			
			<tr id="b#OrgUnit#" class="hide"><td height="40" colspan="8" id="#OrgUnit#"></td></tr>
				
		</cfoutput>

</table>

</td>
</tr>

</table>

</cf_divscroll>

</BODY></HTML>