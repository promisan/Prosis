<!--- Prosis template framework --->
<cfsilent>
 <proUsr>administrator</proUsr>
 <proOwn>Hanno van Pelt</proOwn>
 <proDes>Generic Logon</proDes>
21sep07 - removed call to CF_DialogHeaderSub.  Created single button with call to window.print(); changed input button to use class="input.button1"; adjusted references to "../../images/" to "../../../images"
 <proCom>Changed release no</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<!--- 
	Travel/Application/DocumentEdit.cfm
	
	Create Criteria string for query from data entered thru search form 

	Calls:  DocumentEditSubmit.cfm
	
	Modification history:
	19Nov99 - added code to allow/disallow document header data editing		
	04Feb02 - added code to allow identification of TU staff assigned to case.
			- requirement raised by Melma Raghavan, Travel Unit
	21Apr04 - added Remarks and UsualOrigin fields
	16Jun04 - add PersonCategory as a editable field
			- control SAT Date field display based on ActionClass value (show if 3 or 4 only)
			- change label color for Ticketing Thru field; add comments after TA Number(s) field
	21Jun04 - added icon that displays after the UsualPointofOrigin label when radio button set to NO
	25Jun04 - added code to handle Copying of current document and unmatched rotating persons into a new document
	29Oct04 - added code to determine whether user has permission to edit document header based on 
			  entries in Organization.dbo.OrganizationAuthorization
	22dec04 - updated Missing query code from RM.MissionStatus =  1 to RM.Operational = 1
			- added today Operational column in Organization.Ref_Mission table			  
	21sep07 - removed call to CF_DialogHeaderSub.  Created single button with call to window.print().
			- changed input button to use class="input.button1".
			- adjusted references to "../../images/" to "../../../images"
--->
<html><head><title>Personnel Request - Edit</title></head>

<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>"> 
<body class="dialog" onLoad="window.focus();">

<cfset CLIENT.DataSource = "AppsTravel">
<cfparam name="URL.ID" default="0">

<cf_dialogStaffing>
<cfinclude template="Dialog.cfm">

<SCRIPT LANGUAGE = "JavaScript">
function mouseHand() {
	document.documentedit.style.cursor = "hand";
}

function mouseNormal() {
	document.documentedit.style.cursor = "";
}

function my_scrolltop(yn) {
	if (yn) {
		window.scrollBy(0,-1000);
	} else {
		window.scrollBy(0,1000);
	}
}

function clone(doc,cat,clas) {
	if (confirm("Do you want to copy this request?  For Military requests, rotating personnel having no nominees will be copied to the new request.")) {
		window.open("DocumentCloneSubmit.cfm?ID=" + doc + "&ID1=" + cat + "&ID2=" + clas, "documentclone", "width=20, height=20, toolbar=no, scrollbars=no, resizable=no");
	}
	return false	
}

function my_alert() {
	alert("Icon is visible when nominee(s) are not departing from the usual point of origin.");
}

function my_alert2() {
	alert("This feature is under development.");
}
</SCRIPT>

<cfquery name="Get" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT   D.*, PM.Description AS PermanentMissionDesc, PM.NationalityCode 
	FROM     Document D, Ref_PermanentMission PM 
	WHERE    D.PermanentMissionId = PM.PermanentMissionId
	AND      D.DocumentNo = '#URL.ID#'
</cfquery>

<cfquery name="Parameter" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Parameter WHERE Identifier = 'A'
</cfquery>

<cfquery name="P_Mission" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT PermanentMissionId, Description FROM Ref_PermanentMission
	WHERE Operational = '1' AND Contributor = '1' AND PermanentMissionId > 0
	ORDER BY Description
</cfquery>

<cfquery name="Mission" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Mission FROM ORGANIZATION.DBO.Ref_Mission WHERE Mission <> 'ALL' AND Operational = '1'
	ORDER BY Mission
</cfquery>

<cfquery name="Category" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Category FROM Ref_Category ORDER BY Category
</cfquery>

<cfquery name="Class" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM FlowClass WHERE ActionClass = #get.ActionClass#
</cfquery>

