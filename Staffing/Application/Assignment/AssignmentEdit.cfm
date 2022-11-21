
<cfparam name="URL.Source"    default="">
<cfparam name="URL.caller"    default="P">
<cfparam name="URL.box"       default="">
<cfparam name="URL.Template"  default="Assignment">

<cfif URL.Source eq "TFR">
	<cfset lbl = "Assignment Transfer">
<cfelse>
    <cfset lbl = "Assignment Edit"> 
</cfif>	

<cf_tl id="#lbl#" var="label">
<cf_tl id="Process Incumbency Amendment" var="sublabel">

<cf_screentop layout="webapp" 
    band="no" 
	height="100%" 
	scroll="yes" 
	banner="blue" 
	label="#label#" 
	jquery="Yes"
	menuaccess="context"
	option="#sublabel#">  		

<cf_FileLibraryScript>

<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>


<cfquery name="getAssignment" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  A.*, O.OrgUnitName, 
    	    OrgUnitCode, 
			OrgUnitClass, 
			FunctionNo,
			FunctionDescription,
			O.Mission, 
			O.MandateNo, 
			P.LastName, 
			P.FirstName, 
			P.IndexNo
    FROM  	PersonAssignment A, 
		    Organization.dbo.Organization O, 
		    Person P
	WHERE   A.OrgUnit      = O.OrgUnit
	AND     P.PersonNo     = A.PersonNo
	AND     A.AssignmentNo = '#URL.ID1#' 
</cfquery>

<cfparam name="URL.ID" default="#getAssignment.PersonNo#">


<cfoutput>

<!--- On July 1st, JM added try and catch sentence to hidepost ()  function ----->

<script>
	
	function showpost(form,selmis,mis,pst,fno,fun,unit,grd,posno) {
	 	ptoken.open("#SESSION.root#/Staffing/Application/Position/Lookup/Search.cfm?FormName= " + form + "&mission=" + selmis + "&fldmission=" + mis + "&fldpostnumber=" + pst + "&fldfunctionno=" + fno + "&fldfunction=" + fun + "&fldorgunit=" + unit + "&fldgrade=" + grd + "&fldposno=" + posno, "IndexWindow", "width=800, height=600, status=yes, toolbar=yes, scrollbars=yes, resizable=no");	}
	
	function selectpost(source, mission, mandateno, applicantno, personno, recordid, documentno) {
	    ptoken.open("#SESSION.root#/Staffing/Application/Position/Lookup/PositionView.cfm?Source=" + source + "&mission=" + mission + "&mandateno=" + mandateno + "&applicantno=" + applicantno + "&personno=" + personno + "&recordid=" + recordid + "&documentno=" + documentno, "_top");
	}
	
	function applyunit(org) {    
		    ptoken.navigate('#SESSION.root#/Staffing/Application/Assignment/setUnit.cfm?orgunit='+org,'unitprocess')
		}
	
	function hidepost() {		
		try{		
			document.getElementById("view").innerHTML = "";
			document.getElementById("action").className = "regular"
		} catch (err) {}
	}
	
	function change() {
	    ptoken.location("AssignmentEdit.cfm?source=Change&box=#url.box#&ID=#url.id#&ID1=#url.id1#&Template=#url.template#")
	}
	
	function ask(txt) {

		if (confirm(txt+" ?")) {	
			return true 	
		} else {	
		return false	
		}
	}	 
	
	function Selected(no,description) {									
		  document.getElementById('functionno').value = no
		  document.getElementById('functiondescription').value = description					 
		  ProsisUI.closeWindow('myfunction')
		 }		
	
	function preview() {
					
		ass  = document.getElementById("AssignmentNo").value
		fun  = document.getElementById("functionno").value
		org  = document.getElementById("orgunit").value
		expi = document.getElementById("dateexpiration").value				
		eff  = document.getElementById("DateEffective").value		
		se   = document.getElementsByName("incumbency") 
		
		   if (se[0].checked) { 
		     inc = 100 
		   } else { 
			   if (se[1].checked) {
				   inc = 50 
				  } else { inc = 0 }
		   }
		  		   	
		loc = document.getElementById("locationcode").value		
		cls = document.getElementById("assignmentclass").value
		
		url = "AssignmentEditPreview.cfm?assignmentno="+ass+
			  "&functionno="+fun+
			  "&DateEffective="+eff+
			  "&DateExpiration="+expi+
			  "&orgunit="+org+
			  "&incumbency="+inc+
			  "&locationcode="+loc+
			  "&assignmentclass="+cls;
			  
		ptoken.navigate(url,'action')	  		
	}	
			
</script>

</cfoutput>

<cf_CalendarScript>
<cf_dialogOrganization>
<cf_dialogPosition>

<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#getAssignment.Mission#'
</cfquery>
			  
<!--- provisions for runtime corrections --->

<cfif getAssignment.recordcount eq "0">

	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE PersonAssignment
		SET    OrgUnit = Pos.OrgUnitOperational
		FROM   PersonAssignment, Position Pos
		WHERE  PersonAssignment.PositionNo = Pos.PositionNo
		AND    AssignmentNo                = '#URL.ID1#' 
	</cfquery>
	
	<cfquery name="getAssignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    A.*, 
		          O.OrgUnitName, 
				  OrgUnitCode, 
				  OrgUnitClass, 
		          O.Mission, 
				  O.MandateNo, 
				  P.LastName, 
				  P.FirstName, 
				  P.IndexNo
	    FROM      PersonAssignment A INNER JOIN
                  Person P ON A.PersonNo = P.PersonNo INNER JOIN
                  Organization.dbo.Organization O ON A.OrgUnit = O.OrgUnit
		WHERE     A.AssignmentNo = '#URL.ID1#' 
	</cfquery>

</cfif>

<!--- Edition of expiration date is allowed --->
<cfset vCanEditExpirationDate = 1>

<cfif getAssignment.recordcount eq "0">

	<table width="100%"><tr>
	     <td class="labelmedium2" height="60" align="center">It appears this record <b>no</b> longer exists! Operation aborted.</td></tr>
	</table>	
	<cfabort>

</cfif>

<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   Po.PositionNo, 
	         Po.PostGrade, 
		     Po.PostType, 
		     Po.SourcePostNumber, 
		     Po.FunctionDescription,
			 Po.MissionOperational,
		     Po.OrgUnitOperational,
		     Org.Mission, 
		     Org.MandateNo,
		     Org.OrgUnitName,
		     Po.DateEffective,
		     Po.DateExpiration
	FROM     Position Po, Organization.dbo.Organization Org
	WHERE    PositionNo            = '#getAssignment.PositionNo#' 
	AND      Po.OrgUnitOperational = Org.OrgUnit 
</cfquery>	

<!--- provision to correct enddates of the assignment based on the position --->

<cfif Position.dateexpiration lt getAssignment.dateexpiration>

	<cfquery name="update" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE PersonAssignment
		SET    DateExpiration = '#dateformat(Position.dateexpiration,client.dateSQL)#'
		WHERE  AssignmentNo   = '#getAssignment.AssignmentNo#' 
	</cfquery>

</cfif>

