
<cfoutput>

<script>
	
	function listing(mission,box,ent,code) {
			
		icM  = document.getElementById("d"+box+"Min")
	    icE  = document.getElementById("d"+box+"Exp")
		se   = document.getElementById("d"+box);
		frm  = document.getElementById("i"+box);
		 		 
		if (se.className=="hide") {
		 	 icM.className = "regular";
		     icE.className = "hide";
	    	 se.className  = "regular";
			
		 } else {
		   	 icM.className = "hide";
		     icE.className = "regular";
			 se.className  = "hide"	 
		 }		 		
	  }
  
</script>  

</cfoutput>


<table width="100%" class="navigation_table">

 <tr class="line labelmedium fixrow">
   <td style="min-width:40"></td>
   <td><cf_tl id="Class"></td>
   <td><cf_tl id="Track"></td>
   <td><cf_tl id="Due"></td>
   <td><cf_tl id="VA"></td>
   <td><cf_tl id="Grade">/<cf_tl id="Candidate"></td>
   <td><cf_tl id="Position"></td>		       
   <td><cf_tl id="Title"></td>
   <td><cf_tl id="Office"></td>	   
   <td><cf_tl id="Officer"></td>	   
  </tr>		

<cfoutput query="Summary">
		   
	<cfif counted gt "0">
				
		<cfif description eq "">
			<cfset desc = "<font color='FF0000'>Tracks no longer open">
		<cfelse>
			<cfset desc = Description>	
		</cfif>
					
		<tr class="labelmedium">

			<cfset vOpenDetail = "$('.cls#URL.Mission##currentrow#').toggle(); $('.clsIcon#URL.Mission##currentrow#').toggleClass('fa-caret-circle-down').toggleClass('fa-caret-circle-up');">
		
			<cfif description neq "">
		  
			  	<cfif URL.mode neq "Print" AND EntityCode neq "">
				
				    <td width="4%" height="20" align="center">
						<i class="fas fa-caret-circle-down clsIcon#URL.Mission##currentrow#" 
							style="font-size:18px; color:##A5A5A5; cursor:pointer;" 
							onclick="#vOpenDetail#">
						</i>
					</td>
				</cfif>
				
			<cfelse>
			
				<td></td>	
			
			</cfif>
			
			<td colspan="8" style="height:32px;font-size:17px">										
					
				<cfif code neq "0">
				
					<a href="javascript:#vOpenDetail#">#Desc# (#counted#)</a>
				
				<cfelse>
				
					#Desc# <font size="2">(#counted#)</font>
								
					<cfquery name="get"
					datasource="AppsQuery"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">	
						SELECT * 
						FROM   (#preservesingleQuotes(SelectedTracks)#) as T
						WHERE  ActionCode is NULL
					</cfquery>		

					<cfloop query="get">
						<a href="javascript:showdocument('#DocumentNo#','')">#documentno#</a>
						<cfif currentrow neq recordcount>,</cfif>
					</cfloop>
					
				</cfif>	
									
			</td>
			
		 </tr>
		 		 
		 <cfif currentrow neq recordcount>
		 
		 	<tr><td colspan="13" class="line"></td></tr>
			
		 </cfif>			 
	
		<cfset row = currentrow>														
		<cfinclude template="ControlListingResultStepDetail.cfm">
	
	</cfif>
			   			
</cfoutput>
	
</table>	