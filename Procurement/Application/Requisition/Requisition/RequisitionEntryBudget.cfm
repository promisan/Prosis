<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="URL.objectCode" default="undefined">

<cfquery name="Requisition" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  RequisitionLine 
	WHERE RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="Funding" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  RequisitionLineBudget 
	WHERE RequisitionNo = '#URL.ID#'
</cfquery>

<!--- added for not defined object code --->
<cfif url.objectcode eq "undefined">
   <cfset url.objectcode = "">
</cfif>

<!--- clear for object code --->

<cfquery name="ClearObject" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE FROM RequisitionLineBudget 
	WHERE  RequisitionNo = '#URL.ID#'
	AND    ObjectCode NOT IN (SELECT Code FROM Program.dbo.Ref_Object)
</cfquery>

<cfparam name="url.archive" default="0">

<cfquery name="Parameter" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT * 
	FROM Ref_ParameterMission
	WHERE Mission = '#Requisition.Mission#' 
</cfquery>

<cfif (Parameter.FundingByReviewer eq "1" and url.archive eq "0" and Requisition.actionStatus lt "3")
     or Funding.recordcount eq "0">

	<cfinvoke component="Service.Access"  
	  method   = "ProcRole" 
	  mission  = "#Requisition.mission#"
	  orgunit  = "#Requisition.OrgUnit#" 
	  role     = "'ProcReqReview'"
	  returnvariable="accessreq">

	<cfif accessreq eq "EDIT" or accessreq eq "ALL">
		<cfset url.access = "edit">
	</cfif>
		
</cfif>

<!--- buyer has send it back --->

<cfif Requisition.JobNo neq "" and getAdministrator("*") eq "0">
	<cfset url.access = "view">
</cfif>

<cfif Parameter.enforceObject eq "0">
	<cfset URL.Object = "">
</cfif>

<cfparam name="URL.Object"  default="">
<cfparam name="URL.Perc"    default="1">
<cfparam name="URL.Clear"   default="">
<cfparam name="URL.Action"  default="">

<cfif url.action eq "del">

	<cfquery name="delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	DELETE 
		FROM  RequisitionLineBudget
		WHERE BudgetId = '#URL.BudgetId#' 
	</cfquery>

</cfif>

<!--- ---------------------------- --->
<!--- Process selection in budget- --->
<!--- ---------------------------- --->

<cfquery name="Clear" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    DELETE FROM RequisitionLineBudget
	WHERE  RequisitionNo = '#URL.ID#' 
	AND    Percentage = 0 
</cfquery>	

<cfquery name="Funding" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT F.*, O.Description
    FROM   RequisitionLineBudget F, 
	       Program.dbo.Ref_Object O 
	WHERE  RequisitionNo = '#URL.ID#'
	AND    F.ObjectCode = O.Code
</cfquery>

<cfquery name="Budget" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT F.*, P.ProgramCode as ProgramNo, O.Description, P.ProgramName
	
	FROM   RequisitionLineBudget F INNER JOIN
           Program.dbo.Ref_Object O ON F.ObjectCode = O.Code LEFT OUTER JOIN
           Program.dbo.Program P ON F.ProgramCode = P.ProgramCode		
  
	WHERE RequisitionNo = '#URL.ID#'	
	ORDER BY F.Created 
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#Requisition.Mission#' 
</cfquery>

<cfquery name="Percentage" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT sum(Percentage) as Percentage
    FROM   RequisitionLineBudget F
	WHERE  RequisitionNo = '#URL.ID#'
</cfquery>

