<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cf_screentop html="No" scroll="Yes" jquery="Yes">

<cfparam name="URL.Source" default="Lookup">

<cfajaximport tags="cfwindow">

<cfoutput>
	
	<script>
		
		function openmap(field)	{			
				val = document.getElementById(field).value	
				if (parent.opener) {
					try { parent.ColdFusion.Window.destroy('mymap',true) } catch(e) {}
					parent.ColdFusion.Window.create('mymap', 'Google Map', '',{x:100,y:100,height:480,width:430,modal:true,resizable:false,center:true})    							
					parent.ColdFusion.navigate('#SESSION.root#/Tools/Maps/MapView.cfm?search=no&field='+field+'&coordinates='+val,'mymap') 		
				} else {
					try { ColdFusion.Window.destroy('mymap',true) } catch(e) {}
					ColdFusion.Window.create('mymap', 'Google Map', '',{x:100,y:100,height:480,width:430,modal:true,resizable:false,center:true})    							
					ColdFusion.navigate('#SESSION.root#/Tools/Maps/MapView.cfm?search=no&field='+field+'&coordinates='+val,'mymap') 	
				}			
		    }
			
	</script>
	
	<script language="JavaScript">
	    	
			function Selected(location,locationcode,locationname,orgunit,orgunitname,personno,name) {
				if (parent.opener) {
					parent.opener.$('##location').val(location);
					parent.opener.$('##locationcode').val(locationcode);
					parent.opener.$('##locationname').val(locationname);
					parent.window.close();					
				} else {
					opener.$('##location').val(location);
					opener.$('##locationcode').val(locationcode);
					opener.$('##locationname').val(locationname);
					window.close();					
				}
		    }
			
	</script>

</cfoutput>

<cf_divscroll>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">
	
	<tr><td>
	
	<cfparam name="url.id1" default="">
	
	<cfif url.id1 neq "">	
		<cfset cond = "WHERE Location = '#url.id1#'">	
	<cfelse>	
		<cfset cond = "WHERE Mission  = '#url.id2#'">	
	</cfif>
	 
	<!--- Query returning search results --->
	
	<cfset list = "Mission,Location,LocationCode,LocationName,AddressCity,latitude,longitude,MissionOrgUnitId,TreeOrder">
	
	<cfquery name="SearchResult" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   #list#
	    FROM     Location L 
		         #preserveSingleQuotes(cond)# 	
		ORDER BY Mission, TreeOrder 
	</cfquery>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">
	
	<cfoutput query="SearchResult" group="TreeOrder">
	
	   <cfset indent = "10"> 
	   <cfinclude template="LocationListingDetail.cfm">
		
	   <cfquery name="Level02" 
	    datasource="appsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT  #list#
	    FROM    Location L 
		WHERE   L.ParentLocation = '#SearchResult.Location#'	
		ORDER BY Mission, TreeOrder 
	   </cfquery>
	   
	    <cfloop query="Level02">
			       
		  <cfset indent = "20"> 
		  <cfinclude template="LocationListingDetail.cfm">
		 	
		  <cfquery name="Level03" 
		      datasource="appsMaterials" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			    SELECT  #list#
			    FROM    Location L 
				WHERE   L.ParentLocation = '#Level02.Location#'		
				ORDER BY Mission, TreeOrder 
		   </cfquery>
	
		    <cfloop query="Level03">
					        
			   <cfset indent = "30"> 	
		       <cfinclude template="LocationListingDetail.cfm">
			 
			    <cfquery name="Level04" 
			      datasource="appsMaterials" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
			       SELECT  #list#
				    FROM    Location L
					WHERE   L.ParentLocation = '#Level03.Location#'		
					ORDER BY Mission, TreeOrder 
			    </cfquery>
		
			    <cfloop query="Level04">
							      
				   <cfset indent = "40"> 
			       <cfinclude template="LocationListingDetail.cfm">
						 
				</cfloop> 
			   
		      </cfloop>
		     
	    </cfloop> 
	     
	</CFOUTPUT>
	
	</TABLE>   
	</td>
	</tr>
	</table>

</cf_divscroll>	
