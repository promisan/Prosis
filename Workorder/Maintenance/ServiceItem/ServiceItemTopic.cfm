
<!--- enabled custom fields for a service item --->
<cfparam name="URL.Mode" default="">
<cfparam name="URL.Code" default="">

<cfif Url.mode eq "delete">
	<cfquery name="TopicDelete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE 	
	FROM   Ref_TopicServiceItem 
	WHERE  ServiceItem = '#URL.ID1#'
	AND	   Code        = '#URL.Code#'
	</cfquery>
</cfif>

<cfquery name="Topic" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     R.Code, 
	           R.TopicClass, 
			   R.Mission, 
			   R.Description, 
			   R.ValueClass, 
			   R.ValueLength, 
			   R.ValueValidation, 
			   R.ValueObligatory, 
			   R.ListDataSource, 
			   R.ListTable, 
	           R.ListPK, 
			   R.ListDisplay, 
			   R.ListOrder, 
			   R.ListCondition, 
			   R.ListingOrder, 
			   R.Operational, 
			   S.ShowInContext,
			   S.FieldDefault,
			   R.OfficerUserId, 
			   R.OfficerLastName, 
			   R.OfficerFirstName, 			   
	           R.Created
	FROM       Ref_Topic AS R INNER JOIN
	           Ref_TopicServiceItem AS S ON R.Code = S.Code
	WHERE      S.ServiceItem = '#URL.ID1#'
	ORDER BY   ListingOrder
</cfquery>


<CFFORM action="ServiceItemTopicSubmit.cfm" style="width:100%" method="post" name="edittopicform" onsubmit="return false">

<table width="100%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr><td height="15px"></td></tr>
<TR>			
	<td colspan="13" class="labellarge">Custom Fields</b></td>	  		
</tr>
<tr><td height="7px"></td></tr>		   
<tr><td colspan="14" class="line"></td></tr> 

 <TR height="18px">
	   <td width="5px"></td>	  
	   <td width="40px" class="labelit">Code</td>	  
	   <td width="22px" class="labelit">Name</td>
	   <td width="10px" class="labelit">Entity</td>
	   <td width="10px" class="labelit">Class</td>
	   <td width="40px" class="labelit">Context</td>
	   <td width="10px" class="labelit">Type</td>
	   <td width="50px" class="labelit">Default</td>	   
	   <td width="10px"  class="labelit">Ob.</td>
	   <td width="10px"  class="labelit">E.</td>	  
	   <td width="10px"  class="labelit" align="right">Created</td>		
	   <td width="25px"  class="labelit" align="left"></td>			   
	   <td width="25px"  class="labelit" align="left"></td>			   	   
	   <td width="40px"></td>			  	  
    </TR>	
	
	<tr><td class="line" colspan="14"></td></tr>
	
	<cfif Topic.recordcount eq "0">
	
	<tr><td colspan="14" height="22" align="center" class="labelmedium" style="padding-top:10px"><font color="808080">There are no custom fields defined</td></tr>
	
	</cfif>