<cfquery name="RequestType" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Ref_RequestType
</cfquery>

<cfquery name="PayResponsibility" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Ref_PayResponsibility ORDER BY PayResponsibility DESC
</cfquery>

<!-- added 040202 MM -->
<cfquery name="TuStaff" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM TuStaff WHERE (DateExpiration >= GETDATE() OR DateExpiration IS NULL) ORDER BY FullName 
</cfquery>
<!-- added 040202 MM -->

<!-- added 040421 MM -->
<cfquery name="TicketingThru" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM TicketingThru ORDER BY SortOrder
</cfquery>
<!-- added 040421 MM -->

<!--- 19Nov03
Stored proc combines document-level and person-level completed actions,
get max(actionid), and checks if this value has matching ActionId in
FlowActionView table for records allowing 'DocumentEdit'. 
<cfstoredproc procedure="spCheckDocEditAccess" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
 
   <cfprocparam type="In" cfsqltype="CF_SQL_INT" dbvarname="@DOCID" value="#URL.ID#" null="No">	
   <cfprocresult name="CanEditDoc" resultset="1">    
   
</cfstoredproc>
--->

<!--- 19Nov03. Initialize edit flag vars --->
<cfset AllowDocEdit = "False">
<cfset AllowTvlEdit = "False">
<cfset sPassThrough = "disabled">
<cfset sPassThroughTvl = "disabled">

<cfquery name="ChkUserAccess" datasource="AppsOrganization" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT O.Mission, O.AccessLevel 
	FROM   OrganizationAuthorization O INNER JOIN
	       TRAVEL.DBO.Ref_Category C ON O.ClassParameter = C.TravellerType
	WHERE  O.Mission = '#Get.Mission#'
	AND    O.Role = 'Requestor'
	AND    O.UserAccount = '#SESSION.acc#'	
	AND    C.Category = '#Get.PersonCategory#'
</cfquery>

<!--- Note: If no match is found by above query, rerun the same query but this time
    		look for a NULL in Mission column --->
<cfif #ChkUserAccess.RecordCount# EQ 0>
	<cfquery name="ChkUserAccess" datasource="AppsOrganization" 
	 username="#SESSION.login#" password="#SESSION.dbpw#">
    	SELECT DISTINCT O.Mission, O.AccessLevel 
		FROM OrganizationAuthorization O INNER JOIN
		     TRAVEL.DBO.Ref_Category C ON O.ClassParameter = C.TravellerType
		WHERE O.Mission IS NULL
		AND O.Role = 'Requestor'
		AND O.UserAccount = '#SESSION.acc#'	
		AND C.Category = '#Get.PersonCategory#'
	</cfquery>
</cfif>

<cfif ChkUserAccess.RecordCount GT 0>
	<!--- If match is found and accesslevel value is 2, allow EDIT access to this document --->
	
	<cfif ChkUserAccess.AccessLevel EQ 1>
		<cfset AllowDocEdit = "True">
		<cfset sPassThrough = "">		
	</cfif>
	<cfif ChkUserAccess.AccessLevel EQ 2>	
		<cfset AllowTvlEdit = "True">
		<cfset sPassThroughTvl = "">		
	</cfif>	
</cfif> 

<!--- 19Nov03
If stored proc 'spCheckDocEditAccess' returns at least 1 record, edit IS ALLOWED.
Set edit flag vars accordingly. 
<cfoutput query="CanEditDoc">
	<cfif #CanEditDoc.RecordCount# GT 0>
		<cfset AllowDocEdit = "True">
		<cfset sPassThrough = "">
	</cfif>
</cfoutput>

***************21 April 04
*** It is now apparent that the Request Doc must always be editable as desk officers
*** are always faced with requirement to modify request details even after submission
*** to TU.
<cfset AllowDocEdit = "True">
<cfset sPassThrough = "">
--->

<cfset dep_date = DateFormat(Get.PlannedDeployment,client.dateformatshow)>	

