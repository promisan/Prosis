
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

<cfquery name="ClassAll" 
datasource="AppsProgram" 
username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT F.*, 
	       A.ProgramCode as Selected
	FROM   Ref_ActivityClass F LEFT OUTER JOIN
           ProgramActivityClass A ON F.Code = A.ActivityClass AND A.ActivityId = '#URL.ActivityID#'	   	
	WHERE  F.Code IN (SELECT Code 
	                  FROM   Ref_ActivityClassMission 
					  WHERE  Mission = (SELECT Mission FROM Program WHERE ProgramCode = '#url.ProgramCode#'))	   
</cfquery>	
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">

<tr><td>
	
	<table width="100%" cellspacing="0" cellpadding="0">
	
	<cfset rows = 0>
	<cfparam name="cnt" default="0">
		
	<cfoutput query="ClassAll">
															
		<cfif rows eq "3">
			    <TR>
				<cfset rows = 0>
				<cfset cnt = cnt+27>
		</cfif>
					
		    <cfset rows = rows + 1>
				<td width="25%">
				<table width="100%" cellspacing="0" cellpadding="0">
					<cfif Selected eq "">
					          <TR class="regular">
					<cfelse>  <TR class="highlight4">
					</cfif>
					<td width="20" align="left" height="20" style="padding-left:0px">
				    <cfif Selected eq "">
						<input type="checkbox" class="radiol" style="width:15px;height:15px" name="ActivityClass" value="#Code#" onClick="hl(this,this.checked)"></td>
					<cfelse>
						<input type="checkbox" class="radiol" style="width:15px;height:15px" name="ActivityClass" value="#Code#" checked onClick="hl(this,this.checked)"></TD>
				    </cfif> 
					<td class="labelmedium" style="padding-left:4px">#Description#</td>
				</table>
				</td>
				<cfif ClassAll.recordCount eq "1">
	 					<td width="25%" class="regular"></td>
				</cfif>
			
		</CFOUTPUT>
	
	</table>
  
</td></tr>

</table>
