<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Hanno van Pelt</proOwn>
	<proDes>ST version 1</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cf_textareascript>
<cf_dialogPosition>
<cf_dialogOrganization>
<cf_calendarScript>

<cfparam name="URL.Box"         default="">
<cfparam name="URL.Action"      default="Edit">
<cfparam name="URL.ActionText"  default="Edit position">
<cfparam name="URL.Mode"        default="Read">
<cfparam name="URL.ID"          default="">
<cfparam name="URL.ID1"         default="">
<cfparam name="URL.ID2"         default="">

<cfparam name="URL.Mode" default="Lookup">
<cfparam name="URL.occ" default="">		
<cfparam name="url.edition" default="">

<!--- Added the following lines as position loan was not able to be saved August 8th 2008--->

<cfif URL.Action eq "Loan" or URL.Action eq "Owner">
	<cfset URL.mode = "Write">
</cfif>


<!--- 15/7/2013 Hanno correct for strange situation
   provision to correct the missionoperational --->

<cfquery name="resetPosition" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE Position
	SET    MissionOperational = (SELECT Mission 
	                             FROM   Organization.dbo.Organization 
								 WHERE  OrgUnit = P.OrgUnitOperational)
	FROM   Position P
	WHERE  PositionNo = '#URL.ID2#' 
</cfquery>

<cfquery name="Position" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Position
	WHERE  PositionNo = '#URL.ID2#' 
</cfquery>

<cfoutput>

<script>

  function AddVacancy(postno,box) {
			ProsisUI.createWindow('mydialog', 'Record Recruitment Track', '',{x:100,y:100,height:document.body.clientHeight-60,width:900,modal:true,center:true});	
			ptoken.navigate('#SESSION.root#/Vactrack/Application/Document/DocumentEntryPosition.cfm?box='+box+'&portal=1&Mission=#Position.Mission#&ID1=' + postno + '&Caller=Listing','mydialog');	
		}

function owner(act,text) {
   ptoken.location('PositionEdit.cfm?box=#url.box#&Action='+act+'&ActionText='+text+'&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#')
}

function admblank() {
	document.positionedit.orgunit1.value 		= ""
	document.positionedit.mission1.value 		= ""
	document.positionedit.orgunitname1.value 	= ""
	document.positionedit.orgunitclass1.value 	= ""
}


function funblank() {
	document.positionedit.orgunit2.value 		= ""
	document.positionedit.mission2.value 		= ""
	document.positionedit.orgunitname2.value 	= ""
	document.positionedit.orgunitclass2.value 	= ""
}

function ask() {
	if (confirm("Do you want to delete this position ?")) {	
	return true 	
	}	
	return false	
}	

function applyunit(org) {    
	ptoken.navigate('#SESSION.root#/Staffing/Application/Position/Position/setUnit.cfm?orgunit='+org,'process')
}

function Selected(no,description) {									
	  document.getElementById('functionno').value = no
	  document.getElementById('functiondescription').value = description					 
	  ProsisUI.closeWindow('myfunction')
 }		
		
</script>

</cfoutput>

<cfajaximport tags="cfform">

<!--- feature to clean positions that are obviosuly wrong --->
<cfquery name="qCandidates" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT P.*
	FROM Position P 
	WHERE  P.DateEffective > P.DateExpiration
	AND    P.PositionNo NOT IN (SELECT PositionNo 
	                          FROM   PersonAssignment)
</cfquery>

<cftransaction>
<cfloop query="qCandidates">

	<cfquery name="qCheck" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT *
		FROM PersonEvent
		WHERE  PositionNo = '#qCandidates.PositionNo#'
	</cfquery>						  


	<cfif qCheck.recordcount eq 0>
		<!---remove the position--->
		<cfquery name="Clean" 
		    datasource="AppsEmployee" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    DELETE FROM Position
			WHERE  PositionNo = '#qCandidates.PositionNo#'
		</cfquery>	
	
	<cfelse>
		<!--- We will try to relink ---->
		<cfquery name="qRelink" 
		    datasource="AppsEmployee" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT     *
			FROM  Position
			WHERE     
			PositionParentId = '#qCandidates.PositionParentId#'
			AND '#qCheck.DateEvent#' BETWEEN DateEffective AND DateExpiration
			AND PositionNo != '#qCandidates.PositionNo#' 
		</cfquery>
		
		<cfif qRelink.recordcount eq 0>
			<!---- nothing we can do --->
			
		<cfelse>
			<!---- we need to relink ---->
			<cfquery name="qUpdate" 
			    datasource="AppsEmployee" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				UPDATE PersonEvent
				SET PositionNo = '#qRelink.PositionNo#'
				WHERE     
				PositionNo = '#qCandidates.PositionNo#'
			</cfquery>

					
			<!---- Now we remove --->
			<cfquery name="Clean" 
			    datasource="AppsEmployee" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    DELETE FROM Position
				WHERE  PositionNo = '#qCandidates.PositionNo#'
			</cfquery>				
		</cfif>
	</cfif>

</cfloop>
</cftransaction>

<cfif Position.Recordcount eq "0">

	<!--- position had migrated to a different instance --->
	
	<cfquery name="Position" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Position
		  WHERE  SourcePositionNo  = '#URL.ID2#'	 			 
	</cfquery>	
	
	<cfset url.id2 = Position.PositionNo>
  
</cfif>

<cfif Position.Recordcount eq "0">

  <cf_message message="Problem, request can not be completed. Try again or contact your administrator">
  <cfabort>
  
</cfif>

<cfquery name="LaterInstance" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Position
	  WHERE  PositionParentId  = '#Position.PositionParentID#'
	  AND    DateEffective > '#Position.DateExpiration#'				 
</cfquery>		

<cfquery name="PriorInstance" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     Position
	  WHERE    PositionParentId  = '#Position.PositionParentID#'
	  AND      DateExpiration < '#Position.DateExpiration#'				
	  ORDER BY DateExpiration DESC 
</cfquery>		


<cfif url.id eq "">
   <cfset url.id  = Position.Mission>
   <cfset url.id1 = Position.MandateNo>
</cfif>

<cfquery name="ParamMission" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_ParameterMission
	WHERE Mission = '#URL.ID#'
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
    FROM  Ref_Mandate
	WHERE Mission   = '#URL.ID#' 
	AND   MandateNo = '#URL.ID1#'
</cfquery>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Mission
	WHERE  1=1  <!--- MissionOwner = '#CurrentMission.MissionOwner#' : disabled by Hanno to allow DPA - DPKO cross loan, maybe not good for validation but lets do it now  --->
	AND    Mission IN (SELECT Mission 
	                   FROM   Ref_MissionModule 
				   	   WHERE  SystemModule = 'Staffing'
					   AND    Operational = 1)
</cfquery>

<cfquery name="PositionParent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT P.*, OrgUnit, OrgUnitName
    FROM   PositionParent P, Organization.dbo.Organization O
	WHERE  P.PositionParentid = '#Position.PositionParentid#'
	AND    P.OrgUnitOperational = O.OrgUnit
	AND	   P.MandateNo = '#Mandate.MandateNo#' 
</cfquery>

<cfif PositionParent.recordcount eq "0">

	<cfquery name="UpdateParent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE PositionParent
		SET    OrgUnitOperational = '#Position.OrgUnitOperational#'
		WHERE  PositionParentid   = '#Position.PositionParentid#'
	</cfquery>
	
	<cfquery name="PositionParent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT P.*, OrgUnit, OrgUnitName
	    FROM   PositionParent P, Organization.dbo.Organization O
		WHERE  P.PositionParentid   = '#Position.PositionParentid#'
		AND    P.OrgUnitOperational = O.OrgUnit
	</cfquery>

</cfif>

<cfquery name="LastAssignment" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT MAX(DateExpiration) as DateExpiration 
	FROM   PersonAssignment
	WHERE  PositionNo = '#URL.ID2#'
	AND    AssignmentStatus IN ('0','1')
</cfquery>

<cfquery name="Organization" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
     SELECT *
     FROM Organization
	 WHERE OrgUnit = '#Position.OrgUnitOperational#' 
</cfquery>

<cfif Organization.recordcount neq "1">

  <cf_message message="Problem, organization can not be found. Please contact your administrator">
  <cfabort>
  
</cfif>

<cfinvoke component="Service.Access"  
  method         = "position" 
  orgunit        = "#Position.OrgUnitOperational#" 
  role           = "'HRPosition'"
  posttype       = "#Position.PostType#"
  returnvariable = "accessPosition">
 
<cfinvoke component="Service.Access"  
  method         = "position" 
  orgunit        = "#Position.OrgUnitOperational#" 
  role           = "'HRInquiry'"
  posttype       = "#Position.PostType#"
  returnvariable = "accessInquiry">  
   
<cfinvoke component="Service.Access"  
  method         = "position" 
  orgunit        = "#Position.OrgUnitOperational#" 
  role           = "'HRLoaner'"
  posttype       = "#Position.PostType#"
  returnvariable = "accessLoaner">
    
<cfinvoke component="Service.Access"  
  method         = "position" 
  orgunit        = "#Position.OrgUnitOperational#" 
  role           = "'HRLocator'"
  posttype       = "#Position.PostType#"
  returnvariable = "accessLocator">  
  
<cfinvoke component="Service.Access"  
  method         = "staffing" 
  orgunit        = "#Position.OrgUnitOperational#" 
  posttype       = "#Position.PostType#"
  returnvariable = "accessStaffing">

	  
<cfif 	(AccessPosition eq "NONE") and 
		(AccessInquiry  eq "NONE") and
		(AccessStaffing eq "NONE") and 
		(AccessLoaner   eq "NONE") and
		(AccessLocator  eq "NONE")>	  	  
	
		<cf_message message = "You are not authorised to view Post type <cfoutput>#Position.PostType#</cfoutput>. Please contact your administrator.">
		<cfabort>
	
</cfif>

