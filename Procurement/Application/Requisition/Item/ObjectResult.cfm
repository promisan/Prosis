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
<cfparam name="URL.Item" default="">
<cfparam name="URL.Mission" default="">
<cfparam name="URL.Period" default="">

<cfquery name="QObject" 
	datasource="AppsPurchase"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   R.*
	FROM     ItemMasterObject I,
		     Program.dbo.Ref_Object R,
		     Program.dbo.Ref_ObjectUsage U,
		     Organization.dbo.Ref_MissionPeriod M,
		     Program.dbo.Ref_AllotmentEdition E,
		     Program.dbo.Ref_AllotmentVersion V
	WHERE    ItemMaster    = '#URL.Item#' 
	AND      I.ObjectCode  = R.Code
	AND      U.Code        = R.ObjectUsage
	AND      M.Mission     = '#URL.Mission#'
	AND      M.Period      = '#URL.Period#'
	AND      E.EditionId   = M.EditionId
	AND      E.Mission     = M.Mission
	AND      V.Code        = E.Version
	AND      V.Mission     = E.Mission
	AND      V.ObjectUsage = U.Code
	ORDER BY R.ListingOrder
</cfquery>

<cfoutput>

<table width="93%" align="center" bgcolor="ffffef" style="border:1px solid silver;border-top:0px">	
	
	<tr> 
	<td height="25"  bgcolor="ffffcf">
			  	   
				<table cellspacing="0" cellpadding="0" class="formpadding">	   
				
				<tr>			   
			       <TD width="500" class="labelit" colspan="2" style="padding-left:4px"><cf_tl id="Object of Expenditure"></TD>			   	  
				   <td width="80"></td>
				</tr>
				 
				<cfif qObject.recordcount eq "0">
				 <tr><td colspan="4" height="1" bgcolor="ffffff" class="labelit" align="center">None defined</td></tr>					
				</cfif>   
				
				<cfloop query="qObject">
				<tr><td colspan="4" height="1" class="linedotted"></td></tr>		
				<tr>				
					<td width="80" class="labelit">#CodeDisplay#</td>
					<td width="420" class="labelit">#Description#</td>
					<td></td>		
				</tr>
				</cfloop>	
				
				</table>
	
	</td>
	</tr>
	
<cfquery name="Standard" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT R.* 
	FROM   ItemMasterStandard I, Ref_Standard R
	WHERE  I.StandardCode = R.Code
	AND    R.Operational = 1
	AND    I.ItemMaster = '#url.Item#'		
</cfquery>	

<cfif Standard.recordcount gt "0">
		
	<tr>    
		  
		   <td>
		   
		   <table cellspacing="0" cellpadding="0" class="formpadding">
		    
		       <tr bgcolor="ffffcf">
			  
		       <TD colspan="2" width="500" class="labelit">Standard</td>			  
			   <td width="80" class="labelit">Expiration</td>
			   </tr>
			  		  			 			 
			   <cfloop query="Standard">
			   
			   	   <tr><td colspan="4" height="1" class="linedotted"></td></tr>		
				   <tr>
					  
					   <td width="80" height="20" class="labelit">#Code#</td>
					   <td width="420" class="labelit">#Description#</td>						   
					   <td class="labelit">#dateformat(DateExpiration,CLIENT.DateFormatShow)#</td>
				   </tr>	
				   
				     <cf_filelibraryCheck			    	
    					DocumentPath  = "Standards"
						SubDirectory  = "#URL.Item#" 
						Filter        = "">	
					
					<cfif Files gte "1">
					
					   <tr>
					   <td></td>
					   <td colspan="3">
				   
					   <cf_filelibraryN
						DocumentPath  = "Standards"
						SubDirectory  = "#URL.Item#" 	
						Filter        = ""					
						LoadScript    = "1"		
						EmbedGraphic  = "no"
						Width         = "100%"
						Box           = "att#URL.Item#"
						Insert        = "no"
						Remove        = "no">	
						
						</td>
						</tr>
					
					</cfif>
				      
			   </cfloop>
		   </table>
		  </td>
		  
	</tr>	

</cfif>  


</table>


</cfoutput>