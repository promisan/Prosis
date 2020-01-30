<!--- Create Criteria string for query from data entered thru search form --->

<cf_message message="Function was moved to module contoller">
<cfabort>

<cf_screentop height="100%" html="No" scroll="Vertical">

<cfset Page         = "0">
<cfset add          = "0">
<cfinclude template="../../Access/HeaderMaintain.cfm">

<cfparam name="URL.Code"  default="">
<cfparam name="URL.Class" default="">

<table width="99%" align="center" frame="hsides" border="0" cellspacing="0" cellpadding="0" rules="rows" bordercolor="e4e4e4">

<cfinclude template="HelpInit.cfm">

<cfquery name="Parameter"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Parameter	
</cfquery>
	
<cfif SESSION.isAdministrator eq "No"> 
 
	<cfquery name="SearchResult"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   S.*, P.*, PC.TopicClass
		FROM     Ref_SystemModule S INNER JOIN HelpProject P ON S.SystemModule = P.SystemModule INNER JOIN
	             HelpProjectClass PC ON P.ProjectCode = PC.ProjectCode
		WHERE    S.SystemModule IN (SELECT S.SystemModule
								FROM  Ref_SystemModule S, 
									  Organization.dbo.OrganizationAuthorization A
								WHERE A.ClassParameter = S.RoleOwner
								AND   A.UserAccount = '#SESSION.acc#'
								AND   A.Role = 'AdminSystem'
								AND  S.Operational = 1)
		ORDER BY S.MenuOrder, P.ProjectCode,TopicClass					
	</cfquery>

<cfelse>

	<cfquery name="SearchResult"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  S.*, P.*, PC.TopicClass   
		FROM    Ref_SystemModule S INNER JOIN HelpProject P ON S.SystemModule = P.SystemModule INNER JOIN
                HelpProjectClass PC ON P.ProjectCode = PC.ProjectCode
		WHERE   S.SystemModule IN (SELECT SystemModule FROM Ref_SystemModule S WHERE Operational = 1)		
		ORDER   BY S.MenuOrder, P.ProjectCode,TopicClass	
	</cfquery>

</cfif>	
	
<cfoutput>

<cf_ajaxRequest>

<script>

function show(cde) {

	se1 = document.getElementById(cde+"_exp")
	se2 = document.getElementById(cde+"_col")
	se = document.getElementById(cde)
	if (se.className == "hide") {
		se2.className = "regular"
	    se1.className = "hide"
		se.className  = "regular" 
	} else {
		se2.className = "hide"
	    se1.className = "regular"
		se.className  = "hide"
	}
}

function detail(cde,cls) {

	se1 = document.getElementById(cde+"_"+cls+"_col")
	se2 = document.getElementById(cde+"_"+cls+"_exp")
	document.getElementById(cde+"_"+cls).className  = "hide" 
	
	if (se2.className == "regular")	{ 
	      se2.className = "hide"
		  se1.className = "regular"
    } else {
		    se2.className = "regular"
  		    se1.className = "hide"
			url = "RecordListingDetail.cfm?code="+cde+"&class="+cls
			document.getElementById(cde+"_"+cls).className  = "regular" 
			
			AjaxRequest.get({
			        'url':url,
			        'onSuccess':function(req) 
			{
			document.getElementById(cde+"_"+cls).innerHTML  = req.responseText 
			},
		             'onError':function(req) 
			{ 
			document.getElementById(cde+"_"+cls).innerHTML  = req.responseText;
			}	
			}
			);	
		}	
}

function reloadForm(page) {
        window.location="RecordListing.cfm?Page=" + page; 
}

function recordadd(cde,cls) {
        window.location = "RecordEdit.cfm?idmenu=#URL.Idmenu#&code="+cde+"&class="+cls;
}

function recordedit(cde,cls,id) {
        window.open("RecordEdit.cfm?idmenu=#URL.Idmenu#&code="+cde+"&class="+cls+"&id="+id,"helpedit","width=#client.width-100#, height=#client.height-100#, status=yes, toolbar=no, scrollbars=no, resizable=yes, modal=yes")
	
}

</script>	
</cfoutput>

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr>
    <TD align="left"></TD> 
	<TD align="left">Code</TD> 
	<TD align="left">Description</TD>
	<TD align="left">Module</TD>
	<TD align="right">Robohelp</TD>
