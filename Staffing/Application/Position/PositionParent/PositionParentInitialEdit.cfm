<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cf_screentop height="100%" jquery="Yes" layout="webapp" banner="gray" user="yes" scroll="no" label="Position Parent - Edit Form">

<cfajaximport tags="cfform">
<cf_calendarScript>
<cf_dialogPosition>
<cf_dialogOrganization>

<cfoutput>
	
	<script>
	 
		function ask() {
			if (confirm("Please use withcare. You are about remove this position, its realted loaned positions and all its associated assignments. Is this what you want to do ?")) {	
			return true 	
			}	
			return false	
		}	 
		
		function verify(myvalue) { 
			
			if (myvalue == "") { 
			
					alert("You did not define a salary scale")
					document.ContractEntry.search.focus()
					document.ContractEntry.search.select()
					document.ContractEntry.search.click()
					return false
					}		
		}		
		
		
		function applyunit(org) {    
			ptoken.navigate('#SESSION.root#/Staffing/Application/Position/PositionParent/setUnit.cfm?orgunit='+org,'process')
		}
							
		function Selected(no,description) {									
			  document.getElementById('functionno').value = no
			  document.getElementById('functiondescription').value = description					 
			 ProsisUI.closeWindow('myfunction')
		 }		
	
	</script>

</cfoutput>

<cfquery name="ParamMission" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.ID#'
</cfquery>

<cfquery name="CurrentMission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Mission
	WHERE  Mission = '#URL.ID#'
</cfquery>

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Mandate
	WHERE  Mission = '#URL.ID#' 
	AND    MandateNo = '#URL.ID1#'
</cfquery>

<cfquery name="Position" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PositionParent
	WHERE  PositionParentId = '#URL.ID2#'
</cfquery>

<cfif Position.recordcount eq "0">

	 <cf_message message = "Position no longer exists.">
	 <cfabort>

</cfif>

<cfinvoke component="Service.Access"  
  method="position" 
  orgunit="#Position.OrgUnitOperational#" 
  posttype="#Position.PostType#"
  returnvariable="accessPosition">
  
 <cfinvoke component="Service.Access"  
  method="position" 
  orgunit="#Position.OrgUnitOperational#" 
  posttype="#Position.PostType#"
  returnvariable="accessStaffing">
	  
<cfif (AccessPosition eq "NONE" or AccessPosition eq "READ") and 
      (AccessStaffing eq "NONE" or AccessStaffing eq "READ")>	 
	
	 <cf_message message = "You are not authorised for any post-type. Please contact your administrator.">
	 <cfabort>

</cfif>

<cfquery name="Posttype" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_PostType
</cfquery>

<cfquery name="FundTable" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Fund
</cfquery>

<cfquery name="Location" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Location
	WHERE  Mission = '#URL.ID#'
</cfquery>

<cfif getAdministrator(url.id) eq "1">

	<cfquery name="Postgrade" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     DISTINCT PostGrade, PostOrder
			FROM       Ref_PostGrade G INNER JOIN
		               Ref_PostGradeParent GP ON G.PostGradeParent = GP.Code INNER JOIN
		               Ref_PostType P ON GP.PostType = P.PostType 
			ORDER BY PostOrder		   
		</cfquery>

	
<cfelse>

	<cfquery name="Postgrade" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     DISTINCT PostGrade, PostOrder
			FROM       Ref_PostGrade G INNER JOIN
		               Ref_PostGradeParent GP ON G.PostGradeParent = GP.Code INNER JOIN
		               Ref_PostType P ON GP.PostType = P.PostType INNER JOIN
		               Organization.dbo.OrganizationAuthorization A ON P.PostType = A.ClassParameter
			WHERE 	   A.Role IN ('HRPosition','HROfficer') 
			AND        A.AccessLevel IN ('1','2')
			AND        A.Mission = '#URL.ID#'
			AND        A.UserAccount = '#SESSION.acc#'	
			ORDER BY PostOrder
		</cfquery>
		
	
</cfif>
	
<cfif PostGrade.recordcount eq "0">
	
  <cf_message message = "You are not authorised for any posttype. Please contact your administrator.">
  <cfabort>
	
</cfif>

<cfquery name="Postclass" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Postclass
</cfquery>

<cf_divscroll style="height:100%">

<cfform action="PositionParentInitialEditSubmit.cfm" method="POST" name="ParentEdit" target="result">
 