<cfif url.mode eq "read">
    
	<cfset AccessPosition = "READ">
	<cfset AccessLoaner   = "READ">		
	<cfset AccessStaffing = "READ">
	<cfset AccessLocator  = "READ">
	<cfset AccessInquiry  = "READ">
		
</cfif>	

<cfquery name="Location" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Location
	WHERE  Mission      = '#URL.ID#'
	AND    LocationCode = '#Position.LocationCode#'
</cfquery>

<cfif getAdministrator(url.id) eq "1">
	
		<cfquery name="Postgrade" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     DISTINCT P.PostType,PostGrade, PostOrder
			FROM       Ref_PostGrade G INNER JOIN
		               Ref_PostGradeParent GP ON G.PostGradeParent = GP.Code INNER JOIN
		               Ref_PostType P ON GP.PostType = P.PostType 
			ORDER BY   P.PostType,PostGrade,PostOrder		   
		</cfquery>
	
<cfelse>	
		
		<cfquery name="Postgrade" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     DISTINCT P.PostType,PostGrade, PostOrder
			FROM       Ref_PostGrade G INNER JOIN
		               Ref_PostGradeParent GP ON G.PostGradeParent = GP.Code INNER JOIN
		               Ref_PostType P ON GP.PostType = P.PostType INNER JOIN
		               Organization.dbo.OrganizationAuthorization A ON P.PostType = A.ClassParameter
			WHERE 	   A.Role IN ('HRPosition','HROfficer','HRAssistant','HRLoaner','HRLocator','HRInquiry') 
			AND        A.AccessLevel IN ('0','1','2')
			AND        A.Mission IN  ('#URL.ID#','#Position.MissionOperational#')
			AND        A.UserAccount = '#SESSION.acc#'	
			ORDER BY   P.PostType,PostOrder
		</cfquery>
	
</cfif>

<cfif PostGrade.recordcount eq "0">
	
  <cf_message message = "You are not authorised for any posttype. Please contact your administrator.">
  <cfabort>
	
</cfif>

<cfquery name="VacancyClass" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_VacancyActionClass
	WHERE    Operational = 1 
	         OR Code = '#Position.VacancyActionClass#'
	ORDER BY ListingOrder
</cfquery>

<cfquery name="FundTable" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Fund
</cfquery>

<cfquery name="Postclass" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_Postclass
	WHERE    PostClass IN (SELECT PostClass 
	                  FROM   Ref_PostClassMission 
					  WHERE  Mission = '#url.id#')
	ORDER BY ListingOrder
</cfquery>

<cfif PostClass.recordcount eq "0">
	
	<cfquery name="Postclass" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Ref_Postclass
		WHERE    (Operational = 1 OR PostClass = '#Position.PostClass#')	
		ORDER BY ListingOrder
	</cfquery>

<cfelse>
	
	<cfquery name="Postclass" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Ref_PostClass
		WHERE    (PostClass IN (SELECT PostClass FROM Ref_PostClassMission WHERE Mission = '#url.id#') AND Operational = 1)
				 OR PostClass = '#Position.PostClass#'	<!--- existing selection --->   
		ORDER BY ListingOrder
	</cfquery>


</cfif>

<cf_screentop scroll="yes" title="Position Edit" html="No" ValidateSession="no" jquery="yes">

<cfform action="PositionEditSubmit.cfm?id=#url.id#&id1=#url.id1#&id2=#url.id2#&Box=#URL.Box#" 
		   method="POST" 
		   style="height:98%"
		   target="saveposition"
		   name="positionedit">
		      
