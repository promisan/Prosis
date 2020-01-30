
<cfparam name="URL.ID1" default="0">

<script>

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 	 	 		 	
	 if (fld != false){
		 itm.className = "highLight4";
	 }else{		
	     itm.className = "regular";		
	 }
  }

</script>

<cfparam name="URL.Domain" default="Assignment">

<cfquery name="GroupAll" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
		SELECT F.*, S.PositionNo
		FROM   PersonAssignmentGroup S RIGHT OUTER JOIN Ref_Group F ON S.AssignmentGroup = F.GroupCode 
		   AND S.AssignmentNo = '#URL.ID1#' 
		   AND S.Status <> '9'
	
		WHERE  F.GroupCode IN (SELECT GroupCode 
		                       FROM   Ref_Group 
							   WHERE  GroupDomain = '#URL.Domain#')
		 
		<!--- limited by mission --->
		 					   
	    AND    F.GroupCode IN (SELECT GroupCode 
						       FROM   Ref_GroupMission 
							   WHERE  Mission = '#Position.Mission#')
							   
		AND    F.Operational = 1						   
							   
</cfquery>

<cfif groupAll.recordcount eq "0">	

	<cfquery name="GroupAll" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">

		SELECT F.*, S.PositionNo
		FROM   PersonAssignmentGroup S 
		       RIGHT OUTER JOIN Ref_Group F 
			   ON S.AssignmentGroup = F.GroupCode 
		   AND S.AssignmentNo = '#URL.ID1#' 
		   AND S.Status <> '9'
		   
		WHERE  F.GroupCode IN (SELECT GroupCode 
		                       FROM   Ref_Group 
							   WHERE  GroupDomain = '#URL.Domain#')
		AND    F.Operational = 1					   
		
	</cfquery>										

</cfif>				

<cfif groupall.recordcount eq "0">

	<script>
      document.getElementById('classification').className = "hide"
	</script>

</cfif>							
  
<table width="90%" border="0" cellspacing="0" cellpadding="0" align="left">

<tr><td>
	
	<table border="0" width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<cfset row = 0>
					
	<cfoutput query="GroupAll">
	
		<cfset row = row+1>
	
		<cfif row eq "1">
			<tr>
		</cfif>
	    
		<td  style="border:0px dotted silver">
		
			<table border="0" width="100%" cellspacing="0" cellpadding="0">
								
				<cfif PositionNo eq "">
				          <TR class="regular">
				<cfelse>  <TR class="regular">
				</cfif>
		   
				<TD style="padding-left:3px" class="labelmedium">#Description#:</TD>
				<TD align="right" style="padding:3px">
					<cfif PositionNo eq "">
						<input type="checkbox" class="radiol" name="positiongroup" value="#GroupCode#" onClick="hl(this,this.checked)"></TD>
					<cfelse>
						<input type="checkbox" class="radiol" name="positiongroup" value="#GroupCode#" checked onClick="hl(this,this.checked)"></TD>
				    </cfif>	
				</tr>
			
			</table>
		
		</td>
		
		<cfif row eq "4">
			<cfset row = "0">
			<tr>
		</cfif>
			
	</cfoutput>
	
	</table>
	  
</td></tr>

</table>