<cfoutput query="Topic">

	<cfif URL.code neq Code>

	<TR class="navigation_row cellcontent line">						  			   
	   <td align="center" ></td>	  	      
	   <td >#code#</td>	  
	   <td>#description#</td>
	   <td><cfif mission eq "">any<cfelse>#Mission#</cfif></td>
	   <td>#topicclass#</td>	   
	   <td>#ShowInContext#</td>
	   <td>#ValueClass# <cfif ValueClass eq "text">(#valueLength#)</cfif></td>	  
	   <td>
	   		<cfswitch expression="#ValueClass#">
				<cfcase value="Boolean">
					<cfif FieldDefault eq 0>No<cfelse>Yes</cfif>
				</cfcase>
				<cfdefaultcase>
					#FieldDefault#
				</cfdefaultcase>
			</cfswitch>	
			
		</td>
	   <td><cfif ValueObligatory eq "0"><b>No</b><cfelse>Yes</cfif></td>
	   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>	  
	   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>
	   <td align="right">
	   	<cf_img icon="edit" onclick="editItemTopic('#Code#', '#URL.ID1#')">
	   </td>				
	   <td align="right">
	   	<cf_img icon="delete" onclick="deleteItemTopic('#Code#', '#URL.ID1#')">				
	   </td>				
	   
	   <td align="center" width="40px"></td>  	   		   
   </TR>	
   
   <cfelse>
   
		<!--- it is an edit --->
		<TR bgcolor="FFFFFF">						  			   
		   <td align="center" height="20"></td>	  	      
		   <td height="17">#code#</td>	  
		   <td>#description#</td>
		   <td><cfif mission eq "">any<cfelse>#Mission#</cfif></td>
		   <td>#topicclass#</td>	   
		   <td>
			    <select style="font:10px" name="#Code#_Context" id="#Code#_Context" class="enterastab">
					<option value="Any" <cfif ShowInContext eq "Any">selected</cfif>>Any</option>
					<option value="BackOffice" <cfif ShowInContext eq "BackOffice">selected</cfif>>BackOffice</option>
					<option value="Portal" <cfif ShowInContext eq "Portal">selected</cfif>>Portal</option>					
				</select>								
				
			</td>
		   <td>#ValueClass# <cfif ValueClass eq "text">(#valueLength#)</cfif></td>	  
		   <td>
		   		<cfswitch expression="#ValueClass#">
					<cfcase value="Boolean">
					    <select style="font:10px" name="#Code#_Default" id="#Code#_Default" class="enterastab">
								<option value="0" <cfif FieldDefault eq 0>selected</cfif>>No</option>
								<option value="1" <cfif FieldDefault eq 1>selected</cfif>>Yes</option>
						</select>								
					</cfcase>
					<cfcase value="Text">
						<input type="text" id="#Code#_Default" name="#Code#_Default" value="#FieldDefault#">
					</cfcase>
					<cfcase value="List">

						 <cfquery name="GetList" 
						  datasource="AppsWorkOrder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							  SELECT *
							  FROM   Ref_TopicList
							  WHERE  Code = '#Code#'		
							  ORDER BY ListOrder
						</cfquery>		

					    <select style="font:10px" name="#Code#_Default" id="#Code#_Default" class="enterastab">
							<option value=""></option>
							
							<cfloop query="GetList">					  
								<option value="#GetList.ListValue#" <cfif GetList.ListValue eq Topic.FieldDefault>selected</cfif>>#GetList.ListValue#</option>
							</cfloop>
							
						</select>						
										
					</cfcase>					
					<cfdefaultcase>
						<input type="text" id="#Code#_Default" name="#Code#_Default" value="#FieldDefault#">
					</cfdefaultcase>
				
				</cfswitch>
			</td>					
		   		
		   <td>
		   
		   		   	<!----
			    <select style="font:10px" name="Obligatory_#Code#" id="Obligatory_#Code#" class="enterastab">
						<option value="0" <cfif ValueObligatory eq 0>selected</cfif>>No</option>
						<option value="1" <cfif ValueObligatory eq 1>selected</cfif>>Yes</option>
				</select>			
			--->	
				<cfif ValueObligatory eq "0"><b>No</b><cfelse>Yes</cfif>
		   
		   </td>
		   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>	  
		   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>
		   <td align="right">
					<a href="##" onclick="saveItemTopic('#Code#', '#URL.ID1#')"><img src="#CLIENT.root#/images/save.png"></a>
		   </td>				
		   <td></td>
		   
		   <td align="center" width="40px"></td>  	   		   
	   </TR>	
	   		
   </cfif>
   
   <tr><td colspan="13" class="line"></td></tr>
   
</cfoutput>

	<tr><td colspan="14 "height="30"></td></tr>
	
	<TR>		
		<td colspan="14" class="labellarge">Actions</b></td>	  		
   	</tr>
	
  	<tr><td height="7"></td></tr>	
		   
   	<tr><td colspan="14" class="line"></td></tr>    
	<tr>
		<td colspan="14">
			<cfinclude template="ServiceItemAction.cfm">
		</td>
	</tr>

</table>


<cfset ajaxonload("doHighlight")>

</CFFORM>	