<table width="96%" align="center" style="height:100%">

  <tr class="hide"><td id="process" height="5"></td></tr>
  <tr class="hide"><td height="60" colspan="2"><iframe name="saveposition" id="saveposition" width="100%" frameborder="0"></iframe></td></tr>

  <cfoutput>
    	       
  <input type="hidden" name="missionselect"    id="missionselect"    value="#Position.Mission#">	
  <input type="hidden" name="PositionNo"       id="PositionNo"       value="#URL.ID2#">	
  <input type="hidden" name="PositionParentId" id="PositionParentId" value="#Position.PositionParentId#">	
  <input type="hidden" name="mission"          id="mission"          value="#Position.Mission#">	
  <input type="hidden" name="missionParent"    id="missionParent"    value="#PositionParent.Mission#">
  <input type="hidden" name="mandateno"        id="mandateno"        value="#Position.MandateNo#">
  <input type="hidden" name="action"           id="action"           value="#URL.Action#">
  
  </cfoutput>
	  
  <cfset c = "ffffff">
  
  <tr>
    <td width="100%" colspan="2" style="height:100%">
	
	<cf_divscroll>
	
	<cfoutput>
	
    <table width="99%" class="formpadding" align="center">
		   
	<cfif PositionParent.DateEffective neq Mandate.DateEffective or 
	      PositionParent.DateExpiration neq Mandate.DateExpiration>
	
		<tr bgcolor="#c#" class="line">
		   <td style="padding-left:6px;background-color:ffffcf;border-bottom:1px solid silver;" style="padding-left:6px" class="labelmedium2">#Mandate.Mission#<cf_tl id="Staffing Period">:</td>
		   <td style="padding-left:10px" class="labelmedium2">#DateFormat(Mandate.DateEffective,CLIENT.DateFormatShow)#&nbsp;-</font>&nbsp;#DateFormat(Mandate.DateExpiration,CLIENT.DateFormatShow)#</b></td>
		</tr>	
	
	</cfif>	   
					
	<tr bgcolor="#c#" class="line">
	   <td class="labelmedium2 fixlength" style="height:30px;background-color:ffffcf;min-width:299px;padding-left:6px"><cf_tl id="Owner">|<cf_tl id="Budget Title">|<cf_tl id="Grade">|<cf_tl id="Period"></td>
	   <td class="labelmedium2" style="padding-left:10px">	
	   
	   <table style="width:100%;height:100%">
	   <tr class="labelmedium2"><td class="fixlength">   
		      #PositionParent.OrgUnitName# | #PositionParent.FunctionDescription# | #PositionParent.PostGrade# | #DateFormat(PositionParent.DateEffective,CLIENT.DateFormatShow)#&nbsp;-</font>&nbsp;#DateFormat(PositionParent.DateExpiration,CLIENT.DateFormatShow)#</b>
	   &nbsp;
	   <cfif Position.PositionStatus eq "1">
	   <img src="#SESSION.root#/Images/check_mark.gif" align="absmiddle" alt="" border="0">
	   <font color="008080"><cf_tl id="Locked"> <cfelse>
	   <font color="0080FF">[<cf_tl id="Staffing period Pending clearance">]</font>
	   </cfif>		
	   </td>
	   
	   	   
	   <cfquery name="LaterPosition" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Position
			 WHERE  PositionNo      != '#URL.ID2#'
			 AND    PositionParentId = '#Position.PositionParentid#'
			 AND    DateEffective  > '#DateFormat(Position.DateExpiration,client.dateSQL)#'
		</cfquery>	
	   
	    
	   	   
	   </tr>
	   </table>		
	   </td>
	</tr>
		
	
	<cfif url.action neq "view">
	
	  <cfif URL.Action eq "Edit">		
	  
	  <cfelse>	

	  <tr> 
	    <td colspan="2" class="labelit" style="padding-left:5px;height:35px;font-size:23px;font-weight:200;">		  
		  
			   <font color="red">
				<cf_tl id="#URL.ActionText#">	
				
	    </td>	
	  </tr>
	  
	  </cfif>
	  
	</cfif>
	
	<cfif URL.Action eq "Edit">
		     
		 <cfif LaterPosition.recordcount eq "0">
	
		<tr bgcolor="#c#">
		   <td style="height:30px;padding-left:6px;background-color:f1f1f1;border-bottom:1px solid silver;" class="labelmedium2"><cf_tl id="Loan status">:</td>
		   
		   <td class="labelmedium2" style="height:25;padding-left:10px">
		   
		   <cfif Position.PositionStatus eq "0">
		   
		      <font color="red"><cf_tl id="Not applicable">: Position/mandate is not locked, loan not allowed.</font>
		      
			  <!--- loan not relevant at this point --->
		   
		   <cfelse>
		   			   
			    <cfif PositionParent.OrgUnitOperational neq Position.OrgUnitOperational or
			       PositionParent.FunctionNo neq Position.FunctionNo>
				   
				   <table>
				   
				   	<tr><td class="labelmedium2">
									   				   
				    	<b><cf_tl id="Loaned to">:</b> <cfif PositionParent.Mission neq Organization.Mission><u>#Organization.Mission#</u> -</cfif> #Organization.OrgUnitName#
					
						</td>
				   	   
					    <cfif URL.Action neq "Owner" and 
						    (AccessLoaner eq "EDIT" or AccessLoaner eq "ALL" 
							  or AccessPosition eq "EDIT" or AccessPosition eq "ALL")>
							  
						    <cfif LastAssignment.DateExpiration lt PositionParent.DateExpiration>
																					
							  <cfif LaterPosition.recordcount eq "0"> 
	 						    <cf_tl id="Return to Owner" var="1">
								
								<td style="padding-left:10px">
								  
							  	    <input type="button" style="width:160px;height:23px" class="button10g" value="<cfoutput>#lt_text#</cfoutput>" onclick="owner('Owner','Return to owner')">								
															
								</td>
								
							  
							  </cfif>	
							  
							<cfelse>									
							
							    <cfif LaterPosition.recordcount eq "0"> 
								
									<cf_tl id="Return Owner" var="1">
									
									<td style="padding-left:10px">
									
									 <input type="button" style="width:160px;height:23px" class="button10g" value="<cfoutput>#lt_text#</cfoutput>" onclick="owner('Owner','Return to owner')">								
															
									</td>							    
								
							    </cfif>	
								
								<td class="labelmedium2"><cf_tl id="Position incumbered until"><b>#DateFormat(PositionParent.DateExpiration, CLIENT.DateFormatShow)#</b></td>
								
							</cfif>
						</cfif>
						
						</tr>
						
						</table>
				
			   <cfelse>
			   
				   <cfif URL.Action neq "Loan" and ((AccessLoaner eq "EDIT" or AccessLoaner eq "ALL") OR (AccessPosition eq "ALL"))>
				   
				   	<!---- LastAssignment.DateExpiration neq "" added by JA on August 7th 2012 --->
					
				   	    <cfif LastAssignment.DateExpiration lt PositionParent.DateExpiration AND LastAssignment.DateExpiration neq "">
						   
							<cfif LaterPosition.recordcount eq "0">
							
								<cf_tl id="Loan this position" var="1">
								
								<a style="font-size:16px" href="javascript:owner('loan','Loan this Position')">#lt_text#</a>
															   
							<cfelse>
							    
							</cfif>
							
						<cfelse>
						
						    <cfif LaterPosition.recordcount eq "0">							
								<cf_tl id="Loan position" var="1">
							    <input type="button" style="height:23px" class="button10g" value="<cfoutput>#lt_text#</cfoutput>" onclick="owner('loan','Loan position')">								
							</cfif>							
							&nbsp;<cf_tl id="This position incumbered until">							
							<b>#DateFormat(PositionParent.DateExpiration, CLIENT.DateFormatShow)#</b>														
						</cfif>
					</cfif>
			   
			   </cfif>
			   
			   </cfif>			
		   	
		   </td>
		</tr>
		
		 </cfif>
	
	</cfif>
	
	</cfoutput>
					
	<cfif URL.Action eq "Edit">
	
	      <cfset eff = "#Position.DateEffective#">
	      <cfset exp = "#Position.DateExpiration#">
		
	<cfelse>
	
	    <cfif LastAssignment.DateExpiration neq "">
		
		    <cfif URL.Action eq "Owner" and now() lte PositionParent.DateExpiration>
			    <cfset eff = "#now()#">
			<cfelseif URL.Action eq "Loan" and LastAssignment.DateExpiration lt PositionParent.DateExpiration>
				<cfset eff = "#LastAssignment.DateExpiration+1#">					
			<cfelseif URL.Action eq "Loan" and PositionParent.DateExpiration gte now() and PositionParent.DateEffective lte now()>			
				<cfif PriorInstance.DateExpiration neq "">
					<cfset eff = "#PriorInstance.DateExpiration+1#">				
				<cfelse>
					 <cfset eff = "#Position.DateEffective#">
				</cfif>			
			<cfelse>
			    <cfset eff = "#Position.DateEffective#">
			</cfif>	
			
		<cfelse>
		
	       <tr class="line"><td colspan="2" class="labelit" style="padding-left:2px;height:29px;font-size:17px;border-top:0px solid silver;border-bottom:1px solid silver"><font color="black"><cf_tl id="Usage"></td></tr>	
		
			<cfset eff = "#Position.DateEffective#">
			
		</cfif>
		
	    <cfset exp = "#PositionParent.DateExpiration#">
		
	</cfif>
	
	<cfif Position.PositionStatus eq "0">
	
		<!--- for post manager --->
		
		<TR bgcolor="ffffff">
	    <TD class="labelmedium2" height="18" style="background-color:f1f1f1;border-bottom:1px solid silver;padding-left:6px"><cf_tl id="Effective period">:</TD>
	    <TD style="padding-left:10px">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td style="height:25;padding-left:2px" class="labelmedium2">	
				
			<cfif (Position.PositionStatus eq "0" 
			     AND (AccessPosition eq "EDIT" OR AccessPosition eq "ALL"))>
								 
					<cf_intelliCalendarDate9
					    class="regularxxl"
						FieldName="dateeffective" 
						DateValidStart="#Dateformat(PositionParent.DateEffective, 'YYYYMMDD')#"
						DateValidEnd="#Dateformat(PositionParent.DateExpiration, 'YYYYMMDD')#"
						Manual="false"
						Default="#Dateformat(eff, CLIENT.DateFormatShow)#"
						AllowBlank="false">	
												
			<cfelse>
						
				<cfoutput>
					#DateFormat(Position.DateEffective,CLIENT.DateFormatShow)#&nbsp;
					<input type="hidden" name="dateeffective" value="#Dateformat(eff, CLIENT.DateFormatShow)#">
				</cfoutput>
				
			</cfif>
			
			<cfoutput>
				<input type="hidden" name="DateEffectiveOld" value="#Dateformat(eff, CLIENT.DateFormatShow)#">
		    </cfoutput>
		</td>
		
		<td height="18" style="padding-left:6px">-</td>
		
		<td class="labelmedium2" style="padding-left:6px" class="labelmedium2">
													
			<cfif (Position.PositionStatus eq "0" AND (AccessPosition eq "EDIT" OR AccessPosition eq "ALL"))>
																	
				<cf_intelliCalendarDate9
					FieldName="DateExpiration" 
					class="regularxxl"
					Default="#Dateformat(exp, CLIENT.DateFormatShow)#"
					DateValidStart="#Dateformat(PositionParent.DateEffective, 'YYYYMMDD')#"
					DateValidEnd="#Dateformat(PositionParent.DateExpiration, 'YYYYMMDD')#"
					Manual="true"
					AllowBlank="false">	
									
			<cfelse>
					
				<cfoutput>#DateFormat(Position.DateExpiration,CLIENT.DateFormatShow)#</b>
				<input type="hidden" name="DateExpiration" value="#Dateformat(Position.DateExpiration, CLIENT.DateFormatShow)#">
				</cfoutput>
			
			</cfif>			
		
		<cfoutput>
		<input type="hidden" name="DateExpirationOld" value="#Dateformat(Position.DateExpiration, CLIENT.DateFormatShow)#">
	    </cfoutput>
		</td>
				
		<cfif PositionParent.DateEffective gt Position.DateEffective or PositionParent.DateExpiration lt Position.DateExpiration>
		  
		  <td class="labelmedium2" style="padding-left:8px"><font color="FF0000">Effective period does not lie within the budget position #dateformat(PositionParent.DateEffective,client.dateformatshow)# - #dateformat(PositionParent.DateExpiration,client.dateformatshow)#</font></td>
		
		</cfif>
		
		</table>
		
		</TD>
		</TR>
	
	<cfelse>
		   		
		<!--- for loaner manager --->
				
		<cfquery name="EarlierPosition" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Position
			 WHERE  PositionNo       != '#URL.ID2#'
			 AND    PositionParentId  = '#Position.PositionParentid#' 
			 AND    DateEffective     <  #dateformat(eff,client.dateformatshow)#
		</cfquery>
	
		<TR bgcolor="ffffff">
	    <TD class="labelmedium2" height="18" style="background-color:f1f1f1;border-bottom:1px solid silver;padding-left:6px"><cf_tl id="Effective">:</TD>
	    <TD style="padding-left:10px">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td class="labelmedium2">	
								  								
			<cfif URL.Action eq "Loan"  or 
			      URL.Action eq "Owner" or 
				  (PositionParent.DateEffective lte eff and EarlierPosition.recordcount eq "0" AND AccessPosition eq "EDIT" or AccessPosition eq "ALL")>				  
				
				<table>
				<tr class="labelmedium2">
				<td>	
												
					<cf_intelliCalendarDate9
						FieldName      = "dateeffective" 
						class          = "regularxxl"
						DateValidStart = "#Dateformat(Position.DateEffective, 'YYYYMMDD')#"
						DateValidEnd   = "#Dateformat(PositionParent.DateExpiration, 'YYYYMMDD')#"
						Default        = "#Dateformat(eff, CLIENT.DateFormatShow)#">	
						
						</td>
						
						<cfif PositionParent.DateEffective lte eff and EarlierPosition.recordcount eq "0">
						
							<cfif url.action neq "loan" and url.action neq "owner">
	                             <td style="padding-left:5px">
	                             <input type="checkbox" name="forceamend" value="1" checked>
	                             </td>
	                             <td style="padding-left:4px"><cf_UItooltip tooltip="Use this option to amend both position AND parent position"><cf_tl id="Amend"></cf_UItooltip></td>
		                    <cfelse>															                              
	                              <input class="hide" type="checkbox" name="forceamend" value="0">	                            
		                    </cfif>
							
						<cfelse>
												
						<input class="hide" type="checkbox" name="forceamend" value="0">	
						
						</cfif>					
					
				</tr>
				</table>	
									
			<cfelse>
			
			
				<cfoutput>
				<input class="hide" type="checkbox" name="forceamend" value="0">
				#DateFormat(Position.DateEffective,CLIENT.DateFormatShow)#
				<input type="hidden" name="dateeffective" value="#Dateformat(eff, CLIENT.DateFormatShow)#">
				</cfoutput>
				
			</cfif>
					
		<cfoutput>
		<input type="hidden" name="DateEffectiveOld" value="#Dateformat(Position.DateEffective, CLIENT.DateFormatShow)#">
	    </cfoutput>
		</td>		
		<td style="padding-left:6px">-</td>
		<td style="padding-left:6px" class="labelmedium2">
			
		
			<cfif (AccessPosition eq "ALL" or url.action eq "Loan") and url.Action neq "Owner">
																		
				<cf_intelliCalendarDate9
					FieldName="DateExpiration"
					class="regularxxl"
					DateValidStart="#Dateformat(Mandate.DateEffective, 'YYYYMMDD')#"
					DateValidEnd="#Dateformat(Mandate.DateExpiration, 'YYYYMMDD')#" 
					Default="#Dateformat(exp, CLIENT.DateFormatShow)#">	
										
			<cfelse>
			
				<cfoutput>	
				#DateFormat(Position.DateExpiration,CLIENT.DateFormatShow)#
				<input type="hidden" name="DateExpiration" value="#Dateformat(Position.DateExpiration, CLIENT.DateFormatShow)#">
				</cfoutput>
				
			</cfif>		
		</td>	
			
		<cfoutput>
		
			<input type="hidden" name="DateExpirationOld" value="#Dateformat(Position.DateExpiration, CLIENT.DateFormatShow)#">
	    		
			<cfif PositionParent.DateEffective gt Position.DateEffective or 
		      PositionParent.DateExpiration lt Position.DateExpiration>
			  
			  	<td class="labelmedium2" style="padding-left:10px"><font color="FF0000">ALERT: Effective period does not lie within the Budget Position period  #dateformat(PositionParent.DateEffective,client.dateformatshow)# - #dateformat(PositionParent.DateExpiration,client.dateformatshow)#</font></td>
			
			</cfif>
		
		</cfoutput>
		
		</tr>
		
		</table>
	
	</TD>
	</TR>
		
	</cfif>
	
	<!--- for post manager, post loaner only status = 1 --->
	
	<!--- TREE BORROWING --->
	
	<cfif URL.Action eq "Loan">
	
	        <!--- change in owner mode if allowed --->
			
			<TR>
		    <TD class="labelmedium2" style="padding-left:6px;background-color:f1f1f1;border-bottom:1px solid silver;"><cf_tl id="Loan to other entity">:</TD>
			
			<TD style="padding-left:10px">
			
			    <script language="JavaScript">
				function positionreset() {
					se = document.getElementById("orgunitname")
					se.value = ""
					se = document.getElementById("orgunit")
					se.value = ""
					se = document.getElementById("locationcode")
					se.value = ""
					se = document.getElementById("locationname")
					se.value = ""
				}
				
				</script>
		
			   	<select name="missionoperational" id="missionoperational" class="regularxxl" size="1" onChange="positionreset()">
			    	<cfoutput query="Mission">
					<option value="#Mission#" <cfif Position.MissionOperational eq Mission>selected</cfif>>
			    		#Mission#
					</option>
					</cfoutput>
					
			    </select>
			
			</td>
			</TR>	
				
	<cfelseif URL.Action eq "Edit">	
	
	    <!--- do not allow change in edit mode --->
		<input type="hidden" name="missionoperational" id="missionoperational" value="<cfoutput>#Position.MissionOperational#</cfoutput>" size="20" maxlength="20" readonly class="disabled">	
			
	<cfelse>
	
		
	    <!-- return to owner --->
		<input type="hidden" name="missionoperational" id="missionoperational" value="<cfoutput>#Position.Mission#</cfoutput>" size="20" maxlength="20" readonly class="disabled">	
	
	</cfif>	
		
	<!--- TREE ORGUNIT --->	
				
	<TR bgcolor="ffffff">
    <TD class="labelmedium2" style="background-color:f1f1f1;border-bottom:1px solid silver;height:30;padding-left:6px"><cf_tl id="Organization">:<font color="FF0000">*</font></TD>
		
    <TD  style="padding-left:10px" class="labelmedium2">
	
	<cfif URL.Action neq "Owner">
	
	    <!--- edit mode / loan mode only if access ---> 
	
		<cfquery name="Organization" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	        SELECT *
	        FROM   Organization
			WHERE  OrgUnit = '#Position.OrgUnitOperational#'
	    </cfquery>
		
		<cfif (Position.PositionStatus eq "0" AND (AccessPosition eq "EDIT" or AccessPosition eq "ALL")) 
		      OR (URL.Action eq "Loan")>
			
			<table>
			<tr><td>
				<input type="text" name="orgunitname" id="orgunitname" value="<cfoutput>#Organization.OrgUnitName#</cfoutput>" class="regularxxl" size="60" maxlength="60" readonly>
			</td>
			<td style="padding-left:2px">		
				<input type="button" name="btnFunction" value="..." style="width:30px;height:25" 
				onClick="selectorgmisn(document.getElementById('missionoperational').value,'',document.getElementById('dateeffective').value)"/> 
			</td>
			</tr>
			</table>			
			
		<cfelse>
		
			<cfoutput>#Organization.OrgUnitName#</cfoutput>
			
		</cfif>
			
	<cfelse>
	
	    <!--- return to owner --->
	
		<cfquery name="Organization" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	        SELECT *
	        FROM Organization
			WHERE OrgUnit = '#PositionParent.OrgUnitOperational#'
	    </cfquery>
		
		<cfoutput>#Organization.OrgUnitName#</cfoutput>
	
	</cfif>
	
	<input type="hidden" name="orgunit"      id="orgunit" value="<cfoutput>#Organization.OrgUnit#</cfoutput>">
	<input type="hidden" name="orgunitcode"  id="orgunitcode" value="<cfoutput>#Organization.orgunitCode#</cfoutput>"> 
	<input type="hidden" name="orgunitclass" id="orgunitclass" value="<cfoutput>#Organization.OrgUnitClass#</cfoutput>"> 
		
	</TD>
	</TR>	
	
	<TR bgcolor="ffffff">
    <TD width="160" height="19" style="padding-left:6px;background-color:f1f1f1;border-bottom:1px solid silver;">			
	    <cf_helpfile SystemModule = "Staffing" Class = "Position" HelpId = "admorg" LabelId = "Administrative Organization">			 			
	</TD>
	
	<!--- only for post manager --->
	
	<cfquery name="Organization" 
     datasource="AppsOrganization" 
   	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
   	    SELECT *
        FROM Organization
		<cfif URL.Action neq "Owner">
		WHERE OrgUnit = '#Position.OrgUnitAdministrative#'
		<cfelse>
		WHERE OrgUnit = '#PositionParent.OrgUnitAdministrative#'
		</cfif>
    </cfquery>
	
	<cfif AccessPosition eq "EDIT" OR AccessPosition eq "ALL">
	
		<TD class="labelmedium2" style="padding-left:10px">
			<table>
				<tr>
				<td>
			    <input type="text" id="mission1"     name="mission1"       value="<cfoutput>#Organization.Mission#</cfoutput>"   class="regularxxl" size="14" maxlength="20" readonly> 
				<input type="text" id="orgunitname1" name="orgunitname1" value="<cfoutput>#Organization.OrgUnitName#</cfoutput>" class="regularxxl" size="60" maxlength="60" readonly> 
				</td>			
				<td style="padding-top:1px;padding-left:2px">
				
				 <cf_img icon="open" onClick="selectorgN('<cfoutput>#URL.ID#</cfoutput>','Administrative','orgunit','applyorgunit','1')"> 
				
				</td>			
				
				<cfquery name="Tree" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  *
					FROM    Ref_Mission
					WHERE   Mission = '#URL.ID#'
				</cfquery>			
				
				<!---
				<cfif Tree.TreeAdministrative eq "">
				--->
				
					<cf_tl id="Clear" var="1">
					<td>
					
					<cf_img icon="delete" onClick="admblank()">
					
					</td>
					
				<!---	
				</cfif>
				--->
				
				</tr>
			</table>
		
			<input type="hidden" id="orgunit1"       name="orgunit1"      value="<cfoutput>#Position.OrgUnitAdministrative#</cfoutput>">
			<input type="hidden" id="orgunitcode1"   name="orgunitcode1"  value="">
			<input type="hidden" id="orgunitclass1"  name="orgunitclass1" value="<cfoutput>#Organization.OrgUnitClass#</cfoutput>">
	
		</TD>
		</TR>	
			
	<cfelse>	
		
		<TD style="padding-left:10px" class="labelmedium2">
	    
		<cfif Organization.Mission eq ""><cf_tl id="Not defined"><cfelse>
		<cfoutput>#Organization.Mission# #Organization.OrgUnitName#</cfoutput>
		</cfif>
		<input type="hidden" name="orgunit1" value="<cfoutput>#Position.OrgUnitAdministrative#</cfoutput>">
			
		</TD>	
		</tr>
	
	</cfif>
	
	<cfquery name="Tree" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_Mission
		WHERE   Mission = '#PositionParent.Mission#'
	</cfquery>		
	
	<cfif tree.TreeFunctional eq "">
	
	<input type="hidden" id="orgunit2" name="orgunit2" value="<cfoutput>#Position.OrgUnitFunctional#</cfoutput>">
	
	<cfelse>
	
	<cfquery name="Organization" 
     datasource="AppsOrganization" 
   	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
   	    SELECT *
        FROM Organization
		<cfif URL.Action neq "Owner">		
		WHERE OrgUnit = '#Position.OrgUnitFunctional#'		
		<cfelse>		
		WHERE OrgUnit = '#PositionParent.OrgUnitFunctional#'		
		</cfif>		
    </cfquery>
		
	<TR bgcolor="ffffff">
    <TD width="150"  class="labelmedium2" style="height:30px;background-color:f1f1f1;border-bottom:1px solid silver;padding-left:6px"><cf_tl id="Functional Unit">:</TD>
	
	<cfif AccessPosition eq "EDIT" OR AccessPosition eq "ALL">
	
		<TD style="padding-left:10px">
			<table><tr><td>
		    <input type="text"  id="mission2"     name="mission2"     value="<cfoutput>#Organization.Mission#</cfoutput>"     class="regularxxl" size="14" maxlength="20" readonly> 
			<input type="text"  id="orgunitname2" name="orgunitname2" value="<cfoutput>#Organization.OrgUnitName#</cfoutput>" class="regularxxl" size="60" maxlength="60" readonly> 
			</td>
			<td style="padding-top:1px;padding-left:2px">
			
			 <cf_img icon="open" onClick="selectorgN('<cfoutput>#URL.ID#</cfoutput>','Administrative','orgunit','applyorgunit','2')"> 
			<!---	
				
			<button name="btnFunction" class="button3" style="height:25;width:30px" onClick="selectorgN('<cfoutput>#URL.ID#</cfoutput>','Administrative','orgunit','applyorgunit','2')"> 
			      <img src="<cfoutput>#SESSION.root#/Images/edit.gif</cfoutput>" alt="" name="img1" 
				  style="cursor: pointer;" alt="" height="15" width="15" border="0" align="top">			
			</button>
			--->
			
			</td>		
				
			<cfquery name="Tree" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    Ref_Mission
				WHERE   Mission = '#URL.ID#'
			</cfquery>			
						
				<cf_tl id="Clear" var="1">
				<td>
				<cf_img icon="delete" onClick="funblank()">
				<!---
				<button name="btnFunction" type="button" class="button3" style="height:25;width:30px" onClick="funblank()"> 
				  <img src="<cfoutput>#SESSION.root#/Images/delete5.gif</cfoutput>" alt="" name="img1" 
					  style="cursor: pointer;" alt="" height="15" width="15" border="0" align="absmiddle">
				</button>	
				--->
				</td>
			
			</tr></table>
		
			<input type="hidden" id="orgunit2"       name="orgunit2"      value="<cfoutput>#Position.OrgUnitFunctional#</cfoutput>">
			<input type="hidden" id="orgunitcode2"   name="orgunitcode2"  value="">
			<input type="hidden" id="orgunitclass2"  name="orgunitclass2" value="">
	
		</TD>
		</TR>	
			
	<cfelse>	
		
		<TD class="labelmedium2" style="padding-left:10px">
	    
		<cfif Organization.Mission eq ""><cf_tl id="Not defined"><cfelse>
		<cfoutput>#Organization.Mission# #Organization.OrgUnitName#</cfoutput>
		</cfif>
		<input type="hidden" id="orgunit2" name="orgunit2" value="<cfoutput>#Position.OrgUnitFunctional#</cfoutput>">
			
		</TD>	
		</tr>
	
	</cfif>
	
	</cfif>
	
	<TR bgcolor="ffffff">
    <TD style="background-color:f1f1f1;border-bottom:1px solid silver;height:30px;padding-left:6px" class="labelmedium2"><cf_tl id="Location">:</TD>
    <TD style="padding-left:10px" class="labelmedium2">
		
	  <cfif (Position.PositionStatus eq "0" AND (AccessPosition eq "EDIT" or AccessPosition eq "ALL"))
		      OR (Position.PositionStatus eq "1" AND (AccessLocator eq "EDIT" or AccessLocator eq "ALL")) 
		      OR (URL.Action neq "Edit" and URL.Action neq "View")>
			  
			<cfset editmode = "show">
			  
			<input type="hidden"  name="locationcode" id="locationcode" value="<cfoutput>#Position.LocationCode#</cfoutput>">
					  
			<table cellspacing="0" cellpadding="0">
				<tr><td>		
				   	<input type="text" name="locationname" id="locationname" value="<cfoutput>#Location.LocationName#</cfoutput>" class="regularxxl" size="60" maxlength="60" readonly>			
				</td>
				<td style="padding-left:2px">			
					<input type="button" class="button10g" style="width:30px;height:27px" value="..." onClick="selectlocation('webdialog','locationcode','locationname',document.getElementById('missionoperational').value)"> 			 			
				</td>
				</tr>
			</table>			
					
	  <cfelse>
	  
	  	   <cfset editmode = "hide">
		
		   <cfoutput><cfif Location.LocationName eq "">n/a<cfelse>#Location.LocationName#</cfif>
		   <input type="hidden" name="locationcode" id="locationcode" value="#Position.LocationCode#">
		   </cfoutput>
		   
		   <cfif Location.ServiceLocation neq "">
		   
			   <cfoutput>
			   
		   			<cfquery name="get" 
					datasource="appsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM    Ref_PayrollLocation
						WHERE   LocationCode = '#Location.ServiceLocation#'
					</cfquery>	
					
					: #Location.ServiceLocation# #get.Description#		
		   
		   			<cfquery name="getDesignation" 
					datasource="appsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    TOP 1 D.Description
						FROM      Ref_PayrollLocationDesignation AS R INNER JOIN
						          Ref_Designation AS D ON R.Designation = D.Code
						WHERE     R.LocationCode = '#Location.ServiceLocation#' 
						AND      ( R.DateExpiration IS NULL OR R.DateExpiration >= GETDATE() )
					</cfquery>		
					
					<cfif getDesignation.recordcount eq "1">
					(<b>#getDesignation.Description#</b>)
					</cfif>		
					
				</cfoutput>		
		   		   
		   </cfif>
		   	
	  </cfif>
				
	</TD>
	</TR>
				  	
	<TR bgcolor="ffffff">
	
    <TD class="labelmedium2" style="background-color:f1f1f1;border-bottom:1px solid silver;height:30px;padding-left:6px"><cf_tl id="Functional Title">: <font color="FF0000">*</font></TD>
			
    <TD style="padding-left:10px" class="labelmedium2">
				
	<cfif editmode eq "Show">
				
		<cfif (AccessPosition eq "ALL" OR AccessPosition eq "EDIT") 	
			OR URL.Action eq "Loan" 			
			OR getAdministrator(url.id) eq "1">			
									
			 <cfif url.action eq "Owner">
				   
				   <table cellspacing="0" cellpadding="0">
				   <tr>
				   
				    <td>
				   
				   <table cellspacing="0" cellpadding="0">
					<tr><td>	
				   
				   <input type="text" id="functiondescription" name="functiondescription" value="<cfoutput>#PositionParent.functiondescription#</cfoutput>" class="regularxxl" size="60" maxlength="60" readonly> 
				   </td>
					 <td style="padding-left:2px">	
				   	<!---	does not make sense to change in a return action		  
				   <input type="button" name="btnFunction" value="..." class="button10g" style="width:30px;height:25" 
				      onClick="selectfunction('webdialog','functionno','functiondescription','<cfoutput>#mission.missionowner#</cfoutput>','','')"/> 
					  --->
												   		   
				   <input type="hidden" id="functionno" name="functionno" value="<cfoutput>#PositionParent.functionno#</cfoutput>" class="disabled" size="6" maxlength="6" readonly>		
				    </td>
					</tr>
					</table>
				   	
				   </td>
				   </tr>
				   </table>
				   
			<cfelse>	   								   
				   
				    <table cellspacing="0" cellpadding="0">
					<tr><td>	
					   <input type="text" id="functiondescription" name="functiondescription" value="<cfoutput>#Position.functiondescription#</cfoutput>" class="regularxxl" size="60" maxlength="60" readonly> 
				    </td>
				    <td style="padding-left:2px">				   
				    <input type="button" name="btnFunction" value="..." style="height:27px;width:30px;" class="button10g" onClick="selectfunction('webdialog','functionno','functiondescription','<cfoutput>#mission.mission#</cfoutput>','','')"/> 
					<input type="hidden" id="functionno" name="functionno" value="<cfoutput>#Position.functionno#</cfoutput>" class="disabled" size="6" maxlength="6" readonly>		
					</td>
				   </tr>
				   </table>
			
			</cfif>
				
		<cfelse>
		
			 <cfif PositionParent.OrgUnitOperational neq Position.OrgUnitOperational or
			       PositionParent.FunctionNo neq Position.FunctionNo>
				      				   				   
				    <!--- return to owner --->
					<cfoutput>#PositionParent.functiondescription#</cfoutput>
					<input type="hidden" id="functiondescription" name="functiondescription" value="<cfoutput>#PositionParent.functiondescription#</cfoutput>" class="regular" size="50" maxlength="50" readonly> 
					<input type="hidden" id="functionno" name="functionno" value="<cfoutput>#PositionParent.functionno#</cfoutput>">		
					
				   
			<cfelse>		
							
				<cfoutput>#Position.functiondescription#</cfoutput>
				<input type="hidden" id="functiondescription" name="functiondescription" value="<cfoutput>#Position.functiondescription#</cfoutput>" class="regular" size="50" maxlength="50" readonly> 
				<input type="hidden" id="functionno" name="functionno" value="<cfoutput>#Position.functionno#</cfoutput>">		
			
			</cfif>
		
		</cfif>
		
	<cfelse>
	
		<cfif url.action eq "Edit">
		
		<!--- return to owner --->
		<cfoutput>#Position.functiondescription#</cfoutput>
		<input type="hidden" id="functiondescription" name="functiondescription" value="<cfoutput>#Position.functiondescription#</cfoutput>" class="regular" size="50" maxlength="50" readonly> 
		<input type="hidden" id="functionno" name="functionno" value="<cfoutput>#Position.functionno#</cfoutput>">		
		
		
		<cfelse>
						
	    <!--- return to owner --->
		<cfoutput>#PositionParent.functiondescription#</cfoutput>
		<input type="hidden" id="functiondescription" name="functiondescription" value="<cfoutput>#PositionParent.functiondescription#</cfoutput>" class="regular" size="50" maxlength="50" readonly> 
		<input type="hidden" id="functionno" name="functionno" value="<cfoutput>#PositionParent.functionno#</cfoutput>">		
		
		</cfif>
			
	</cfif>	
	
	</TD>
	</TR>				
					 			
	<script language="JavaScript">
	
	function measuresource(cls) {
		
		se = document.getElementById("approvalpostgradebox")
			
		if (cls == "regular")
		   {se.className = "regular"}
		else
		   {se.className = "hide"}
		}      
		
	</script>
		
	<TR>
    <TD class="labelmedium2" style="background-color:f1f1f1;border-bottom:1px solid silver;padding-left:6px;height:31px"><cf_tl id="Authorised">:</TD>
    <TD style="padding-left:10px;padding-top:4px" class="labelmedium2">
		
	<cfif (Position.PositionStatus eq "0" AND AccessPosition eq "EDIT") OR (AccessPosition eq "ALL")>
	
		<INPUT type="radio" class="radioL" name="PostAuthorised" value="1" <cfif 1 eq Position.PostAuthorised> checked </cfif>> Yes
		<INPUT type="radio" class="radioL" name="PostAuthorised" value="0" <cfif 0 eq Position.PostAuthorised> checked </cfif>> No
	
	<cfelse>
	
    	<cfoutput>
		<cfif Position.PostAuthorised eq "1">Yes<cfelse>No</cfif>
		<input type="hidden" name="PostAuthorised" value="#Position.PostAuthorised#">
		</cfoutput>
	
	</cfif>
				
	</TD>
	</TR>
	
	<TR bgcolor="ffffff">
    <TD class="labelmedium2" style="background-color:f1f1f1;border-bottom:1px solid silver;padding-left:6px"><cf_tl id="Post type">: <font color="FF0000">*</font></TD>

    <TD style="padding-left:10px"><table cellspacing="0" cellpadding="0">
		<tr>
	    <TD width="130" class="labelmedium2" style="min-width:200px">
		
				<cfif (Position.PositionStatus eq "0" AND AccessPosition eq "EDIT") OR (AccessPosition eq "ALL")>
					
					<cfquery name="CheckPostType" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					     SELECT *
	                     FROM   Ref_PostTypeMission 
						 WHERE  Mission = '#Position.Mission#'
					</cfquery>	 
					
					<cfif getAdministrator(Position.Mission) eq "1">
					
						<cfquery name="Posttype" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT R.PostType, R.Description
						    FROM   Ref_PostType R
							<cfif CheckPostType.recordcount gte "1">
							WHERE  PostType IN (SELECT PostType
							                    FROM   Ref_PostTypeMission 
											    WHERE  Mission = '#Position.Mission#')
							OR     PostType = '#Position.PostType#'											   
							</cfif>				   
							ORDER BY ListingOrder
						</cfquery>
					
					<cfelse>
					
						<cfquery name="Posttype" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
						    <!--- has access --->
							
						    SELECT DISTINCT R.PostType, R.Description, R.ListingOrder
						    FROM   Ref_PostType R,		      
							       Organization.dbo.OrganizationAuthorization A
							WHERE  R.PostType = A.ClassParameter
							AND    A.Role = 'HRPosition'
							AND    A.AccessLevel IN ('1','2')
							AND    A.UserAccount = '#SESSION.acc#'
							<cfif CheckPostType.recordcount gte "1">
								AND   PostType IN (SELECT PostType
								                    FROM   Ref_PostTypeMission 
												    WHERE  Mission = '#Position.Mission#')								   
							</cfif>			
							
							<!--- or is used for existing post already --->
							
							UNION 
							
							SELECT R.PostType, R.Description, R.ListingOrder
							FROM   Ref_PostType R 							
							WHERE  PostType = '#Position.PostType#'	   
							
							ORDER BY R.ListingOrder
						</cfquery>
					
					</cfif>
				
				   	<select name="posttype" id="posttype" size="1" style="width:250px" class="regularxxl">
				    <cfoutput query="PostType">
					<option value="#PostType#" <cfif Posttype eq Position.Posttype>selected</cfif>>
			    		#Description#
					</option>
					</cfoutput>
				    </select>
					
				<cfelse>
				
					<cfoutput>
					#Position.PostType#
					<input type="hidden" id="posttype" name="posttype" value="#Position.PostType#">
					</cfoutput>
					
				</cfif>	
				</TD>				
				
				<TD style="padding-left:20px;min-width:100px" class="labelmedium2"><cf_tl id="Grade">:<font color="FF0000">*</font></TD>
			    <TD>
					<table cellspacing="0" cellpadding="0">
					<tr><td class="labelmedium2 fixlength">
						
						<cfif (Position.PositionStatus eq "0" AND AccessPosition eq "EDIT") OR (AccessPosition eq "ALL")>
							
								<cfoutput>			
									<script language="JavaScript">					
									 function processfunction(funno) {
									     ptoken.navigate('PositionGradeSelect.cfm?field=postgrade&presel=#Position.PostGrade#&posttype='+document.getElementById('posttype').value+'&mission=#url.id#&functionno='+funno,'gradeselect')
									 }					 
									</script>	
								</cfoutput>		
													
								<cf_securediv id="gradeselect" 
								  bind="url:PositionGradeSelect.cfm?field=postgrade&posttype={posttype}&presel=#Position.PostGrade#&mission=#url.id#&functionno=#Position.FunctionNo#"/>
																						
					    <cfelse>
						
						   <cfoutput>
	    					#Position.PostGrade#
		    				<input type="hidden" id="postgrade" name="postgrade" value="#Position.PostGrade#">
			    			</cfoutput>
						
				    	</cfif>	
					
					</td>
					<td style="padding-left:10px" class="labelmedium2 fixlength">
					
					<cfoutput>
					
						<a href="javascript:gjp('#Position.functionNo#','#Position.postgrade#')"><cf_tl id="Job profile"></a>
						</cfoutput>
							
					</TD>
					</tr>
					</table>
				</td>
				
		</TR>
		</TABLE>
	</TD>
	
	</TR>
		   
   <TR>
   
  	     
		<!--- Postclass --->				
				
		 <td WIDTH="100" style="background-color:f1f1f1;border-bottom:1px solid silver;padding-left:6px" class="labelmedium2">
		   <cf_tl id="Post class">: <font color="FF0000">*</font></TD>
											
			<cfquery name="Color" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_PostClass
				WHERE  PostClass = '#Position.PostClass#'
			</cfquery>	
								
		<TD style="padding-left:10px">
							
			<table cellspacing="0" height="90%" cellpadding="0" bgcolor="<cfoutput>#color.PresentationColor#</cfoutput>">
			<tr><td class="labelmedium2" style="min-width:200px">
			
			<cfif (AccessPosition eq "EDIT" OR AccessPosition eq "ALL")
				OR (Position.PositionStatus eq "1" AND (AccessLoaner eq "EDIT" or AccessLoaner eq "ALL"))>
				
			   	<select name="PostClass" class="regularxxl" style="width:250px">
			    <cfoutput query="PostClass">
				<cfif PostClass.accessLevel eq "2">
					<cfif AccessPosition eq "ALL" or AccessLoaner eq "ALL">
					<option value="#PostClass#" <cfif Postclass eq Position.Postclass> selected </cfif>>
		    			#Description#
					</option>
					</cfif>
				<cfelse>
					<option value="#PostClass#" <cfif Postclass eq Position.Postclass> selected </cfif>>
		    			#Description#
					</option>
				</cfif>	
				
				</cfoutput>
			    </select>
				
			<cfelse>
							    
				<cfoutput>
				#Position.PostClass#
				<input type="hidden" id="PostClass" name="PostClass" value="#Position.PostClass#">
				</cfoutput>
									
			</cfif>	
									
		</TD>
			
		<!--- end post class --->   
		
		<cfif ParamMission.ShowPositionFund eq "1">
     
		   <td class="labelmedium2" style="padding-left:20px;min-width:100px"><cf_tl id="Fund">: <font color="FF0000">*</font></td>
	       <TD WIDTH="130" class="labelmedium2">
		
			<cfif (Position.PositionStatus eq "0" AND AccessPosition eq "EDIT")	OR (AccessPosition eq "ALL")>
						
				  	<select name="Fund" size="1" class="regularxxl" style="width:110px">
					    <cfoutput query="FundTable">			
							<option value="#Code#" <cfif Code eq Trim(PositionParent.Fund)> selected </cfif>>
					   		#Code# 
							</option>
						</cfoutput>
			    	</select>
				
			<cfelse>
				
				<cfoutput>
					#PositionParent.Fund#
					<input type="hidden" name="Fund" value="#PositionParent.Fund#">
				</cfoutput>
				
			</cfif>	
					
		 </td>
		 
	 <cfelse>
		 
		 <input type="hidden" name="Fund" value="">		 
		 			
	</cfif>
	
	    </tr>
			</table>
	 
	</TR>
	
	
	<TR>
    <TD class="labelmedium2" style="background-color:f1f1f1;border-bottom:1px solid silver;padding-left:6px;height:33px"><cf_tl id="Classification">:</TD>
    
	<TD style="padding-left:10px;padding-top:3px">
	
		<table cellspacing="0" cellpadding="0">
		
		<tr class="labelmedium2">
		
		<cfif (Position.PositionStatus eq "0" AND AccessPosition eq "EDIT")	OR (AccessPosition eq "ALL")>
		
			<td>
		    <INPUT type="radio" class="radiol" name="Classified" value="0" <cfif PositionParent.ApprovalPostGrade eq "">checked</cfif>  onclick="measuresource('hide')">
			</td>
			<td style="padding-left:3px;padding-top:1px"><cf_tl id="Non classified"></td>
			<td style="padding-left:15px">
			<INPUT type="radio" class="radiol" name="Classified" value="1" <cfif PositionParent.ApprovalPostGrade neq "">checked</cfif> onclick="measuresource('regular')">
			</td>
			<td style="padding-left:3px;padding-top:1px"><cf_tl id="Classified"></td>
					
			<cfif PositionParent.ApprovalPostGrade neq "">
		     <cfset cl = "regular">
			<cfelse>
		     <cfset cl = "hide"> 	 
			</cfif>
			
			<td style="padding-left:9px" class="<cfoutput>#cl#</cfoutput>" id="approvalpostgradebox">
									
				<table cellspacing="0" cellpadding="0">
				
				    <tr class="labelmedium2">
					 <td>as</td>
					 <td style="padding-left:3px">
				
					<cf_securediv id="approvalpostgrade" 
					  bind="url:PositionGradeSelect.cfm?field=ApprovalPostGrade&posttype={posttype}&presel=#Position.PostGrade#&mission=#url.id#&functionno=#Position.FunctionNo#"/>				
								  
					</td>
					 
					<TD style="padding-left:9px"><cf_tl id="Reference"></TD>
				    <TD style="padding-left:4px">					
											
							<cfoutput>
						        <input type="text" 
								    class="regularxxl" 
									name="approvalreference" value="#PositionParent.ApprovalReference#" size="20" maxlength="20">
							</cfoutput>							
											
					  </td>					
					</tr>
					
				 </table>
			  
			  </td>	  	
			
			<cfelse>			
				
				<td>
				<cfoutput>
				<cfif PositionParent.ApprovalPostGrade eq ""><cf_tl id="Non classified"><cfelse>#PositionParent.ApprovalPostGrade#</cfif>
				<input type="hidden" name="approvalpostgrade" value="#PositionParent.ApprovalPostGrade#">
				</cfoutput>
				</td>
				<TD style="padding-left:9px"><cf_tl id="Reference No">:</TD>
				<TD style="padding-left:3px">
					<cfif PositionParent.ApprovalReference eq "">N/A<cfelse><cfoutput>#PositionParent.ApprovalReference#</cfoutput></cfif>
				</td>
			
			</cfif>
						
			</tr>
			
	   </table>	
	   
    </td>
   </tr>	  
   			   
	<TR class="labelmedium2">
        <td valign="top" style="background-color:f1f1f1;border-bottom:1px solid silver;padding-top:6px;padding-left:6px;height:30px">
		<cf_tl id="Post functional classification">:
		</td>
        <td style="padding-left:10px">
		
		   <cfinclude template="PositionEditGroup.cfm">
		</td>
	</TR>
		
	<cfif AccessPosition eq "EDIT" OR AccessPosition eq "ALL" OR URL.Action eq "Loan" OR AccessStaffing eq "EDIT" or AccessStaffing eq "ALL">	
		   
	    <TR class="labelmedium2">
		
		<TD style="background-color:f1f1f1;border-bottom:1px solid silver;padding-left:6px">
		
		<table style="height:100%">
		<tr class="labelmedium2" style="height:30px">
				
			<cfif LaterPosition.recordcount eq "0">
		   
			   <td class="fixlength" style="border-right:1px;background-color:ffffaf;padding-left;6px;padding-right:4px" align="center">
			   
			        <!--- likely we need to tune this a bit to capture 0 percent and 
					 multiple assignments --->
					 
					 <cfquery name="Post" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
						 SELECT *
						 FROM   PersonAssignment
						 WHERE  PositionNo      = '#URL.ID2#'
						 AND    AssignmentStatus IN ('0','1')
						 AND    AssignmentType   = 'Actual'					 
						 AND    Incumbency       = 100
						 AND    DateEffective  <= CAST(GETDATE() AS Date) 
						 and    DateExpiration >= CAST(GETDATE() AS Date)				
						 AND    DateEffective  < '#DateFormat(Position.DateExpiration,client.dateSQL)#'
					</cfquery>	
					
					
					<cfquery name="PostStatus" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
						 SELECT *
						 FROM   PersonAssignment
						 WHERE  PositionNo      = '#URL.ID2#'
						 AND    AssignmentStatus IN ('0','1')
						 AND    AssignmentType   = 'Actual'
						 AND    AssignmentClass  = 'Regular'
						 AND    Incumbency       = 100
						 AND    DateEffective  <= CAST(GETDATE() AS Date) 
						 and    DateExpiration >= CAST(GETDATE() AS Date)				
						 AND    DateEffective  < '#DateFormat(Position.DateExpiration,client.dateSQL)#'
					</cfquery>	
					 
					 <cfquery name="PostLien" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
						 SELECT *
						 FROM   PersonAssignment
						 WHERE  PositionNo      = '#URL.ID2#'
						 AND    AssignmentStatus IN ('0','1')
						 AND    AssignmentType = 'Actual'
						 AND    Incumbency = 0
						 AND    DateEffective  <= CAST(GETDATE() AS Date) 
						 and    DateExpiration >= CAST(GETDATE()-60 AS Date)		<!--- 60 days threshold --->		
						 AND    DateEffective  < '#DateFormat(Position.DateExpiration,client.dateSQL)#'
					</cfquery>	
			   
							
					<cfif Post.recordcount eq "0">				
						<font color="FF0000"><cf_tl id="Vacant"></font>					
					<cfelseif PostStatus.recordcount gte "1" and PostLien.recordcount eq "0">				
						<cf_tl id="Encumbered by holder">					
					<cfelse>				
						<font color="gray"><cf_tl id="Encumbered"></font>						
					</cfif>  
					 
			   </td>
			   		   	   
	  	    </cfif>
			
		    <td style="padding-left:6px"><cf_tl id="Vacancy class">:<font color="FF0000">*</font> </TD>
			
		</tr>
		</table>
		</td>
		
		<TD style="padding-left:10px">
		
		     <table><tr class="labelmedium2"><td>
		
		  	<select name="vacancyActionClass" size="1" class="regularxxl" 
			onchange="_cf_loadingtexthtml='';ptoken.navigate('getRecruitment.cfm?class='+this.value+'&id2=#url.id2#','recruitment')">
			   
				<cfoutput query="VacancyClass">
				<option value="#Code#" <cfif Code eq Position.VacancyActionClass> selected </cfif>>
		    		#Description#
				</option>
				</cfoutput>
		    </select>
			
			</td>
			
			<td style="padding-left:5px" id="recruitment">
			    <cfset url.class = 	Position.VacancyActionClass>			    
			     <cfinclude template="getRecruitment.cfm">			
			</td>
			
			</tr></table>
			
		</TD>
		</TR>
	
	<cfelse>
	
		<TR class="labelmedium2" bgcolor="ffffff">
	    <TD style="height:30px;background-color:f1f1f1;border-bottom:1px solid silver;padding-left:6px"><cf_tl id="Vacancy class"> </TD>
	    <TD style="padding-left:10px">
		
		  <table><tr class="labelmedium2"><td>
		
		  <cfquery name="VacancyClass" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Ref_VacancyActionClass
				WHERE Code = '#Position.VacancyActionClass#'
				ORDER BY ListingOrder
		  </cfquery>
		
		  <cfoutput>#VacancyClass.Description#</cfoutput>	
		  
		  <input type="hidden" name="VacancyActionClass" value="<cfoutput>#Position.VacancyActionClass#</cfoutput>">
		  
		  </td>
			
			<td style="padding-left:5px" id="recruitment">			
			     <cfinclude template="getRecruitment.cfm">			
			</td>
			
			</tr></table>
			
		</TD>
		</TR>
		
	</cfif>
		
	<TR class="labelmedium2">
    <TD style="height:30px;background-color:f1f1f1;border-bottom:1px solid silver;padding-left:6px"><cf_tl id="Source Post number">:</TD>
    <TD style="padding-left:10px">
		
	<cfquery name="Parameter" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    	SELECT *
	    FROM Parameter
	</cfquery>
		
	<cfif Parameter.SourcePostNumber eq "Position">
	
		<cfif AccessPosition eq "EDIT" OR AccessPosition eq "ALL">
			
			<INPUT type="text" class="regularxxl" name="SourcePostNumber" id="SourcePostNumber" value="<cfoutput>#Position.sourcepostnumber#</cfoutput>" maxLength="20" size="10">
		
		<cfelse>
		
			<cfoutput><cfif Position.sourcepostnumber neq "">#Position.sourcepostnumber#<cfelse>Not entered</cfif></cfoutput>
			<INPUT type="hidden" class="regularxxl" name="SourcePostNumber" id="SourcePostNumber" value="<cfoutput>#Position.sourcepostnumber#</cfoutput>" maxLength="20" size="10">
		
		</cfif>
	
	<cfelse>
	
		<cfif AccessPosition eq "EDIT" OR AccessPosition eq "ALL">
			
			<INPUT type="text" 
			 class="regularxxl" id="SourcePostNumber"
			 name="SourcePostNumber" 
			 value="<cfoutput>#PositionParent.sourcepostnumber#</cfoutput>" 
			 maxLength="10" 
			 size="10">
		
		<cfelse>
		
			<cfoutput><cfif PositionParent.sourcepostnumber neq "">#PositionParent.sourcepostnumber#<cfelse>Not entered</cfif></cfoutput>
			<INPUT type="hidden" 
			  class="regularxxl" id="SourcePostNumber"
			  name="SourcePostNumber" 
			  value="<cfoutput>#PositionParent.sourcepostnumber#</cfoutput>" 
			  maxLength="10" 
			  size="10">
		
		</cfif>
							
	</cfif>
	
	<cftry>
			
	<cfif Position._sourcepostnumber neq "">
	
	<TR class="labelmedium2">
    <TD style="height:30px;background-color:f1f1f1;border-bottom:1px solid silver;padding-left:6px"><cf_tl id="IMIS Post number">:</TD>
    <TD style="padding-left:10px">
		
		
		<cfif AccessPosition eq "EDIT" OR AccessPosition eq "ALL">
			
			<INPUT type="text" class="regularxxl" name="_SourcePostNumber" id="_SourcePostNumber" value="<cfoutput>#Position._sourcepostnumber#</cfoutput>" maxLength="20" size="10" readonly>
		
		<cfelse>
		
			<cfoutput><cfif Position._sourcepostnumber neq "">#Position._sourcepostnumber#<cfelse>Not entered</cfif></cfoutput>
			<INPUT type="hidden" class="regularxxl" name="_SourcePostNumber" id="_SourcePostNumber" value="<cfoutput>#Position._sourcepostnumber#</cfoutput>" maxLength="20" size="10" readonly>
		
		</cfif>
		
	</tr>
	
	</cfif>
	
	<cfcatch></cfcatch>
	
	</cftry>
			
	<!--- template to add a custom link to the field 
	on April 15, 2009, Jorge Mazariegos changed it from SourcePostNumber to PositionNo
	
	
	<cf_customLink
		FunctionClass = "Staffing"
		FunctionName  = "stPosition"
		Field         = "PositionNo">
		
		--->
		
	<script>
	 try { parent.sourcepost.value = document.getElementById("SourcePostNumber").value } catch(e) {}
	</script>	
	
	</TD>
	</TR>	
		
	<cfquery name="Topic" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  	 SELECT  *
	     FROM  Ref_PositionParentGroup
		 WHERE Code IN (SELECT GroupCode 
		                FROM   Ref_PositionParentGroupList)
		 AND  Code IN  (SELECT GroupCode 
		                FROM   Ref_PositionParentGroupMission
		                WHERE  Mission = '#URL.ID#' )              
	</cfquery>
	
	<cfif Topic.recordcount gt "0">

		<cfoutput query="topic">
		
			<tr>
				<td class="labelmedium2" style="height:30px;background-color:f1f1f1;border-bottom:1px solid silver;padding-left:6px">#Description#: <font color="FF0000">*</font></td>
				<td style="padding-left:10px" class="labelmedium2">
				
				<cfquery name="Group" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT *
				  FROM  PositionParentGroup
				  WHERE PositionParentId  = '#Position.PositionParentID#'
				  AND   GroupCode = '#Code#'
			    </cfquery>				
				
				<cfif (Position.PositionStatus eq "0" AND AccessPosition eq "EDIT") 	
				OR (AccessPosition eq "ALL") 
				OR (Position.PositionStatus eq "1" AND (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL"))>
														
				<cfquery name="List" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT  *
				     FROM  Ref_PositionParentGroupList
					 WHERE GroupCode = '#Code#'
					 ORDER BY GroupListOrder, GroupListCode
				</cfquery>				
								
				<select name="ListCode_#Code#" required="No" class="regularxxl">
					<cfloop query="List">
					<option value="#GroupListCode#" <cfif #Group.GroupListCode# eq "#GroupListCode#">selected</cfif>>#Description#</option>
					</cfloop>
				</select>
				
				<cfelse>
				
				<cfquery name="List" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT  *
				     FROM  Ref_PositionParentGroupList
					 WHERE GroupCode = '#Code#'
					 AND   GroupListCode = '#Group.GroupListCode#'					
				</cfquery>
				
				<cfif List.recordcount eq "0">
				undefined
				<cfelse>
				#List.Description#
				</cfif>								
				
				</cfif>
				
				</td>
			</tr>
		
		</cfoutput>
	
	</cfif>
	
	<cf_filelibraryCheck    	
		DocumentPath="Position"
		SubDirectory="#Position.PositionNo#" 
	    Filter="">		
		
	<cfif files gte "1" or AccessPosition eq "EDIT" or AccessPosition eq "ALL" or AccessLoaner eq "EDIT" or AccessLoaner eq "ALL">	
	
	<tr>
		<td valign="top" class="labelmedium2" style="background-color:f1f1f1;border-bottom:1px solid silver;padding-top:4px;padding-left:6px"><cf_tl id="Attachments">:</td>
		<td class="labelmedium2" style="padding-top:3px;padding-left:10px">
		
		<cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL" or AccessLoaner eq "EDIT" or AccessLoaner eq "ALL">
				 	  
				 <cf_filelibraryN
				    Box="primary"
					DocumentPath="Position"
					SubDirectory="#Position.PositionNo#" 
					Filter=""
					Insert="yes"
					Remove="yes"
					Highlight="no"
					Listing="yes">
										
			
		 <cfelse>
				 
				 <cf_filelibraryN
				    Box="primary"
					DocumentPath="Position"
					SubDirectory="#Position.PositionNo#" 
					Filter=""
					Insert="no"
					Remove="no"
					Highlight="no"
					Listing="yes">
							 	 
		 </cfif>
	 
	    </td>
		
   </tr>	
   
   </cfif>
   
   <cfset spst = position.SourcePositionNo>
   
   <cfquery name="Exist" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM  Position
	  WHERE PositionNo = '#spst#'					
   </cfquery>
        
   <cfset row = 0>	
         
  <cfloop condition="#exist.recordcount# eq '1'">
  	     
	   <cfset row = row + 1>
   
	   <cf_filelibraryCheck    	
			DocumentPath="Position"
			SubDirectory="#spst#" 
		    Filter="">	
	   
	   <cfif files gte "1">	
		
		<tr>
			<td height="30" class="labelmedium2" style="background-color:f1f1f1;border-bottom:1px solid silver;padding-top:4px;padding-left:6px"><cf_tl id="Attachment Log"><cfoutput>/ #spst#</cfoutput>:</td>
			<td class="labelmedium2" style="padding-left:10px">
			
				<cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL" or AccessLoaner eq "EDIT" or AccessLoaner eq "ALL">
				
					 <cf_filelibraryN
						Box="secunday#row#"
						DocumentPath="Position"
						SubDirectory="#spst#" 
						Filter=""
						Insert="no"
						Remove="yes"
						Highlight="no"
						Listing="yes"> 			
			
				<cfelse>
					
					 <cf_filelibraryN
						Box="secunday#row#"
						DocumentPath="Position"
						SubDirectory="#spst#" 
						Filter=""
						Insert="no"
						Remove="no"
						Highlight="no"
						Listing="yes"> 			
						
				</cfif>		
		 
		    </td>
			
	   </tr>
	   
	   </cfif>
	   
	   <cfquery name="Exist" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		  FROM  Position
		  WHERE PositionNo = '#Exist.SourcePositionNo#'					
	   </cfquery>	
	   
	   <cfset spst = exist.PositionNo>
	   
   </cfloop>
      						   
   <TR bgcolor="ffffff" class="line">
        <td class="labelmedium2" valign="top" style="height:30px;background-color:f1f1f1;border-bottom:1px solid silver;padding-top:3px;padding-left:6px"><cf_tl id="Remarks">:</td>
        <TD class="labelmedium2" style="padding-left:10px">
		
		<cfif AccessPosition eq "EDIT" OR AccessPosition eq "ALL">
		
		<textarea style="width:99%;height:60px;padding:3px;padding-left:5px;font-size:14px;background-color:f1f1f1;border:0px" 
		    onkeyup="return ismaxlength(this)" 
			totlength="300"
			class="regular" 
			name="remarks"><cfoutput>#Position.remarks#</cfoutput></textarea> 
		
		<cfelse>
		  		
			<cfif Position.remarks eq "">
				None
			<cfelse>
				<cfoutput>#Position.remarks#</cfoutput>
			</cfif>
				
		</cfif>
		
		</TD>
   </TR>
	
   <cfoutput>	
  
   <script language="JavaScript">
   
	    function editposition() {
	   		ptoken.location('PositionEdit.cfm?box=#url.box#&mode=edit&id=#url.id#&id1=#url.id1#&id2=#url.id2#')
	    }
		
   </script>
   
   </cfoutput>
   
   <tr><td></td></tr>
   
   <cfif url.mode eq "read">	
   
   <tr><td colspan="2">   
   <cf_securediv bind="url:../Position/PositionMemo.cfm?positionno=#url.id2#" id="memo">   
   </td></tr>    
   
   </cfif>
   
   </table>
   
   </cf_divscroll>
   
   </td></tr>
   
   <cfoutput>
   
     
  
          
   <tr><td align="center" style="height:40px" colspan="2" class="labelmedium2">
   
   
  		
   <cfif url.mode neq "read">
      
	   <cf_tl id="Back" var="1">
	   <input class="button10g" onclick="editposition()" style="width:130;height:30" type="button"  name="Reset" value="#lt_text#">
	   
	   <cf_tl id="Reset" var="1">
	   <input class="button10g" type="reset"  style="width:130;height:30" name="Reset" value="#lt_text#">
	   
   </cfif>	  
      
   
   
   <cfif laterPosition.recordcount gte "1">
   
   		    There is already an instance with the later effective period for this position. <u>Select Classify and Loan to review.</u>
   
	   		<!--- no ability to edit this one anymore --->
   
   <cfelse>                        
		
		  <cfif url.mode eq "read">
		  
			  <cfinvoke component="Service.Access"  
				  method         = "position" 
				  orgunit        = "#Position.OrgUnitOperational#" 
				  role           = "'HRPosition'"
				  posttype       = "#Position.PostType#"
				  returnvariable = "accessPosition">
			  
			  <cfinvoke component="Service.Access"  
				  method         = "staffing" 
				  orgunit        = "#Position.OrgUnitOperational#" 
				  posttype       = "#Position.PostType#"
				  returnvariable = "accessStaffing">
 		   		
			   <cfif  ((AccessPosition eq "EDIT" or AccessPosition eq "ALL")
			   or ((AccessStaffing eq "EDIT" or AccessPosition eq "ALL") and Position.PostAuthorised eq "0"))>			    	
				   <cfoutput>	  
				   <cf_tl id="Amend this Position" var="1">		   
				   <input class="button10g" type="button" name="edit" value="#lt_text#" style="font-size:15px;width:270;height:35" onClick="Prosis.busy('yes');editposition()">
				   </cfoutput>
			   </cfif>
		 
		   <cfelse>
		          
			   <cfif LastAssignment.DateExpiration eq "" and ((AccessPosition neq "NONE")
			   or ((AccessStaffing neq "NONE") and Position.PostAuthorised eq "0"))>
			  
			   <cf_tl id="Delete" var="1">
			  	   
				   <cfif URL.Action eq "Edit">
				   
				       	<input class   = "button10g" 
						       type    = "submit" 
							   name    = "Delete" 
							   style   = "width:130;height:30" 
							   value   = "#lt_text#" 
							   onclick = "return ask();">
				   </cfif>
				   
			   </cfif>
			   
			   <cfif URL.Action eq "Edit">
				   <cf_tl id="Save" var="1"> 
			   <cfelseif URL.Action eq "Owner">   
			       <cf_tl id="Return" var="1"> 
			   <cfelse>
			       <cf_tl id="Loan" var="1"> 
			   </cfif>
			   
			   <input class="button10g" type="submit" onclick="Prosis.busy('yes')" style="width:160;height:30" name="Submit" value="#lt_text#">
			   
		   </cfif>
	   
   </cfif>  
   
   </cfoutput>
   	   
   </td>
   </tr>
      
</TABLE>  

</CFFORM> 
