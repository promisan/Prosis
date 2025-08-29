<!--
    Copyright © 2025 Promisan B.V.

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
<cfset dtef=CreateDate(URL.startyear,1,1)>
<cfset dtel=CreateDate(URL.startyear,12,31)>

<cfparam name="url.idmenu" default="">

<cfquery name="holiday" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_Holiday
		WHERE   Mission = '#url.mission#'				
		AND    	CalendarDate >= #dtef#
		AND     CalendarDate <= #dtel#		
</cfquery>

<cfform onsubmit="return false" name="holidaylistform">				  
     
<table width="100%" align="center" style="width:300px">

   	  <tr class="line labelmedium" style="height:20px">
  	  <td height="25" width="20"></td>
   	  <td width="15%" style="min-width:70px"><cf_tl id="Date"></td>	 
   	  <td width="60%"><cf_tl id="Name of Holiday"></td>	
	  <td width="10"></td>
      </tr>
	  	  	      		  
	  <cfoutput query = "holiday">
	  	 
	   <cfset FIRSTOFMONTH=CreateDate(Year(CalendarDate),Month(CalendarDate),1)>
	   <cfset ENDOFMONTH=CreateDate(Year(CalendarDate),Month(CalendarDate),DaysInMonth(CalendarDate))>
	  
	   <cfif CalendarDate gte FirstOfMonth and CalendarDate lte EndOfMonth>
	       <cfset color = "ffffcf">
	   <cfelse>
	       <cfset color = "ffffff">
	   </cfif>
	  
       <tr bgcolor="#color#" class="line labelmedium">
	    <td style="padding-left:4px;padding-right:2px"><input type="checkbox" name="HolidayId" id="HolidayId" value="#HolidayId#"></td>
        <td style="padding-left:2px;padding-right:2px">#DateFormat(CalendarDate,"dd/mm")#</td>		
        <td style="min-width:180px;padding-left:2px;padding-right:6px">#Description#</td>
			
		<cfif ClusterId neq "">		    
						
		<cfquery name="getCluster" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_HolidayCluster
				WHERE   Mission = '#url.mission#'							
		</cfquery>
		
		<cfset getclusterid = clusterid>
		
		<cfloop query="getCluster">
		
		   <cfif getclusterId eq clusterid>
		   
			    <cfif currentrow eq "1">				
					<cfset col = "00FF00">				
				<cfelseif currentrow eq "2">				
					<cfset col = "ffffcf">				
				<cfelse>				
					<cfset col = "f4f4f4">							
				</cfif>		   
		   		   
		   </cfif>
			
		</cfloop>
				
			<td bgcolor="#col#">&nbsp;</td>
			
		<cfelse>
		    <td></td>	
		</cfif>				
				
       </tr>
      </cfoutput>
	  	  
	  <cfif holiday.recordcount gt "0">
	  
	  	<cfoutput>
	  
		  <tr><td height="1" colspan="4" class="line"></td></tr>
		  <tr><td colspan="4" style="padding-top:5px" align="center">
		  <table cellspacing="0" cellpadding="0" class="formspacing">
		  <tr><td>
		  	  <input type="button" class="button10g" name="Cluster" id="Cluster" style="height:22;width:90" value="Cluster" onclick="validatelist('#url.mission#','cluster')">
		  </td><td>
			  <input type="button" class="button10g" name="Remove"  id="Remove"  style="height:22;width:90" value="Remove" onclick="validatelist('#url.mission#','remove')">
		  </td></tr>
		  <tr><td id="listsubmit"></td></tr>
		  </table>			  
		  </td></tr>	
		  
		 </cfoutput> 		  
	  
	  </cfif>
	  	  
</table>

</cfform>