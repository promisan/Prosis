
<cfparam name="URL.Source"      default="MANUAL">
<cfparam name="URL.RecordId"    default="0">
<cfparam name="URL.PersonNo"    default="">
<cfparam name="URL.ApplicantNo" default="">
<cfparam name="URL.DocumentNo"  default="">
<cfparam name="URL.Caller"      default="0">
<cfparam name="URL.Box"         default="">

<cfif url.source eq "Vac">
	<cfset HTML = "No">
<cfelse>
	<cfset HTML = "Yes">	
</cfif>

 <cfif URL.Caller neq "Listing">
 	  
	<cf_tl id="Register Assignment" var="vPosition">
		
	<cf_screentop scroll="Yes" 
	    layout     = "webapp" 
		label      = "#vPosition#" 
		close      = "parent.ColdFusion.Window.hide('myarrival',true)"
		menuaccess = "context" 
		banner     = "yellow"
		height     = "100%"
		html       = "#html#"
		line       = "No"
		jQuery     = "yes">  
		  
<cfelse>
	
	<cf_tl id="Position Assignment" var="vPosition">
	
	<cf_screentop scroll="Yes" 
	    layout="webapp" 
		label="#vPosition#" 
		menuaccess="context" 
		banner="yellow"
		html       = "#html#"
		height="100%"
		line="No"
		jQuery="yes">
 
</cfif>

<cf_calendarScript>
<cf_dialogOrganization>
<cf_dialogStaffing>
<cfajaximport tags="cfform">

<cfoutput>
	
	<script LANGUAGE = "JavaScript">
		
		function check(myvalue) { 
	
		if (myvalue == "") { 
			alert("You have not selected an employee !")
			return false
			}
		}
	
		function applyunit(org) {    
		    ptoken.navigate('#SESSION.root#/Staffing/Application/Assignment/setUnit.cfm?orgunit='+org,'unitprocess')
		}
		
		function Selected(no,description) {									
			  document.getElementById('functionno').value = no
			  document.getElementById('functiondescription').value = description					 
			  ProsisUI.closeWindow('myfunction')
		 }		
			
	</script>

</cfoutput>

<cfquery name="Organization" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT O.*, P.functionNo, P.functiondescription, 
	       P.LocationCode, P.Mission, M.Description, Mis.MissionOwner as Owner, Mis.StaffingMode
    FROM   Position P, 
	       Organization.dbo.Organization O, 
		   Organization.dbo.Ref_Mandate M,
		   Organization.dbo.Ref_Mission Mis
	WHERE  P.OrgUnitOperational = O.OrgUnit
	AND    P.PositionNo = '#URL.ID#'
	AND    M.Mission = O.Mission
	AND    Mis.Mission = M.Mission
	AND    M.MandateNo = O.MandateNo 
</cfquery>

<cfquery name="Position" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   P.*
    FROM     Position P
	WHERE    P.PositionNo = '#URL.ID#'
</cfquery>

<cfquery name="PositionParent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   PP.*
	FROM     Position P, PositionParent PP
	WHERE    P.PositionNo        = '#URL.ID#'
	AND      PP.PositionParentId = P.PositionParentId  
</cfquery>

<cfquery name="AssignmentClass" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     Ref_AssignmentClass
	WHERE    Operational = 1
	ORDER BY ListingOrder
</cfquery>

<cfquery name="AssignmentType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     Ref_AssignmentType
</cfquery>

<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_ParameterMission
	WHERE    Mission = '#Organization.Mission#'
</cfquery>

<cfquery name="Location" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Location
	WHERE    Mission = '#Organization.Mission#'
</cfquery>

<cf_divscroll>

<table width="97%" border="0" class="formpadding" cellspacing="0" cellpadding="0" align="center">

<tr><td style="padding:7px">
	<cfinclude template="../Position/Position/PositionViewHeader.cfm">
</td></tr>

