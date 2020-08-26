
<cf_screentop height="100%" 
     layout="webapp" html="No" label="Record New Functional Title" close="parent.ColdFusion.Window.destroy('functiondialog',true)" line="no" scroll="yes" banner="gray" bannerforce="Yes"> 

<cf_dialogPosition>

<cfajaximport tags="cfdiv,cfwindow">

<cfquery name="SearchOccGroup"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT OccupationalGroup, Description
	FROM   OccGroup O
	WHERE  Status = '1'
	
	<cfif SESSION.isAdministrator eq "No">
		AND EXISTS  (SELECT 'X'
		             FROM   Organization.dbo.OrganizationAuthorization A
					 WHERE  A.Role           = 'FunctionAdmin' 						 
					 AND    A.GroupParameter = O.OccupationalGroup
					 AND    A.UserAccount    = '#SESSION.acc#')
	</cfif>	
	
	ORDER BY Description
</cfquery>

<cfquery name="SelectGrade"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   R.*
	FROM     Ref_GradeDeployment R 	         
	WHERE    R. PostGradeBudget IN (SELECT PostGradeBudget FROM Employee.dbo.Ref_PostGradeBudget)
	ORDER BY ListingOrder
</cfquery>

<cfquery name="FunctionClass"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     FunctionClass
	FROM       Ref_FunctionClass
	WHERE      Operational = 1
	<cfif SESSION.isAdministrator eq "No">
	
	AND ( 
	
		Owner IN (SELECT ClassParameter
                  FROM   Organization.dbo.OrganizationAuthorization
		          WHERE  Role = 'FunctionAdmin' 
				  AND    UserAccount = '#SESSION.acc#')
				  
		OR
		
		Owner IN (SELECT ClassParameter
                  FROM   Organization.dbo.OrganizationAuthorization
		          WHERE  Role = 'OrgUnitManager' 
				  AND    AccessLevel = '3'
				  AND    UserAccount = '#SESSION.acc#')
				
		)						  
						  
	</cfif>		
</cfquery>

<cfquery name="MissionClass"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    GroupListCode as MissionClass
	FROM      Ref_GroupMissionList
	WHERE     GroupCode = 'Size'
</cfquery>

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" target="result">

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

<tr class="hide"><td colspan="2" height="100"><iframe name="result" id="result"></iframe></td></tr>