</TR>
<tr><td colspan="5" bgcolor="silver"></td></tr>
<cfoutput query="SearchResult" group="SystemModule">

<!---
<tr><td colspan="5" bgcolor="f4f4f4">#Description#</td></tr>
--->

<cfoutput group="ProjectCode">

 <!--- <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffcf'))#"> --->
	<TR bgcolor="ffffff">
	<td width="6%" style="cursor:pointer" bgcolor="white" align="center" onClick="javascript:show('#projectcode#')">
	
	<cfif URL.Code eq ProjectCode>
		<cfset cl = "regular">
		<cfset cli = "hide">
	<cfelse>
		<cfset cl = "hide">
		<cfset cli = "regular">
	</cfif>
		
	<img src="#SESSION.root#/Images/expand5.gif" alt="Expand" class="#cli#"
            onMouseOver="document.#projectcode#_exp.src='#SESSION.root#/Images/expand-over.gif'" 
		    onMouseOut="document.#projectcode#_exp.src='#SESSION.root#/Images/expand5.gif'"
			name="#projectcode#_exp" border="0" class="show" 
			align="absmiddle" style="cursor: pointer;">
		
		<img src="#SESSION.root#/Images/collapse5.gif" class="#cl#"
			onMouseOver="document.#projectcode#_col.src='#SESSION.root#/Images/collapse-over.gif'" 
		    onMouseOut="document.#projectcode#_col.src='#SESSION.root#/Images/collapse5.gif'"
			name="#projectcode#_col" alt="Collapse" border="0" 
			align="absmiddle" class="hide" style="cursor: pointer;">		
	
	 	
	</td>		
	<TD width="50"><a href="javascript:show('#projectcode#')">#ProjectCode#</a></TD>
	<TD>#ProjectName#</TD>
	<TD>#SystemModule#</TD>
	<TD align="right"><cfif #ProjectFilePath# eq "">Internal<cfelse>#ProjectFilePath#/#ProjectFileName#</cfif></TD>
	</TR>
	<TR class="#cl#" id="#ProjectCode#"><td colspan="5">
	
<cfoutput>
 
   <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td align="right" height="20" width="40">
	
	<cfif URL.Code eq ProjectCode and URL.Class eq TopicClass>
		<cfset cl = "regular">
		<cfset cli = "hide">
	<cfelse>
		<cfset cl = "hide">
		<cfset cli = "regular">
	</cfif>
	
	<img src="#SESSION.root#/Images/icon_expand.gif"
	     alt="Expand"
	     id="#projectcode#_#topicClass#_col"
	     border="0"
		 align="absmiddle"
	     class="#cli#"
	     style="cursor:pointer"
	     onClick="javascript:detail('#projectcode#','#topicClass#')">
	 
	<img src="#SESSION.root#/Images/icon_collapse.gif"
	     alt="Collapse"
	     id="#projectcode#_#topicclass#_exp"
	     border="0"
		 align="absmiddle"
	     class="#cl#"
	     style="cursor:pointer"
	     onClick="javascript:detail('#projectcode#','#topicClass#')">
	</td>		
	<TD width="100"><a href="javascript:detail('#ProjectCode#','#topicClass#')">#TopicClass#</a></TD>
	
	<td align="right" width="80%">
	   <a href="javascript:recordadd('#ProjectCode#','#TopicClass#')">Add Topic</a>		
		&nbsp;
	</td>	
	</TR>
			
	<tr><td colspan="3" id="#ProjectCode#_#topicClass#" class="#cl#">
	<cfif cl eq "regular">
		<cfinclude template="RecordListingDetail.cfm">
	</cfif>	
	</td></tr>
	
	<cfif CurrentRow neq RecordCount and recordcount neq "1">
	<tr bgcolor="E9E9E9"><td height="1" colspan="5"></td></tr>
	</cfif>
	</table>
		
</CFOUTPUT>
</td>
</tr>

<cfif CurrentRow neq RecordCount>
	<tr bgcolor="E9E9E9"><td height="1" colspan="5"></td></tr>
</cfif>

</CFOUTPUT>

</cfoutput>

</TABLE>

</td>

</TABLE>

</BODY></HTML>