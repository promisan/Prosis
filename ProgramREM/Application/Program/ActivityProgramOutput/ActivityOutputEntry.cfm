
<cf_screenTop height="100%" html="No" scroll="yes" flush="Yes">

<!--- JavaScript program form calls (in Tools tag directory)--->

<cf_calendarscript>
<cf_dialogREMProgram>

<table width="100%" border="0" bordercolor="silver"><tr><td>

	<cfinclude template="../Header/ViewHeader.cfm">

</td></tr>

<!--- Query returning search results for activities  --->
<cfquery name="SearchResult" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT  A.*,	O.OrgUnitName as OrganizationName  
   FROM    #CLIENT.LanPrefix#ProgramActivity A LEFT OUTER JOIN Organization.dbo.#CLIENT.LanPrefix#Organization O ON A.OrgUnit = O.OrgUnit
   WHERE   A.ActivityId = '#URL.ActivityId#'
</cfquery>

<!--- Query returning search results --->
<cfquery name="Parameter" 
datasource="AppsProgram" >
    SELECT *
    FROM Parameter
</cfquery>

<tr><td>

<cfform action="OutputEntryFullSubmit.cfm" method="POST" enablecab="No" name="OutputEntryFull">
	
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" frame="all">

  <!---
  <tr>
    <td width="100%" height="24">&nbsp;<font size="2" color="C0C0C0"><b>Activity</b>
	</td>
  </tr>
  --->
  
 <cfoutput>
        <tr><td height="36" align="center">
		<input class="button10g" type="button" value="Cancel" onClick="javascript:ActivityViewer('#URL.ProgramCode#','#URL.Period#')">
		<INPUT class="button10g" type="submit" value="Save">
		</td></tr>
 </cfoutput>
  
   <tr><td>
	  		
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">  
	    
	 <tr>
	  <td width="100%" colspan="2">
	  <table border="0" cellpadding="0" cellspacing="0" width="100%">
		
		<TR class="labelmedium line" style="border-top:1px solid silver" bgcolor="f4f4f4">		   
			<TD width="60%" align="left" style="padding-left:5px"><cf_tl id="Description"></TD>
			<td></td>
			<td width="12%" align="left"><cf_tl id="Target Date"></td>
			<TD width="8%" align="left"><cf_tl id="Reference"></TD>
			<TD align="left"></TD>	
		</TR>
	
		<cfset Client.recordNo = 0>
		
		<cfoutput query="SearchResult" group="ActivityDateStart">
				
			<cfoutput>
			 
				<tr bgcolor="yellow">				
					<TD class="labelmedium" style="padding-left:5px;padding-right:5px" colspan="2">#SearchResult.ActivityDescription#</TD>
					<TD class="labelmedium">#DateFormat(SearchResult.ActivityDate, CLIENT.DateFormatShow)#</TD>
					<TD class="labelmedium">#SearchResult.Reference#</TD>
					<tr><td height="5"></td></tr>
				</TR>
				
				<tr><td colspan="5"><cfinclude template="OutputEntryFull.cfm"></td></tr> 
				
			</cfoutput>
		
		</cfoutput>
	
		</table>
	
		</td>
	 </tr>
	
	</table>
	
	</td>
	</tr>
	
	</table>
  
</cfform>  
  
