
<cfparam name="missionname"      default="">
<cfparam name="number"           default="1">
<cfparam name="hasMissionGlobal" default="">

<cfoutput>

   <cfif hasMissionGlobal neq "" and URL.ID2 neq "">
      <cfset cl = "e5e5e5">	 
   <cfelse>   
      <cfset cl = "transparent">		 
   </cfif>
       
   <td align="center" style="min-width:70px" id="d#ms#_#row#I" bgcolor="#cl#">           
	   <input class="radiol" type="radio" name="#ms#_AccessLevel_#row#" id="#ms#_AccessLevel_#row#" value=""  
	   <cfif AccessLevel eq "">checked<cfelseif hasMissionGlobal neq "" and url.id2 neq "">disabled</cfif>
	   onClick="ClearRow('d#ms#_#row#','I')">   
   </td>
    
   <cfif AccessLevel eq ""> 
	   <script language="JavaScript">
			javascript:d#ms#_#row#I.style.fontWeight='bold';
			javascript:d#ms#_#row#I.style.background='yellow';
	   </script>
   </cfif>
        
   <cfloop index="lvl" from="0" to="#no-1#">
   
 	  	<cfif no eq "2">		
		  <!--- correction as we need here only edit 1 and all 2 ---> 
	      <cfset al = lvl+1>		   
	   <cfelse>
	      <cfset al = lvl>	  
	   </cfif>	
   
	   <td align="center" style="min-width:70px" id="d#ms#_#row##al#" bgcolor="#cl#">
	   	    
		   <input class="radiol" 
		          type="radio" 
				  name="#ms#_AccessLevel_#Row#" 
				  id="#ms#_AccessLevel_#Row#" 
		          value="#al#" 
		   <cfif AccessLevel eq al>checked<cfelseif hasMissionGlobal gte "#al#" and url.id2 neq "">disabled</cfif>
		   onClick="ClearRow('d#ms#_#Row#','#al#')">
		   	   
	   </td>	
	
	   <cfif AccessLevel eq al>
		   <script language="JavaScript">
		    try {
		    document.getElementById("s_#missionname#").className = "regular"
			} catch(e) {}
			javascript:d#ms#_#Row##al#.style.fontWeight='bold';
			javascript:d#ms#_#Row##al#.style.background='yellow';
		   </script>
	   </cfif>	  
   
   </cfloop>       
   
   <!--- pass the mission as a parameter 
   this option is used for granting access to a certain mission
  --->
   
   <cfif Role.MissionAsParameter eq "1">
        
	   <cfset selmis = mission>
		  
	  	<cfif prior neq code>
		
			<cfquery name="Mis" 
				datasource="AppsOrganization"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT Mission
					FROM   Ref_Mission
					WHERE  MissionOwner = '#code#'		
			</cfquery>
				
			<cfset prior = code>
		
		</cfif>
		
		<cfif accesslevel eq "">
		  <cfset cl = "hide">
		<cfelse>
		  <cfset cl = "regular">
		</cfif>
	  
	  	<td style="min-width:70px" bgcolor="#cl#">
		
		  <select style="width:100;font:10px" 
		          class="regularxl" id="d#ms#_#Row#_mis" class="#cl#" 
				  name="#ms#_Mission_#Row#">
				  
				  <option value="" selected>Global</option>
				  <cfloop query="Mis">
				  	<option value="#mission#" <cfif Mission eq selmis>selected</cfif>>#Mission#</option>
				  </cfloop>
				  
		  </select>
		   
		</td>
		  
  </cfif>   
	   
</cfoutput>	   		  
	