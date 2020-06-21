
<cfparam name="URL.ID2" default="Template">
<cfparam name="URL.ID3" default="0000">
<cfparam name="URL.Mission" default="#URL.ID2#">
<cfparam name="URL.Mandate" default="#URL.ID3#">
<cfparam name="URL.FormName" default="">

<cf_screentop html="No" jquery="Yes">

<cf_divscroll>

<input type="hidden" name="mission" value="<cfoutput>#URL.Mission#</cfoutput>">

 <cfquery name="Mandate" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM Ref_Mandate
   WHERE Mission = '#URL.Mission#'
</cfquery>
     
<table style="width:99%" class="formpadding">

<tr><td valign="top">

<CFSET cond = Replace("#URL.ID1#", "'", "''", "ALL" )>
<cfset cond = "FunctionDescription LIKE '%#cond#%'">

<!--- Hanno the field URL.Owner can be passed a mission or straight as the owner --->

<cfparam name="URL.Owner" default="">

<cfset fclass = "">
<cfset owner  = url.owner>

<cfif url.Owner neq "">
	
	<cfquery name="Mission" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM Ref_Mission 
	   WHERE Mission = '#URL.Owner#'
	</cfquery>
	
	<cfif mission.recordcount eq "1">

		<cfset fclass = "'#Mission.FunctionClass#'">
		<cfset owner  = Mission.MissionOwner>
		
	</cfif>
	
</cfif>

 <cfquery name="Parameter" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM Ref_ParameterOwner 
   <cfif URL.Owner neq "">   
   WHERE Owner = <cfqueryparam
				 value="#Owner#"
				 cfsqltype="CF_SQL_VARCHAR" 
				 maxlength="10">
   </cfif>
</cfquery>
	
<cfloop query="Parameter">
  <cfif fclass eq "">
     <cfset fclass = "'#FunctionClassSelect#'">
  <cfelse>
  	 <cfset fclass = "#fclass#,'#FunctionClassSelect#'">
  </cfif>
</cfloop>
 
<!--- Query returning search results --->
<cfquery name="Level01" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 200 F.FunctionNo, 
	         F.FunctionClass, 
			 F.FunctionDescription, 
			 (SELECT count(*) FROM FunctionOrganization WHERE FunctionNo = F.FunctionNo) as Roster
	FROM     FunctionTitle F 
	WHERE    #preserveSingleQuotes(cond)#
	<cfif fclass neq "">
	AND      F.FunctionClass IN (#preserveSingleQuotes(fclass)#)
	</cfif>
	AND      F.FunctionOperational = '1'
	ORDER BY F.FunctionDescription
</cfquery>

	<table align="center" style="width:97%" class="navigation_table formpadding">
	
	<TR class="labelmedium line fixrow">
	    <td width="30" height="20"></td>
	    <TD><cf_tl id="Id"></TD>
		<TD><cf_tl id="Description">"</TD>
		<TD><cf_tl id="Status"></TD>
		<TD><cf_tl id="Bucket"></TD>
	</TR>
	
	<cfoutput query="Level01" group="FunctionDescription">
		
		<CFSET des = Replace("#FunctionDescription#", "'", "", "ALL" )> 
		
		<TR class="navigation_row line labelmedium">
			<td align="center" style="padding-top:3px">
				<cf_img icon="select" navigation="Yes" onclick="javascript:Selected('#FunctionNo#','#des#','#url.fldfunctionno#','#url.fldfunctiondescription#')">
			</td>
			<TD>#FunctionNo#</TD>
			<TD>#FunctionDescription#</TD>
			<TD>#FunctionClass#</TD>
			<td align="center" style="padding-right:4px"><cfif Roster neq "">*</cfif></td>
		</TR>
	
	</CFOUTPUT>
	
	</TABLE>

</td></tr>
   
</table>

</cf_divscroll>

<cfset ajaxonload("doHighlight")>


