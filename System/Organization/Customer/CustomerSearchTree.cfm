
<cfoutput>

<cfquery name="Param" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT  *
      FROM    Ref_ParameterMission
   	  WHERE   Mission = '#URL.Mission#' 	 
</cfquery>

<cfquery name="Mandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT    *
      FROM     Ref_Mandate
   	  WHERE    Mission = '#Param.TreeCustomer#' 
	  ORDER BY DateEffective DESC
</cfquery>

<cf_divscroll>

<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding"> 			
	<tr><td colspan="2" id="findme" valign="top">   		
		<cfform>
	
		<cftree name="tree#Mandate.Mandateno#" font="tahoma"  fontsize="11" bold="No" format="html" required="No">
		
			     <cftreeitem 
				  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#Param.TreeCustomer#','#Mandate.Mandateno#','CustomerList.cfm','CUS','#Param.TreeCustomer#','#Param.TreeCustomer#','#Mandate.Mandateno#','#url.dsn#','','0','systemfunctionid!#url.systemfunctionid#')">  		 
				  
	    </cftree>	
			
		</cfform>		
	</td></tr>
</table>
</cf_divscroll>

</cfoutput>

<script>
 document.getElementById('boxlistcustomer').className = "regular"
</script>
