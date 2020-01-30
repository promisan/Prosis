 
<!--- define the total for each unit --->
 
<cfquery name="Check" 
      datasource="AppsQuery" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT *
      FROM   #SESSION.acc#PositionSum P
	  WHERE  P.OrgUnit = '#org#' 
</cfquery>
   
<cfoutput>  	
	  
   <cfif Check.post gt 0>
	   
    <cfif find(org, CLIENT.OrgUnitS)>
  		  <img src="../../../../Images/zoomout.jpg" alt="" border="0" align="middle" style="cursor: pointer;" onClick="javascript: zoomForm('del','#org#')">
    <cfelse>	
  		  <img src="../../../../images/zoomin.jpg" alt="" style="cursor: pointer;" border="0" align="middle" onClick="javascript: zoomForm('add','#org#')">
	</cfif>
			
   </cfif>
					
   <a name="#Org#" href="javascript:editOrgUnit('#Org#')">
       <img src="../../../../Images/view.gif" alt="" width="16" height="15" border="0" align="middle" onDblClick="javascript:">
   </a>
   
</cfoutput> 