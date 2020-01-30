
<cf_tl id="Staff Chain utility" var="vScreenLabel">
<cf_screentop label="#vScreenLabel#" html="Yes" layout="webapp" scrollbar="Yes" jquery="yes">

<cfoutput>

<script>

	function highlightPerson(selector, highlight) {
		if (highlight) {
			$(selector).closest('.personContainer').css('background-color','CAF2A8');
		} else {
			$(selector).closest('.personContainer').css('background-color','');
		}
	}
	
	function ShowPost(pos) {		       
		  ptoken.open("#session.root#/DWUmoja/InquiryPost/Position.cfm?id=" + pos+"&header=1", "PostDialog"+pos);
	}
	  
	function ShowPerson(ind) {
    	w = #CLIENT.width# - 60;
	    h = #CLIENT.height# - 160;
		ptoken.open("#session.root#/DWarehouse/Detail/EmployeeView.cfm?ID=" + ind, "form"+ind);
	}
	
	function ShowEvent(id) {
	    	ptoken.open('#SESSION.root#/Staffing/Application/Employee/Events/EventDialog.cfm?portal=0&id='+id,'_blank')
	}		
		
</script>

</cfoutput>

<table width="100%" height="100%">

<tr><td height="10"></td></tr>

 <cfquery name="Person" 
		   datasource="appsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">		   
		   SELECT    *
		   FROM      Person P		  
		   WHERE     IndexNo = '#myindexno#'		 			   				  
 </cfquery> 		
 
<cfoutput>
<tr class="line">

<td colspan="1">
 
 <table width="89%" align="center" border="0" class="formpadding formspacing">
	<tr class="labelmedium">
		<td width="200"><cf_tl id="IndexNo"></td><td>#Person.IndexNo#</td>
	</tr>
	<tr class="labelmedium">
		<td><cf_tl id="Name"></td><td>#Person.FirstName# #Person.LastName#</td>
	</tr>		
	</table>
 
</td>


<td width="1%" rowspan="2" valign="top" align="right" style="padding-right:30px;">
	<cfoutput>
		<span id="printTitle" style="display:none;"><span style="font-size:135%; font-weight:bold;">#ucase(vScreenLabel)#</span></span>
		<cf_tl id="Print" var="1">
		<cf_button2 
			mode		= "icon"
			type		= "Print"
			title       = "#lt_text#" 
			id          = "Print"					
			imageHeight = "40px"
			height		= "45px"
			width		= "45px"
			printTitle	= "##printTitle"
			printContent = ".clsPrintContent">
	</cfoutput>
</td>

<tr>
</cfoutput> 