<tr><td height="4"></td></tr>
<tr><td style="width:180" class="labelmedium"><cf_tl id="Occ. Group">:<font color="FF0000">*</font></TD>
	<TD>
		<cfselect name="OccGroup" class="regularxl" required="Yes" multiple="No" query="SearchOccGroup"  value="OccupationalGroup"  display="Description"
		message="Please enter an Occupational Group" size="1"/>
	</TD>
	</tr>
		<TR>
    <TD valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Description">:<font color="FF0000">*</font></TD>
    <TD>
	
	<cf_LanguageInput
			TableCode       = "FunctionTitle" 
			Mode            = "Edit"
			Name            = "FunctionDescription"			
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "100"
			Size            = "90"
			Class           = "regularxl">
		
   	</TD>
	</TR>
    <TR>
		
	<tr><td valign="top" style="padding-top:7px" class="labelmedium"><cf_tl id="Title Construct">:</td><td>
	<table class="formspacing">
				
		<TR class="labelit">
		<TD><cf_uitooltip tooltip="Functional Title Prefix like : <b>Chief">Prefix:</cf_uitooltip></TD>
	    <TD>
	  	   <cfinput type="Text" name="FunctionPrefix" value="" required="No" size="30" maxlength="30" class="regularxl">
	    </TD>
		</tr>
		
		<tr class="labelit">
		<TD><cf_uitooltip tooltip="Functional Title Prefix like : <b>Finance">Keyword:</cf_uitooltip></TD>
		<TD>
	  	   <cfinput type="Text" name="FunctionKeyword" value="" required="No" size="60" maxlength="100" class="regularxl">
	    </TD>
		</tr>
		<tr class="labelit">
		<TD><cf_uitooltip tooltip="Functional Title Prefix like : <b>Officer">Suffix:</cf_uitooltip></TD>
		<TD>
	  	   <cfinput type="Text" name="FunctionSuffix" value="" required="No" size="30" maxlength="30" class="regularxl">
	    </TD>
		</TR>
	
	</table>
	</td></tr>	
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Classification">:</TD>
    <TD>
	
		<cfquery name="Classification"
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM Ref_FunctionClassification
			ORDER BY Code,Description
		</cfquery>
		
		<select name="FunctionClassification" class="regularxl">
				<option value="">n/a</option>
		<cfoutput query="Classification">
		<option value="#Code#">#Code# #Description#</option>
		</cfoutput>
		</select>

     	</TD>
	</TR>
		
    <TD class="labelmedium"><cf_tl id="Usage Class">:<font color="FF0000">*</font></TD>
    <TD class="labelmedium">  
    	<select name="FunctionClass" required="Yes" class="regularxl">
		<cfoutput query="FunctionClass">
		<option value="#FunctionClass#" <cfif #functionClass# eq "Standard">selected</cfif>>#FunctionClass#</option>
		</cfoutput>
		</select>
	      	 
	</TD>	
	</TR>
		
    <TD class="labelmedium"><cf_tl id="Roster function">:</TD>
    <TD class="labelmedium"><cf_UIToolTip tooltip="Once disabled you may not process candidates nor perform <br> a roster search for the bucket that are associated to this title">
	    <input type="radio" name="FunctionRoster" value="1" checked> <cf_tl id="Yes">
		<input type="radio" name="FunctionRoster" value="0"> No
		</cf_UIToolTip>
	</TD>
	
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Parent">:</TD>
    <TD class="labelmedium">
	 
	   <table cellspacing="0" cellpadding="0"><tr><td>
	   <cfinput type="text" name="functionaltitle" id="functionaltitle" ondblclick="this.value='';document.getElementById('functionno').value=''" class="regularxl" size="50" maxlength="60" readonly> 
	   </td>
	   <td style="padding-left:3px">
  	   <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/locate3.gif"
	     alt="Search for title"
	     width="16"
	     height="16"  
	     align="absmiddle"
	     style="cursor: pointer; border: 0px solid silver;"
	     onClick="selectfunction('webdialog','functionno','functionaltitle','')">			   
	   </td></tr></table>
	
	   <input type="hidden" id="functionno" name="functionno" class="disabled" size="6" maxlength="6" readonly>		
	 	  
	</TD>
	
	</TR>	
	
	<tr>
	   <td class="labelmedium" valign="top"><cf_tl id="Critical function">:</td>
	  
	   <td>
	   <table width="98%" cellspacing="0" cellpadding="0" align="center">
	 
		  <cfset row = 0>
	      <cfloop query="MissionClass"> 
			<cfset row = row + 1>
		   <cfif row eq 1><tr></cfif> 
		  
		       <td align="left">
			    <table width="100%" border="0"><tr><td>
					
				<cfoutput>
			    <input type="checkbox" name="clssel" value="#MissionClass.MissionClass#">			
				 &nbsp;#MissionClass.MissionClass#
				 </cfoutput>		
							 		 		
				</td>
				</tr>
				</table>
			    <cfif row eq "3">
		          </tr>
		          <cfset row = 1>
	    	    </cfif>
				
		  </cfloop> 
		  
	  </table>
	  </td>
	  
	</tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="40">
	
		<table class="formspacing">
		<tr><td>
			<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="parent.ProsisUI.closeWindow('functiondialog',true)">
	    </td>
		<td>
		    <input class="button10g" type="submit" name="Insert" value="Save">	
		</td>
		</tr>
		</table>
		
	</td></tr>
	
</table>

</CFFORM>

