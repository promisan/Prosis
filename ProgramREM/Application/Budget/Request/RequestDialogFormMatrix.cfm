

<!--- apply labels --->

<cfquery name="Master" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ItemMaster
		WHERE     Code = '#url.itemmaster#'
</cfquery>

<cfset row = 0>
<cfloop index="itm" list="#master.BudgetLabels#" delimiters="|">
   <cfset row = row+1>
      <cfset lbl[row] = itm>
</cfloop>
<cfparam name="lbl[1]" default="Item">
<cfparam name="lbl[2]" default="Quantity">
<cfparam name="lbl[3]" default="Memo">

<cf_tl id="#lbl[1]#" var="label_itm">
<cf_tl id="#lbl[2]#" var="label_qty">
<cf_tl id="#lbl[3]#" var="label_mem">

<cfoutput>

	<script>			
		try { document.getElementById('labelmemo').innerHTML = '#label_mem#:' } catch(e) {}		
	</script>
	
</cfoutput>	

<cfquery name="Mode" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ItemMasterObject
		WHERE     ItemMaster  = '#url.itemmaster#'
		AND       ObjectCode  = '#url.objectcode#'
</cfquery>

<cfquery name="Request" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ProgramAllotmentRequest
		WHERE     RequirementId  = '#url.requirementid#' 		
</cfquery>

<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_Period
		WHERE     Period = '#url.period#' 	
  </cfquery>		
			   
 <cfquery name="Closure" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    MAX(RequirementDate) as RequirementStart
		FROM      Ref_AllotmentEditionFundObject
		WHERE     Editionid       = '#url.EditionId#' 	
		AND       ObjectCode      = '#url.objectcode#'
		AND       Fund            = '#url.fund#'
		AND       RequirementDate > '#Period.DateEffective#' 
		AND       RequirementEntryMode = 0 <!--- only if explicitly disabled, if value = 1 we still allow the entry  --->
		AND       Operational     = 1	
</cfquery>	

<cfinvoke component="Service.Access"  
	Method         = "budget"
	ProgramCode    = "#url.Programcode#"
	Period         = "#url.period#"		
	EditionId      = "#url.editionid#" 			
	Role           = "'BudgetManager'"
	ReturnVariable = "BudgetManagerAccess">		

<!--- safeguard only --->	
<cfquery name="LastDate" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    MAX(R.AuditDate) AS Date
	FROM      Ref_Audit R 
	WHERE     Period = '#url.period#'		
</cfquery>		

<!--- added 25 July 2014 --->

<cfsavecontent variable="filterdates">

	<cfoutput>

	<!--- we filter for the periods --->
	
	<cfif BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL" or closure.RequirementStart eq "">
		
		<!--- no filtering --->
	
	<cfelseif Request.requirementid eq "">
	
		<!--- new requirement we only show dates after the last closure date --->		
		AND    (
		       AuditDate >= '#dateformat(Closure.RequirementStart,CLIENT.DateSQL)#' 
		       OR 
		       AuditDate = '#dateformat(LastDate.Date,CLIENT.DateSQL)#'
			   ) 
	<cfelse>	
	
		<cfquery name="CurrentStart" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">				
		SELECT    MIN(R.AuditDate) AS Date
		FROM      ProgramAllotmentRequestQuantity PARQ INNER JOIN
           	      ProgramAllotmentRequest PAR ON PARQ.RequirementId = PAR.RequirementId INNER JOIN
                  Ref_Audit R ON PARQ.AuditId = R.AuditId
		WHERE     PAR.RequirementIdParent = '#entry.requirementidparent#'			
		</cfquery>		
	
		<cfif CurrentStart.date lt closure.requirementStart>
		
			<!--- edit requirement we only show dates after the current start date --->		
			AND    AuditDate >= '#dateformat(CurrentStart.Date,CLIENT.DateSQL)#'
		
		<cfelse>
		
			AND    (
		       AuditDate >= '#dateformat(Closure.RequirementStart,CLIENT.DateSQL)#' 
		       OR 
		       AuditDate = '#dateformat(LastDate.Date,CLIENT.DateSQL)#'
			   ) 
		
	    </cfif>
					
	</cfif>			

	</cfoutput>
	
</cfsavecontent>

<cfquery name="Dates" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    A.*
		FROM      Ref_Audit A
		WHERE     A.Period = '#url.period#'		
		#preserveSingleQuotes(filterdates)#		
		ORDER BY  DateYear, AuditDate 
</cfquery>


<cfif Dates.recordcount eq "0">

	<table width="100%" style="border:1px dotted silver" bordercolor="e4e4e4" width="100%" align="center">
		<tr><td align="center" class="labelmedium" height="50"><i>
			<font color="FF0000">Problem, no audit entry dates recorded for this period</font>
			</td>
		</tr>
	</table>

