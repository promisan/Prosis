
<cfquery name="Period" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Ref_MissionPeriod
	  WHERE  Mission = '#URL.Mission#'
	  AND    Period  = '#URL.Period#' 
  </cfquery>
 
  <cfif Period.MandateNo eq "">
  	
    <cf_message message="Please define mandate" return="no">
	<cfabort>
  
  </cfif>

<cfquery name="Parameter" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM Parameter
  </cfquery>
  
<cfparam name="CLIENT.ProgramMode" default="Maintain">  

<cfset Criteria = ''>
     
<table width="100%">
	
     <tr>
        <td style="padding-left:4px"> 
	
		<cfinvoke component="Service.AccessGlobal"  
		      method="global" 
			  role="AdminProgram" 
			  returnvariable="GlobalAccess">
			
		<cfinvoke component="Service.Access"
			   Method="Organization"
			   Mission="#URL.Mission#"
			   Role="ProgramOfficer', 'ProgramManager', 'ProgramAuditor"
			   ReturnVariable="MissionAccess">	
						   			
		<cfset CLIENT.ShowReports = "YES">
		
		<CFIF GlobalAccess neq "NONE" 
		     OR MissionAccess eq "READ" OR MissionAccess eq "EDIT" or MissionAccess eq "ALL">
			 
			 	<cf_UItree name="idtree" bold="No" format="html" required="No">
				     <cf_UItreeitem
					  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.mission#','#Period.MandateNo#','ProgramListing.cfm','PRA','Operational Structure','#url.mission#','#Period.MandateNo#','#url.period#','Full')">  		 
			    </cf_UITree>		
	
	    <cfelse>
		
				<cf_UItree name="idtree" bold="No" format="html" required="No">
				     <cf_UItreeitem
					  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.mission#','#Period.MandateNo#','ProgramListing.cfm','PRA','Operational Structure','#url.mission#','#Period.MandateNo#','#url.period#','role')">  		 
			   </cf_UITree>	
	     
		</cfif>
		
	 </td>
	 </tr>
      	  
</table>