<tr class="hide"><td height="60"><iframe name="process" id="process" width="100%" height="100%"></iframe></td></tr>
   
  <tr>
    <td width="100%">
		
	<cfform action="AssignmentEntrySubmit.cfm?Box=#URL.Box#&Caller=#URL.Caller#&Source=#URL.Source#&ApplicantNo=#URL.ApplicantNo#&PersonNo=#URL.PersonNo#&RecordId=#URL.RecordId#&DocumentNo=#URL.DocumentNo#" 
		   method="POST" 
		   name="AssignmentEntry" 
		   target="process" 
		   onSubmit="return check(AssignmentEntry.name.value)">
		   
		<cfoutput>
		   <input type="hidden" name="PositionNo"  value="#URL.ID#">
		   <input type="hidden" name="AssignmentNo" value="0">
	    </cfoutput>   
	   
	    <table width="95%" border="0" class="formpadding" cellspacing="0" cellpadding="0" align="center">
		 	 	
		<TR>
	    <TD class="labelmedium" style="width:170px"><cf_tl id="Incumbent">:</TD>
		
	    <TD class="labelmedium">
		
		<cfquery name="Check" 
		  datasource="AppsSelection" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT   P.PersonNo
			FROM     Applicant A INNER JOIN
	                 Employee.dbo.Person P ON A.EmployeeNo = P.PersonNo
			WHERE    A.PersonNo = '#URL.ApplicantNo#'
		</cfquery>
			
		<cfif URL.PersonNo eq "" and Check.PersonNo eq "">
			
		    <cfajaximport tags="cfWindow">
		
			<cfset link = "#SESSION.root#/staffing/application/Assignment/getEmployee.cfm?PositionNo=#url.id#&insert=yes">	
		
			<table cellspacing="0" cellpadding="0">
			<tr><td>
			
			   <cf_selectlookup
				    box        = "employee"
					link       = "#link#"
					button     = "Yes"
					icon       = "Search.png"
					iconheight = "25"
					iconwidth  = "25"
					close      = "Yes"
					type       = "employee"
					des1       = "Selected">
				
			</td>		
			<td>&nbsp;</td>
			<td width="500" style="border:1px solid silver">
						   
			   <cfdiv bind="url:#link#" id="employee"></cfdiv>
			   
			</td>
			<td width="30%"></td>
			</table>
			
		<cfelse>
			
			<cfquery name="Person" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT *
			     FROM   Person
			     WHERE  PersonNo = '#URL.PersonNo#' OR PersonNo = '#Check.PersonNo#' 
		    </cfquery>		
		
			<cfoutput>
			
	       	<b>#Person.FirstName# #Person.LastName# <cfif Person.IndexNo neq "">(#Person.IndexNo#)</cfif></b>
		       <input type="hidden" name="personno" value="#Person.PersonNo#">
			   <input type="hidden" name="lastname" value="#Person.LastName#">
		       <input type="hidden" name="firstname" value="#Person.FirstName#">
			   <input type="hidden" name="indexno" value="#Person.IndexNo#">
		
			</cfoutput>
	  	
		</cfif>
	
		</TD>
		</TR>	
				
		<tr>
		<td colspan="2" align="center">
			<cfdiv id="historybox">
		</td>
		</tr>	
						 
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Arrival date">:</TD>
	    <TD>	
		
			<table cellspacing="0" cellpadding="0">
			
			<tr>
				<td>					
				
					<!--- ---------------------------------------- --->
					<!--- check the last contract for this mission --->					
					<!--- --- 29/6/2010 Hanno I changed this------ --->
					
					<cfquery name="LastContract" 
					  datasource="AppsEmployee" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
							SELECT   top 1 *
							FROM     PersonContract
							WHERE    Mission = '#Organization.Mission#' 
							AND      PersonNo = '#URL.PersonNo#'
							AND      ActionStatus != '9'		
							ORDER BY DateEffective DESC 
					</cfquery>
					
					<cfif lastContract.recordcount eq "1">
							
						 <cf_intelliCalendarDate9
							FieldName="DateArrival" 
							class="regularxl"
							Default="#Dateformat(lastContract.dateeffective, CLIENT.DateFormatShow)#"
							DateValidEnd="#Dateformat(Position.DateExpiration, 'YYYYMMDD')#"
							AllowBlank="False">	
					
					<cfelse>
					
						<cfif now() lte Position.DateExpiration>
								
						  <cf_intelliCalendarDate9
							FieldName="DateArrival" 
							class="regularxl"
							Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
							DateValidEnd="#Dateformat(Position.DateExpiration, 'YYYYMMDD')#"
							AllowBlank="False">	
							
						<cfelse>
						
						  <cf_intelliCalendarDate9
							FieldName="DateArrival" 
							class="regularxl"
							Default="#Dateformat(Position.DateExpiration, CLIENT.DateFormatShow)#"
							DateValidEnd="#Dateformat(Position.DateExpiration, 'YYYYMMDD')#"
							AllowBlank="False">	
						
						</cfif>	
					
					</cfif>
				
				</td>			
				<td class="labelit" style="width:400px;padding-left:10px">Record assignment start date once this is a continuation.</td>			
			</tr>
			</table>
				
		</td>
		</tr>
				
		<tr>
		<td class="labelmedium"><cf_tl id="Expected enddate">:&nbsp;&nbsp;</td>
		<td>	
		
		  <cf_intelliCalendarDate9
			FieldName="DateDeparture" 
			Default="#Dateformat(Position.DateExpiration, CLIENT.DateFormatShow)#"
			class="regularxl"
			AllowBlank="True">	
									
		</TD>
		</TR>
		
		<cfoutput>
		
		<cfif Organization.StaffingMode eq "1" and Parameter.AssignmentFunction eq "1">
				
			<TR>
		    <TD class="labelmedium"><cf_tl id="Deployed in"> :</TD>
						
		    <TD>
			
				<table cellspacing="0" cellpadding="0">
				<tr>
				<!--- ajax container --->
				<td class="hide" id="unitprocess"></td>
				<td>
					
				<cfif Organization.StaffingMode eq "1">			
					<cf_img icon="open" onclick="selectorgmisn('#PositionParent.Mission#','#PositionParent.MandateNo#','','applyunit')">														
				</cfif>
				
				</td>
				<td  style="padding-left:5px">
				<input type="text" name="orgunitname" id="orgunitname"   value="#Organization.OrgUnitName#" class="regularxl" size="40" maxlength="50" readonly>
				</td>
				<td  style="padding-left:5px">
				<input type="text" name="orgunitclass" id="orgunitclass" value="#Organization.OrgUnitClass#" class="regularxl" size="15" maxlength="15" readonly style="text-align: center;"> 
				</td></tr></table>
			
				<input type="hidden" name="orgunitcode" id="orgunitcode" value="#Organization.OrgUnitCode#" class="disabled" size="5" maxlength="5" readonly style="text-align: center;">
				<input type="hidden" name="mandateno" id="mandateno"     value="#PositionParent.MandateNo#">
				<input type="hidden" name="mission" id="mission"         value="#PositionParent.Mission#">
				<input type="hidden" name="orgunit" id="orgunit"         value="#Organization.OrgUnit#"> 
				
			</TD>
			</TR>	
			
		<cfelse>
		
			<TR>
		    <TD class="labelmedium"><cf_tl id="Unit"> :</TD>		
			
		    <TD>
			
				<table>
				<tr>
				
				<td>
				<input type="text" name="orgunitname" id="orgunitname"   value="#Organization.OrgUnitName#" class="regularxl" size="40" maxlength="50" readonly style="text-align: left;background-color:eaeaea">
				</td>
				<td  style="padding-left:5px">
				<input type="text" name="orgunitclass" id="orgunitclass" value="#Organization.OrgUnitClass#" class="regularxl" size="15" maxlength="15" readonly style="text-align: center;;background-color:eaeaea"> 
				</td></tr></table>
			
				<input type="hidden" name="orgunitcode" id="orgunitcode" value="#Organization.OrgUnitCode#" class="disabled" size="5" maxlength="5" readonly style="text-align: center;background-color:eaeaea">
				<input type="hidden" name="mandateno" id="mandateno"     value="#PositionParent.MandateNo#">
				<input type="hidden" name="mission" id="mission"         value="#PositionParent.Mission#">
				<input type="hidden" name="orgunit" id="orgunit"         value="#Organization.OrgUnit#"> 
				
			</TD>
			</TR>			
		
		</cfif>	
		
		<cfif Organization.StaffingMode eq "1" and Parameter.AssignmentFunction eq "1">
			
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Actual Function">:</TD>
		    <TD>
			
				<table cellspacing="0" cellpadding="0">
				<tr>
				
						<td style="padding-right:5px"><cf_img icon="open" onclick="selectfunction('webdialog','functionno','functiondescription','#Organization.Owner#','','')"></td>	
						<td>
						<input type="text"   name="functiondescription" id="functiondescription" value="#Organization.functiondescription#" size="52" maxlength="80" readonly class="regularxl">
						<input type="hidden" name="functionno"          id="functionno"          value="#Organization.functionno#" class="regular" size="5" maxlength="5" readonly style="text-align: center;">
						</td>				  
						
				</tr>
				</table>
			</td>
			</tr>
		
		<cfelse>
			
			<TR>
		    <TD class="labelmedium"><cf_tl id="Function">:</TD>	  	
				
				<td>
				<input type="text"   name="functiondescription" id="functiondescription" value="#Organization.functiondescription#" size="52" maxlength="80" readonly class="regularxl" style="background-color:eaeaea">
				<input type="hidden" name="functionno"          id="functionno"          value="#Organization.functionno#" class="regular" size="5" maxlength="5" readonly style="text-align: center;">
				</td>		
			
			
			</TR>	
			
		</cfif>
		
		</cfoutput>
		
						
		<TR>
	    <TD class="labelmedium"><cf_tl id="Location">:</TD>
	    <TD height="23">
		
		    <cfif Parameter.AssignmentLocation eq "0">
			
			   <cfif Location.recordcount eq "0">
				
				 [not available]
				 <input type="hidden" id="LocationCode" name="LocationCode" value="">
				 
			   <cfelse>
				 
				   	<select name="LocationCode" size="1" class="regularxl">
					<cfoutput>
				    <cfloop query="Location">
						<option value="#LocationCode#" <cfif Organization.locationCode eq LocationCode>selected</cfif>>
				    		#LocationCode# #LocationName#
						</option>
					</cfloop>
					</cfoutput>
				    </select>
					
				</cfif>
			
			<cfelse>
			
			  <cf_dialogAsset>
			
			  <cfoutput>
			  	<table cellspacing="0" cellpadding="0">
				<tr>
				<td>
			  	  <cf_img icon="open" onclick="selectloc('movement','location','locationcode','locationname','x','x','x','x','#Organization.Mission#')">
				  </td>
				  
				  <td style="padding-left:5px">
					
				   <input type="text" name="locationcode" id="locationcode" value="" class="regularxl" size="7"  readonly>		
				   </td>
				   <td>
				   <input type="text" name="locationname" id="locationname" value="" class="regularxl" size="39" maxlength="60" readonly style="text-align: left;">
		   		   <input type="hidden" name="location"   id="location"     value=""> 
				   </td>
				   </tr>
				   </table>
				 			  
			  </cfoutput>
			  		
			</cfif>
			
			
		</TD>
		</TR>
				
		<script>
		
		 function getincumbency(cls) {
			 ptoken.navigate('getIncumbency.cfm?assignmentclass='+cls,'getclass')
		 }	 
		
		</script>
		<tr class="hide"><td id="getclass"></td></tr>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Incumbency class">:</TD>
	    <TD>
		
			   	<select name="AssignmentClass" size="1" class="regularxl" onchange="getincumbency(this.value)">
			    <cfoutput query="AssignmentClass">
				<option value="#AssignmentClass#">
		    		#Description#
				</option>
				</cfoutput>
			    </select>
				
		</TD>
		</TR>
				
		<TR>
	    <TD class="labelmedium"><cf_tl id="Incumbency">:</TD>
	    <TD class="labelmedium">
		
				<cfoutput>
				<select name="incumbency" class="regularxl">
				<cfloop index="itm" from="100" to="0" step="-50">
					<option value="#itm#" <cfif itm eq 100>selected</cfif>>#itm#% <cfif itm eq "0">lien</cfif></option>
				</cfloop>				
				</select>
				</cfoutput>
					 		
		</TD>
		</TR>
				
		<cfoutput>
			<input type="hidden" name="assignmenttype" value="#assignmenttype.assignmenttype#">
		</cfoutput>
						
		<!--- option to record topics in a dropdown --->
			
	    <cfinclude template="AssignmentEditTopic.cfm">
		
		
		<cfif Organization.StaffingMode eq "1" and Parameter.AssignmentFunction eq "1">
						    
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Parent Office">:</TD>
	    <TD>
		 <table cellspacing="0" cellpadding="0">
		 <tr><td>
			 	<cf_img icon="open" onclick="showparent('webdialog','parentoffice','parentlocation')">
			</td>
			<td style="padding-left:2px">			 	
		    <input type="text" id="parentoffice" name="parentoffice" value="" size="15" maxlength="20" readonly class="regularxl">
			</td>
			<td style="padding-left:2px">
			<input type="text" id="parentlocation" name="parentlocation" value="" size="20" maxlength="20" readonly class="regularxl">
			</td>
		  </tr>
		  </table>	
		</TD>
		</TR>
		
		<cfelse>
		
		 <input type="hidden" id="parentoffice" name="parentoffice" value="" size="15" maxlength="20" readonly class="regularxl">
		 <input type="hidden" id="parentlocation" name="parentlocation" value="" size="20" maxlength="20" readonly class="regularxl">
		
		</cfif>
		
		
		<TR id="classification">
	        <td class="labelmedium"><cf_tl id="Classification">:</td>
	        <TD>
			
			  <cfinclude template="AssignmentEditGroup.cfm">
			
			</td>
		</TR>
					   
		<TR>
	        <td valign="top" style="padding-top:3px" class="labelmedium"><cf_tl id="Remarks">:</td>
	        <TD><textarea rows="2" name="Remarks" totlength="400" onkeyup="ismaxlength(this)" class="regular" style="width:96%;padding:3px;font-size:14px"></textarea> </TD>
		</TR>
			
		<tr><td height="3" colspan="2"></td></tr>			
		<tr><td class="line" colspan="2"></td></tr>
		
		<tr><td height="3" colspan="2"></td></tr>		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Process mode">:</TD>
	    <TD class="labelmedium">		
			<INPUT type="radio" name="Condition" value="1"> <cf_tl id="Terminate conflicting assignments for this employee">.
		</TD>
		</TR>
		
		<tr>
		 <TD></TD>
	     <TD class="labelmedium">		
			<INPUT type="radio" name="Condition" value="2"> <cf_tl id="Terminate any conflicting assignments">.
		</TD>
		</TR>
		
		<tr>
			<TD></TD>
		    <TD class="labelmedium">		
			<INPUT type="radio" name="Condition" value="9" checked> <cf_tl id="Reject if any active assignment exists">.
			</TD>
		</TR>
		<tr><td height="6" colspan="2"></td></tr>		
			
		<tr><td class="line" colspan="2"></td></tr>
		
		<tr><td height="6" colspan="2" >
		<table width="100%" cellspacing="0" cellpadding="0">
		   <td align="center" height="43">
		   
		   	<cf_tl id="Reset" var="vReset">
			<cf_tl id="Close" var="vClose">
			<cf_tl id="Save"  var="vSave">
			
			<cfoutput>
			    <input class="button10g" type="reset"  name="Reset" value="#vReset#">
				<cfif URL.Caller eq "Listing">
			   		<input type="button" name="cancel" value="#vClose#" class="button10g" onClick="window.close()">
				<cfelse>
					<input type="button" name="cancel" value="#vClose#" class="button10g" onClick="parent.ProsisUI.closeWindow('myarrival')">
				</cfif>
			    <input class="button10g" type="submit" name="Submit" value="#vSave#">
			</cfoutput>
	      </td>
	    </table>
		</td></tr>
		
		<tr><td height="1" colspan="2" ></td></tr>
				
	</TABLE>

	</CFFORM>

</td>
</tr>

</table>

</cf_divscroll>

<cf_screenBottom layout="webapp">