<!--- Create Criteria string for query from data entered thru search form --->

<cfset dateValue = "">
<CF_DateConvert Value="#URL.ID3#">
<cfset DOB = dateValue>

<CFSET nme = Replace( url.id2, "|", "''", "ALL" )>

<CFSET Criteria = "WHERE LastName LIKE '%#nme#%' AND Nationality = '#PreserveSingleQuotes(URL.ID4)#'">

<!--- Query returning search results --->
<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
    FROM Ref_ParameterMission
	WHERE Mission = '#url.mission#'	
</cfquery>

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
    FROM Person
	#PreserveSingleQuotes(Criteria)# 
	ORDER BY LastName, FirstName
</cfquery>

<cf_screentop label="Associate candidate to employee record" close="ColdFusion.Window.destroy('myperson',true)" option="Enforce database integrity" jquery="Yes" line="no" layout="webapp" banner="yellow" height="100%" scroll="Yes">
	
<cfif SearchResult.recordcount eq "0" and Parameter.TrackToEmployee eq "1">
		
	<cfoutput>

	<iframe src="#SESSION.root#/staffing/application/employee/personentry.cfm?mode=recruitment&personno=#url.personno#"
	    width="100%" 
		height="99%" 
		frameborder="0">
	</iframe>
	
	</cfoutput>

<cfelse>
		
	
	<cf_dialogStaffing>
	
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
		  
		  <tr><td style="padding:10px">
		  
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">
			
			<TR class="labelmedium line">
			    <TD>&nbsp;</TD>
			    <TD><cfoutput>#client.indexNoName#</cfoutput></TD>
			    <TD>LastName</TD>
			    <TD>FirstName</TD>
			    <TD>Nat.</TD>
			    <TD>Gender</TD>
			    <TD>DOB</TD>
			</TR>
			
			 <cfif SearchResult.recordcount eq "0">		  
			  <tr><td colspan="7" height="25" align="center"><font color="808080">Problem no matching (name and date of birth) employee profiles found</td></tr>		
		     </cfif>
			
			<CFOUTPUT query="SearchResult">
			<TR style="height:22px" class="labelmedium navigation_row line">
				<TD style="padding-left:8px;padding-top:2px">
				<cf_img icon="open" onclick="applyperson('#IndexNo#','#personNo#','#url.personno#')">
				</TD>
				<TD><a href="javascript:ShowPerson('#IndexNo#:#personNo#')" title="Inquiry employee">#IndexNo#</A></TD>
				<TD>#LastName#</TD>
				<TD>#FirstName#</TD>
				<TD>#Nationality#</TD>
				<TD>#Gender#</TD>
				<TD>#DateFormat(BirthDate, CLIENT.DateFormatShow)#</TD>
			</TR>
			</CFOUTPUT>
			
			</TABLE>
			
		</tr></td>
		
		<tr><td height="1" bgcolor="silver"></tr>
		
		<tr><td align="center" height="30">
		
			<input type="button" class="button10g" name="OK"    value="Close" onClick="ColdFusion.Window.destroy('myperson',true)">
		
		</td></tr>
		
		</table>
		
</cfif>	

<cfset ajaxonload("doHighlight")>	

<cf_screenbottom layout="webapp">