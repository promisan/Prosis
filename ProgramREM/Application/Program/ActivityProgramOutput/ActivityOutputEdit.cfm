
<cf_screenTop height="100%" html="No" scroll="yes" flush="Yes">

<cf_dialogREMProgram>

<table width="100%" border="0" frame="hsides" bordercolor="silver">

<tr><td>
<cfinclude template="../header/ViewHeader.cfm">
</td></tr>

<tr><td>

<!--- Query returning search results for activities  --->
<cfquery name="SearchResult" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  A.*,	
        O.OrgUnitName as OrganizationName 
FROM    #CLIENT.LanPrefix#ProgramActivity A LEFT OUTER JOIN Organization.dbo.#CLIENT.LanPrefix#Organization O ON A.OrgUnit = O.OrgUnit
WHERE   A.ActivityId = '#URL.ActivityId#'
</cfquery>

<!--- Query returning search results --->
<cfquery name="Parameter" 
datasource="AppsProgram" >
    SELECT *
    FROM Parameter
</cfquery>

<!--- Entry form --->
<cfform action="OutputEditSubmit.cfm" method="POST" name="outputedit">
	
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
   
  <tr><td>
			
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">  
	    
	 <tr>
	  <td width="100%" colspan="2">
	  <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
		
		<TR class="labelit">
		    <td width="1%" align="center"></td>
			<TD width="60%" align="left"><cf_tl id="Description"></TD>
			<td></td>
			<td width="12%" align="left"><cf_tl id="Target Date"></td>
			<TD width="8%" align="left"><cf_tl id="Reference"></TD>
			<TD align="left"></TD>	
		</TR>
	
		<cfoutput query="SearchResult" group="ActivityDateStart">
		
			<tr>
		   	  <td height="6" colspan="5"></td>
			</tr>
		
			<cfoutput>
			 
				<tr bgcolor="white">
					<td width="1%" align="center" class="regular"></td>
					<TD colspan="2" class="labelmedium">#SearchResult.ActivityDescription#</b></TD>
					<TD class="labelmedium">#DateFormat(SearchResult.ActivityDate, CLIENT.DateFormatShow)#</b></TD>
					<TD class="labelmedium">#SearchResult.Reference#</b></TD>
					<tr><td height="5"></td></tr>
				</TR>
				
				<tr><td colspan="5">
							
			   <cfinclude template="OutputEdit.cfm"> 
			
			    </td></tr> 
				
			</cfoutput>
		
		</CFOUTPUT>
	
	  </table>
  
  </td></tr>
  
  </table>
  
 </td></tr>
  
  </table>
   
 </td></tr>
 
 <tr>
   <td height="28" align="center">
   		<cfoutput>
		<input class="button10g" type="button" value="Cancel" onClick="javascript:ActivityViewer('#URL.ProgramCode#','#URL.Period#')">
		<INPUT class="button10g" type="submit" value="Save">
		</cfoutput>
   </td>
  </tr>
  
  </table>  
  
</cfform>    

<cf_screenbottom html="No">

