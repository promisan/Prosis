
<cfquery name="Parameter"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM        Parameter
</cfquery>
  
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   FunctionTitle
  WHERE  FunctionNo= '#URL.ID1#' 
</cfquery>

<cfif Get.recordcount eq "0">
	<table align="center"><tr><td height="40" class="labelmedium"><font color="FF0000">Title was removed.</font></td></tr></table>
	<cfabort>
</cfif>

<cfquery name="Parent" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   FunctionTitle
  WHERE  FunctionNo= '#Get.ParentFunctionNo#'
</cfquery>

<cfquery name="Occ"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   OccupationalGroup, Description
	FROM     OccGroup
	WHERE    Status = '1'
	<cfif SESSION.isAdministrator eq "No">
		AND (EXISTS  (SELECT 'X'
		             FROM   Organization.dbo.OrganizationAuthorization A
					 WHERE  A.Role           = 'FunctionAdmin' 						 
					 AND    A.GroupParameter = O.OccupationalGroup
					 AND    A.UserAccount    = '#SESSION.acc#') OR OccupationalGroup = '#Get.OccupationalGroup#')
	</cfif>		
	ORDER BY Description
</cfquery>

<cfquery name="SelectGrade"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   R.*
	FROM     Ref_GradeDeployment R
	WHERE    R.PostGradeBudget IN (SELECT PostGradeBudget FROM Employee.dbo.Ref_PostGradeBudget)
	ORDER BY Listingorder
</cfquery>

<cfquery name="FunctionClass"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     FunctionClass
	FROM       Ref_FunctionClass
	WHERE      (FunctionClass = '#Get.FunctionClass#' OR Operational = 1)	
	<cfif SESSION.isAdministrator eq "No">
	AND       
	           (
			   
			   	FunctionClass = '#Get.FunctionClass#' OR 
	
		          Owner IN (SELECT ClassParameter
                            FROM   Organization.dbo.OrganizationAuthorization
			                WHERE  Role = 'FunctionAdmin' 
			                AND    UserAccount = '#SESSION.acc#')
				)
						  
	</cfif>		
</cfquery>

<cfquery name="MissionClass"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     GroupListCode as MissionClass
	FROM       Ref_GroupMissionList
	WHERE      GroupCode = 'Size'
</cfquery>

<cfoutput>