<cfif Percentage.Percentage neq "" and Percentage.Percentage neq "1">

    <!--- auto correction --->
	
	<cfif Budget.BudgetId neq "">
		
			<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequisitionLineBudget
				SET Percentage = Percentage+(1-#Percentage.Percentage#)  
				WHERE BudgetId = '#Budget.BudgetId#' 
			</cfquery>
				
	</cfif>	
					
	<cfquery name="Budget" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT F.*, 
			      O.Description,
				  P.ProgramCode as ProgramNo, 
				  P.ProgramName
				  
			 FROM  RequisitionLineBudget F INNER JOIN
                  Program.dbo.Ref_Object O ON F.ObjectCode = O.Code LEFT OUTER JOIN
                  Program.dbo.Program P ON F.ProgramCode = P.ProgramCode
			
			WHERE RequisitionNo   = '#URL.ID#'
			
	</cfquery>
		
<cfelse>

<cfif percentage.percentage neq "">
	<cfset url.perc = 1-#Percentage.Percentage#>
</cfif>

</cfif>

<cf_tl id="Save" var="1">
<cfset vsave=lt_text>		
   
<table border="0" 
   bordercolor="silver" 
   width="100%" 
   cellspacing="0" 
   cellpadding="1"
   class="formpadding">
   
   	  <tr class="hide"><td id="budgetlinebox"></td></tr>
	    
	  <tr>
	  	  
	    <cfif URL.Access eq "Edit" or getAdministrator(requisition.mission) eq "1">
	  
	  		<cfif budget.recordcount eq "0">
			<td class="labelmedium" style="padding-left:2px">
			<cfelse>
		    <td width="30" class="labelmedium" style="padding-left:2px">		
			</cfif>
							
					<cfoutput>	
					 <img src="#SESSION.root#/Images/search.png" alt="Select budget" name="img4" 						 
						  style="cursor: pointer;border-radius:5px" alt="" width="22" height="22" border="0" align="absmiddle" 
						  onClick="bd(period.value)">
					</cfoutput>	  
						
				<cfif budget.recordcount eq "0">
				 &nbsp;<a href="javascript:bd()"><font color="0080C0">[<cf_tl id="Press to select from internal budget">]</a></font>
				</cfif>
						
			<td>
			
		</cfif>
	    
	    <td>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="1" class="formpadding">
							
		<cfoutput>
		
			<cfloop query="Budget">
			
			<cfset fd  = Fund>
			<cfset obj = ObjectCode>
			<cfset per = URL.Per>
					
			<TR class="labelit" height="17" bgcolor="ffffff">
				   <td width="50">#Fund#</td>
				   <td width="20%">#ProgramNo#&nbsp;#ProgramName# </td>
				   <td width="40%">#ObjectCode# #Description# </td>
				   <td width="50">#Percentage*100#%</td>
				   
				   <td width="30%" style="cursor:pointer">
				   
					   <table width="100%" cellspacing="0" cellpadding="0">
					   
					   <tr>
					   
					   <!--- check on the role --->
					   
					   <td class="labelit">
					   
					   <cfinvoke component = "Service.Access"  
						   method           = "ProcRole" 
						   orgunit          = "#Requisition.OrgUnit#" 
						   mission          = "#Requisition.Mission#"
						   role             = "'ProcReqObject'"
						   returnvariable   = "access">			
						   						   
						 <cfif (Access eq "EDIT" or Access eq "ALL")>  
					         <cf_UItooltip tooltip="If you unselect the amount will not be charge to the budget">
					          <input type="checkbox" 
					           onclick="ColdFusion.navigate('RequisitionEntryBudgetStatus.cfm?id=#budgetid#&action='+this.checked,'budgetlinebox')"
					           value="1" <cfif status eq "1">checked</cfif>><cf_tl id="Charge to budget">
					         </cf_UItooltip>
					       <cfelse>
					         <cfif status eq "1"><font color="6688aa"><cf_tl id="ChargeBudget"><cfelse><font color="gray"><cf_tl id="NotChargeBudget"></cfif>
					       </cfif>  
						 
					   </td>   
					   					   				   
					   <td width="30">
					   
						   <cfif budget.recordcount gte "2">
						   
						      <cf_img icon="delete" onclick="budget('','#BudgetId#','del')">				   
					
						   </cfif>
					  
					   </td>
					   
					   </tr>
					   </table>
				   
				   </td>
				  				   
			</TR>	
					
			<cfif currentRow neq Recordcount>
				<tr><td height="1" colspan="6" class="linedotted"></td></tr>		
			</cfif>
			
			</cfloop>
			
		</cfoutput>		
		
		</table>		
		</td>
		</tr>		
	   							
</table>	
	