
<cfquery name="Mission" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission IN (SELECT Mission 
	                  FROM   Organization.dbo.Ref_MissionModule 
					  WHERE  SystemModule IN ('Budget','Program'))
					  
	AND Mission IN (SELECT Mission
					FROM Ref_AllotmentEdition 
				    WHERE EditionId IN (SELECT DISTINCT EditionId FROM ProgramAllotmentRequest)		
					)									 
				  
</cfquery>

<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp"  
			  label="Snapshot"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST">

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td></td></tr>
	<cfoutput>
    <TR>
    <TD class="labelmedium">Date:</TD>
    <TD class="labelmedium">
  	   #dateformat(now(),CLIENT.DateFormatShow)#
    </TD>
	</TR>
	</cfoutput>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Entity">:</TD>
    <TD>
		<cfoutput>
			<select name="mission" class="regularxl">
	        	<cfloop query="Mission">
	        	<option value="#Mission#">#Mission#</option>
	         	</cfloop>
		    </select>
		</cfoutput>		
	</TD>
	</TR>
	
	<TR>
    <TD class="Labelmedium"><cf_tl id="Period">:</TD>
	<TD>
	    <cfdiv bind="url:SelectPeriod.cfm?mission={mission}" id="boxperiod">
	</TD>
	</TR>
	
	<TR>
    <TD class="Labelmedium"><cf_tl id="Edition">:</TD>
    <TD>
		<cfdiv bind="url:SelectEdition.cfm?mission={mission}" id="boxedition">
    </TD>
	</TR>	
	
	<TR>
    <TD class="Labelmedium"><cf_tl id="Memo">:</TD>
    <TD>
		   <cfinput type="text" name="Memo" value="" message="please enter a description" size="30" maxlenght= "90" class= "regularxl">
    </TD>
	</TR>	
	
	<tr><td></td></tr>
	<tr><td colspan="2" class="line"></td></tr>	
			
	<tr>	
	<td colspan="2" align="center" height="40">	
		
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value="Take Snapshot">
	
	</td>	
	
	</tr>
		
</TABLE>

</CFFORM>