<table width="96%"align="center">
  
  <tr><td colspan="2" class="hide">
	   <iframe name="result" id="result" width="100%" height="100"></iframe>
	</td></tr>
	
	<tr class="hide"><td id="process"></td></tr>
	
  <tr>
    <td height="22" align="left" valign="middle">
	<cfoutput>
    	
		<input type="hidden" name="missionselect" id="missionselect" value="<cfoutput>#Position.Mission#</cfoutput>" size="20" maxlength="20" readonly class="disabled">	
    	<input type="hidden" name="PositionParentId"  id="PositionParentId" value="<cfoutput>#Position.PositionParentId#</cfoutput>">	
	    <input type="hidden" name="mission"      id="mission" value="<cfoutput>#Position.Mission#</cfoutput>">	
     	<input type="hidden" name="mandateno"    id="mandateno" value="<cfoutput>#Position.MandateNo#</cfoutput>" size="5" maxlength="5" readonly class="disabled">	
		
	</cfoutput>
    </td>
  
    <td align="right" class="labelmedium">
	<cfoutput>
	      &nbsp;<cfoutput>Mission: <b>#URL.ID#</b> MandateNo: <b>#URL.ID1#</b> <cfif Mandate.MandateStatus eq "1"><font color="0080C0"><cf_tl id="Locked"></font><cfelse><font color="0080C0">Draft</font></cfif></cfoutput></font>
		  &nbsp;
	</cfoutput>
    </td>
  </tr> 	
  
  
  <tr><td height="1" colspan="2" class="line"></td></tr>
   
  <tr>
    <td width="100%" colspan="2">
	
    <table border="0" width="95%" align="center" class="formpadding">
	
    <TR><td height="4"></td></TR>		
	
	<cfoutput>
	 <tr>
     <td class="labelmedium"><cf_tl id="Staffing Period">:</td>
     <td class="labelmedium">#Dateformat(Mandate.DateEffective, CLIENT.DateFormatShow)# - #Dateformat(Mandate.DateExpiration, CLIENT.DateFormatShow)#</td>
	 </tr>	
	</cfoutput>
			
	<TR>
    <TD class="labelmedium"><cf_tl id="Organization">:</TD>
		
    <TD>
	
	<table cellspacing="0" cellpadding="0"><tr><td>
		
	<cfquery name="Organization" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
        SELECT *
        FROM Organization
		WHERE OrgUnit = '#Position.OrgUnitOperational#'
    </cfquery>
	
	<input type="text" name="orgunitname" id="orgunitname" value="<cfoutput>#Organization.OrgUnitName#</cfoutput>" class="regularxl" size="60" maxlength="50" readonly>
	</td>
	
	<td style="padding-left:2px">
	<input type="button" name="btnFunction" class="button1" value="..." style="width:30px;height:27" onClick="selectorgmisn(document.getElementById('mission').value,document.getElementById('mandateno').value)"/> 
			
	</td>		
	<input type="hidden" name="orgunit"      id="orgunit"      value="<cfoutput>#Position.OrgUnitOperational#</cfoutput>">
	<input type="hidden" name="orgunitclass" id="orgunitclass" value="<cfoutput>#Organization.OrgUnitClass#</cfoutput>" class="disabled" size="10" maxlength="10" readonly> 
	<input type="hidden" name="orgunitcode"  id="orgunitcode"  value="#OrgUnit.orgunitCode#"> 
	
	</td></tr></table>
	
	</TD>
	</TR>	
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Function">:</TD>
		
    <TD class="regular">
	
	<table cellspacing="0" cellpadding="0"><tr><td>
	<input type="text" name="functiondescription" id="functiondescription" value="<cfoutput>#Position.functiondescription#</cfoutput>" class="regularxl" size="60" maxlength="50" readonly> 
	</td>
	
	<td style="padding-left:2px">
	<input type="button" value="..." name="btnFunction"  style="height:27;width:30px" onClick="selectfunction('webdialog','functionno','functiondescription','<cfoutput>#CurrentMission.missionowner#</cfoutput>','','')"> 
			
	</td>
	</tr>
	</table>		
	<input type="hidden" name="functionno" id="functionno" value="<cfoutput>#Position.functionno#</cfoutput>" class="disabled" size="4" maxlength="4" readonly>		
    </TD>
	</TR>		
			
	<TR>
    <TD class="labelmedium"><cf_space spaces="42"><cf_tl id="Administrative Organization">:</TD>
		
    <TD class="regular">
		
	<input type="button" class="button10g" name="search" style="height:25;width:100px" value=" select " onClick="selectorgN('PositionEdit','orgunit1','orgunitcode1','mission1','orgunitname1','orgunitclass1','','<cfoutput>#URL.ID#</cfoutput>','Administrative')"> 
	</TD>
	</TR>	
		
	<cfquery name="Organization" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
        SELECT O.*, O2.OrgUnitNameShort as ParentNameShort
	    FROM   Organization.dbo.Organization O, Organization.dbo.Organization O2
	    WHERE  O.OrgUnit = '#Position.OrgUnitAdministrative#'
	    AND    Left(O.HierarchyCode,2)=O2.HierarchyCode
	    AND    O.MandateNo=O2.MandateNo
	    AND    O.Mission=O2.Mission   
    </cfquery>
	
	<TR>
    
    <td colspan="2" style="padding-left:105px">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		
	    <input type="hidden" id="orgunit1" name="orgunit1" value="<cfoutput>#Position.OrgUnitAdministrative#</cfoutput>" class="disabled" size="10" maxlength="10" readonly>
		<input type="hidden" id="orgunitcode1" name="orgunitcode1" value="">
		
	<tr><TD width="90"></TD>
	    <TD class="labelit"><cf_tl id="Entity">:</TD>
	    <TD><input type="text" class="regularxl" readonly name="mission1" id="mission1" value="<cfoutput>#Organization.Mission#</cfoutput>" size="20" maxlength="20" readonly></TD> 
	</tr>
	
	<tr><TD></TD>
	    <TD class="labelit"><cf_tl id="Name">:</TD>
		<TD><input type="text" class="regularxl" readonly name="orgunitname1" id="orgunitname1" value="<cfoutput>#Organization.ParentNameShort# #Organization.OrgUnitName#</cfoutput>" size="50" maxlength="80" readonly></TD> 
	</tr>
	<tr><TD></TD>
	    <TD class="labelit"><cf_tl id="Class">:</TD>
	    <TD><input type="text" class="regularxl" readonly name="orgunitclass1" id="orgunitclass1" value="<cfoutput>#Organization.OrgUnitClass#</cfoutput>" size="20" maxlength="20" readonly></TD> 
	</tr>
	</table>	
	</td>
	</TR>
			
	<script language="JavaScript">
	
	function measuresource(cls) {
		
		se = document.getElementById("approvalpostgradebox")			
		if (cls == "regular") {
		    se.className = "regular"
		} else {
		    se.className = "hide"
		}
	}      
		
	</script>
	
	<cfif ParamMission.ShowPositionFund eq "1">
			
	<TR>
    <TD class="labelmedium"><cf_tl id="Fund">:</TD>
    <TD>
	   	<select name="Fund" size="1" class="regularxl">
		<cfoutput>
	    <cfloop query="FundTable">
		<option value="#Code#" <cfif Code eq rtrim(ltrim(Position.Fund))> selected </cfif>>
    		#Code# 
		</option>
		</cfloop>
		</cfoutput>
	    </select>
	</TD>
	</TR>
	
	 <cfelse>
		 
		 <input type="hidden" name="Fund" value="">		 
		 			
	</cfif>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Post type">:</TD>
    <TD>
	   	<select name="posttype" id="posttype" size="1" class="regularxl">
	    <cfoutput query="PostType">
		<option value="#PostType#" <cfif Posttype eq Position.Posttype> selected </cfif>>
    		#PostType#
		</option>
		</cfoutput>
	    </select>
	</TD>
	</TR>
	
	<cfif Position.ApprovalPostGrade neq "">
	     <cfset cl = "regular">
	<cfelse>
	     <cfset cl = "hide"> 	 
	</cfif>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Grade">:</TD>
    <TD>
	
		<cfoutput>
		   
		<script language="JavaScript">

		 function processfunction(funno) {			
			 ptoken.navigate('#session.root#/Staffing/Application/Position/Position/PositionGradeSelect.cfm?field=postgrade&posttype='+document.getElementById('posttype').value+'&presel=#Position.PostGrade#&mission=#url.id#&functionno='+funno,'gradeselectbox')			
		 }
 
		</script>
		</cfoutput>

		<cf_securediv id="gradeselectbox" bind="url:#session.root#/Staffing/Application/Position/Position/PositionGradeSelect.cfm?field=postgrade&posttype={posttype}&presel=#Position.PostGrade#&mission=#url.id#&functionno=#Position.FunctionNo#">
		
	</TD>
	</TR>
		 			
    <TR>
    <TD class="labelmedium"><cf_tl id="Post classification">:</TD>
    <TD>
	
		<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td>
		
			<table>
			<tr class="labelmedium">
			<td><INPUT type="radio" name="Classified" class="radiol" value="0" <cfif Position.ApprovalPostGrade eq "">checked</cfif> onclick="javascript:measuresource('hide')"></td>
			<td style="padding-left:4px"><cf_tl id="Non classified"></td>
			<td style="padding-left:7px"><INPUT type="radio" name="Classified" class="radiol" value="1" <cfif Position.ApprovalPostGrade neq "">checked</cfif> onclick="javascript:measuresource('regular')"></td>
			<td style="padding-left:4px"><cf_tl id="Classified"></td>
			</tr>
			</table>
		
		</td>
		
		<td style="padding-left:8px" id="approvalpostgradebox" class="#cl#">
		
			<table>
			<tr><td>
					
				<cf_securediv bind="url:#session.root#/Staffing/Application/Position/Position/PositionGradeSelect.cfm?field=approvalpostgrade&presel=#Position.ApprovalPostGrade#&mission=#url.id#&functionno=#Position.FunctionNo#&posttype={posttype}">
				</td>
				<TD style="padding-left:8px" class="labelmedium"><cf_tl id="Date">:</TD>
			    <TD style="padding-left:3px" class="regular">
					
					<cf_intelliCalendarDate9
						FieldName="ApprovalDate" 
						class="regularxl"
						DateFormat="#APPLICATION.DateFormat#"
						Default="#Dateformat(Position.ApprovalDate, CLIENT.DateFormatShow)#">	
						
				</TD>
				
				</tr></table>
	
			</td>	
			</tr>
			</table>
							
	</TD>
	</TR>		
    	
	<tr><td class="labelmedium"><cf_tl id="Approval reference">:</td>
	
		<td>
		<cfoutput>
		<input type="text" class="regularxl" name="ApprovalReference" value="#Position.ApprovalReference#" size="20" maxlength="20">
		</cfoutput>
		
		</td>
	</tr>
							 
    <TR>
    <TD class="labelmedium"><cf_tl id="Effective date">:</TD>
    <TD height="20">
	
	<cfif Mandate.MandateStatus eq "0" or AccessPosition eq "ALL">
	
		
		<cf_intelliCalendarDate9
			FormName="PositionEdit"
			FieldName="DateEffective" 
			DateValidStart="#Dateformat(Mandate.DateEffective, 'YYYYMMDD')#"
			DateValidEnd="#Dateformat(Mandate.DateExpiration, 'YYYYMMDD')#"
			AllowBlank="false"
			class="regularxl"
			Default="#Dateformat(Position.DateEffective, CLIENT.DateFormatShow)#">	
			
			<cfoutput>
			<input type="hidden" name="DateEffectiveOld" value="#Dateformat(Position.DateEffective, CLIENT.DateFormatShow)#">
			</cfoutput>
				
	<cfelse>
	    <cfoutput>
		#Dateformat(Position.DateEffective, CLIENT.DateFormatShow)#
		</cfoutput>
		
	</cfif>	
	
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Expiration date">:</TD>
    <TD>
	
	<cfif Mandate.MandateStatus eq "0" or AccessPosition eq "ALL">

	<cf_intelliCalendarDate9
		FormName="PositionEdit"
		FieldName="DateExpiration" 
		AllowBlank="false"
		class="regularxl"
		DateValidStart="#Dateformat(Mandate.DateEffective, 'YYYYMMDD')#"
		DateValidEnd="#Dateformat(Mandate.DateExpiration, 'YYYYMMDD')#"
		Default="#Dateformat(Position.DateExpiration, CLIENT.DateFormatShow)#">	
		
	<cfelse>
	
	    <cfoutput>
		#Dateformat(Position.DateExpiration, CLIENT.DateFormatShow)#		
		</cfoutput>
	
	</cfif>	
		
	</TD>
	</TR>
	
	<cfquery name="Parameter" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
	</cfquery>
	
	<cfif Parameter.SourcePostNumber eq "PositionParent">
			
	<TR>
    <TD class="labelmedium"><cf_tl id="Postnumber">:</TD>
    <TD>
	<INPUT type="text" 
	class="regularxl" id="SourcePostNumber" name="SourcePostNumber" value="<cfoutput>#Position.sourcepostnumber#</cfoutput>" maxLength="20" size="20">
	
	<!--- template to add a custom link to the field --->
	
	<cf_customLink
		FunctionClass = "Staffing"
		FunctionName  = "stPosition"
		Field         = "SourcePostNumber">
		
	</TD>
	</TR>
	
	<cfelse>
		
	<INPUT type="hidden" class="regular" name="SourcePostNumber" value="">
		
	</cfif>
	
	<cfquery name="Topic" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  	 SELECT  *
	     FROM  Ref_PositionParentGroup		 
		 WHERE Code IN (SELECT GroupCode 
		                FROM   Ref_PositionParentGroupList)
		 AND   Code IN (SELECT GroupCode 
		                FROM   Ref_PositionParentGroupMission
						WHERE  Mission = '#URL.ID#')				
	</cfquery>
	
	<cfif Topic.recordcount gt "0">

		<cfoutput query="topic">
		
			<tr>
				<td class="labelmedium">#Topic.Description#: <font color="FF0000">*</font></td>
				<td>
				
				<cfquery name="List" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					  SELECT   *
					  FROM     Ref_PositionParentGroupList
					  WHERE    GroupCode = '#Topic.Code#'
					  ORDER BY GroupListOrder, GroupListCode
				</cfquery>
				
				<cfquery name="Group" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					  SELECT *
					  FROM  PositionParentGroup
					  WHERE PositionParentId  = '#Position.PositionParentID#'
					  AND   GroupCode = '#Topic.Code#'
			    </cfquery>
								
				<select name="ListCode_#Topic.Code#" required="No" class="regularxl">
					<cfloop query="List">
						<cfif len(Description) gt 55>
							<option value="#List.GroupListCode#" <cfif Group.GroupListCode eq List.GroupListCode>selected</cfif>>#left(Description,55)#</option>
						<cfelse>
							<option value="#List.GroupListCode#" <cfif Group.GroupListCode eq List.GroupListCode>selected</cfif>>#Description#</option>
						</cfif>
					</cfloop>
				</select>
					
				</td>
			</tr>
		
		</cfoutput>
	
	</cfif>
			
	<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM Parameter
	</cfquery>
	
	<tr><td class="labelmedium"><cf_tl id="Attachments">:</td>
	<td>
	 	 <cf_filelibraryN
				DocumentPath="#Parameter.DocumentLibrary#"
				SubDirectory="#URL.ID2#" 
				Filter="main"
				Insert="yes"
				Remove="yes"
				width="100%"
				Highlight="no"
				Listing="yes">
	</td>
	
	</tr>
	
	<tr><td height="1" colspan="2"></td></tr>	
	<tr><td height="1" colspan="2" class="line"></td></tr>
	<tr><td height="1" colspan="2"></td></tr>
		
	<!--- check if changes are allowed --->

	<cfquery name="Pos" 
         datasource="AppsEmployee" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
	    	 SELECT * 
			 FROM  Position
	    	 WHERE PositionParentId = '#URL.ID2#'
	</cfquery>	

	<!--- check if changes are allowed --->

	<cfquery name="ass" 
         datasource="AppsEmployee" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
	    	 SELECT * 
			 FROM   PersonAssignment
	    	 WHERE  PositionNo IN (SELECT PositionNo 
			                       FROM   Position 
								   WHERE  PositionParentId = '#URL.ID2#')
			 AND    AssignmentStatus IN ('0','1')				  
	</cfquery>	
	
	<cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL">
	
	   <tr><td colspan="2" align="center">	     
	   
	   <cfif (pos.recordcount gte "2" or ass.recordcount gte "2") and AccessPosition eq "EDIT">
	  
		      <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/finger.gif" align="absmiddle" alt="" border="0">
			  <b>Parent can not be modified once position is loaned or there are several recorded assignments.</b>
	  
	   <cfelse>	
	   
	      <table border="0" class="labelmedium2 formspacing">
		  <tr>
		  
		  <td>	   	  
		  <input type="button" name="cancel" value="Cancel" class="button10g" style="height:25;width:100" onClick="window.close()">	   		  
		  </td> 
		  
		  <cfif getAdministrator(pos.mission) eq "1" or (AccessPosition eq "ALL" and Mandate.MandateStatus eq "0")>			  
		  
		  	 <td>
			   <input class="button10g" type="submit" name="Delete" value="Delete" style="height:25;width:100" onClick="return ask()">			  
			 </td>  
			  
		  </cfif>
		 		
		  <cfif Mandate.MandateStatus eq "1">
		  <td align="right" style="width:100px;padding-left:5px"><cf_tl id="Apply to child"></td>
		  <td align="center" style="max-width:30px;padding-left:5px">
		     <input type="checkbox" name="Child" value="1" class="radiol" style="height:18px">	
		  </td>
		  </cfif>
		  
		   <td>
		  <input class="button10g" type="submit" name="Submit" value="Save" style="height:25;width:100">	
		  </td>
		  </tr>
		  </table>	 
		  
	   </cfif>	 
	    
	   </td></tr>      
	   
	</cfif>	   

	</TABLE>
			
	</td></tr>
		
</table>

</CFFORM>

</cf_divscroll>

<cf_screenBottom layout="webapp">
