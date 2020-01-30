
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

<table width="100%" 
      border="0" 
	  align="center" 
	  cellspacing="0" 
	  cellpadding="0" 
	  class="navigation_table">

<cfoutput query="Summary">
		   
	<cfif counted gt "0">
				
		<cfif description eq "">
			<cfset desc = "<font color='FF0000'>Tracks no longer open">
		<cfelse>
			<cfset desc = Description>	
		</cfif>
					
		<tr class="labelmedium">
		
			<cfif description neq "">
		  
			  	<cfif URL.mode neq "Print">
				
				    <td width="4%" height="20" align="center">
				 
					<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
						id="d#URL.Mission##currentrow#Exp" border="0" class="show" 
						align="absmiddle" style="cursor: pointer;" 
						onClick="listing('#URL.Mission#','#URL.Mission##currentrow#','#EntityCode#','#Code#')">
						
						<img src="#SESSION.root#/Images/arrowdown.gif" 
						id="d#URL.Mission##currentrow#Min" alt="" border="0" 
						align="absmiddle" class="hide" style="cursor: pointer;" 
						onClick="listing('#URL.Mission#','#URL.Mission##currentrow#','#EntityCode#','#Code#')">
						
					</td>
				</cfif>
				
			<cfelse>
			
				<td></td>	
			
			</cfif>
			
			<td colspan="2" style="height:32px;font-size:17px">										
					
				<cfif code neq "0">
				
					<a href="javascript:listing('#URL.Mission#','#URL.Mission##currentrow#','#EntityCode#','#Code#')">#Desc# (#counted#)</a>
				
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
						<a href="javascript:showdocument('#DocumentNo#','')"><font color="0080C0">#documentno#</a>
						<cfif currentrow neq recordcount>,</cfif>
					</cfloop>
					
				</cfif>	
									
			</td>
			
		 </tr>
		 		 
		 <cfif currentrow neq recordcount>
		 
		 	<tr><td colspan="3" class="line"></td></tr>
			
		 </cfif>			 
		 
		<!--- content box, better to make each line hide/show --->  		
		<tr class="<cfif URL.mode neq 'Print'>hide</cfif>" id="d#URL.Mission##currentrow#">
		
			<td colspan="6" style="padding-left:38px">												
				<cfinclude template="ControlListingResultStepDetail.cfm">										
		    </td>
			
		</tr>
	
	</cfif>
			   			
</cfoutput>
	
</table>	