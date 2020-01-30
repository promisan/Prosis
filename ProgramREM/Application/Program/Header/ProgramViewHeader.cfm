<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="header" default="0">
<cfparam name="url.output" default="">
<cfparam name="URL.Mission" default="">

<cfif header eq "0">
	<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">
	<link href="../../../print.css"                                 rel="stylesheet" type="text/css" media="print">
</cfif>

<!--- get user Authorization level for adding programs --->

<cf_dialogmail>

<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM Parameter
</cfquery>

<cfquery name="Param" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ParameterMission
		WHERE    Mission = '#URL.Mission#'
</cfquery>

<cfquery name="CheckMission" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   *
		 FROM     Organization.dbo.Ref_EntityMission 
		 WHERE    EntityCode     = 'EntProgram'  
		 AND      Mission        = '#url.Mission#' 
</cfquery>

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  P.*, O.OrgUnitName as OrganizationName, 
        Pe.OrgUnit, 
		O.Mission, 
		O.OrgUnitCode, 
		Pe.Reference, 
		Pe.PeriodParentCode,
		Pe.PeriodHierarchy,
		Pe.ReferenceBudget1,
		Pe.ReferenceBudget2,
		Pe.ReferenceBudget3,
		Pe.ReferenceBudget4,
		Pe.ReferenceBudget5,
		Pe.ReferenceBudget6,
		Pe.Period, 
		Pe.ProgramManager, 
		Pe.ProgramId,
		Pe.RecordStatus,
		Pe.Status
FROM    #CLIENT.LanPrefix#Program P, Organization.dbo.#CLIENT.LanPrefix#Organization O, ProgramPeriod Pe
WHERE   Pe.OrgUnit       = O.OrgUnit
AND     P.ProgramCode    = '#URL.ProgramCode#'
AND     Pe.ProgramCode   = P.ProgramCode
AND     Pe.Period        = '#URL.Period#'
</cfquery>

<cfif Program.ProgramClass eq "Project">

	<cfset text = "Project">

<cfelse>

	<cfset lev = 0>
	<cfset pos = 0>
	<cfloop index="i" from="1" to="3" step="1">
	    <cfset pos = Find(".", "#Program.PeriodHierarchy#" , "#pos#")>
		<cfif pos neq "0">
		 	<cfset lev = lev + 1>
			<cfset pos = pos + 1>
		<cfelse> <cfset pos = "99">	
		</cfif>
	</cfloop>
	
	<cfswitch expression="#lev#">
	
		<cfcase value="0"><cfset text = "#Param.TextLevel1#"></cfcase>
		<cfcase value="1"><cfset text = "#Param.TextLevel2#"></cfcase>
		<cfcase value="2"><cfset text = "Program component"></cfcase>
		<cfcase value="3"><cfset text = "Program component"></cfcase>
	
	</cfswitch>

</cfif>

<cf_DialogREMProgram>
<cf_dialogOrganization>
<cf_FileLibraryScript>

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><td style="height:40px">

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  
	<!--- Header ---->
	 
	<tr class="noprint clsNoPrint">
	
		<td height="28" class="labellarge">
		<cfoutput>
		#Text#: #Program.ProgramCode# 
		<cfif Len(Program.ProgramName) gt 50>
		#Left(Program.ProgramName, 50)#...
		<cfelse>
		#Program.ProgramName#
		</cfif>
		</b></font></cfoutput>
		</td>
		
	<!--- Header buttons ---->
	
	<cfoutput>
	
	<cfinvoke component="Service.Access"
		Method="program"
		ProgramCode="#URL.ProgramCode#"
		Period="#URL.Period#"	
		ReturnVariable="ProgramAccess">	
		
		<td height="26" colspan="2" align="right" class="noprint clsNoPrint" id="recordstatus">
	
			<table align="right" class="formspacing">
			
			<tr>	
					
		  	<!--- show only if user had suffcient rights --->
		  
		    	<cf_tl id="Refresh" var="1">
		    	<cfset vPrint = lt_text>
	
				<cfoutput>
		    	<td>				
					<input type="button" 
						class="button10g" 
						style="height:27;width:110;" 
						name="#vPrint#" 
						value="#vPrint#" 
						onClick="history.go()">
				</td>
				</cfoutput>
			
				<cfif ProgramAccess eq "ALL">	
			
			    	<cfif Program.RecordStatus eq "1">
						<cf_tl id="Deactivate" var="1">
					    <td>
							<button name="Delete" 
					 		style="width:170;height:25" 
							type="button"
						 	value="Deactivate" 
						 	class="button10g"
						 	onClick="ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/ProgramDelete.cfm?programcode=#Program.ProgramCode#&period=#URL.Period#','recordstatus')">#lt_text# : #url.period#</button>
						</td>
					<cfelse>
						<td>
							<cf_tl id="Reinstate" var="1">
							<button name="Delete" 
							type="button"
					 		style="width:170;height:25" 
					 		value="Reinstate" 
					 		class="button10g" 
					 		onClick="ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/ProgramReinstate.cfm?programcode=#Program.ProgramCode#&period=#URL.Period#','recordstatus')">#lt_text# : #url.period#</button>
						</td>	
					</cfif>			
				</cfif>
			
				
		</tr>	
			</table>			
		
		</td>
		
		
	  </tr> 
	  
	  </cfoutput>
	  
	  <tr><td colspan="4" class="line"></td></tr>	
	  
	  <tr><td colspan="4">
	  
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  
			  <tr>
			    <td width="100%" colspan="3" id="header">		
				<cfset url.verbose = Param.BudgetAllotmentVerbose>		
				<cfinclude template="ProgramViewHeaderContent.cfm">
				</td>			
			  </tr>
			  		
			  </table>
			  
		  
		  </td>		
		</tr>
		
	</table>
	
	</td>	
	</tr>
	
</table>


   