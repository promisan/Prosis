
 <cfquery name="Person" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	SELECT TOP 1 Ass.OrgUnit
	FROM   PersonAssignment Ass INNER JOIN
	       Position Pos ON Ass.PositionNo = Pos.PositionNo 
    WHERE  Ass.DateExpiration > GETDATE() 
     AND   Ass.DateEffective <= GETDATE()
	 AND   Ass.AssignmentStatus IN ('0', '1') 
	 AND   Ass.PersonNo = '#URL.PersonNo#'
	ORDER BY Ass.DateEffective 
</cfquery>

<cfoutput>

<script>
		
	w = 0
	h = 0
	if (screen) {
	w = #CLIENT.width# - 55
	h = #CLIENT.height# - 120
	}
	
	function pasdialog(pasid) {
	  window.open("#SESSION.root#/ProgramReM/Portal/Workplan/PAS/PASView.cfm?Code=#URL.Code#&ID=#URL.ID#&PersonNo=#URL.PersonNo#&ContractId="+pasid,"pas","left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=no, scrollbars=no, resizable=yes");
	}
	
	function pasadd() {
	  ColdFusion.navigate('PASEntry.cfm?Period=#URL.Period#&Refresh=1&Code=#URL.Code#&ID=#URL.ID#&PersonNo=#URL.PersonNo#&OrgUnit=#Person.OrgUnit#','detail')
	}
		
	function delegate()	{
	  ColdFusion.navigate('ListingSupervisor.cfm?Period=#URL.Period#&Code=#URL.Code#&ID=#URL.ID#&PersonNo=#URL.PersonNo#&Mode=Edit','detail')
	}
	
	function refresh() {
	  ColdFusion.navigate('ListingSupervisor.cfm?Period=#URL.Period#&Refresh=1&Code=#URL.Code#&ID=#URL.ID#&PersonNo=#URL.PersonNo#&Mode=View','detail')
	}
	
	function showlist()	{	  
	  se = document.getElementById("show")
	  if (se.checked)
	  { val = 1 }
	  else
	  { val = 0 }
	    ColdFusion.navigate('ListingSupervisor.cfm?show='+val+'&Period=#URL.Period#&Code=#URL.Code#&ID=#URL.ID#&PersonNo=#URL.PersonNo#&Mode=View','detail')
	}
		 
	function loadform(itm,cde) {  

	if (itm != "")	{	
    ColdFusion.navigate(itm+'?code='+cde+'&ID=#URL.ID#&personNo=#URL.PersonNo#&Period=#URL.Period#&scope=#URL.scope#','detail')
		}
	}
	
	function period(itm,cde,per) {	
	  if (itm != "")	{	
         ColdFusion.navigate(itm+'?code='+cde+'&ID=#URL.ID#&personNo=#URL.PersonNo#&Period='+per+'&scope=#URL.scope#','detail')
		}
   	 
	}
	
</script>
	
</cfoutput>