<cfelse>
	
	<cfoutput>
	
	<table width="100%" cellspacing="0" cellpadding="0">
	
	<tr><td style="border:1px solid silver">
		
	<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
	
	<!--- ajax calculation box --->
	
	<tr class="hide"><td id="ctotal"></td></tr>
	
	<tr>
	
	<td id="labelitem" rowspan="2" style="border-right:1px solid silver;padding-left:8px;padding-top:4px" valign="top" class="labelmedium">#label_itm#</td>
	
		 <cfset prior = year(dates.auditdate)>
		 <cfset cnt = 0>
		 
		 <cfloop query="dates">
		 
			 <cfif year(auditdate) neq prior or dates.recordcount eq currentrow>      
				 <td style="border-bottom:1px dotted silver;height:20;padding-left:4px" class="labelit" colspan="#cnt+1#">#prior#</td>	 
				 <cfset prior = year(auditdate)>
				 <cfset cnt = 2>
			 <cfelse>
			     <cfif currentrow eq "1">
			       <cfset cnt = cnt+2>	 
				 <cfelse>
				   <cfset cnt = cnt+1>
				 </cfif>
			 </cfif>
	
		 </cfloop>
		 
	 <td colspan="3" style="border-bottom:1px dotted silver;padding-left:4px" class="labelit"><cf_tl id="Costing"></td>
	 
	</tr>
	
	<tr>	
	
	<cfloop query="dates">
	 
	  <td align="center" bgcolor="e4e4e4" style="padding-top:0px;font-size:10px;border-top:1px solid silver" class="labelit">#dateformat(AuditDate,"MMM")#
	    <cf_space spaces="4">   
	  </td>
	  
	  <cfif currentrow eq "1">
	  <td style="border-top:1px solid silver" bgcolor="f4f4f4" ></td>
	  </cfif>
	  
	</cfloop>
	 
	<td style="border-top:1px solid silver;font-size:10px" bgcolor="ffffaf" align="center" class="labelit">
	   <cf_space spaces="7"><cf_tl id="Sum">
	</td>
	<td style="border-top:1px solid silver;font-size:10px" height="17" colspan="2" bgcolor="ffffaf" align="center" class="labelit">
	  <cf_space spaces="31">
	  <cf_tl id="Base Cost">
	</td>
		
	</tr>

		
	<cfif mode.BudgetEntryPosition eq "0">		
			<cfinclude template="RequestDialogFormMatrixItemMaster.cfm">		
	<cfelse>		
		<cfinclude template="RequestDialogFormMatrixPosition.cfm">	
	</cfif>	
		
	<!--- ------------ --->
	<!--- column total --->
	<!--- ------------ --->
	
	<tr>
	 <td style="padding-left:10px;border-top:1px solid silver;" colspan="1" class="labelit"><cf_tl id="Subtotal"></td>
	 
		 	 
	  <cfloop query="dates">
	  
	  		<cfquery name="getTotal" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    A.*, 
	 				         (SELECT SUM(PQ.RequestQuantity)
							  FROM  ProgramAllotmentRequestQuantity PQ, ProgramAllotmentRequest R 
							  <cfif Request.RequirementIdParent neq "">
							  WHERE R.RequirementIdParent = '#Request.RequirementIdParent#' 
							  <cfelse>
							  WHERE 1=0
							  </cfif>
							  AND    R.RequestType = 'Standard'
							  AND    R.RequirementId = PQ.RequirementId
							  AND    PQ.AuditId = A.AuditId) as Total
					FROM      Ref_Audit A		  
					WHERE     A.Period = '#url.period#'		  
					ORDER BY  DateYear, AuditDate 
			</cfquery>	
	     
			 <cfset row = currentrow>
		     
			 <td height="17" bgcolor="ffffdf" style="border-top:1px solid silver;border-left:1px solid silver">
			 	 
		       <cf_space space="4"> 	
			     
		       <input type="input"  
			       class="button3" 
				   readonly 
				   style="font-size:13px;padding-top:2px;text-align:center;width:100%" 
				   id="rtotal_#row#" 
				   name="rtotal_#row#" 
				   value="<cfoutput>#getTotal.Total#</cfoutput>">
		     </td>
			 
			 <cfif currentrow eq "1">
			  	<td bgcolor="FDE8CC" style="border-top:1px solid silver;border-left:1px solid silver"><cf_space spaces="7"></td>
			 </cfif>
		 
	  </cfloop>
	
	  <td bgcolor="ffffaf" align="right" style="padding-right:2px;border-top:1px solid silver;border-left:1px solid silver;padding-right:4px;border-right:1px solid silver">
	  	  
		    <cfquery name="getTotal" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
			      SELECT SUM(PQ.RequestQuantity) as Total
				  FROM   ProgramAllotmentRequestQuantity PQ, ProgramAllotmentRequest R 
				   <cfif Request.RequirementidParent neq "">
				  WHERE  R.RequirementIdParent = '#Request.requirementidParent#' 
				  <cfelse>
				  WHERE 1=0
				  </cfif>
				  AND    R.RequestType = 'Standard'
				  AND    R.RequirementId = PQ.RequirementId
				  AND    R.Period = '#url.period#'				 
			 </cfquery>	

		     <input type="text" readonly 
				 style  = "background-color:transparent;height:25px;font-size:14px;border:0px;padding-top:2px;padding-right:2px;text-align:right;width:98%" 
				 name   = "overalltotal" 
				 id     = "overalltotal" 
				 value  = "#numberformat(getTotal.total,',__')#"
				 class  = "regular">
			 
	  </td>
	  
	  <td colspan="2" style="padding-right:2px;border-top:1px solid silver;border-left:1px solid silver"></td>
	  
	</tr>		
	 
	</table>
	
	</td>
	
	</tr>
	
	</table>
	
	<input type="hidden" name="AuditIds" value="#quotedvalueList(Dates.Auditid)#">
	
	</cfoutput>
	
</cfif>	

<cfset ajaxonload("doHighlight")>



 