<cfform name="formentry">

	<table width="96%" align="center" class="formpadding">
	
	<tr><td>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		<tr><td height="5"></td></tr>
		<tr><td colspan="2">
		
		<table width="96%" cellspacing="0" align="center" class="formpadding">
		 	
	    <TR>
	    <TD valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Name">:</TD>
	    <TD>
	    	<cf_LanguageInput
					TableCode       = "FunctionTitle" 
					Mode            = "Edit"
					Name            = "FunctionDescription"
					Value           = "#get.FunctionDescription#"
					Key1Value       = "#get.FunctionNo#"
					Type            = "Input"
					Required        = "Yes"
					Message         = "Please enter a description"
					MaxLength       = "80"
					Size            = "70"
					Class           = "regularxl">	
				  
	       	</TD>
		</TR>
	    <TR>
		
		<tr><td class="labelmedium"><cf_tl id="Title">:</td><td>
		
		<table cellspacing="0" cellpadding="0" class="formspacing">
		
			<TR>
		    <TD class="labelsmall"><cf_uitooltip tooltip="Functional Title Prefix like : <b>Chief">Prefix:</cf_uitooltip></TD>
		    <TD class="labelsmall" style="padding-left:3px"><cf_uitooltip tooltip="Functional Title Prefix like : <b>Finance">Keyword:</cf_uitooltip></TD>
		    <TD class="labelsmall" style="padding-left:3px"><cf_uitooltip tooltip="Functional Title Prefix like : <b>Officer">Suffix:</cf_uitooltip></TD>
		    </tr>
				
			<TR>
			    <TD><cfinput type="Text" name="FunctionPrefix" value="#Get.FunctionPrefix#" required="No" size="20" maxlength="20" class="regularxl"></TD>
				<TD style="padding-left:3px"><cfinput type="Text" name="FunctionKeyword" value="#Get.FunctionKeyword#" required="No" size="30" maxlength="60" class="regularxl"></TD>
				<TD style="padding-left:3px"><cfinput type="Text" name="FunctionSuffix" value="#Get.FunctionSuffix#" required="No" size="15" maxlength="20" class="regularxl"></TD>
			</TR>
		
		</table>
		</td></tr>
			
		<tr><td class="labelmedium"><cf_tl id="Occupational Group">:</TD>
		<TD>
		   
			<select name="OccGroup" class="regularxl">
			 <cfloop query="Occ"> 
			 <option value="#Occ.OccupationalGroup#" <cfif #Occ.OccupationalGroup# eq #Get.OccupationalGroup#>selected</cfif>>#Occ.Description#</option>
			 </cfloop>
			</select> 
	
		</TD>
		</tr>
		
		<TR>
	    <TD class="labelmedium"><cf_uitooltip tooltip="Functional Title Classification Code"><cf_tl id="Classification">:</cf_uitooltip></TD>
	    <TD>
		
				<cfquery name="Classification"
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM Ref_FunctionClassification
				ORDER BY Code,Description
			</cfquery>
			
			<cfselect name="FunctionClassification" class="regularxl" required="Yes">
				<option value="">n/a</option>
				<cfloop query="Classification">
				<option value="#Code#" <cfif Get.FunctionClassification eq code>selected</cfif>>#Code# #Description#</option>
				</cfloop>
			</cfselect>
	
	    	</TD>
		</TR>
		
	    <TD class="labelmedium"><cf_tl id="Usage Class">:</TD>
	    <TD>  
	    	<select name="FunctionClass" required="Yes" class="regularxl">
				<cfloop query="FunctionClass">
					<option value="#FunctionClass.FunctionClass#" <cfif Get.FunctionClass eq "#FunctionClass.FunctionClass#">selected</cfif>>#FunctionClass#</option>
				</cfloop>
			</select>	      	 
		</TD>
		
		<tr>
	    <TD class="labelmedium"><cf_tl id="Roster">:</TD>
	    <TD style="cursor: pointer;height:25px" class="labelmedium">
		    <cf_UIToolTip tooltip="Once disabled you may not process candidates nor perform <br> a roster search for the bucket that are associated to this title">
		    <input type="radio" class="radiol" name="FunctionRoster" value="1" <cfif Get.FunctionRoster eq "1">checked</cfif>> Yes
			<input type="radio" class="radiol" name="FunctionRoster" value="0" <cfif Get.FunctionRoster eq "0">checked</cfif>> No
			</cf_UIToolTip>
		</TD>
		</TR>
					
		<TR>
	    <TD class="labelmedium"><cf_tl id="Parent Function">:</TD>
	    <TD>
		   <table cellspacing="0" cellpadding="0">
		   <tr>
		   <td style="cursor:pointer; height:14; width:15; border: 0px solid silver;">
		  
		       <cfinput type="text" 
			         name="functionaltitle" 
					 id="functionaltitle" 
					 value="#Parent.FunctionDescription#" 
					 ondblclick="this.value='';document.getElementById('functionno').value=''" 				 
					 class="regularxl" 
					 size="50" 
					 maxlength="60" readonly> 
		   
		   </td>
		   
		   <td>
		   
		   <table border="1" bordercolor="silver">
		   <tr>
		   <td style="height:24px;width:23px" align="center">
		   
		     <img src="#SESSION.root#/Images/locate3.gif"
			     alt="Search for title"
			     width="12"
			     height="12"  
			     align="absmiddle"
			     onClick="selectfunction('webdialog','functionno','functionaltitle','')">	
		   
		   </td>
		   
		   <td style="height:24px;width:23px" align="center">
		   
			   <img src="#CLIENT.Root#/images/css/delete.png" onclick="document.getElementById('functionaltitle').value=''; document.getElementById('functionno').value='';">
			   
		   </td>
		   </tr>
		   </table>
		   
		   </td>
		   
		   </tr></table>
		   <input type="hidden" name="functionno"    id="functionno"    value="#get.ParentFunctionNo#" class="disabled" size="6" maxlength="6" readonly>		
		   <input type="hidden" name="functionnoold" id="functionnoold" value="#get.FunctionNo#"       class="disabled" size="6" maxlength="6" readonly>	   	  
		</TD>
		</TR>		
		
		<tr>
		   <td class="labelmedium"><cf_tl id="Classification">:</td>
		   <td style="padding-left:0px">
			   
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			 
			  <cfset row = 1>
		      <cfloop query="MissionClass"> 
			   <cfif row eq 1><tr></cfif> 
			  
			       <td align="left" class="regular">
				    <table width="100%" border="0"><tr><td class="labelmedium" style="padding-left:4px">
					
					  <cfquery name="check"
		              datasource="AppsSelection" 
		              username="#SESSION.login#" 
		              password="#SESSION.dbpw#">
			          	  SELECT   *
				          FROM     FunctionMissionClass
				          WHERE    MissionClass = '#MissionClass.MissionClass#'
						  AND      FunctionNo = '#Get.FunctionNo#'
		             </cfquery>
					 <cfoutput>
						 <input class="radiol" type="checkbox" name="clssel" value="#MissionClass.MissionClass#" <cfif check.recordcount neq "0">checked</cfif>>
						 &nbsp;#MissionClass.MissionClass#
					 </cfoutput>
					 <!--- check --->
					 		 		
					</td>
					</tr>
					</table>
					<cfset row = row + 1>
				    <cfif row eq "5">
			          </tr>
			          <cfset row = 1>
		    	    </cfif>
			  </cfloop> 
			  </table>
		  
		  </td>
		 
		</tr>
		
		 <tr class="labelmedium">
		   <td><cf_tl id="Attachments">:</td>
		  
	       <td height="25">
			   <cf_filelibraryN
				DocumentPath="#Parameter.DocumentLibrary#"
				SubDirectory="#Get.FunctionNo#" 
				Filter="Generic"
				Insert="yes"
				Remove="yes"
				Highlight="no"
				Listing="yes">
			</td>
			
		   </tr>	
		   
		   <tr>	
		    <TD><cf_tl id="Operational">:</TD>
		    <TD style="height:25px"> 
				<cf_UIToolTip tooltip="Once disabled you may no longer select this functional title for new Buckets and/or Positions anymore">
			    <input type="radio" class="radiol" name="FunctionOperational" value="1" <cfif Get.FunctionOperational eq "1">checked</cfif>> Yes
				<input type="radio" class="radiol" name="FunctionOperational" value="0" <cfif Get.FunctionOperational eq "0">checked</cfif>> No
				</cf_UIToolTip>
			</TD>
		
		</TR>
			
		<tr><td height="3"></td></tr>
		
		</table>
		
		</td></tr>
		
		</table>
		
	</td></tr>
	
	<tr><td class="line" height="1"></td></tr>	
			
		<tr><td height="2" colspan="3"></td></tr>
		
		<cfquery name="CountRec" 
	      datasource="AppsSelection" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
		      SELECT *
		      FROM   FunctionOrganization
		      WHERE  FunctionNo  = '#Get.ParentFunctionNo#' 
	    </cfquery>
			
		<cfinvoke component="Service.AccessGlobal"  
		      method="global" 
			  role="FunctionAdmin" 
			  returnvariable="Access">
			  		
		<tr><td colspan="3" height="30" align="center">
		
		<cfif Access eq "ALL" and countrec.recordcount eq "0">  
		    <input class="button10g" style="width:136;height:27" type="submit" name="Delete" value="Delete" onclick="return ask()">
		</cfif>
		
		<cfif Access eq "EDIT" or Access eq "ALL">  
			<input class="button10g" style="width:136;height:27" type="button" name="UpdateC" value="Save" onclick="ptoken.navigate('RecordSubmit.cfm?action=save','result','','','POST','formentry')">
		</cfif>
			
		</td></tr>
		
		<tr><td id="result" colspan="3" align="center"></td></tr>
			
	</table>
	
</CFFORM>

</cfoutput>