<cfif Position.recordcount eq "0">

	<cfquery name="Reset" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Position
		SET    OrgUnitOperational = Pos.OrgUnitOperational
		FROM   Position P, PositionParent Pos
		WHERE  P.PositionParentId = Pos.PositionParentId
		AND    PositionNo         = '#getAssignment.PositionNo#' 
	</cfquery>
		
	<cfquery name="Position" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT Po.PositionNo, 
		       Po.PostGrade, 
			   Po.PostType, 
			   Po.SourcePostNumber, 
			   Po.FunctionDescription,
			   Po.MissionOperational,
			   Po.OrgUnitOperational,
			   Org.Mission, 
			   Org.MandateNo,
			   Org.OrgUnitName,
			   Po.DateEffective,
			   Po.DateExpiration
		FROM   Position Po INNER JOIN Organization.dbo.Organization Org ON Po.OrgUnitOperational = Org.OrgUnit 
		WHERE  PositionNo = '#getAssignment.PositionNo#' 		
	</cfquery>	

</cfif>

<cfif Position.recordcount eq "0">

	<table align="center">
	<tr><td align="center" style="height:100px" class="labelmedium2"><font color="FF0000">Detected an invalid orgunit, please contact your administrator.</font></td></tr>
	</table>
	<cfabort>

</cfif>

<!--- ----------------------------------------------------------- --->
<!--- verify and correct if needed the assignments based on logic --->
<!--- ----------------------------------------------------------- --->

<cf_AssignmentVerify 
   mission="#position.mission#" 
   mandateno="#position.MandateNo#" 
   personno="#getAssignment.PersonNo#">
  		   
<cf_AssignmentContractCheck 
   mission="#position.mission#" 
   mandateno="#position.MandateNo#" 
   personno="#getAssignment.PersonNo#">	
 
<cfquery name="PositionParent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT PP.*,
	       O.Mission, 
	       O.MandateNo
	FROM   Position P, 
	       PositionParent PP,
		   Organization.dbo.Organization O
	WHERE  P.PositionNo  = '#getAssignment.PositionNo#'
	AND    PP.PositionParentId = P.PositionParentId  
	AND    PP.OrgUnitOperational = O.OrgUnit
</cfquery>

<cfquery name="MissionParam" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_ParameterMission
	WHERE  Mission = '#PositionParent.Mission#'
</cfquery>

<cfquery name="MissionAssignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT A.*
	FROM   PersonMission A
	WHERE  A.PersonNo     = '#getAssignment.PersonNo#'
	AND    A.Mission      = '#PositionParent.Mission#'
</cfquery>

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Man.*, M.MissionOwner, M.StaffingMode 
    FROM   Ref_Mandate Man, Ref_Mission M
	WHERE  Man.Mission   = '#PositionParent.Mission#'
	  AND  Man.MandateNo = '#PositionParent.MandateNo#' 
	  AND  M.Mission     = Man.Mission
</cfquery>

<cfquery name="Extend" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   PersonExtension E
	WHERE  E.PersonNo  = '#getAssignment.PersonNo#'
	AND    E.Mission   = '#PositionParent.Mission#'
	AND    E.MandateNo = '#PositionParent.MandateNo#'  
</cfquery>

<cfquery name="AssignmentClass" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     Ref_AssignmentClass
	WHERE    (Operational = 1 or AssignmentClass = '#getAssignment.AssignmentClass#')
	ORDER BY ListingOrder
</cfquery>

<cfquery name="AssignmentType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_AssignmentType
</cfquery>

<cfquery name="Location" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Location
	WHERE  Mission = '#getAssignment.Mission#'
</cfquery>

<cfinvoke component = "Service.Access"  
   method           = "staffing" 
   mission          = "#Position.MissionOperational#" 
   orgunit          = "#Position.OrgUnitOperational#" 
   posttype         = "#Position.PostType#"
   returnvariable   = "accessStaffing">	   
            
