
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
  
  	<cf_waitEnd>
	
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

<cfform>
 
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
   
  <tr><td valign="top">
    
    <table width="100%" border="0" cellspacing="0" cellpadding="0"  class="formpadding">
	
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
			 
				 	<cftree name="idtree" font="tahoma"  fontsize="11" bold="No" format="html" required="No">
					     <cftreeitem 
						  bind="cfc:service.Tree.OrganizationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#url.mission#','#Period.MandateNo#','ProgramListing.cfm','PRA','Operational Structure','#url.mission#','#Period.MandateNo#','#url.period#','Full')">  		 
				    </cftree>		
	
	    <cfelse>
		
					<cftree name="idtree" font="tahoma"  fontsize="11" bold="No" format="html" required="No">
					     <cftreeitem 
						  bind="cfc:service.Tree.OrganizationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#url.mission#','#Period.MandateNo#','ProgramListing.cfm','PRA','Operational Structure','#url.mission#','#Period.MandateNo#','#url.period#','role')">  		 
				    </cftree>	
	     
		</cfif>
		
	 </td></tr>
    	  
	   <tr>
        <td height="3"></td>
      </tr>
			  
    </table></td>
  </tr>
  
</table>

</cfform>