<cf_screentop scroll="Yes" 		
			  banner="yellow"	  
			  layout="webapp"
			  title="Personnel Request - #get.DocumentNo#" 
			  label="Personnel Request - #get.DocumentNo#" 
			  option="#get.PermanentMissionDesc#  #get.Mission# #dep_date#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;">

<CFFORM action="DocumentEditSubmit.cfm" method="POST" name="documentedit">

<table width="100%" height="100%" border="0" cellspacing="1" cellpadding="1" style="padding-left:20px;padding-right:20px">

	<tr>
		
    <td height="23" colspan="2" align="left" class="labelit">
	    		 
		<table width="100%">
		
		<tr><td>	
		
		<input style="height:18px" type="button" class="button10s" name="Print" value="  Print  " title="Print the contents of the window" onClick="javascript:window.print()">		
	    <input style="height:18px" type="button" class="button10s" name="Scroll" value="Bottom" title="Scroll page to the bottom" onClick="javascript:my_scrolltop(0)">		
		<cfoutput>
		<cfif (AllowDocEdit OR AllowTvlEdit) AND Get.Status is "0">
		    <input style="height:18px" type="button" class="button10s" name="Clone" value=" Copy " title="Make a duplicate of this request" 
					  onClick="javascript:clone('#Get.DocumentNo#','#Get.PersonCategory#','#Get.ActionClass#')">
			<input style="height:18px" type="submit" class="button10s" name="Submit" value=" Save " title="Save record changes">
		</cfif>
	  	</cfoutput>		
	    <input type="button" style="height:18px" class="button10s" name="Close" value=" Close " title="Close this page" onClick="closing()">	
					
		</td>
		
		<td class="labelit" style="padding-left:10px">	
			
						
			Number and Type of personnel requested:&nbsp;<cfoutput>#get.PersonCount#</cfoutput></font> - <font color="#FFCC33"><cfoutput>#get.PersonCategory#</cfoutput></font>
			&nbsp;Workflow:&nbsp;<cfoutput>#Class.Description#</cfoutput></font>
			<cfif Get.DocumentNoTrigger NEQ "">
				&nbsp;Source Req#&nbsp;:&nbsp;
				<a onMouseOver="javascript:mouseHand()" onMouseOut="javascript:mouseNormal()" title="Click to open this request. (under development)"
					onClick="javascript:my_alert2()"><font color="#FFCC33"><cfoutput>#Get.DocumentNoTrigger#</cfoutput></a></font>
			</cfif>
				
		</td>
				
		<td align="right" style="padding-left:4px;padding-right:5px" class="labelit">
				
		<cfif Get.Status is "0" or Get.Status is "9">	   
	        <INPUT type="radio" name="Status" value="0" <cfif Get.Status is "0"> checked</cfif>> Pending
			<INPUT type="radio" name="Status" value="9" <cfif Get.Status is "9"> checked</cfif>> Cancelled
		<cfelse>
		    <input type="hidden" name="Status" value="1" hidden="text">
			<input type="text" name="StatusShow" value="Completed" size="8" maxlength="8" readonly style="color: Black; text-align: center; border-bottom-style: solid; border-bottom-width: 1px;">   
	    </cfif>
		
				
		</td>
		</tr>
		
		</table>		
	
	</td>
	</tr> 	
	
	<tr><td colspan="2" class="linedotted"></td></tr>
     
	<tr>
    <td width="100%" colspan="2">
    <table width="98%" border="0" cellspacing="1" cellpadding="1" align="center">
	
	<cfoutput>
    <input type="hidden" name="documentno" value="#get.DocumentNo#", size="5" maxlength="5" class="disabled" readonly>
    <input type="hidden" name="pmcode" value="#get.NationalityCode#", size="3" maxlength="3" class="disabled" readonly>	
    <!---input type="hidden" name="category" value="#get.PersonCategory#", size="20" maxlength="20" class="disabled" readonly--->	
    <input type="hidden" name="actionclass" value="#get.ActionClass#", size="2" maxlength="2" class="disabled" readonly>
    <input type="hidden" name="AllowDocEditFlag" value="#AllowDocEdit#", size="5" maxlength="5" class="disabled" readonly>	
    <input type="hidden" name="AllowTvlEditFlag" value="#AllowTvlEdit#", size="5" maxlength="5" class="disabled" readonly>		
  	</cfoutput>		

	<!--- Field: Permanent Mission --->
    <tr>
    <td class="labelit">Permanent Mission*:</td>
	<td>	
 	    <cfselect name="PermanentMissionId" required="Yes" passThrough="#sPassThrough#" class="regularxl">
		    <cfoutput query="P_Mission">
			<option value="#PermanentMissionId#" <cfif #PermanentMissionId# eq #Get.PermanentMissionId#> selected</cfif>>#Description#</option>
			</cfoutput>		
	    </cfselect>	
	</td>
	</tr>	
    <!--- Field: Field Mission --->
    <tr>
    <td class="labelit">DPKO Field Mission*:</td>
	<td>		
		<cfselect name="Mission" required="Yes" passThrough="#sPassThrough#" class="regularxl">
	    <cfoutput query="Mission">
		<option value="#Mission#" <cfif #Mission# eq #Get.Mission#> selected</cfif>>#Mission#</option>
		</cfoutput>
	    </cfselect>
	</td>
	</tr>
    <!--- Field: Personnel Type or Category --->
    <tr>
    <td class="labelit">Personnel Type*:</td>
	<td>	
 	    <cfselect name="Category" required="Yes" passThrough="#sPassThrough#" class="regularxl">
	    <cfoutput query="Category">
		<option value="#Category#" <cfif Category eq Get.PersonCategory> selected</cfif>>#Category#</option>
		</cfoutput>
	    </cfselect>			
	</td>
	</tr>
	
	<!--- Field: Travel arranged by:  MM 10May04 --->
	<tr>
	<td class="labelit">Travel arrangement by*:</td>
	<td class="labelit">		
	<cfif AllowDocEdit>
		<input type="radio" name="TvlArrBy" value="U" <cfif Get.TravelArrangement EQ "U"> checked</cfif>> UN
		<input type="radio" name="TvlArrBy" value="C" <cfif Get.TravelArrangement EQ "C"> checked</cfif>> Country	
	<cfelse>
		<cfif Get.TravelArrangement is "U"> 
			<cfset myStr = "UN">
		<cfelse>
			<cfset myStr = "Country">
		</cfif>
		<cfinput name="TvlArrBy" type="text" value="#myStr#" class="regularxl" size="10" passThrough="#sPassThrough#">
	</cfif>
	</td>
	</tr>
	
    <!--- Field: Request Type --->
	<tr>
    <td class="labelit">&nbsp;Request Type*:</td>
	<td>
	
 	    <cfselect name="RequestType" required="Yes" passThrough="#sPassThrough#" class="regularxl">
	    <cfoutput query="RequestType">
		<option value="#RequestType#" <cfif #RequestType# eq #Get.RequestType#> selected</cfif>>#Description#</option>
		</cfoutput>
	    </cfselect>			
	</td>
	</tr>
    <!--- Field: Request Date --->
    <tr>
	<td class="labelit">&nbsp;Request date (dd/mm/yyyy)*:</td>
	<td>
	<cfif AllowDocEdit>
		<cf_intelliCalendarDate
		FormName="documentedit"
		FieldName="RequestDate" 
		class="regularxl"
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(Get.RequestDate, CLIENT.DateFormatShow)#"
		AllowBlank="False">	
	<cfelse>
	
		<cfset disp_date = DateFormat(#Get.RequestDate#,"dd/mm/yyyy")>
		<cfinput name="RequestDate" type="text" value="#disp_date#" class="regularxl" size="10" style="text-align: center" passThrough="#sPassThrough#">
		
	</cfif>
	</td>
	</tr>	
	
 	<!--- Field: Planned deployment --->
	<tr> 
	<td class="labelit">&nbsp;Planned deployment date (dd/mm/yyyy)*:</td>
	<td>
	<cfif AllowDocEdit>	
		<cf_intelliCalendarDate
		FormName="documentedit"
		class="regularxl"
		FieldName="PlannedDeployment" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(Get.PlannedDeployment, CLIENT.DateFormatShow)#"
		AllowBlank="False">	
	<cfelse>
	
		<cfset disp_date = DateFormat(Get.PlannedDeployment,"dd/mm/yyyy")>
		<cfinput name="PlannedDeployment" type="text" value="#disp_date#" class="regularxl" size="10" style="text-align: center" passThrough="#sPassThrough#">
		
	</cfif>
	</td>
	</tr>		
    <!--- Field: Default SAT date --->
	<cfif Get.ActionClass EQ '3' OR  Get.ActionClass EQ '4'>
		<tr> 
		<td class="labelit">Default SAT date (dd/mm/yy):</td>
		<td>
		<cfif AllowDocEdit>	
		
			<cf_intelliCalendarDate
			FormName="documentedit"
			FieldName="SatDate" 
			class="regularxl"
			DateFormat="#CLIENT.DateFormatShow#"
			Default="#Dateformat(Get.SatDate, CLIENT.DateFormatShow)#"
			AllowBlank="True">	
		<cfelse>
		
			<cfset sat_date = DateFormat(#Get.SatDate#,"dd/mm/yyyy")>
			<cfinput name="SatDate" type="text" value="#sat_date#" class="regularxl" size="10" style="text-align: center" passThrough="#sPassThrough#">
			
		</cfif>
		</td>
		</tr>
	</cfif>
    <!--- Field: Number requested --->	
	<tr>
    <td class="labelit">Number requested*:</td>
    <td>
	  	<cfinput type="text" name="PersonCount" value="#get.PersonCount#" message="Please enter the number of personnel requested." 
		 required="Yes" size="10" maxlength="10" class="regularxl" passThrough="#sPassThrough#"> <font size="1" face="tahoma">personnel</font>
	</td>
	</tr>	
    <!--- Field: Tour of Duty Length --->	
	<tr>
    <td class="labelit">Tour of duty length*:</td>
    <td>
	  	<cfinput type="text" name="DutyLength" value="#get.DutyLength#" message="Please enter the TOD length in whole months."
		 required="Yes" size="10" maxlength="10" class="regularxl" passThrough="#sPassThrough#"> <font face="tahoma" size="1" >months</font>
	</td>
	</tr>	
	<!--- Field: Request reference --->	
	<tr>
    <td class="labelit">Request Reference (40 chars max):</td>
    <td>
	  	<cfinput type="text" name="Referenceno" value="#get.ReferenceNo#" message="Please enter the request reference (if any)." 
		size="40" maxlength="40" class="regularxl" passThrough="#sPassThrough#">
	</td>
	</tr>
    <!--- Field: Rank Level required --->				
    <tr>
    <td class="labelit">Ranks required (200 chars max):</td>
    <td>
	<cfif AllowDocEdit>	
		<cfoutput><textarea style="width:90%;font-size:14px;padding:3px" rows="2" name="LevelRequired" message="Please enter rank(s) required if appropriate." class="regular">#get.LevelRequired#</textarea></cfoutput>
	<cfelse>
		<cfoutput><textarea style="width:90%;font-size:14px;padding:3px" rows="2" name="LevelRequired" message="Please enter rank(s) required if appropriate." class="regular" disabled>#get.LevelRequired#</textarea></cfoutput>
	</cfif>
	</td>
	</tr>	
    <!--- Field: Qualifications required --->				
    <tr>
    <td class="labelit">Qualifications required (200 chars max):</td>
    <td>
	<cfif AllowDocEdit>	
		<cfoutput><textarea style="width:90%;font-size:14px;padding:3px" rows="2" name="Qualification" class="regular">#get.Qualification#</textarea></cfoutput>
	<cfelse>
		<cfoutput><textarea style="width:90%;font-size:14px;padding:3px"  rows="2" name="Qualification" class="regular" disabled>#get.Qualification#</textarea></cfoutput>
	</cfif>		
	</td>
	</tr>
	<!--- Field: Remarks  MM 21/4/04 --->				
    <tr>
    <td class="labelit">Remarks (200 chars max):</td>
    <td>
	<cfif AllowDocEdit>	
		<cfoutput><textarea style="width:90%;font-size:14px;padding:3px" rows="2" name="Remarks" class="regular">#get.Remarks#</textarea></cfoutput>
	<cfelse>
		<cfoutput><textarea style="width:90%;font-size:14px;padding:3px"  rows="2" name="Remarks" class="regular" disabled>#get.Remarks#</textarea></cfoutput>
	</cfif>		
	</td>
	</tr>
	<!--- Field: Traveller departing from usual point of origin?:  MM 21/4/04 --->
	<!--- 21Jun04 - added code to hide/display alert icon based on value of UsualOrigin field --->
	<tr>
	<td class="labelit">From usual point of origin?:&nbsp;
	<cfif NOT Get.UsualOrigin>
	  <a href="javascript:my_alert()" title="Icon is visible when nominee(s) are not departing from the usual point of origin.">
		<img src="../../../Images/alert.jpg" alt="" width="13" height="10" border="0" align="middle">
	  </a>
	</cfif>
	</td>
	<td class="labelit">
	<cfif AllowDocEdit>		
		<input type="radio" name="UsualOrigin" value="1" <cfif #Get.UsualOrigin# is "1"> checked</cfif>> Yes
		<input type="radio" name="UsualOrigin" value="0" <cfif #Get.UsualOrigin# is "0"> checked</cfif>> No	
	<cfelse>
		<cfif Get.UsualOrigin is "1"> 
			<cfset myStr = "Yes">
		<cfelse>
			<cfset myStr = "No">
		</cfif>
		<cfinput name="UsualOrigin" type="text" value="#myStr#" class="regularxl" size="10" passThrough="#sPassThrough#">
	</cfif>
	</td>
	</tr>
	<!--- Field: Flag this request as requiring urgent attention?:  MM 26/4/04 --->
	<tr>
	<td class="labelit">Flag request as requiring urgent attention?:</td>
	<td class="labelit">		
	<cfif AllowDocEdit>	
		<input type="radio" name="Attention" value="1" <cfif #Get.Attention# is "1"> checked</cfif>> Yes
		<input type="radio" name="Attention" value="0" <cfif #Get.Attention# is "0"> checked</cfif>> No
	<cfelse>
		<cfif Get.Attention is "1"> 
			<cfset myStr = "Yes">
		<cfelse>
			<cfset myStr = "No">
		</cfif>
		<cfinput name="Attention" type="text" value="#myStr#" class="regularxl" size="10" passThrough="#sPassThrough#">	
	</cfif>
	</td>
	</tr>
	
	<tr bgcolor="#FFFFFF">
		<td class="labelmediumcl" height="30" colspan="2">
		&nbsp;<strong>The following fields are for Travel Unit use only:</strong>		
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		Note: An asterisk (*) after the field label indicates a mandatory field.</font>
		</td>
	</tr>
	
	<tr><td class="linedotted" colspan="2"></td></tr>
	
    <!--- Field: Responsibility for Payment --->
	<tr>
    <td class="labelit">Responsibility for payment*:</td>
	<td>
	
 	    <cfselect name="PayResponsibility" required="Yes" passThrough="#sPassThroughTvl#" class="regularxl">
	    <cfoutput query="PayResponsibility">
		<option value="#PayResponsibility#" <cfif #PayResponsibility# eq #Get.PayResponsibility#> selected</cfif>>
		#PayResponsibility#
		</option>
		</cfoutput>
	    </cfselect>
	</td>
	</tr>	
    <!--- Field: Responsibility for processing --- added 040202 --->
	<tr>
    <td class="labelit">Responsibility for processing*:</td>
	<td>
	
 	    <cfselect name="TuStaff" required="Yes" passThrough="#sPassThroughTvl#" class="regularxl">
	    <cfoutput query="TuStaff">
		<option value="#TuStaff#" <cfif TuStaff eq Get.TuStaff> selected</cfif>>#FullName#</option>
		</cfoutput>
	    </cfselect>
	</td>
	</tr>	
    <!--- Field: Ticketing Thru --- added 040421 --->
	<tr>
    <td class="labelit"><font color="purple"><b>Ticketing Through*:</b></font></td>
	<td>
	
 	    <cfselect name="TicketingThru" required="Yes" passThrough="#sPassThroughTvl#" class="regularxl">
	    <cfoutput query="TicketingThru">
		<option value="#TicketingThru#" <cfif #TicketingThru# eq #Get.TicketingThru#> selected</cfif>>#TicketingThru#</option>
		</cfoutput>
	    </cfselect>
	</td>
	</tr>	
	<!--- Field: TA Numbers  MM 10May04 --->
	<tr>
    <td class="labelit">TA Number(s) (30 chars max):</td>
    <td>
	  	<cfinput type="text" name="TaNumber" value="#get.TaNumber#" message="Please enter TA number(s)." 
		 required="No" size="30" maxlength="30" class="regularxl" passThrough="#sPassThroughTvl#">
 		&nbsp;&nbsp;
		<font face="tahoma" size="1.5" >Note: Input a 'P' in this field if you have printed the deployment request but have not prepared the TA.</font>
	</td>
	</tr>	
	<!--- Field: Travel Unit Remarks  MM 26/4/04 --->				
    <tr>
    <td class="labelit">Travel Unit Remarks (200 chars max):</td>
    <td>
	<cfif AllowTvlEdit>	
		<cfoutput><textarea style="width:90%;font-size:14px;padding:3px" rows="2" name="RemarksTvl" class="regular">#get.RemarksTvl#</textarea></cfoutput>
	<cfelse>
		<cfoutput><textarea style="width:90%;font-size:14px;padding:3px" rows="2" name="RemarksTvl" class="regular" disabled>#get.RemarksTvl#</textarea></cfoutput>
	</cfif>		
	</td>
	</tr>
	
	<tr bgcolor="#FFFFFF"><td height="10" colspan="2"></td></tr>
	
    <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">

    <tr style="border:1px solid silver">
      <td class="labelit">St</td>
	  <td class="labelit">&nbsp;&nbsp;</td>
      <td class="labelit">Activity</td>
	  <td class="labelit">&nbsp;</td>	  
	  <td class="labelit">Planned</td>
	  <td class="labelit">Started</td>
      <td class="labelit">Completed</td>
   	  <td class="labelit">Processed by</td>
  	  <td class="labelit">Date</td>	
	  <td class="labelit">Action</td>
     </tr>

	<tr><td class="linedotted" colspan="8"></td></tr>

	<cfset element = 1>
	<cfset elementundo = 1>
	<cfset show = "1">

	<cfinclude template="Template/DocumentEdit_Lines.cfm">
     
	</table>

</td>

</tr>

<tr><td height="10" colspan="2" class="linedotted></td></tr>

<tr><td colspan="2" align="center">
	
	<input type="button" class="input.button1" name="Scroll" value="  Top  " onClick="javascript:my_scrolltop(1)">
	<cfif Get.Status is "0" or Get.Status is "9">
	
		<cfif (#AllowDocEdit# OR #AllowTvlEdit#) AND #Get.Status# is "0">
			<input type="submit" class="input.button1" name="Submit" value="  Save  ">
		</cfif>
		
		<cfif IsDefined("showProcDelButton")>
	   		<cfif #showProcDelButton# EQ "True">   
				<input type="submit" class="input.button1" name="Delete" value="Process Delete">
		   	<!--- showProcDelButton is set in DocumentRotatingPersonList.cfm 
		   		 which is in turn called by Template\DocumentEdit_Lines.cfm --->
	     	</cfif>			 
	   </cfif>
	</cfif>
	<input type="button" class="input.button1" name="Close" value="  Close  " onClick="javascript:closing()">

	</td>
</tr>

</table>

</td>
</tr>

</table>

</cfform>

<cf_screenbottom layout="webapp">