<cf_divscroll>   	
			   
	<table width="100%" align="center">
		
	<tr><td>  	  
		
		<cfset header = "9">
		<cfif URL.caller eq "P">			      
		      <cfinclude template="EmployeeAssignment.cfm">			  
		<cfelseif URL.caller eq "0">	
			  <cfinclude template="../Position/Position/PositionViewHeader.cfm">
		<cfelse>	
			  <cfinclude template="AssignmentConflict.cfm"> 
		</cfif> 
		
	</td></tr>	
	
	<tr><td style="padding-left:1px;padding-right:1px">	
			
		<cfform action = "AssignmentEditSubmit.cfm?source=#url.source#&box=#URL.Box#&Caller=#URL.Caller#" 
	        method = "POST" 
			target = "process"		
		    name   = "AssignmentEdit">
				  
			<table width="100%" align="center" class="formpadding">
			
				<tr class="hide">
					<td height="60"><iframe name="process" id="process" width="100%" height="100%"></iframe></td>
				</tr>				
												
			   <cfoutput>
			   
				   <cfif URL.Source eq "TFR">
						<input type="hidden" id="PositionNo" name="PositionNo"        value="#URL.PositionNo#"> 
				   <cfelse>
						<input type="hidden" id="PositionNo" name="PositionNo"        value="#Position.PositionNo#"> 
				   </cfif>
				   
				   <input type="hidden" id="AssignmentNo"      name="AssignmentNo"      value="#getAssignment.AssignmentNo#">
				   <input type="hidden" id="PersonNo"          name="PersonNo"          value="#getAssignment.PersonNo#"> 
				   <input type="hidden" id="LastName"          name="LastName"          value="#getAssignment.LastName#"> 
				   <input type="hidden" id="FirstName"         name="FirstName"         value="#getAssignment.FirstName#"> 
				   <input type="hidden" id="MandateExpiration" name="MandateExpiration" value="#Dateformat(Mandate.DateExpiration, CLIENT.DateFormatShow)#"> 
				   <input type="hidden" id="IndexNo"           name="IndexNo"           value="#getAssignment.IndexNo#"> 
				   <input type="hidden" id="mandateno"         name="mandateno"         value="#PositionParent.MandateNo#">
				   <input type="hidden" id="mission"           name="mission"           value="#PositionParent.Mission#">
					
				</cfoutput>	
			   
				<cfset edit = "Yes">
				
				<!--- check workflow --->
				
				<cfquery name="checkaction" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     TOP 1 *
					FROM       EmployeeActionSource
					WHERE      ActionSourceNo = '#getAssignment.AssignmentNo#'
					ORDER BY Created DESC
				</cfquery>
																									
				<cfif getAssignment.AssignmentStatus eq "0" AND Mandate.MandateStatus eq "1" and checkaction.actionstatus eq "0">
				
					<tr class="labelmedium line">
										
					<td width="100%" align="center" bgcolor="yellow" height="20">
					  <font color="FF0000">This record is PENDING approval <cfif getAssignment.ContractId neq ""> for Contract extension.</cfif></font></b>&nbsp;
					</td>
					</tr>	  
				    <cfset edit = "No">
				  
				<cfelseif getAssignment.AssignmentStatus eq "9" or getAssignment.AssignmentStatus eq "8">	 
				
					<tr class="labelmedium line">
				    <td width="100%" height="20" align="center" bgcolor="FF0000">    	
				      	<font color="red">This record was cancelled!</font></b>&nbsp;  
					    <cfset edit = "No"> 
					</td>
			   	    </tr>	  
					
				<cfelse> 	
				
					<cfif URL.Source eq "TFR">			
					<cfelse>			
					</cfif> 
					
			     </cfif>
				 
				<cfif URL.Source eq "TFR">
						
					<tr><td style="height:40px">
				
						<table width="98%" bgcolor="e4e4e4" align="center">
									
						<tr class="line"><td>
						
							  <cfquery name="Old" 
						    datasource="AppsEmployee" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
							    SELECT A.DateEffective, A.DateExpiration, Po.PositionNo, Po.PostGrade, 
								       Po.PostType, Po.FunctionDescription, O.OrgUnitName, Po.SourcePostNumber, Po.PositionParentId 
							    FROM   PersonAssignment A, Position Po, Organization.dbo.Organization O
								WHERE  Po.OrgUnitOperational = O.OrgUnit
								  AND  Po.PositionNo = A.PositionNo
								  AND  A.AssignmentNo = '#URL.ID1#'
						   </cfquery>
						        
						   <cfquery name="Position" 
							datasource="AppsEmployee" 		
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT TOP 1 *
							    FROM Position Po, Organization.dbo.Organization O
								WHERE Po.OrgUnitOperational = O.OrgUnit
								AND   Po.PositionNo = '#URL.PositionNo#'
							</cfquery>	
						   
						   <cfoutput>
					   			
							   <table width="100%" cellspacing="0" cellpadding="0">
							   <tr class="labelmedium2" style="height:20px">
							   <td style="font-weight:200;padding-top:2px;padding-left:5px;border-right:1px solid gray" valign="top" rowspan="2" class="labelmedium2"><font size="3"><cf_tl id="Transfer from">:</b></td>					   
							   <td style="padding-left:4px"><cf_tl id="Number"></td>					   
							   <td style="padding-left:4px"><cf_tl id="Type"></td>
							   <td><cf_tl id="Function"></td>
							   <td><cf_tl id="Unit"></td>
							   <td><cf_tl id="Period"></td>
							   <td></td>
							   </tr>
							   <tr style="height:20px">					   
							   <td style="padding-left:4px">#Old.PositionParentId# <cfif old.SourcePostNumber neq "">(#Old.SourcePostNumber#)</cfif></td>					   
							   <td style="padding-left:4px">#Old.PostType#</td>
							   <td>#Old.PostGrade# - #Old.FunctionDescription#</td>
							   <td>#Old.OrgUnitName#</td>
							   <td>#DateFormat(Old.DateEffective, CLIENT.DateFormatShow)# -#DateFormat(Old.DateExpiration, CLIENT.DateFormatShow)#</td>
							   <td></td>
							   </tr>						  						   
							   </table>		
						   
						    </cfoutput>
							
					   </td></tr>	 
					   </table>		
				   </td></tr>
				   
				</cfif>
			       
			  <tr>
			    <td>
			    <table width="98%"	align="center">			   
				  
				   <cfif MissionParam.EnableMissionPeriod eq "1">
				
					<cfif Dateformat(getAssignment.DateExpiration, CLIENT.DateFormatShow) neq Dateformat(Mandate.DateExpiration, CLIENT.DateFormatShow)>
					
						<TR class="line">
					    <TD class="labelmedium2"><cf_tl id="Staffing period">:<cfoutput>&nbsp;#Mandate.MandateNo#</cfoutput></TD>
					    <td style="width:85%" height="20" style="padding-left:4px">
							
							<table>
							<tr class="labelmedium2">
							<td width="40"></td>
							<td>
							<cfoutput>
							#Dateformat(Mandate.DateEffective, CLIENT.DateFormatShow)#
							</td>
							<td width="24" style="padding-left:3px;padding-right:3px">:</td>
							<td>			
							#Dateformat(Mandate.DateExpiration, CLIENT.DateFormatShow)#	
							</td>				
							<td align="right" width="100%">&nbsp;<cfif Mandate.MandateStatus eq "1"><font size="2" color="0080C0">Locked</font><cfelse>Draft</b> (modify position to move a person)</cfif></b></td>			 		  
							</cfoutput>
							</tr>
							</table>
								
						</td>
						</TR>	
						
					</cfif>				
							
				</cfif>	
								
				<cfif Mandate.MandateStatus eq "1">
				
					    <!--- check if the person has a later assignment already --->
						
						<cfquery name="Check" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  *
						    FROM  PersonAssignment A
							WHERE PersonNo = '#getAssignment.PersonNo#'
							AND   DateEffective > '#getAssignment.DateEffective#'
							AND   AssignmentStatus IN ('0','1')
							AND   AssignmentNo != '#getAssignment.AssignmentNo#'
							AND   PositionNo IN (SELECT PositionNo 
							                      FROM  Position
												  WHERE Mission   = '#PositionParent.Mission#'
												  <!--- added for charles --->
												  AND   MandateNo = '#PositionParent.MandateNo#'
												  AND   PositionNo = A.PositionNo
												 )
					    </cfquery>
									
						<cfif check.recordcount gte "1">
							<tr bgcolor="silver" class="line">
							<td colspan="2" height="1" align="center" class="labelmedium2"><b>Attention:</b> This Person has a valid assignment beyond this assignment.</td></tr>												
						</cfif>
									
							    
					<cfif   Check.recordcount gte "1" OR
					        getAssignment.AssignmentStatus eq "0" OR URL.Source eq "TFR" OR URL.Source eq "Change"
							OR AccessStaffing eq "NONE" OR AccessStaffing eq "READ">
													
							<!--- option not available --->
					
					<cfelse>	
					  
					    <TR class="line">
					    <TD colspan="2" align="left" height="40">
					    
							<table class="formpadding">
							<tr>
							
							<cfoutput>
							
							<td style="padding-left:5px" class="labelmedium2">
							
								<cf_tl id="Transfer to another position" var="transfer">
							    <input type="button" name="Transfer" value="#transfer#" class="button10g" style="width:370px;height:30px;font-size:14px;border-top-left-radius:10px;;border-bottom-left-radius:10px" onclick="selectpost('TFR','#Mandate.Mission#','#Mandate.MandateNo#','','#getAssignment.PersonNo#','#getAssignment.AssignmentNo#','#Position.PositionNo#')">
								
								<cf_tl id="Change Functional Title, Location, Incumbency or Unit" var="myfunction">
							    <input type="button" name="Transfer" value="#myfunction#" class="button10g" style="width:370px;height:30px;font-size:14px;border-top-right-radius:10px;;border-bottom-right-radius:10px" onclick="change()">
							
							</td>			
								
							</cfoutput>
							
							</tr>
							</table>
						
						</TD>
						</TR>
															
					</cfif>
				
				</cfif>
				
				<tr><td colspan="2">
				
				<table width="100%" class="formpadding" align="center">
				
				
				<cfif URL.Caller neq "P">
					
					<TR class="labelmedium2" style="height:24px">
					    <TD height="20"><cf_tl id="Employee">:</TD>
						<cfoutput>	
					    <TD style="padding-right:5px">
							<a href ="javascript:EditPerson('#getAssignment.PersonNo#','#getAssignment.IndexNo#')">#getAssignment.FirstName# #getAssignment.LastName# (IndexNo:#getAssignment.IndexNo#)</A>
						</TD>
						</cfoutput>	
					</TR>	
				
				<cfelse>
					
					<cfoutput>	
						
					<TR class="labelmedium2" style="height:24px">
				    <TD height="20"><cf_tl id="Position">:</TD>
					
				    <TD>	
					
						<table cellspacing="0" cellpadding="0">
						<tr class="labelmedium2" style="height:24px">	
							<td>
						    <a title="Open Position" href="javascript:EditPosition('#Position.Mission#','#Position.MandateNo#','#Position.PositionNo#')">
							<font color="0080C0">
							<cfif Position.SourcePostNumber neq "">
							#Position.SourcePostNumber# / 
							<cfelse>
							#Position.PositionNo# /
							</cfif>
							#Position.PostGrade# / #Position.PostType# / #Position.FunctionDescription#  <cfif Mandate.MandateStatus eq "1">[locked]</cfif>		
							</u>
							</font>
							</a>
							</td>
							<cfif MissionParam.ShowPositionPeriod eq "1">
								<td style="padding-left:15px" class="labelmedium2" height="14"><font color="808080"><cf_tl id="Effective">:</font></td>
								<td align="center" class="labelmedium2" style="padding-left:5px" bgcolor="FfFfFf">
								<font color="black">#Dateformat(Position.DateEffective, CLIENT.DateFormatShow)#</td>
								<td align="center" class="labelmedium2" style="padding-left:3px;padding-right:3px">-</td>
								<td bgcolor="ffffff" class="labelmedium2" align="center">		
								<font color="black">#Dateformat(Position.DateExpiration, CLIENT.DateFormatShow)#
								</td>
							</cfif>
						</tr>
						</table>				
						
					</TD>
							
					</TR>	
						
					</cfoutput>
							
				</cfif>
						
				<cfif URL.Source neq ""> 
				     
					 <cfif now() lt Position.DateEffective>
					    <cfset st = Dateformat(Position.DateEffective, CLIENT.DateFormatShow)>
					 <cfelse> 
					    <cfset st = Dateformat(now(), CLIENT.DateFormatShow)>
					 </cfif>
										 
			 	<cfelse>
					<cfset st = Dateformat(getAssignment.DateEffective, CLIENT.DateFormatShow)>
				</cfif> 
					
				<cfif URL.Source eq "TFR" or URL.Source eq "Change"> 
				
					<tr class="labelmedium2" style="height:24px"><td height="20"><cf_tl id="Effective">:</td>
					<TD>		
				
							<cfif validcontract eq "1" and source eq "">
							
								<cfoutput>#Dateformat(getAssignment.DateEffective, CLIENT.DateFormatShow)#						
								<!--- effective date can not be changed --->							
								<input type="hidden" name="DateEffective" id="DateEffective" value="#Dateformat(getAssignment.DateEffective,CLIENT.DateFormatShow)#">					
								</cfoutput>	
							
							<cfelse>			
								
								<cf_intelliCalendarDate9
									FieldName="DateEffective" 
									Manual="True"		
									class="regularxl"					
									DateValidStart="#Dateformat(Position.DateEffective, 'YYYYMMDD')#"
									DateValidEnd="#Dateformat(Position.DateExpiration, 'YYYYMMDD')#"
									Default="#st#"
									AllowBlank="False">	
								
							</cfif>	
																
					</td>
					
					</tr>	
				
				<cfelse>
				    								
					<tr class="labelmedium2" style="height:24px">
					<td height="20">
					
						<cfif (AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT") and edit eq "Yes">
						
							<cfoutput>#PositionParent.Mission#</cfoutput> <cf_tl id="since">:
						
						<cfelse>
						
							<cf_tl id="Effective"> :
							
						</cfif>
								
					</td>
					<TD>
						
						<table width="100%" cellspacing="0" border="0" cellpadding="0">
						<tr class="labelmedium2" style="height:24px">	
							
							
						<cfif (AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT") and edit eq "Yes">
						
							<cfif MissionParam.EnableMissionPeriod eq "1">
							
								<td>
																
								 <cf_intelliCalendarDate9
								    Manual="False"
									FieldName="DateArrival" 
									class="regularxl"
									Default="#Dateformat(MissionAssignment.DateArrival, CLIENT.DateFormatShow)#"
									AllowBlank="True">	
									
									<cfoutput>
									<input type="hidden" value="#Dateformat(MissionAssignment.DateDeparture, CLIENT.DateFormatShow)#" name="DateDeparture" id="DateDeparture">	
									<input type="hidden" value="#st#" name="DateEffective" id="DateEffective">	
									</cfoutput>
									
								</td>	
										
							<cfelse>
											
								<cfinclude template="AssignmentEditContinuous.cfm">
								
								<cfif cstr lt Position.DateExpiration and cstr gt st>
											
									<td class="labelmedium2">
									
									<cfoutput>
										<input type="hidden" value="#st#" id="DateEffective" name="DateEffective">		
										#Dateformat(cstr, CLIENT.DateFormatShow)#
									</cfoutput>							
											
								<cfelse>	
												
									<td>
									
										<cfif validcontract eq "1" and URL.Source neq "TFR">
																						
											<cfoutput><b>#Dateformat(getAssignment.DateEffective, CLIENT.DateFormatShow)#
											
											<!--- effective date can not be changed --->
											
											<input type="hidden" id="DateEffective" name="DateEffective" value="#Dateformat(getAssignment.DateEffective,CLIENT.DateFormatShow)#">
											
											</cfoutput>								
										
										<cfelse>
																								
											<cf_intelliCalendarDate9
												FieldName="DateEffective" 
												Default="#st#"
												Manual="True"	
												class="regularxl"
												DateValidStart="#Dateformat(Position.DateEffective, 'YYYYMMDD')#"
												DateValidEnd="#Dateformat(Position.DateExpiration, 'YYYYMMDD')#"
												AllowBlank="False">	
											
										</cfif>	
									
									</td>
								
								</cfif>	
								
							</cfif>	
							
						<cfelse>
						
							<td class="labelmedium2">		
							<cfoutput><b>#Dateformat(getAssignment.DateEffective, CLIENT.DateFormatShow)#</cfoutput>			
							</td>
						
						</cfif>			
						
						</tr>
						</table>
					
				</cfif>	
							
				</td></tr>
										
			    <TR class="labelmedium2" style="height:24px">
			    <TD width="130"><cf_tl id="Expiration">:</TD>
			    <TD width="85%">
				
					<table cellspacing="0" cellpadding="0">
					<tr class="labelmedium2" style="height:24px"><td>
								
					<!--- check if the person has a later assignment already --->
					
					<cfquery name="Check" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT  *
					    FROM  PersonAssignment
						WHERE PersonNo = '#getAssignment.PersonNo#'
						AND   DateEffective > '#getAssignment.DateEffective#'
						AND   AssignmentStatus IN ('0','1')
						AND   AssignmentNo != '#getAssignment.AssignmentNo#'
						AND   PositionNo IN (SELECT PositionNo FROM Position WHERE Mission = '#PositionParent.Mission#')
					</cfquery>
						
					<cfif Check.recordcount eq "0" and 
					    (AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT") and 
						(getAssignment.AssignmentStatus eq "1" or Mandate.MandateStatus eq "0")>
						
							<cfset sc = "expiration_selectdate">
						
					<cfelse>
						
							<cfset sc = "">
						
					</cfif>
						
					<cfif (AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT") and edit eq "Yes">
					
							<!--- check if the person has a prior assignment already --->
							<cfquery name="Prior" 
									datasource="AppsEmployee" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT  *
								    FROM    PersonAssignment
									WHERE   PersonNo = '#getAssignment.PersonNo#'
									AND     DateEffective < '#getAssignment.DateEffective#'
									AND     AssignmentStatus IN ('0','1')
									AND     AssignmentNo != '#getAssignment.AssignmentNo#'
									AND     Incumbency = '#getAssignment.Incumbency#'
									AND     PositionNo IN (SELECT PositionNo 
									                       FROM   Position
														   WHERE  Mission = '#PositionParent.Mission#')
									ORDER BY DateEffective DESC					   
														   
							</cfquery>	
							
							
							<cfoutput>
							<script>
								 function expiration_selectdate() {							 
								    ptoken.navigate('AssignmentEditExpirationPasstru.cfm?validcontract=#validcontract#&assignmentNo=#getAssignment.AssignmentNo#','reason')			
								 }
							</script>
							</cfoutput>
													
							<cfif validcontract eq "1">
							
								<cfoutput>
									
									<cfif vCanEditExpirationDate eq 0>
									
										#dateformat(validcontractExpiration,CLIENT.DateFormatShow)#  &nbsp;<font color="6688aa">:<img src="#SESSION.root#/images/finger.gif" alt="" border="0" align="absmiddle">&nbsp;Expiration date is controlled by contract records</font>
										<!--- expiration date can not be changed --->							
										<input type="hidden" name="dateexpiration" id="dateexpiration" value="#Dateformat(validcontractexpiration,CLIENT.DateFormatShow)#">
									
									<cfelse>
									
									<cfif ValidContractExpiration lt Position.DateExpiration and ValidContractExpiration gt Position.DateEffective>
									
										<cf_intelliCalendarDate9
											FieldName="dateexpiration" 
											Default="#Dateformat(ValidContractExpiration, client.dateFormatShow)#"
											Manual="True"	
											class="regularxl"
											DateValidStart="#Dateformat(Position.DateEffective, 'YYYYMMDD')#"
											DateValidEnd="#Dateformat(Position.DateExpiration, 'YYYYMMDD')#"
											AllowBlank="False">
									
									<cfelse>
									
										<cf_intelliCalendarDate9
											FieldName="dateexpiration" 
											Default="#Dateformat(Position.DateExpiration, client.dateFormatShow)#"
											Manual="True"	
											class="regularxl"
											DateValidStart="#Dateformat(Position.DateEffective, 'YYYYMMDD')#"
											DateValidEnd="#Dateformat(Position.DateExpiration, 'YYYYMMDD')#"
											AllowBlank="False">
											
									</cfif>		
									
									</cfif>	
											
								</cfoutput>	
							
							<cfelse>	
							
							
																						
								<cfif Prior.dateExpiration neq "">
										
									<cf_intelliCalendarDate9
										FieldName="dateexpiration" 
										Manual="True"	
										class="regularxl"
										Default="#Dateformat(getAssignment.DateExpiration, CLIENT.DateFormatShow)#"
										DateValidStart="#Dateformat(Prior.DateExpiration+1, 'YYYYMMDD')#"
										DateValidEnd="#Dateformat(Position.DateExpiration, 'YYYYMMDD')#"
										scriptdate="expiration_selectdate"
										AllowBlank="False">	
									
								<cfelse>
															
									<cf_intelliCalendarDate9
										FieldName="dateexpiration" 
										Manual="True"	
										class="regularxl"
										Default="#Dateformat(getAssignment.DateExpiration, CLIENT.DateFormatShow)#"
										DateValidStart="#Dateformat(Position.DateEffective, 'YYYYMMDD')#"
										DateValidEnd="#Dateformat(Position.DateExpiration, 'YYYYMMDD')#"
										scriptdate="expiration_selectdate"
										AllowBlank="False">				
								
								</cfif>	
							
							</cfif>					
								
					<cfelse>
								
						<cfoutput><b>#Dateformat(getAssignment.DateExpiration, CLIENT.DateFormatShow)#&nbsp;</cfoutput>
					
					</cfif>		
					
					<cfquery name="get" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						 SELECT *
					     FROM   Ref_PersonGroupList
						 WHERE  GroupCode     = '#getAssignment.ExpirationCode#'
						 AND    GroupListCode = '#getAssignment.ExpirationListCode#'
					</cfquery>						
									
					</td>
					
					<td style="padding-left:4px">
					<cfoutput>#get.Description#</cfoutput>
					</td>
					
					</tr>
					</table>
				
				</td>	
				
				<script language="JavaScript">
					function extend(chk) {
						se = document.getElementById("extdate")		
						rs = document.getElementById("reasonbox")		
						if (chk == true) {
							se.className = "regular"	
							rs.className = "hide"			
						} else {
							se.className = "hide"
							rs.className = "regular"				
						}
					}
				</script>
				
				</tr>
								
				<tr>
				
				    <td></td>
				
				    <td>
					<table cellspacing="0" cellpadding="0">		
							
						<tr style="height:0px">
					    <td id="reason">						
				  									
							    <cfset url.dateexpiration = Dateformat(getAssignment.DateExpiration, CLIENT.DateFormatShow)>
								<cfset url.assignmentno   = getAssignment.AssignmentNo>
								<cfset url.validcontract  = validcontract>
																				
								<cfinclude template="AssignmentEditExpiration.cfm">
									
						</td>
						
						<td id="extdate" class="hide">	
																						
							<cfif Extend.recordcount eq "1">
										
								<cf_intelliCalendarDate9
										FieldName="DateExtension" 
										Default="#Dateformat(Extend.DateExtension, CLIENT.DateFormatShow)#"
										Manual="False"	
										class="regularxl"
										DateValidStart="#Dateformat(Position.DateExpiration+1, 'YYYYMMDD')#"						
										AllowBlank="True">	
										
							<cfelse>
							
								<cfif check.DateExpiration neq "">
								
									<cf_intelliCalendarDate9
										FieldName="DateExtension" 
										Default="#Dateformat(check.DateExpiration+1, CLIENT.DateFormatShow)#"
										class="regularxl"
										DateValidStart="#Dateformat(Position.DateExpiration+1, 'YYYYMMDD')#"
										AllowBlank="True">		
										
								<cfelse>
								
									<cf_intelliCalendarDate9
										FieldName="DateExtension" 
										Default=""
										DateValidStart="#Dateformat(Position.DateExpiration+1, 'YYYYMMDD')#"
										AllowBlank="True">							
										
								</cfif>							
								
							</cfif>		
																			
						</td>		
						
						</tr>
							
					</table>
					</td>
					
				</tr>
								
				<!--- adjustment --->	
					
				<TR class="labelmedium2" style="height:24px">
			    <TD><cf_tl id="Organization">:</TD>
				<cfoutput>
			    <TD>
				
				<cfif AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT">
				
					<cfif URL.Source eq "TFR"> 
							 
						 <!--- we don't want to transfer and change assignment organization in one shot --->
						 
						 <table cellspacing="0" cellpadding="0">
						 <tr>
						 <td class="hide" id="unitprocess"></td>
						 	 
					     <cfif Mandate.StaffingMode eq "1" and getAdministrator(Position.mission) eq "1">	
						 	
						 <td style="padding-right:1px">		
						 			 
					     		<img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
									  onMouseOver="document.img0.src='#SESSION.root#/Images/button.jpg'" 
									  onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
									  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
									  onClick="hidepost();selectorgmis('webdialog','orgunit','orgunitcode','mission','orgunitname','orgunitclass',mission.value, mandateno.value)">
									  
			             </td>
					
						</cfif>			
						
						<td>	
						<input type="text" name="orgunitname" value="#Position.OrgUnitName#" size="50" class="regularxl" maxlength="60" readonly style="text-align: left;">
						</td>
						<input type="hidden" name="orgunitclass" value="#Position.OrgUnitClass#" size="15" maxlength="15" readonly style="text-align: center;"> 
						<input type="hidden" name="orgunit"    value="#Position.OrgUnit#"> 
						<input type="hidden" name="orgunitcode" value="#Position.OrgUnitCode#" class="disabled" size="5" maxlength="5" readonly style="text-align:center;">
						
						</tr>
						</table>
												
					<cfelse>
					
						 <table cellspacing="0" cellpadding="0">
						 <tr>
						 <td class="hide" id="unitprocess"></td>
					
						 <cfif Mandate.StaffingMode eq "1"  and URL.source eq "change">				
						
														 
							 <td>						
								<input type="text" id="orgunitname" name="orgunitname" value="#getAssignment.OrgUnitName#" class="regularxl" size="50" maxlength="60" readonly style="text-align: left;">
							</td>	
							
							 <td style="padding-left:1px">
							 <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
										  onMouseOver="document.img0.src='#SESSION.root#/Images/button.jpg'" 
										  onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
										  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 							  
										  onClick="hidepost();selectorgmis('webdialog','orgunit','orgunitcode','mission','orgunitname','orgunitclass',mission.value, mandateno.value)">							  
							 </td>		
							
						<cfelse>
						
							<td class="labelmedium2">	
							#getAssignment.OrgUnitName#					
							<input type="hidden" id="orgunitname" name="orgunitname" value="#getAssignment.OrgUnitName#" class="regularxl" size="50" maxlength="60" readonly style="text-align: left;">
							</td>	  
				
					     </cfif>										
						
						<input type="hidden" id="orgunitclass" name="orgunitclass" value="#getAssignment.OrgUnitClass#" class="regularxl" size="15" maxlength="15" readonly style="text-align: center;"> 
						<input type="hidden" id="orgunit"      name="orgunit"      value="#getAssignment.OrgUnit#"> 
						<input type="hidden" id="orgunitcode"  name="orgunitcode"  value="#getAssignment.OrgUnitCode#">
						
						</tr>
						</table>
						
					</cfif>
				
				<cfelse>
				
					#getAssignment.OrgUnitName#
				
				</cfif>
				
				</TD>
				</TR>	
				
			    <TR class="labelmedium2" style="height:24px">
			    <TD><cf_tl id="Function">:</TD>
			    <TD>				
							
				<cfif AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT">
				
					<cfif URL.Source eq "TFR"> 		
					
						 <table cellspacing="0" cellpadding="0">
						 <tr>
						 
						 	<td style="padding-right:1px">
						
							<cfif Mandate.StaffingMode eq "1" and getAdministrator(Position.mission) eq "1">
							
							 <!--- we don't want to transfer and change assignment FUNCTION in one shot --->
							
							 <img src="#SESSION.root#/Images/search.png" alt="Select function" name="img1" 
									  onMouseOver="document.img1.src='#SESSION.root#/Images/button.jpg'" 
									  onMouseOut="document.img1.src='#SESSION.root#/Images/search.png'"
									  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
									  onClick="hidepost();selectfunction('webdialog','functionno','functiondescription','#Mandate.MissionOwner#','','')">
												
							</cfif>
							</td>		  
							<td>
							<input type="text" id="functionno" name="functionno" value="#Position.functionno#"  size="3" maxlength="5" class="regularxl" readonly style="text-align: center;">
							</td>
							<td style="padding-left:2px">
								<input type="text" id="functiondescription" name="functiondescription" value="#Position.functiondescription#" size="60" class="regularxl" maxlength="40" readonly  style="text-align: left;"> 
							</td>
							</tr>
						</table>	
						
					<cfelseif URL.Source eq "Change"> 		
					
						 <table cellspacing="0" cellpadding="0">
						 <tr class="labelmedium2" style="height:24px">						 
						 	  
							<td>
							<input type="text" id="functionno" name="functionno" value="#getAssignment.functionno#"  size="3" maxlength="5" class="regularxl" readonly style="text-align: center;">
							</td>
							<td style="padding-left:2px">
								<input type="text" id="functiondescription" name="functiondescription" value="#getAssignment.functiondescription#" size="60" class="regularxl" maxlength="40" readonly  style="text-align: left;"> 
							</td>
							
							<td style="padding-left:1px">
						
							<!---
							<cfif Mandate.StaffingMode eq "1" and getAdministrator(Position.mission) eq "1">
							
							 we don't want to transfer and change assignment FUNCTION in one shot --->
							
							 <img src="#SESSION.root#/Images/search.png" alt="Select function" name="img1" 
									  onMouseOver="document.img1.src='#SESSION.root#/Images/button.jpg'" 
									  onMouseOut="document.img1.src='#SESSION.root#/Images/search.png'"
									  style="cursor: pointer;" alt="" width="25" height="25"  align="absmiddle" 
									  onClick="hidepost();selectfunction('webdialog','functionno','functiondescription','#Mandate.MissionOwner#','','')">
							
							<!--- 					
							</cfif>
							--->
							</td>		
							</tr>
						</table>												
								
					<cfelse>								
								
						<cfif (Mandate.StaffingMode eq "1" and Parameter.AssignmentFunction eq "1" and URL.source neq "") or getAssignment.functiondescription eq "">
											
						 <table cellspacing="0" cellpadding="0">
						 <tr>
						 
						 	<td style="padding-right:1px">
												
							 <img src="#SESSION.root#/Images/search.png" alt="Select function" name="img1" 
									  onMouseOver="document.img1.src='#SESSION.root#/Images/button.jpg'" 
									  onMouseOut="document.img1.src='#SESSION.root#/Images/search.png'"
									  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
									  onClick="hidepost();selectfunction('webdialog','functionno','functiondescription','#Mandate.MissionOwner#','','')">
									  
							</td>		  
							<td>
								<input type="text" id="functionno" name="functionno" value="#getAssignment.functionno#"  size="3" maxlength="5" class="regularxl" readonly style="text-align: center;">
							</td>
							<td style="padding-left:2px">
								<input type="text" id="functiondescription" name="functiondescription" value="#getAssignment.functiondescription#" size="43" maxlength="40" readonly class="regularxl" style="text-align: left;">
							</td>
						</tr>
						</table>	
									  
							  					  
						<cfelse>	
														
							#getAssignment.functiondescription#
							
							<input type="hidden" id="functionno" name="functionno" value="#getAssignment.functionno#"  size="3" maxlength="5" class="regular" readonly style="text-align: center;">
							<input type="hidden" id="functiondescription" name="functiondescription" value="#getAssignment.functiondescription#" size="60" maxlength="40" readonly class="regular" style="text-align: left;"> 
									
						</cfif>
						
					</cfif>
				
				<cfelse>
				
					<b>#getAssignment.functiondescription#
					
				</cfif>
				
				
				</TD>
				</TR>	
					
				</cfoutput>
						
				<TR class="labelmedium2" style="height:24px">
			    <TD><cf_tl id="Location">:</TD>
			    <TD>			
								
				<cfquery name="Location" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Location
					WHERE  Mission = '#getAssignment.Mission#'
					ORDER BY ListingOrder, LocationCode
				</cfquery>
				
				<cfif MissionParam.AssignmentLocation eq "0">
				
					<cfif (AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT") and edit eq "Yes">
						
					   	<select id="locationcode" name="locationcode" size="1" onChange="hidepost();" class="regularxl">
						<option value="">---select---</option>
					    <cfoutput query="Location">						
						<option value="#LocationCode#" <cfif getAssignment.locationCode eq LocationCode>selected</cfif>>
				    		#LocationName#
						</option>
						</cfoutput>
					    </select>
						
					<cfelse>
					
						<cfquery name="Loc" 
								datasource="AppsEmployee" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT  *
								FROM  Location
								WHERE Mission = '#Position.Mission#'
								AND   LocationCode = '#getAssignment.LocationCode#'						
							</cfquery>
					
						<cfoutput>#Loc.LocationName#</cfoutput>
					
					</cfif>
					
				<cfelse>
				
					 <cf_dialogAsset>
					 
					  <cfif (AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT") and edit eq "Yes">
					
						  <cfoutput>
						  
						  	<cfquery name="Loc" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT  *
								FROM  Location
								WHERE Mission = '#Position.Mission#'
								AND   LocationCode = '#getAssignment.LocationCode#'						
							</cfquery>
										
							<cfif URL.Source neq "TFR" or getAdministrator(Position.mission) eq "1">
						  
							  <img src="#SESSION.root#/Images/search.png" alt="Select function" name="img2" 
								  onMouseOver="document.img2.src='#SESSION.root#/Images/button.jpg'" 
								  onMouseOut="document.img2.src='#SESSION.root#/Images/search.png'"
								  style="cursor: pointer;" alt="" width="25" height="24" border="0" align="absmiddle" 
								  onClick="selectloc('movement','location','locationcode','locationname','x','x','x','x','#Position.Mission#')">
								  
							</cfif>	  
								
							<input type="text" id="locationcode" name="locationcode" class="regularxl" size="7" value="#getAssignment.LocationCode#" readonly>		
							<input type="text" id="locationcode" name="locationname" value="#Loc.LocationName#" class="regularxl" size="59" maxlength="60" readonly style="text-align: left;">
					   		<input type="hidden" id="location" name="location"  value=""> 
							 
						  
						  </cfoutput>
					  
					  <cfelse>
					  
					  	<cfquery name="Loc" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT  *
								FROM    Location
								WHERE   Mission = '#Position.Mission#'
								AND     LocationCode = '#getAssignment.LocationCode#'						
							</cfquery>
					
						<cfoutput>#Loc.LocationName#</cfoutput>
					
					  </cfif>
					
				</cfif>	
					
				</TD>
				</TR>			
				
				<script>
				
				 function getincumbency(cls) {
					 ptoken.navigate('getIncumbency.cfm?assignmentclass='+cls,'getclass')
				 }	 
				
				</script>
				
				<tr class="hide"><td id="getclass"></td></tr>
				
				<tr class="labelmedium2" style="height:24px">
					<td><cf_tl id="Incumbency class">:</td>
					<td>
					
					<cfif (AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT") and edit eq "Yes">
			   
			   			   	<select id="assignmentclass" name="assignmentclass" size="1" onChange="hidepost();getincumbency(this.value)" class="regularxl">
					    <cfoutput query="AssignmentClass">
						<option value="#AssignmentClass#" <cfif getAssignment.AssignmentClass eq AssignmentClass>selected</cfif>>
				    		#Description#
						</option>
						</cfoutput>
					    </select>
						
					<cfelse>
						
							<cfoutput>#getAssignment.AssignmentClass#</cfoutput>
						
					</cfif>	
					
							
					</TD>
					
				</TR>
				
				<TR class="labelmedium2" style="height:25px">
			    <TD ><cf_tl id="Incumbency">:</TD>
			    <TD style="padding-top:5px">
				
					
					<cfif (AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT") and edit eq "Yes">
					
				    	<cfoutput>
						<input type="radio" name="incumbency" value="100" onClick="hidepost()" <cfif getAssignment.Incumbency eq "100">checked</cfif>> 100%
						<!---
						<INPUT type="radio" name="incumbency" value="90" onClick="hidepost()" <cfif getAssignment.Incumbency eq "90">checked</cfif>> 90%		
						<INPUT type="radio" name="incumbency" value="80" onClick="hidepost()" <cfif getAssignment.Incumbency eq "80">checked</cfif>> 80%		
						<INPUT type="radio" name="incumbency" value="70" onClick="hidepost()" <cfif getAssignment.Incumbency eq "70">checked</cfif>> 70%		
						<INPUT type="radio" name="incumbency" value="60" onClick="hidepost()" <cfif getAssignment.Incumbency eq "60">checked</cfif>> 60%			
						--->
						<INPUT type="radio" name="incumbency" value="50" onClick="hidepost()" <cfif getAssignment.Incumbency eq "50">checked</cfif>> 50%
						<!---
						<INPUT type="radio" name="incumbency" value="40" onClick="hidepost()" <cfif Assignment.Incumbency eq "40">checked</cfif>> 40%
						<INPUT type="radio" name="incumbency" value="30" onClick="hidepost()" <cfif Assignment.Incumbency eq "30">checked</cfif>> 30%
						<INPUT type="radio" name="incumbency" value="20" onClick="hidepost()" <cfif Assignment.Incumbency eq "20">checked</cfif>> 20%
						<INPUT type="radio" name="incumbency" value="10" onClick="hidepost()" <cfif Assignment.Incumbency eq "10">checked</cfif>> 10%
						--->
						<INPUT type="radio" name="incumbency" value="0" onClick="hidepost()"  <cfif getAssignment.Incumbency eq "0">checked</cfif>> 0% Lien
					    </cfoutput>	
						
					<cfelse>
					
						<cfoutput>#getAssignment.Incumbency#%</cfoutput>
					
					</cfif>	
					
					</td>
					
				</tr>
				
				<cfoutput>
				<input type="hidden" name="assignmenttype" value="#getAssignment.assignmenttype#">
				</cfoutput>
				
				<!--- disabled for now 10/3/2011 
				
				<tr>	
					<TD height="20"><cf_tl id="Assignment Type">:</TD>
				    <TD>	
							
					<cfquery name="AssignmentClass" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
					    FROM Ref_AssignmentClass
						ORDER BY ListingOrder
					</cfquery>
					
					<cfquery name="AssignmentType" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
					    FROM Ref_AssignmentType
					</cfquery>
					
						<cfif (AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT") and edit eq "Yes">
					
					   	<select name="assignmenttype" size="1" onChange="hidepost();" style="font:10px">
					    <cfoutput query="AssignmentType">
						<option value="#AssignmentType#" <cfif getAssignment.AssignmentType eq AssignmentType>selected</cfif>>
				    		#Description#
						</option>
						</cfoutput>
				    	</select>
						
						<cfelse>
			
							<cfoutput>#getAssignment.AssignmentType#</cfoutput>
						
						</cfif>
					</td>
				</tr>
				
				--->
				
				<!--- option to record topics in a dropdown --->
				
				<cfif (AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT") and edit eq "Yes">
					<cfset editmode = "edit">
				<cfelse>
					<cfset editmode = "view">
				</cfif>	
					
			    <cfinclude template="AssignmentEditTopic.cfm">							
							   
				<TR class="labelmedium2" style="height:24px" id="classification">
			        <td class="fixlength" valign="top" style="padding-top:6px"><cf_tl id="Incumbency Classification">:</td>
			        <TD>
					   <cfinclude template="AssignmentEditGroup.cfm">
					</td>
				</TR>
				
				<TR class="labelmedium2" style="height:24px">
			        <td valign="top" style="padding-top:5px"><cf_tl id="Remarks">:</td>
			        <TD>
					<cfif (AccessStaffing eq "ALL" OR AccessStaffing eq "EDIT") and edit eq "Yes">
					
						<textarea style="width:96%;font-size:13px;height:65;padding:3px" totlength="400" onkeyup="ismaxlength(this)" class="regular" name="Remarks"><cfoutput>#getAssignment.Remarks#</cfoutput></textarea> 
						
					<cfelse>
					
						<cfif getAssignment.Remarks eq "">n/a<cfelse><cfoutput><b>#getAssignment.Remarks#</cfoutput></cfif>
						
					</cfif>	
								
				</TD>
				</TR>
				
				<tr  class="labelmedium2" style="height:27px">
					<td valign="top" style="padding-top:5px"><cf_tl id="Attachments"></td>
					<td style="padding-right:20px">
					
					<cf_filelibraryN
						DocumentPath  = "Assignment"
						SubDirectory  = "#getAssignment.PersonNo#" 
						Filter        = "#PositionParent.Mission#"
						Presentation  = "all"
						Insert        = "yes"
						Remove        = "yes"
						width         = "100%"	
						Loadscript    = "no"				
						border        = "1">	
					
					</td>		
				</tr>
				
				<tr><td height="2"></td></tr>
				
				<cf_wfActive entitycode="Assignment" objectkeyvalue1="#getAssignment.AssignmentNo#">	
				
				<cfif (getAssignment.AssignmentStatus neq "1" and Mandate.MandateStatus eq "1") 
				OR AccessStaffing eq "NONE" OR AccessStaffing eq "READ">
					
				<cfelse>				
									
				<TR class="labelmedium2" style="background-color:ffffcf;height:37px">
			    <TD align="right" style="padding-right:5px"><cf_tl id="Saving mode">:</TD>
			    <TD>
				    <select name="Condition" class="regularxl" style="border:0px">
				    <option value="1" selected><cf_tl id="Terminate other current assignments for this employee."></option>
					<option value="2" selected><cf_tl id="Terminate any conflicting assignments."></option>
					<option value="9" selected><cf_tl id="Reject if any active assignment exists."></option>
				    </select>
				</TD>
				</TR>
						
				</cfif>
																								
			   <cfif (getAssignment.AssignmentStatus neq "1" and Mandate.MandateStatus eq "1" and checkaction.actionstatus eq "0")
			     OR AccessStaffing eq "NONE" OR AccessStaffing eq "READ">
			  
			    <!--- do not allow to be posted in case of unapproved assignment status --->
				 
				  <cfoutput>
				  <tr>
				      <td align="center" colspan="2" height="26">
					    <table class="formspacing">
						  <tr>
						   <td>
						    <cf_tl id="Close" var="1">
							<input class="button10g" style="width:120px;height:26" type="reset"  name="Reset" value="#lt_text#" onclick="window.close()">	
						   </td>
						   <cfif getAdministrator(Mandate.Mission) eq "1" or (wfstarted eq "no" and AccessStaffing eq "EDIT" OR AccessStaffing eq "ALL")>	
							   <cf_tl id="Delete" var="1">
						   	   <td id="deleteme">
							   <input class="button10g" style="width:120px;height:26" type="reset"  name="Delete" value="#lt_text#" onclick="if (confirm('#lt_text# ?')) {ptoken.navigate('deleteAssignmentAction.cfm?assigmentNo=#getAssignment.AssignmentNo#','deleteme')}">
							   </td>
						   </cfif>	
						</table>	
					  </td>
				  </tr>
				  </cfoutput>
				  
			 <cfelseif (getAssignment.AssignmentStatus eq "0" and checkaction.actionstatus eq "0")
			     AND (AccessStaffing eq "EDIT" OR AccessStaffing eq "ALL")>  
				
				 		<td valign="top">
				 		    <cf_tl id="Save" var="1">
						    <input class="button10g" type="submit" style="width:120px;height:26" name="Submit" value="<cfoutput>#lt_text#</cfoutput>">
						</td>				 
			                
			   <cfelse>          
			   	  
						  	   
				  <tr>
				  
				      <td valign="top" colspan="2" class="labelmedium2" height="34">
					  
					  <table class="formspacing">
					  <tr>
					   
					  <cfif URL.Source eq "Change">	
					  
					      <td valign="top">
					      <cf_tl id="Back" var="1">
					      <input type="button" value="<cfoutput>#lt_text#</cfoutput>" class="button10g" style="width:120px;height:26" onClick="history.back()">
						  </td>
						  
					  <cfelse>			 
					 			
						 <td valign="top">		   
					     <cf_tl id="Close" var="1">
					     <input class="button10g" style="width:130px;height:26" 
						     type="button" 
							 name="Close" 
							 value="<cfoutput>#lt_text#</cfoutput>" 
							 onclick="window.close()">				   	
						  </td>	 
						 
					  </cfif> 
					 		 
					  <cfif URL.Source eq "TFR">	
					  
					  	<td valign="top">			  	  
							<cf_tl id="Back" var="1">
						    <input type="button" name="cancel" 
							   style="width:130px;height:26" 
							   value="<cfoutput>#lt_text#</cfoutput>" 
							   class="button10g" 
							   onClick="history.back()">
						</td>
						<td valign="top">
							<cf_tl id="Submit" var="1">
						  	<input class="button10g" type="submit" style="width:130px;height:26" name="Submit" value="<cfoutput>#lt_text#</cfoutput>">		
						</td>
						
					  <cfelse>				  
					  
					    <cfif (Mandate.MandateStatus eq "0" and AccessStaffing eq "EDIT") or AccessStaffing eq "ALL">
					  		  <cf_tl id="Delete" var="1">	
							 						
							  <cfoutput>								   		  
							  <td valign="top">						 			  
							  <input name="Delete" type="submit" onclick="return ask('#lt_text#')" style="width:120px;height:26" value="<cfoutput>#lt_text#</cfoutput>" class="button10g">
							  </td>
							  </cfoutput>
							  
						</cfif>			
						
						<cfif Mandate.MandateStatus eq "0">
						
							<td valign="top">
				 		    <cf_tl id="Save" var="1">
						    <input class="button10g" type="submit" style="width:120px;height:26" name="Submit" value="<cfoutput>#lt_text#</cfoutput>">
							</td>
							
						<cfelse>		
							
							<td valign="top" id="action" class="labelmedium2">
			 			    <cf_tl id="Validate" var="1">
					  	    <input class="button10g" type="button" style="width:120px;height:26" name="Submit" onclick="preview()" value="<cfoutput>#lt_text#</cfoutput>">	
							</td>
									
						</cfif> 			
						
					  </cfif>	
					  			  
					  </tr>
					  </table>
					         
				      </td>
				  </tr>
			    
			   </cfif>  
			     
			   </table>			 
			   </td></tr>
						   
			</table>  
			
			</CFFORM> 	
		
		</td></tr>
		
		</table> 

</cf_divscroll>

