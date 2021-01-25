		
<cfparam name="url.id2" default="">	

<cfparam name="form.operational" default="0">	
	
<cfquery name="Listing" 
datasource="#alias#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, (SELECT TOP 1 WorkActionId
			   FROM   WorkOrderLineAction
			   WHERE  ActionClass = R.Code	) as Used
    FROM  Ref_Action R		
	ORDER BY Mission, Created
</cfquery>

<table width="94%" class="formpadding navigation_table">
				
    <TR class="labelmedium2 line" height="18">
	   <td width="30"><cf_space spaces="10"></td>	  
	   <td width="100">Action</td>	  
	   <td width="35%"></td>	  
	   <td width="30">Entry</td>	  
	   <td width="10%" align="center">Mode</td>	  
	   <td width="20" align="center" style="padding-right:10px">S</td>
	   <td style="padding-right:5px"></td>
	   <td width="15%">Officer</td>
	   <td width="80" align="right">Created</td>		
	   <td wisth="30"></td>			  	  
    </TR>			
		
	<cfoutput query="Listing" group="mission">
	
	<tr><td colspan="4" class="labelmedium2" style="font-size:26px;height:46px">
	<cfif mission eq "">any<cfelse>#Mission#</cfif>
	</td></tr>
	
	<cfoutput>				
										
			<tr bgcolor="<cfif operational eq "0">e6e6e6</cfif>" class="line navigation_row labelmedium2">			
			  			   
			   <td align="center" width="1%">
			   
			     <table>
				 <tr>
				 
				 	 <td width="20" style="padding-top:8px;padding-left:4px;">
					 <cf_img icon="expand" toggle="yes" onClick="showme('l#code#','#code#','#mission#')">					 
					 </td>		
					
				     <td style="padding-left:1px;padding-top:1px">				 
			   	     <cf_img icon="open" navigation="Yes" onClick="addrecord('#code#')">
				     </td>					
				     							 
				 </tr>
			     </table> 
				 
			  </td>
					
			  <td colspan="2" style="padding-left:4px;padding-right:5px">#description# <font color="808080">(#code#)</font></td>			  						    
			  <td>#left(entryMode,1)#<cfif entryMode eq "Batch"><font size="2">:#BatchDaysSpan#</cfif></td>
			  <td align="center" width="5%">#ActionFulfillment#</td>			   
			    
			  <td align="center">
			   
			      <cfquery name="CheckServices" 
					datasource="#alias#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT	* 
						FROM	Ref_ActionServiceItem
						WHERE	Code =  '#Code#'							
				   </cfquery>
				   #CheckServices.recordCount#
			  </td>
			  <td style="padding-right:5px"></td>
			  <td colspan="1">#OfficerLastName#</td>
			  <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>
			   
			    <!--- ---------------------------------- --->
			    <!--- -to be adjusted for each database- --->
			    <!--- ---------------------------------- --->
			  				   
			  <td align="center" style="padding-left:7px; padding-right:7px;padding-top:3px">
				 
				  <cfif used neq "">	
				  	<cf_img icon="delete" onclick="_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('RecordListingPurge.cfm?alias=#alias#&Code=#code#','listing')">									
				  </cfif>	   
					  
			  </td>  
			   		   
		   </tr>	
		   
		   <tr id="l#code#" class="hide">
		       <td></td>
			   <td class="line" colspan="9" id="content_l#code#"></td>
			</tr>					 	 
							
	</cfoutput>		
	
	</cfoutput>													
				
</table>	

<cfset AjaxOnLoad("doHighlight")>		

<script>
	Prosis.busy('no')
</script>			