<tr><td height="100%" valign="top" style="padding:10px" colspan="2" class="clsPrintContent">

		<cf_divscroll>

		<table width="90%" align="center" border="0" class="navigation_table">
		
		<tr class="labelmedium line">
		   <td><cf_tl id="Position"></td>
		   <td><cf_tl id="Unit"></td>
		   <td><cf_tl id="Owner"></td>
		   <td><cf_tl id="User"></td>
		</tr>
		
		<cfoutput>
		
		 <cfquery name="PositionList" 
		   datasource="hubEnterprise" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   
		   SELECT    DISTINCT PA.PositionId, PM.PostGrade, G.ListingOrder, PM.PostType, R.PostTypeName, PM.PostNature, DateExpirationFund
		   FROM      Position PA INNER JOIN 
	                 PositionModality AS PM ON PA.PositionId = PM.PositionId INNER JOIN
					 Ref_PostGrade G ON PM.PostGrade = G.PostGrade INNER JOIN
                     Ref_PostType AS R ON PM.PostType = R.PostType		
		   WHERE     PA.PositionId IN (#preserveSingleQuotes(positions)#)  	
		   AND       PM.DateEffective < '#dts#'
		   AND       PM.DateExpiration >= '#dte#'   
		   AND       PM.TransactionStatus = '1' 	
		   ORDER BY  ListingOrder					   				  
		 </cfquery> 				
		
		<cfquery name="getData" 
		   datasource="hubEnterprise" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   
		   SELECT     PA.PositionId, 
		              P.IndexNo, 
		              P.LastName, 
					  P.FirstName, 
					  P.DOB,
					  P.NationalityCode,
					  PA.AssignmentType, 
					  PO.JobCode,
					  J.JobDescription,
					  PA.DateEffective, 
					  PA.DateExpiration, 
					  O.OrgUnitNameShort
			FROM      PersonAssignment AS PA INNER JOIN
		              Person AS P ON PA.IndexNo = P.IndexNo INNER JOIN
		              PositionOrganization AS PO ON PA.PositionId = PO.PositionId INNER JOIN
		              Organization AS O ON PO.OrgUnit = O.OrgUnitId INNER JOIN 
					  Ref_AssignmentType R ON R.AssignmentType = PA.AssignmentType INNER JOIN
					  Ref_Job J ON PO.JobCode = J.JobCode
			WHERE     PA.PositionId IN (#preserveSingleQuotes(positions)#) 
			AND       PA.TransactionStatus = '1' 
			<!--- assignment filter --->
			AND       PA.DateEffective < '#dts#' 
			AND       PA.DateExpiration >= '#dte#' 
			<!--- organization filter --->
			AND       PO.DateEffective < '#dts#'
			AND       PO.DateExpiration >= '#dte#'   
			AND       PO.TransactionStatus = '1' 	
		</cfquery>	
				
		<cfloop query="PositionList">
				
			<tr class="navigation_row line">
			
			   <td valign="top" style="width:15%">
			     
			   <table class="formspacing formpadding">	  
				   <tr class="labelmedium">
				      <td colspan="3">
					  <table>
					  
						  <tr class="labelmedium">
							  <td><cf_img icon="select" onclick="ShowPost('#positionid#')"></td>
							  <td><a href="javascript:ShowPost('#PositionId#')"><font color="0080C0">#positionid#</font></a> / #PostGrade#</td>
						  </tr>				  
						  <tr class="labelmedium">
							  <td></td>
						      <td colspan="1">#PostTypeName#</td>
						  </tr>	
						  
						  <tr class="labelmedium">
						  	  <td></td>
						      <td colspan="1"><cfif DateExpirationFund neq "9999/12/31"><font size="2">until:</font> #DateExpirationFund#</cfif></td>
						  </tr>	
									  
					  </table>
					  </td>
					</tr>
									  
			    </table>
				
			   </td>
			   
			      <cfquery name="Owner" dbtype="query">
				     SELECT  *
					 FROM    getData
					 WHERE   PositionId = '#positionid#'
				   </cfquery>
			      
			   <td valign="top" style="width:25%;border-left:1px solid silver;padding-left:10px">
			   
			    <table width="90%" class="formpadding">	  
				   <tr class="labelmedium">
				      <td colspan="3">#Owner.OrgUnitNameShort#</td>
					</tr>
					<tr class="labelit">
				      <td colspan="3">#Owner.JobDescription#</td>
					</tr>	  
					
					 <cfquery name="Funding" 
					   datasource="hubEnterprise" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">					   
						   SELECT    *
						   FROM      PositionFunding PF
						   WHERE     PositionId = '#PositionId#'  	
						   AND       DateEffective  <  '#dts#'
						   AND       DateExpiration >= '#dts#'   
						   AND       TransactionStatus = '1' 			  				   				  
					 </cfquery> 	
					 
					 <tr><td style="width:90%" align="center">
					 <table style="border:1px solid gray" width="100%" >
					
					<cfloop query="Funding">
					<tr style="border-bottom:1px solid black" bgcolor="FFBD9D"><td style="padding-left:6px" colspan="3">#CBFund#-#CBFunctionalArea#-#CBCostCenter#<cfif CBWBse neq "">-#CBWBse#</cfif></td>					     
						
					 </tr> 
					<tr bgcolor="FFBD9D"><td align="center">#CBPercentage#%</td>
					     <td align="center">#dateformat(DateEffective,client.dateformatshow)#</td>
						 <td align="center">#dateformat(DateExpiration,client.dateformatshow)#</td>
					 </tr> 
					</cfloop>		
					
					</table></td></tr>
					
			    </table>
				   
			   </td>
			   
			   <!--- --------------------------------------------- --->
			   <!--- ------------------- OWNER ------------------- --->
			   <!--- --------------------------------------------- --->
			      
			   <td valign="top" class="personContainer" style="width:30%; border-left:1px solid silver; padding-left:10px;">
			   
				   <cfquery name="Owner" dbtype="query">
				     SELECT  *
					 FROM    getData
					 WHERE   AssignmentType = 'LI' 
					 AND     PositionId = '#positionid#'
				   </cfquery>
				   
				   <!--- remove 10/6/2017 
				   
				   <cfif Owner.recordcount eq "0">
				   
					    <cfquery name="Owner" dbtype="query">
					     SELECT  *
						 FROM    getData
						 WHERE   AssignmentType = 'TA' 
						 AND     PositionId = '#pos#'
					   </cfquery>
				   
				   </cfif>
				   
				   --->
				   
				   <table class="formspacing" width="100%">
				   <cfloop query="Owner">
				   
				    <cfquery name="getGrade" 
					   datasource="hubEnterprise" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						   SELECT   *
						   FROM     PersonGrade AS PG 
						    WHERE   PG.IndexNo = '#IndexNo#' 
							AND     PG.TransactionStatus = '1' 
							AND     PG.DateEffective  < '#dts#' 
							ORDER BY DateEffective DESC
						</cfquery>
				    
				   
				   <cfset age = dateDiff("YYYY", dob, now())>
				   <tr class="labelmedium" onmouseover="highlightPerson('.clsPerson_#indexno#', true);" onmouseout="highlightPerson('.clsPerson_#indexno#', false);">
				      <td colspan="3">
					  <cfif myindexno eq indexNo>
					  <font size="5" color="800080">
					  </cfif>
					  
					  <b>#LastName#, #FirstName#</b> : #age# (#nationalitycode#)</td>
					</tr>
					<tr class="labelmedium line" onmouseover="highlightPerson('.clsPerson_#indexno#', true);" onmouseout="highlightPerson('.clsPerson_#indexno#', false);">
				      <td colspan="3" class="clsPerson_#indexno#"><font color="800040">#getGrade.Grade#/#getGrade.Step#</font>&nbsp;<a href="javascript:ShowPerson('#indexno#')"><font color="0080C0">#IndexNo#</font></a></td>
					</tr>
					
					<tr onmouseover="highlightPerson('.clsPerson_#indexno#', true);" onmouseout="highlightPerson('.clsPerson_#indexno#', false);">  
					  <td class="labelit" style="padding-left:5px">#AssignmentType#:</td>
					  <td class="labelit">#dateformat(dateEffective,client.dateformatshow)#</td>
					  <td class="labelmedium" style="font-size:16px;padding-left:4px"><b>
					   <cfif DateExpiration lte now()>
						  <font color="FF0000">#dateformat(DateExpiration,client.dateformatshow)#</font>
					  <cfelse>
						  #dateformat(DateExpiration,client.dateformatshow)#
					  </cfif></td>
				   </tr>	   
				   </cfloop>
				   </table>		   
			 
			   </td>			   
			   
			   <!--- --------------------------------------------- --->
			   <!--- ---------------------USER-------------------- --->
			   <!--- --------------------------------------------- --->
			   
			     <cfquery name="User" dbtype="query">
				     SELECT  *
					 FROM    getData
					 WHERE   AssignmentType != 'LI' AND AssignmentType != 'ZA'
					 AND     PositionId = '#positionid#'
			      </cfquery>
				  
			   <cfif User.recordcount eq "0">
			   			   
			   		<td align="center" valign="middle" bgcolor="B9F4C4" class="labelmedium" style="height:100%;border-left:1px solid silver">
					<cf_tl id="Available">
					</td>
			   
			   <cfelse>	  
			   
				   <td valign="top" class="personContainer" style="width:30%;border-left:1px solid silver;padding-left:10px">
				   
				       <table class="formspacing" width="100%">
					  			   
					   <cfloop query="User">
					   
					   <cfset age = dateDiff("YYYY", dob, now())>
					   
					   <tr class="labelmedium" onmouseover="highlightPerson('.clsPerson_#indexno#', true);" onmouseout="highlightPerson('.clsPerson_#indexno#', false);">
					      <td colspan="3"><b>#LastName#, #FirstName#</b> : #age# (#nationalitycode#)</td>
						</tr>						
						
					    <cfquery name="getGrade" 
						   datasource="hubEnterprise" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
							   SELECT   *
							   FROM     PersonGrade AS PG 
							   WHERE    PG.IndexNo = '#IndexNo#' 
							   AND      PG.TransactionStatus = '1' 
							   AND      PG.DateEffective  <= '#dts#' 
							   ORDER BY DateEffective DESC								
						</cfquery>
						
						<tr class="labelmedium line" onmouseover="highlightPerson('.clsPerson_#indexno#', true);" onmouseout="highlightPerson('.clsPerson_#indexno#', false);">
					      <td colspan="3" class="clsPerson_#indexno#"><font color="800040">#getGrade.Grade#/#getGrade.Step#</font>&nbsp;<a href="javascript:ShowPerson('#indexno#')"><font color="0080C0">#IndexNo#</font></a></td>
						</tr>
						
						<tr onmouseover="highlightPerson('.clsPerson_#indexno#', true);" onmouseout="highlightPerson('.clsPerson_#indexno#', false);">  
						  <td class="labelit">#AssignmentType#:</td>
						  <td class="labelit">#dateformat(dateEffective,client.dateformatshow)#</td>
						  <td class="labelmedium" style="font-size:16px;padding-left:4px"><b>
						  <cfif DateExpiration lte now()>
						  <font color="FF0000">#dateformat(DateExpiration,client.dateformatshow)#</font>
						  <cfelse>
						  #dateformat(DateExpiration,client.dateformatshow)#
						  </cfif>
						  </td>
					   </tr>
					   
					   <cfif AssignmentType eq "PM">
					      	   
						   <cfquery name="getContract" 
						   datasource="hubEnterprise" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
							   SELECT   PA.AppointmentType, R.AppointmentTypeName, PA.ContractTerm, PA.ContractStatus, PA.DateEffective, PA.DateExpiration, PA.IndexNo
							   FROM     PersonAppointment AS PA INNER JOIN
					                    Ref_ContractType AS R ON PA.AppointmentType = R.AppointmentType
							    WHERE   PA.IndexNo           = '#IndexNo#' 
								AND     PA.TransactionStatus = '1' 
								AND     PA.DateEffective    <= '#dts#' 
								AND     PA.DateExpiration   >  '#dte#'
							</cfquery>
							
						   <cfloop query="getContract">
							
							   <tr bgcolor="FFFFCA" onmouseover="highlightPerson('.clsPerson_#indexno#', true);" onmouseout="highlightPerson('.clsPerson_#indexno#', false);">  
								  <td class="labelit" colspan="3">#AppointmentTypeName#:</td>
							   </tr>
							   <tr onmouseover="highlightPerson('.clsPerson_#indexno#', true);" onmouseout="highlightPerson('.clsPerson_#indexno#', false);">
							   	  <td></td>
								  <td class="labelit">#dateformat(dateEffective,client.dateformatshow)#</td>						  
								  <td class="labelmedium" style="font-size:16px;padding-left:4px"><b>#dateformat(DateExpiration,client.dateformatshow)#</td>
							   </tr>
						   
						   </cfloop>
					   
					   </cfif>
					   
					    <cfquery name="getEvent" 
						   datasource="appsEmployee" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
					   
						    SELECT    Pe.EventTrigger, 
							          Pe.EventCode, 
									  R.Description, 
									  Pe.ReasonCode, 
									  Pe.ReasonListcode, 
									  Pe.DateEvent, 
									  Pe.ActionStatus, 
									  Pe.OfficerUserId, 
									  Pe.OfficerLastName, 									 
				                      Pe.OfficerFirstName, 
									  Pe.Created, Pe.EventId, Pe.Mission
									  
							FROM      Person AS P INNER JOIN
				                      PersonEvent AS Pe ON P.PersonNo = Pe.PersonNo INNER JOIN
	            			          Ref_PersonEvent AS R ON Pe.EventCode = R.Code
							WHERE     P.IndexNo = '#IndexNo#' 
							AND       Pe.ActionStatus < '3'
							ORDER BY  Pe.DateEvent DESC
						
						</cfquery>
						
						<cfif getEvent.recordcount eq "0">
						
							<cfquery name="getEvent" 
							   datasource="appsEmployee" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
						   
							    SELECT    TOP 1 Pe.EventTrigger, 
								          Pe.EventCode, 
										  R.Description, 
										  Pe.ReasonCode, 
										  Pe.ReasonListcode, 
										  Pe.DateEvent, 
										  Pe.ActionStatus, 
										  Pe.OfficerUserId, 
										  Pe.OfficerFirstName,
										  Pe.OfficerLastName, 
					                      Pe.Created, Pe.EventId, Pe.Mission
										  
								FROM      Person AS P INNER JOIN
					                      PersonEvent AS Pe ON P.PersonNo = Pe.PersonNo INNER JOIN
		            			          Ref_PersonEvent AS R ON Pe.EventCode = R.Code
								WHERE     P.IndexNo = '#IndexNo#' 
								AND       Pe.ActionStatus = '3'
								ORDER BY  Pe.DateEvent DESC
							
							</cfquery>
						
						</cfif>
						
						<cfloop query="getEvent">
												
							<cfif actionstatus eq "3">
								<cfset cl = "lime">
							<cfelse>
								<cfset cl = "yellow">
							</cfif>
						
							<tr bgcolor="#cl#" onmouseover="highlightPerson('.clsPerson_#indexno#', true);" onmouseout="highlightPerson('.clsPerson_#indexno#', false);">  
								  <td class="labelit" style="border:1px solid gray; padding-left:4px" colspan="3"><a href="javascript:ShowEvent('#EventId#')"><font color="0080C0">#Description#:</font></a></td>
							</tr>
							<tr onmouseover="highlightPerson('.clsPerson_#indexno#', true);" onmouseout="highlightPerson('.clsPerson_#indexno#', false);">
							   	  <td><img src="#session.root#/images/join.gif" alt="" border="0"></td>
								  <td class="labelit">#OfficerFirstName# #OfficerLastName#</td>						  
								  <td class="labelit" style="font-size:16px;padding-left:4px">#dateformat(Created)#</td>
							</tr>						
						
						</cfloop>   
					   
					   
					   </cfloop>
					   </table>   
				  	      
				   </td>	 
				   
				 </cfif>      
			   
			</tr>
		
			<tr id="#positionid#"><td colspan="3" id="#positionid#_content"></td></tr>
		
		</cfloop>
		
		</cfoutput>
		
		</table>
		
		</cf_divscroll>

</td></tr>
</table>
