

<!--- show relevant options --->

<script>
	 document.getElementById('filtercontent').className = "regular"
</script>

<cfparam name="url.mandate" default="">
<cfparam name="man" default="#url.mandate#">

<cfinvoke component="Service.AccessGlobal"  
	   Method="global" 
	   Role="AdminProgram" 
	   Returnvariable="GlobalAccess">
		
<cfinvoke component="Service.Access"
	   Method="Organization"
	   Mission="#URL.Mission#"
	   Role="ProgramOfficer', 'ProgramManager', 'ProgramAuditor"
	   ReturnVariable="MissionAccess">		   
					   			
<cfset CLIENT.ShowReports = "YES">

<cfquery name="getDate" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
		  FROM   Ref_Period
		  WHERE  Period = '#url.period#'					 
 </cfquery>  	

<cfform>

<cfset seldate = dateformat(getDate.DateExpiration,client.dateformatShow)>


	
<cfif GlobalAccess neq "NONE" OR MissionAccess eq "READ" OR MissionAccess eq "EDIT" or MissionAccess eq "ALL">
		 
 	   <cf_UItree name="idtree" format="html" required="No">
		   <cf_UItreeitem 
			  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.mission#','#man#','#session.root#/ProgramREM/Application/Program/ProgramView/ProgramViewOpen.cfm','PRG','#url.mission#','#url.mission#','#man#','','Full','0','&systemfunctionid!#url.systemfunctionid#','#seldate#')">  		 
	   </cf_UItree>		

<cfelse>
	
	    <cf_UItree name="idtree" format="html" required="No">
			<cf_UItreeitem 
			  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.mission#','#man#','#session.root#/ProgramREM/Application/Program/ProgramView/ProgramViewOpen.cfm','PRG','#url.mission#','#url.mission#','#man#','','role','0','&systemfunctionid!#url.systemfunctionid#','#seldate#')">  		 
       </cf_UItree>		
    
</cfif> 

</cfform>
